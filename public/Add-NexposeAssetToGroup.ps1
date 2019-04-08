Function Add-NexposeAssetToGroup {
<#
    .SYNOPSIS
        Adds an asset to a static asset group

    .DESCRIPTION
        Adds an asset to a static asset group

    .PARAMETER GroupId
        The identifier of the asset group

    .PARAMETER AssetId
        The identifier of the asset

    .PARAMETER ReplaceAll
        Replace existing values with those given.  If not set, existing values will be added to

    .EXAMPLE
        Add-NexposeAssetToGroup -GroupId 2 -AssetId @(12, 24, 48)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: asset_groups/{id}
        PUT: asset_groups/{id}/assets
        PUT: asset_groups/{id}/assets/{assetId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$GroupId,

        [Parameter(Mandatory = $true)]
        [string[]]$AssetId,

        [switch]$ReplaceAll
    )

    Begin {
        [string]$groupType = ((Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId" -RestMethod Get).type)
        If ($groupType -ne 'static') {
            Throw 'Group type is unknown or dynamic and can not be modified in this way'
        }
    }

    Process {
        If ($ReplaceAll.IsPresent) {
            [int[]]$assetList = @()
            ForEach ($asset In $AssetId) {
                $assetList += (ConvertTo-NexposeId -Name $asset -ObjectType 'Asset')
            }
            If ($PSCmdlet.ShouldProcess($assetList)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId/assets" -ApiQuery $assetList -RestMethod Put)
            }
        }
        Else {
            ForEach ($asset In $AssetId) {
                If ($PSCmdlet.ShouldProcess($asset)) {
                    $asset = (ConvertTo-NexposeId -Name $asset -ObjectType 'Asset')
                    Write-Output (Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId/assets/$asset" -RestMethod Put)
                }
            }
        }
    }

    End {
    }
}
