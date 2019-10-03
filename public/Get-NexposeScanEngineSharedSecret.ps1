Function Get-NexposeScanEngineSharedSecret {
<#
    .SYNOPSIS
        Returns the current valid shared secret, if one has been previously generated and it has not yet expired.

    .DESCRIPTION
        Returns the current valid shared secret, if one has been previously generated and it has not yet expired
        otherwise the endpoint will respond with a 404 status code. Use this endpoint to detect whether a previously-generated shared secret is still valid.

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
    )

    $result = '' | Select-Object -Property ('secret', 'ttl')
    $result.secret = (Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret' -RestMethod Get)

    If ($result.secret) {
        $result.ttl = (Invoke-NexposeQuery -UrlFunction 'scan_engines/shared_secret/time_to_live' -RestMethod Get)
        Write-Output $result
    }
}
