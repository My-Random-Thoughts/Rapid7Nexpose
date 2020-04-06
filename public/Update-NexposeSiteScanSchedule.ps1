Function Update-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Creates a new scan schedule for the specified site

    .DESCRIPTION
        Creates a new scan schedule for the specified site

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER ScheduleId
        The identifier of the scan schedule

    .PARAMETER Enabled
        Flag indicating whether the scan schedule is enabled

    .PARAMETER Name
        A user-defined name for the scan launched by the schedule

    .PARAMETER StartDate
        The scheduled start date.  Date is represented in yyyy-MM-dd format. Repeating schedules will determine the next schedule to begin based on this date

    .PARAMETER StartTime
        The scheduled start time.  Time is represented in hh:mm format. Repeating schedules will determine the next schedule to begin based on this time

    .PARAMETER Frequency
        Settings for repeating a scheduled task.  Text starts with either 'Once' or 'Every'.
        Examples include: 'Once', 'Every hour', 'Every day', 'Every 2 hours', 'Every 2 days', 'Every Monday', 'Every week', 'Every 3 weeks', 'Every 31st of the month', 'Every 31st of the month repeated every 3 months', 'Every 2nd Monday of the month', 'Every 1st Monday of the month repeated every 3 months', 'Every Monday repeated every 3 weeks'

    .PARAMETER Duration
        Specifies the maximum duration the scheduled scan is allowed to run. Scheduled scans that do not complete within specified duration will be paused.
        The scan duration are represented by the format '[n]D[n]H[n]M'.  In these representations, the [n] is replaced by a value for each of the date and time elements that follow the [n]
        Maximum values are: 364 Days, 23 Hours, 59 Minutes.  Examples inclue: '2d', '2h30m', '1w3d', ''

    .PARAMETER ScanRepeat
        Specifies the desired behavior of a repeating scheduled scan when the previous scan was paused due to reaching is maximum duration. The following table describes each supported value

    .PARAMETER ScanTemplate
        The identifier of the scan template to be used for this scan schedule. If not set, the site's assigned scan template will be used

    .PARAMETER ScanEngine
        The identifier of the scan engine to be used for this scan schedule. If not set, the site's assigned scan engine will be used

    .PARAMETER Assets
        Allows one or more assets defined within the site to be scanned for this scan schedule.  This property is only supported for static sites. When this property is null, or not defined in schedule, then all assets defined in the static site will be scanned

    .EXAMPLE
        Update-NexposeSiteScanSchedule -SiteId 1 -ScheduleId 1 -Name 'Just the once' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Once' -Duration '1h'
        Run just one scan at the start of the year for a maximum of one hour

    .EXAMPLE
        Update-NexposeSiteScanSchedule -SiteId 1 -ScheduleId 2 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Every Day' -Duration '1h'
        Run a scan every single day

    .EXAMPLE
        Update-NexposeSiteScanSchedule -SiteId 1 -ScheduleId 3 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -Frequency 'Every 31st of the month repeated every 3 months' -Duration '1h'
        Run a scan every 1st of the month, every 3 months

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        PUT: sites/{id}/scan_schedules/{scheduleId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [Parameter(Mandatory = $true)]
        [int]$ScheduleId,

        [switch]$Enabled,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateScript({[datetime]::ParseExact($_, 'yyyy-MM-dd', $null)})]
        $StartDate,

        [Parameter(Mandatory = $true)]
        [ValidateScript({[datetime]::ParseExact($_, 'hh:mm', $null)})]
        $StartTime,

        [string]$Frequency,

        [string]$Duration,

        [ValidateSet('restart-scan','resume-scan')]
        [string]$ScanRepeat,

        [object]$Assets    # @{ includedTargets=@(); excludedTargets=@(); includedAssetGroups=@(); excludedAssetGroups=@() }
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
                             New-DynamicParameter -Dictionary $dynParam -Name 'ScanTemplate' -Type 'string' -ValidateSet @((Get-NexposeScanTemplate              ).id)
        If ($SiteId -gt 0) { New-DynamicParameter -Dictionary $dynParam -Name 'ScanEngine'   -Type 'int'    -ValidateSet @((Get-NexposeScanEngine -SiteId $SiteId).id) }
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$ScanTemplate = $($PSBoundParameters.ScanTemplate)
        [string]$ScanEngine   = $($PSBoundParameters.ScanEngine  )
        If ([string]::IsNullOrEmpty($ScanTemplate) -eq $true) { $ScanTemplate = 'discovery' }

        # Verify the duration input
        [string]$regexDuration = '^((?:[1-9][0-9]?|[1-2][0-9][0-9]|3[0-5][0-9]|36[0-4])D)? ?((?:1?[0-9]?|2[0-3])H)? ?((?:[1-4]?[0-9]?|5[0-9])M)?$'
        [System.Text.RegularExpressions.Match]$matchDuration = ([regex]::Match($Duration.ToLower(), $regexDuration, 'IgnoreCase'))

        $matchInterval = (Test-FrequencyString -Frequency $Frequency)
        If ($matchInterval.Success -eq $false) { Throw 'Invalid Frequency entered, please see the examples for more information.' }
    }

    Process {
        [string]$every       = ''
        [string]$dayOfWeek   = ''
        [int]   $interval    = 0
        [int]   $weekOfMonth = 0

        $apiQuery = @{
            enabled        = ($Enabled.IsPresent)
            scanName       =  $Name
            onScanRepeat   =  $ScanRepeat
            scanTemplateId =  $ScanTemplate
            start          = ('{0}T{1}:00Z' -f $StartDate, $StartTime)
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
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/scan_schedules/$ScheduleId" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
