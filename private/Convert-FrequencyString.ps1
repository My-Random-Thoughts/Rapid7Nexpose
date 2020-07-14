Function Convert-FrequencyString {
<#
    .SYNOPSIS
        Convert an interval string to into a repeat object for scan schedules

    .DESCRIPTION
        Convert an interval string to into a repeat object for scan schedules

    .PARAMETER Frequency
        Natural language text of the interval to test

    .EXAMPLE
        Convert-FrequencyString -Frequency 'Every first wednesay of the month'

    .EXAMPLE
        Convert-FrequencyString -Frequency 'Every 31st of the month repeated every 3 months'

    .EXAMPLE
        Convert-FrequencyString -Frequency 'Every 3rd of the month repeat every 2 months'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    [OutputType([hashtable], $null)]
    Param (
        [string]$Frequency
    )

    $matchFrequency = (Test-FrequencyString -Frequency $Frequency -Verbose:$false)
    If ($matchFrequency.Success -eq $false) { Throw 'Invalid input entered, please see the examples for more information.' }

    If ($Frequency.ToLower().StartsWith('every') -eq $true) {

        [int]   $interval    = 0
        [int]   $weekOfMonth = 0
        [string]$dayOfWeek   = ''
        [string]$every       = ''

        ForEach ($groupFrequency In ($matchFrequency.Groups | Where-Object { $_.Success -eq $true })) {
            Switch ($groupFrequency.Name) {
                '1' {    # every (1) HOUR/DAY/WEEK
                    $every    = $groupFrequency.Value
                    $interval = 1
                }

                '2' {}   # every X
                '3' {    # HOURS/DAYS/WEEKS
                    $every    = ($groupFrequency.Value).TrimEnd('s')
                    $interval = ($matchFrequency.Groups[2].Value)
                }

                '4' {    # every MONDAY..SUNDAY
                    $every     = 'week'
                    $interval  = 1
                    $dayOfWeek = $groupFrequency.Value.ToLower()
                }

                '5' {}   # every 1ST..5TH
                '6' {    # MONDAY..SUNDAY of the month
                    $every       = 'day-of-month'
                    $dayOfWeek   =  $groupFrequency.Value.ToLower()
                    $weekOfMonth = ($matchFrequency.Groups[5].Value).Substring(0, 1)
                    $interval    = 1
                }

                '7' {    # 1st .. 31st
                    [int]$matchDay = $groupFrequency.Value -replace ".{2}$"

                    $every     = 'date-of-month'
                    $interval  = 1
                    $dayOfWeek = $matchDay
                }

                '8' {    # repeated every 2 .. 999 months
                    $interval = $groupFrequency.Value
                }
            }
        }

        $apiQuery += @{ repeat = @{} }
        If ($dayOfWeek   -ne '') { $apiQuery.repeat += @{ dayOfWeek   = $dayOfWeek   }}
        If ($every       -ne '') { $apiQuery.repeat += @{ every       = $every       }}
        If ($interval    -gt  0) { $apiQuery.repeat += @{ interval    = $interval    }}
        If ($weekOfMonth -gt  0) { $apiQuery.repeat += @{ weekOfMonth = $weekOfMonth }}

        Return $apiQuery
    }
    Else {
        Return $null
    }
}
