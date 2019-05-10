Function Get-NexposeAssetFileList {
<#
    .SYNOPSIS
        Returns the files discovered on an asset

    .DESCRIPTION
        Returns the files discovered on an asset

    .PARAMETER Id
        The identifier of the asset

    .EXAMPLE
        Get-NexposeAssetFileList -Id 3

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{id}/files

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    Write-Output @(Invoke-NexposeQuery -UrlFunction "assets/$Id/files" -RestMethod Get)
}
