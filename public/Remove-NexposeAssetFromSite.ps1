Function Remove-NexposeAssetFromSite {
<#
    .SYNOPSIS
        Removes an asset from a site. The asset will only be deleted if it belongs to no other sites

    .DESCRIPTION
        Removes an asset from a site. The asset will only be deleted if it belongs to no other sites

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER AssetId
        The identifier of the asset

    .EXAMPLE
        Remove-NexposeAssetFromSite -SiteId 1

    .EXAMPLE
        Remove-NexposeAssetFromSite -SiteId 1 -AssetId @(42, 43, 44)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/assets
        DELETE: sites/{id}/assets/{assetId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [int[]]$AssetId
    )

    Begin {
    }

    Process {
        If ($AssetId.Count -gt 0) {
            ForEach ($asset In $AssetId) {
                If ($PSCmdlet.ShouldProcess($asset)) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/assets/$asset" -RestMethod Delete)
                }
            }
        }
        Else {
            If ($PSCmdlet.ShouldProcess($SiteId)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/assets" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
