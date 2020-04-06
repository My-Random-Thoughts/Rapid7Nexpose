Function Convert-TimeSpan {
<#
    .SYNOPSIS
        Convert an integer, string or timespan into a limited ISO8601 format

    .DESCRIPTION
        Convert an integer, string or timespan into a limited ISO8601 format string.  The limitation is returning only up to Days: 'PxDTxHxMxS'

    .PARAMETER Duration
        Integer, timespan object to convert. Integer values are assumed to be seconds.

    .PARAMETER Format
        Option to choose DateTime or Time format for the resulting output.  In DateTime format, seconds are ignored.  In Time format the smallest possible unit of time is returned (Hours, Minutes, Seconds).  Default value is DateTime

    .PARAMETER MinimumDuration
        Minimum duration validation check, default of none.  Can either be a Timespan object or an integer number of seconds

    .PARAMETER MaximumDuration
        Maximum duration validation check, default of 365 days.  Can either be a Timespan object or an integer number of seconds

    .EXAMPLE
        Convert-TimeSpan -Duration 3600
        Returns 'PT1H'

    .EXAMPLE
        Convert-TimeSpan -Duration 'PT7200.0s'
        Returns 'PT2H'

    .EXAMPLE
        Convert-TimeSpan -Duration ([timespan]::New(3, 10, 30, 0, 0)) -Format DateTime
        Returns 'P3DT10H30M'

    .EXAMPLE
        Convert-TimeSpan -Duration (New-TimeSpan -Days 2 -Hours 10 -Minutes 30) -Format Time
        Returns 'PT58.5H'

    .EXAMPLE
        Convert-TimeSpan -Duration (New-TimeSpan -Start '2020-01-01 13:00' -End '2020-01-02 14:30') -Format Time
        Returns 'PT25.5H'

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [Parameter(Mandatory = $true)]
        [object]$Duration,

        [ValidateSet('DateTime','Time')]
        [string]$Format = 'DateTime',

        [object]$MinimumDuration = (New-TimeSpan),

        [object]$MaximumDuration = (New-TimeSpan -Days 365).Subtract(1)
    )

    Switch ($Duration.GetType().Name) {
        {'int32', 'double'} {
            $Duration = (New-TimeSpan -Seconds $Duration)
            $Format   = 'Time'
        }

        'string' {
            [void]($Duration -match "^P?(?:(\d+)D)?T(?:(\d+)H)?(?:(\d+)M)?(?:([0-9]+?(?:\.?(?<=\.)(?:[0-9]+))?)S)??$")
            If ($Matches) {
                $Duration = ([timespan]::New($Matches[1], $Matches[2], $Matches[3], 0, (($Matches[4] -as [double]) * 1000)))
            }
            Else {
                Throw "Duration is not in the correct ISO8601 format: $Duration"
            }
        }

        'timespan' {
            # Do nothing
        }

        Default {
            Throw "Duration is not in the correct format: $($Duration.GetType().Name)"
        }
    }

    If ($MinimumDuration -is [int]) { $MinimumDuration = (New-TimeSpan -Seconds $MinimumDuration) }
    If ($MaximumDuration -is [int]) { $MaximumDuration = (New-TimeSpan -Seconds $MaximumDuration) }

    If (($Duration.TotalMilliseconds -gt $MaximumDuration.TotalMilliseconds) -or ($Duration.TotalMilliseconds -lt $MinimumDuration.TotalMilliseconds)) {
        Throw "Duration given $Duration was outside the permitted range: $MinimumDuration - $MaximumDuration"
    }

    If ($Format -eq 'DateTime') {
        Return ('P{0}DT{1}H{2}M' -f $Duration.Days, $Duration.Hours, $Duration.Minutes)
    }
    ElseIf ($Format -eq 'Time') {
        If ($Duration.TotalMinutes -ge 60) {
            Return ('PT{0}H' -f ($Duration.TotalHours).ToString('0.####'))
        }
        ElseIf ($Duration.TotalSeconds -ge 60) {
            Return ('PT{0}M' -f ($Duration.TotalMinutes).ToString('0.####'))
        }
        Else {
            Return ('PT{0}S' -f ($Duration.TotalSeconds).ToString('0.####'))
        }
    }
    Else {
        Return $null
    }
}
