Function Remove-NexposeAssetFromGroup {
<#
    .SYNOPSIS
        Removes the assets from the given static asset group

    .DESCRIPTION
        Removes the assets from the given static asset group

    .PARAMETER GroupId
        The group id of the asset group you are removing from

    .PARAMETER AssetId
        The list of asset ids to remove from the group, or if left blank, all assets

    .EXAMPLE
        Remove-NexposeAssetFromGroup -GroupId 2 -AssetId @(12, 24, 48)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: asset_groups/{id}
        DELETE: asset_groups/{id}/assets
        DELETE: asset_groups/{id}/assets/{assetId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$GroupId,

        [int[]]$AssetId = @(0)
    )

    Begin {
        [string]$groupType = ((Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId" -RestMethod Get).type)
        If ($groupType -ne 'static') {
            Throw 'Group type is unknown or dynamic and can not be modified in this way'
        }
    }

    Process {
        If ($AssetId[0] -gt 0) {
            ForEach ($asset In $AssetId) {
                If ($PSCmdlet.ShouldProcess($asset)) {
                    Write-output (Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId/assets/$asset" -RestMethod Delete)
                }
            }
        }
        Else {
            If ($PSCmdlet.ShouldProcess($asset)) {
                Write-output (Invoke-NexposeQuery -UrlFunction "asset_groups/$GroupId/assets" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
