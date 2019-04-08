Function Update-NexposeScanStatus {
<#
    .SYNOPSIS
        Updates the scan status

    .DESCRIPTION
        Updates the scan status. Can pause, resume, and stop scans using this resource. In order to stop a scan the scan must be running or paused. In order to resume a scan the scan must be paused. In order to pause a scan the scan must be running.

    .PARAMETER Id
        The identifier of the scan

    .PARAMETER Status
        The status of the scan

    .EXAMPLE
        Update-NexposeScanStatus -Id 123 -Status 'stop'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scans/{id}/{status}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [ValidateSet('pause','stop','resume')]
        [string]$Status
    )

    [string]$currStatus = ((Get-NexposeScan -Id $Id).status)
    [boolean]$performAction = $false
    Switch ($Status) {
        'pause' {
            If ($currStatus -eq 'running') { $performAction = $true }
        }

        'stop' {
            If ($currStatus -eq 'running') { $performAction = $true }
            If ($currStatus -eq 'paused' ) { $performAction = $true }
        }

        'resume' {
            If ($currStatus -eq 'paused' ) { $performAction = $true }
        }
    }

    If ($performAction -eq $true) {
        If ($PSCmdlet.ShouldProcess($id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "scans/$Id/$Status" -RestMethod Post)
        }
    }
}
