Function New-NexposeScanEngineSharedSecret {
<#
    .SYNOPSIS
        Returns the current valid shared secret or generates a new shared secret.

    .DESCRIPTION
        Returns the current valid shared secret or generates a new shared secret.
        The endpoint returns an existing shared secret if one was previously generated and it has not yet expired.
        Conversely, the endpoint will generate and return a new shared secret for either of the following conditions: a shared secret was not previously generated or the previously-generated shared secret has expired.
        The shared secret is valid for 60 minutes from the moment it is generated.

    .PARAMETER RemoveExisting
        Remove an existing secret, if present, and generate a new one.  Otherwise it will return an existing one

    .EXAMPLE
        New-NexposeScanEngineSharedSecret

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scan_engines/shared_secret
        DELETE: scan_engines/shared_secret

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [switch]$RemoveExisting
    )

    If ($PSCmdlet.ShouldProcess('Shared Secret')) {
        If ($RemoveExisting.IsPresent) {
            [void]@(Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret' -RestMethod Delete -ErrorAction SilentlyContinue)
        }

        [void]@(Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret' -RestMethod Post)
        Get-NexposeScanEngineSharedSecret
    }
}
