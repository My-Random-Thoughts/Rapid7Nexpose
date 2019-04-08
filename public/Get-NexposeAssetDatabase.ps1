Function Get-NexposeAssetDatabase {
<#
    .SYNOPSIS
        Returns the databases enumerated on an asset

    .DESCRIPTION
        Returns the databases enumerated on an asset

    .PARAMETER Id
        The identifier of the asset

    .EXAMPLE
        Get-NexposeAssetDatabase -Id 3

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{id}/databases

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output @(Get-NexposePagedData -UrlFunction "assets/$Id/databases" -RestMethod Get)
}
