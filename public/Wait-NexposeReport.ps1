Function Wait-NexposeReport {
<#
    .SYNOPSIS
        Wait for a report to complete

    .DESCRIPTION
        Wait for a specified report to complete

    .PARAMETER Id
        The report id to wait for

    .PARAMETER TimeOut
        The maximum number of seconds to wait.  Defaults to 1800 (30 minutes)

    .EXAMPLE
        Wait-NexposeReport -ReportId '42'

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [int]$TimeOut = 1800
    )

    $status    = $null
    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    Do {
        If ($null -ne $status) { Start-Sleep -Seconds 5 }

        $status = ((Get-NexposeReportHistory -Id $Id -Verbose:$false | Sort-Object -Property id -Descending | Select-Object -First 1).Status)
        Write-Verbose -Message ('ReportId: {0} | Status: {1} | Running For: {2}s' -f $Id, $status, [math]::Round(($stopWatch.Elapsed.TotalSeconds)).ToString().PadLeft(4))

    } Until (($status -ne 'running') -or ($stopWatch.Elapsed.TotalSeconds -gt $TimeOut))

    $stopWatch.Stop()
    Write-Output (Get-NexposeReportHistory -Id $Id -Verbose:$false | Sort-Object -Property id -Descending | Select-Object -First 1)
}
