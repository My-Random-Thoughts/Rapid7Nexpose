Function Remove-NexposeScanEngineSharedSecret {
<#
    .SYNOPSIS
        Revokes the current valid shared secret, if one exists.

    .DESCRIPTION
        Revokes the current valid shared secret, if one exists.

    .EXAMPLE
        Remove-NexposeScanEngineSharedSecret

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: scan_engines/shared_secret

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
    )

    If ($PSCmdlet.ShouldProcess('Shared Secret')) {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret' -RestMethod Delete)
    }
}
