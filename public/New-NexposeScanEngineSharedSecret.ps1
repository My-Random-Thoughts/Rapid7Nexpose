Function New-NexposeScanEngineSharedSecret {
<#
    .SYNOPSIS
        Returns the current valid shared secret or generates a new shared secret.

    .DESCRIPTION
        Returns the current valid shared secret or generates a new shared secret.
        The endpoint returns an existing shared secret if one was previously generated and it has not yet expired.
        Conversely, the endpoint will generate and return a new shared secret for either of the following conditions: a shared secret was not previously generated or the previously-generated shared secret has expired.
        The shared secret is valid for 60 minutes from the moment it is generated.

    .EXAMPLE
        New-NexposeScanEngineSharedSecret

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scan_engines/shared_secret

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
    )

    If ($PSCmdlet.ShouldProcess('Shared Secret')) {
        [void]@(Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret' -RestMethod Post)
        Get-NexposeScanEngineSharedSecret
    }
}
