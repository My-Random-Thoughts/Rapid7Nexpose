Function Get-NexposeScanEngineSharedSecret {
<#
    .SYNOPSIS
        Returns the current valid shared secret, if one has been previously generated and it has not yet expired.

    .DESCRIPTION
        Returns the current valid shared secret, if one has been previously generated and it has not yet expired
        otherwise the endpoint will respond with a 404 status code. Use this endpoint to detect whether a previously-generated shared secret is still valid.

    .PARAMETER GenerateIfExpired
        Generate a new secret if one does not currently exist

    .EXAMPLE
        Get-NexposeScanEngineSharedSecret

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scan_engines/shared_secret
        GET: scan_engines/shared_secret/time_to_live

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [switch]$GenerateIfExpired
    )

    $secret = (Invoke-NexposeQuery -UrlFunction "scan_engines/shared_secret" -RestMethod Get -ErrorAction SilentlyContinue)
    If (-not $secret) {
        If ($GenerateIfExpired.IsPresent) {
            Return (New-NexposeScanEngineSharedSecret)
        }
        Else {
            Write-Warning -Message 'There is no shared secret currently set'
            Return $null
        }
    }

    $ttl = (Invoke-NexposeQuery -UrlFunction "scan_engines/shared_secret/time_to_live" -RestMethod Get)
    Return [pscustomobject]@{SharedSecret = $secret; TTL = $ttl}
}

