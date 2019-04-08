Function Invoke-NexposeDiscoveryConnection {
<#
    .SYNOPSIS
        Attempts to reconnect the discovery connection

    .DESCRIPTION
        Attempts to reconnect the discovery connection

    .PARAMETER Id
        The identifier of the discovery connection

    .EXAMPLE
        Invoke-NexposeDiscoveryConnection -Id 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: discovery_connections/{id}/connect

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output (Invoke-NexposeQuery -UrlFunction "discovery_connections/$Id/connect" -RestMethod Post)
}
