Function Get-NexposeDiscoveryConnection {
<#
    .SYNOPSIS
        Returns a discovery connection

    .DESCRIPTION
        Returns a discovery connection

    .PARAMETER Id
        The identifier of the discovery connection

    .EXAMPLE
        Get-NexposeDiscoveryConnection -Id 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: discovery_connections
        GET: discovery_connections/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [int]$Id = 0
    )

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "discovery_connections/$Id" -RestMethod Get)
    }
    Else {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'discovery_connections' -RestMethod Get)    # Return All
    }
}
