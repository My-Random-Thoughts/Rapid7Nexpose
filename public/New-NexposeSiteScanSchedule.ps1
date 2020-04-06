Function New-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Creates a new scan schedule for the specified site

    .DESCRIPTION
        Creates a new scan schedule for the specified site

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER Enabled
        Flag indicating whether the scan schedule is enabled

    .PARAMETER Name
        A user-defined name for the scan launched by the schedule

    .PARAMETER StartDateTime
        The scheduled start date and time.  Repeating schedules will determine the next schedule to begin based on this date

    .PARAMETER Frequency
        Settings for repeating a scheduled task.  Text starts with either 'Once' or 'Every'.
        Examples include: 'Once', 'Every hour', 'Every day', 'Every 2 hours', 'Every 2 days', 'Every Monday', 'Every week', 'Every 3 weeks', 'Every 31st of the month', 'Every 31st of the month repeated every 3 months', 'Every 2nd Monday of the month', 'Every 1st Monday of the month repeated every 3 months', 'Every Monday repeated every 3 weeks'

    .PARAMETER Duration
        Specifies the maximum duration the scheduled scan is allowed to run. Scheduled scans that do not complete within specified duration will be paused.  Maximum values are: 364 Days, 23 Hours, 59 Minutes.

    .PARAMETER ScanRepeat
        Specifies the desired behavior of a repeating scheduled scan when the previous scan was paused due to reaching is maximum duration. The following table describes each supported value

    .PARAMETER ScanTemplate
        The identifier of the scan template to be used for this scan schedule. If not set, the site's assigned scan template will be used

    .PARAMETER ScanEngine
        The identifier of the scan engine to be used for this scan schedule. If not set, the site's assigned scan engine will be used

    .PARAMETER Assets
        Allows one or more assets defined within the site to be scanned for this scan schedule.  This property is only supported for static sites. When this property is null, or not defined in schedule, then all assets defined in the static site will be scanned

    .EXAMPLE
        New-NexposeSiteScanSchedule -SiteId 1 -Name 'Just the once' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Once' -Duration '1h'
        Run just one scan at the start of the year for a maximum of one hour

    .EXAMPLE
        New-NexposeSiteScanSchedule -SiteId 1 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Every Day' -Duration '1h'
        Run a scan every single day

    .EXAMPLE
        New-NexposeSiteScanSchedule -SiteId 1 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Every 31st of the month repeated every 3 months' -Duration '1h'
        Run a scan every 1st of the month, every 3 months

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: sites/{id}/scan_schedules

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [switch]$Enabled,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [datetime]$StartDateTime,

        [Parameter(Mandatory = $true)]
        [string]$Frequency,

        [object]$Duration,

        [Parameter(Mandatory = $true)]
        [ValidateSet('restart-scan','resume-scan')]
        [string]$ScanRepeat,

        [object]$Assets    # @{ includedTargets=@(); excludedTargets=@(); includedAssetGroups=@(); excludedAssetGroups=@() }
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'ScanTemplate' -Type 'string' -ValidateSet @((Get-NexposeScanTemplate).id)
        If ($SiteId -gt 0) {
            New-DynamicParameter -Dictionary $dynParam -Name 'ScanEngine' -Type 'int' -ValidateSet @((Get-NexposeScanEngine -SiteId $SiteId).id)
        }
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$ScanTemplate = $($PSBoundParameters.ScanTemplate)
        [string]$ScanEngine   = $($PSBoundParameters.ScanEngine  )
        If ([string]::IsNullOrEmpty($ScanTemplate) -eq $true) { $ScanTemplate = 'discovery' }

        $matchInterval = (Test-FrequencyString -Frequency $Frequency -Verbose:$false)
        If ($matchInterval.Success -eq $false) { Throw 'Invalid Frequency entered, please see the examples for more information.' }

        $dayOfWeek = ($Frequency -match 'Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday')
        If ($dayOfWeek -eq $true) {
            If ($StartDateTime.DayOfWeek -ne $matches.Values[0]) {
                Throw "Start date is a '$($StartDateTime.DayOfWeek)' but interval text says '$((Get-Culture).TextInfo.ToTitleCase($matches.Values[0]))'.  Please ensure the day of the week matches."
            }
        }
    }

    Process {
        $apiQuery = @{
            enabled        = ($Enabled.IsPresent)
            scanName       =  $Name
            onScanRepeat   =  $ScanRepeat
            scanTemplateId =  $ScanTemplate
            start          = ('{0}T{1}:00Z' -f ($StartDateTime.ToString('yyyy-MM-dd')), ($StartDateTime.ToString('HH:mm')))
        }

        If ([string]::IsNullOrEmpty($ScanEngine) -eq $false) {
            $apiQuery += @{
               scanEngineId = $ScanEngine
            }
        }

        $converted = (Convert-FrequencyString -Frequency $Frequency)
        If ($null -ne $converted) { $apiQuery += $converted}

        If ([string]::IsNullOrEmpty($Duration) -eq $false) {
            [string]$convertedDuration = (Convert-TimeSpan -Duration $Duration)
            If ($convertedDuration) {
                $apiQuery.duration = $convertedDuration
            }
        }

        If ([string]::IsNullOrEmpty($Assets) -eq $false) {
            $apiQuery += @{ assets = @{} }
            If ([string]::IsNullOrEmpty($Assets.includedTargets)     -eq $false) { $apiQuery.assets += @{ includedTargets =     @{ addresses     = $Assets.includedTargets     }}}
            If ([string]::IsNullOrEmpty($Assets.excludedTargets)     -eq $false) { $apiQuery.assets += @{ excludedTargets =     @{ addresses     = $Assets.excludedTargets     }}}
            If ([string]::IsNullOrEmpty($Assets.includedAssetGroups) -eq $false) { $apiQuery.assets += @{ includedAssetGroups = @{ assetGroupIDs = $Assets.includedAssetGroups }}}
            If ([string]::IsNullOrEmpty($Assets.excludedAssetGroups) -eq $false) { $apiQuery.assets += @{ excludedAssetGroups = @{ assetGroupIDs = $Assets.excludedAssetGroups }}}
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/scan_schedules" -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
