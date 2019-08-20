Function New-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Creates a new scan schedule for the specified site

    .DESCRIPTION
        Creates a new scan schedule for the specified site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Enabled
        Flag indicating whether the scan schedule is enabled

    .PARAMETER Name
        A user-defined name for the scan launched by the schedule

    .PARAMETER StartDateTime
        The scheduled start date and time.  Repeating schedules will determine the next schedule to begin based on this date

    .PARAMETER IntervalText
        Settings for repeating a scheduled task.  Text starts with either 'Once' or 'Every'.
        Examples include: 'Once', 'Every hour', 'Every day', 'Every 2 hours', 'Every 2 days', 'Every Monday', 'Every week', 'Every 3 weeks', 'Every 31st of the month', 'Every 31st of the month repeated every 3 months', 'Every 2nd Monday of the month', 'Every 1st Monday of the month repeated every 3 months', 'Every Monday repeated every 3 weeks'

    .PARAMETER Duration
        Specifies the maximum duration the scheduled scan is allowed to run. Scheduled scans that do not complete within specified duration will be paused.
        Maximum values are: 364 Days, 23 Hours, 59 Minutes.

    .PARAMETER ScanRepeat
        Specifies the desired behavior of a repeating scheduled scan when the previous scan was paused due to reaching is maximum duration. The following table describes each supported value

    .PARAMETER ScanTemplate
        The identifier of the scan template to be used for this scan schedule. If not set, the site's assigned scan template will be used

    .PARAMETER ScanEngine
        The identifier of the scan engine to be used for this scan schedule. If not set, the site's assigned scan engine will be used

    .PARAMETER Assets
        Allows one or more assets defined within the site to be scanned for this scan schedule.  This property is only supported for static sites. When this property is null, or not defined in schedule, then all assets defined in the static site will be scanned

    .EXAMPLE
        New-NexposeSiteScanSchedule -Id 1 -Name 'Just the once' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -IntervalText 'Once' -Duration '1h'
        Run just one scan at the start of the year for a maximum of one hour

    .EXAMPLE
        New-NexposeSiteScanSchedule -Id 1 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -IntervalText 'Every Day' -Duration '1h'
        Run a scan every single day

    .EXAMPLE
        New-NexposeSiteScanSchedule -Id 1 -Name 'Every Day' -StartDate '2019-01-01' -StartTime '00:01' -ReachesDuration restart-scan -IntervalText 'Every 31st of the month repeated every 3 months' -Duration '1h'
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
        [int]$Id,

        [switch]$Enabled,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [datetime]$StartDateTime,

        [string]$IntervalText,

        [ValidateRange('0.00:10:00.0', '364.23:59:59.0')]    # 10 minutes --> 1 year
        [timespan]$Duration,

        [ValidateSet('restart-scan','resume-scan')]
        [string]$ScanRepeat,

        [object]$Assets    # @{ includedTargets=@(); excludedTargets=@(); includedAssetGroups=@(); excludedAssetGroups=@() }
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
                         New-DynamicParameter -Dictionary $dynParam -Name 'ScanTemplate' -Type 'string' -ValidateSet @((Get-NexposeScanTemplate          ).id)
        If ($Id -gt 0) { New-DynamicParameter -Dictionary $dynParam -Name 'ScanEngine'   -Type 'int'    -ValidateSet @((Get-NexposeScanEngine -SiteId $Id).id) }
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$ScanTemplate = $($PSBoundParameters.ScanTemplate)
        [string]$ScanEngine   = $($PSBoundParameters.ScanEngine  )
        If ([string]::IsNullOrEmpty($ScanTemplate) -eq $true) { $ScanTemplate = 'discovery' }

        # Define the interval regex
        [string]$regexInterval1 = '(?:([1-9][0-9]?[0-9]? )?(hours?|days?|weeks?))'                                        # Capture groups 1 and 2
        [string]$regexInterval2 = '(?:(?:(?:(1st|2nd|3rd|4th|5th))?'                                                      # Capture group  3
        [string]$regexInterval3 = '(monday|tuesday|wednesday|thursday|friday|saturday|sunday)?)'                          # Capture group  4
        [string]$regexInterval4 = '((?:[1-9]|[1-2][0-9]|3[0-1])(?:st|nd|rd|th)))'                                         # Capture group  5
        [string]$regexInterval5 = '(?:(of the month)? ?(?:(?:repeated every )([2-9][0-9]?[0-9]?) (?:weeks|months))?)?'    # Capture groups 6 and 7
        [string]$regexInterval   = "^once|every (?:$regexInterval1|$regexInterval2 ?$regexInterval3|$regexInterval4 ?$regexInterval5)$"

        # Validate input string
        [System.Text.RegularExpressions.Match]$matchInterval = ([regex]::Match($IntervalText.ToLower(), $regexInterval, 'IgnoreCase'))

        If (($matchInterval.Success -eq $false) -or ($matchInterval.Value -ne $IntervalText)) {
            Throw 'Invalid interval entered, please see the examples for more information.'
        }
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
            start          = ('{0}T{1}:00Z' -f ($StartDateTime.ToString('yyyy-MM-dd')), ($StartDateTime.ToString('HH:mm')))
        }

        If ([string]::IsNullOrEmpty($ScanEngine) -eq $false) {
            $apiQuery += @{
               scanEngineId = $ScanEngine
            }
        }

        If ($IntervalText.StartsWith('Every') -eq $true) {
            ForEach ($groupInterval In ($matchInterval.Groups | Where-Object { $_.Success -eq $true })) {
                Switch ($groupInterval.Name) {
                    '1' {    # 1 .. 999
                        $interval = $groupInterval.Value
                    }

                    '2' {    # hours / days
                        $every = ($groupInterval.Value).Replace('s','')
                        If ($interval -eq 0) { $interval = 1 }
                    }

                    '3' {    # 1st .. 5th
                        $weekOfMonth = $groupInterval.Value.SubString(0, 1)
                    }

                    '4' {    # monday .. sunday
                        $every = 'week'
                        $dayOfWeek = $groupInterval.Value.ToLower()
                        If ($interval -eq 0) { $interval = 1 }
                    }

                    '5' {    # 1st .. 31st
                        # The number part should match the start date part
                        [int]$matchDay = ($matchInterval.Groups[5].Value) -replace ".{2}$"
                        If ($matchDay -ne (([datetime]$StartDate).Day)) {
                            Throw 'Start date must match entered IntervalText value'
                        }
                        $every = 'date-of-the-month'
                    }

                    '6' {    # "of the month"
                        If ($interval -eq 0)   { $interval = 1 }
                        If ($every -eq 'week') { $every = 'day-of-month'  }
                        Else                   { $every = 'date-of-month' }
                    }

                    '7' {    # 2 .. 999
                        $interval = $groupInterval.Value
                    }
                }
            }

            $apiQuery += @{ repeat = @{} }
            If ($dayOfWeek   -ne '') { $apiQuery.repeat += @{ dayOfWeek   = $dayOfWeek   }}
            If ($every       -ne '') { $apiQuery.repeat += @{ every       = $every       }}
            If ($interval    -gt  0) { $apiQuery.repeat += @{ interval    = $interval    }}
            If ($weekOfMonth -gt  0) { $apiQuery.repeat += @{ weekOfMonth = $weekOfMonth }}
        }

        If ([string]::IsNullOrEmpty($Duration) -eq $false) {
            $apiQuery += @{
                duration = ("P{0}DT{1}H{2}M" -f $Duration.Days, $Duration.Hours, $Duration.Minutes)
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
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/scan_schedules" -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
