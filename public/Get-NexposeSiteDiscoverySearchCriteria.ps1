Function Get-NexposeSiteDiscoverySearchCriteria {
<#
    .SYNOPSIS
        Retrieve the search criteria of the dynamic site

    .DESCRIPTION
        Retrieve the search criteria of the dynamic site

    .PARAMETER Id
        The identifier of the site

    .EXAMPLE
        Get-NexposeSiteDiscoverySearchCriteria -Id 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/discovery_search_criteria

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Scope = 'Function')]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/discovery_search_criteria" -RestMethod Get)
}
