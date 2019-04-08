Function Get-NexposeAuthenticationSource {
<#
    .SYNOPSIS
        Returns the details for an authentication source.

    .DESCRIPTION
        Returns the details for an authentication source.

    .PARAMETER Id
        The identifier of the authentication sources

    .EXAMPLE
        Get-NexposeAuthenticationSources -Id 3

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: authentication_sources
        GET: authentication_sources/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [int]$Id = 0
    )

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "authentication_sources/$Id" -RestMethod Get)
        }
    Else {
        Write-Output @(Get-NexposePagedData -UrlFunction 'authentication_sources' -RestMethod Get)    # Return All
    }
}
