Function Wait-NexposeScan {
<#
    .SYNOPSIS
        Wait for a scan to complete

    .DESCRIPTION
        Wait for a specified scan to complete

    .PARAMETER Id
        The identifier of the scan to wait for

    .PARAMETER UpdateTimeSpan
        The length of time between checking for updates.  Defaults to 30 seconds

    .PARAMETER WaitTimeOut
        The maximum length of time to wait for the process to complete.  Defaults 30 minutes

    .EXAMPLE
        Wait-NexposeScan -Id '42'

    .EXAMPLE
        Wait-NexposeScan -Id '42' -WaitTimeOut (New-TimeSpan -Hours 2)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [timespan]$UpdateTimeSpan = (New-TimeSpan -Seconds 30),

        [timespan]$WaitTimeOut = (New-TimeSpan -Minutes 30)
    )

    $status    = $null
    $stopWatch = [System.Diagnostics.Stopwatch]::StartNew()

    Do {
        If ($null -ne $status) { Start-Sleep -Seconds ($UpdateTimeSpan.TotalSeconds) }

        $status = ((Get-NexposeScan -Id $Id -Verbose:$false).Status)
        Write-Verbose -Message ('Status: {0} | Elapsed: {1}' -f $status, (($stopWatch.Elapsed).ToString().Split('.')[0]))

    } Until (($status -ne 'running') -or ($stopWatch.Elapsed -gt $WaitTimeOut))

    $stopWatch.Stop()
    Start-Sleep -Seconds 5
    Write-Output (Get-NexposeScan -Id $Id -Verbose:$false)
}
