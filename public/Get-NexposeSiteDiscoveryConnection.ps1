Function Get-NexposeSiteDiscoveryConnection {
<#
    .SYNOPSIS
        Retrieves the discovery connection assigned to the site

    .DESCRIPTION
        Retrieves the discovery connection assigned to the site

    .PARAMETER Id
        The identifier of the site

    .EXAMPLE
        Get-NexposeSiteDiscoveryConnection -Id 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/discovery_connection

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/discovery_connection" -RestMethod Get)
}
