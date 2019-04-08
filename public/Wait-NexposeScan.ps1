Function Wait-NexposeScan {
<#
    .SYNOPSIS
        Wait for a scan to complete

    .DESCRIPTION
        Wait for a specified scan to complete

    .PARAMETER Id
        The identifier of the scan to wait for

    .PARAMETER TimeOut
        The maximum number of seconds to wait.  Defaults to 1800 (30 minutes)

    .EXAMPLE
        Wait-NexposeScan -Id '42'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        N/A

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
        If ($null -ne $status) { Start-Sleep -Seconds 30 }

        $status = ((Get-NexposeScan -Id $Id -Verbose:$false).Status)
        Write-Verbose -Message ('ScanId: {0} | Status: {1} | Running For: {2}s' -f $Id, $status, [math]::Round(($stopWatch.Elapsed.TotalSeconds)).ToString().PadLeft(4))

    } Until (($status -ne 'running') -or ($stopWatch.Elapsed.TotalSeconds -gt $TimeOut))

    $stopWatch.Stop()
    Write-Output (Get-NexposeScan -Id $Id -Verbose:$false)
}
