Function Find-NexposeAssetSite {
<#
    .SYNOPSIS
        Returns the site where the specified asset is located

    .DESCRIPTION
        Returns the site where the specified asset is located

    .PARAMETER Id
        The identifier of the asset

    .PARAMETER Name
        The name of the asset

    .EXAMPLE
        Find-NexposeAssetSite -Id 5

    .EXAMPLE
        Find-NexposeAssetSite -Name 'server01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: assets/search

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    [int[]]$siteId = (Get-NexposeSite).id

    If (($PSCmdlet.ParameterSetName) -eq 'byId') { $ipAddress = ((Get-NexposeAsset -Id   $Id  ).ip) }
    Else                                         { $ipAddress = ((Get-NexposeAsset -Name $Name).ip) }

    ForEach($site In $siteId) {
        $apiQuery = @{
            filters = @(
                @{
                    field    = 'site-id'
                    operator = 'in'
                    values   = @($site)
                }
                @{
                    field    = 'ip-address'
                    operator = 'is'
                    value    = $ipAddress
                }
            )
            match = 'all'
        }

        [object]$assetData = (Invoke-NexposeQuery -UrlFunction 'assets/search' -ApiQuery $apiQuery -RestMethod Post)

        If ([string]::IsNullOrEmpty($assetData.id) -eq $false) {
            Write-Output (Get-NexposeSite -Id $site)
        }
    }
}
