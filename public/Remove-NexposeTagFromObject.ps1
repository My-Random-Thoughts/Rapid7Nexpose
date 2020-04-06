Function Remove-NexposeTagFromObject {
<#
    .SYNOPSIS
        Removes a tag from an object

    .DESCRIPTION
        Removes a tag from an object

    .PARAMETER ObjectType
        The type of the object

    .PARAMETER ObjectId
        The identifier of the object

    .PARAMETER TagId
        The identifier of the tag.  If none is specified, then all tags are removed from the object

    .EXAMPLE
        Remove-NexposeTagFromObject -ObjectType Asset -ObjectId 23 -TagId 3

    .EXAMPLE
        Remove-NexposeTagFromObject -ObjectType Site -ObjectId 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: assets/{id}/tags/{tagId}
        DELETE: asset_groups/{id}/tags
        DELETE: asset_groups/{id}/tags/{tagId}
        DELETE: sites/{id}/tags/{tagId}
        DELETE: SKIPPED - tags/{id}/assets/{assetId}
        DELETE: SKIPPED - tags/{id}/asset_groups
        DELETE: SKIPPED - tags/{id}/asset_groups/{assetGroupId}
        DELETE: SKIPPED - tags/{id}/sites
        DELETE: SKIPPED - tags/{id}/sites/{siteId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('assets', 'asset_groups', 'sites')]
        [string]$ObjectType,

        [Parameter(Mandatory = $true)]
        [int]$ObjectId,

        [int[]]$TagId = 0
    )

    Begin {
    }

    Process {
        [string]$uri = "$ObjectType/$ObjectId/tags"

        If     (($ObjectType -eq 'assets') -and ($TagId[0] -eq 0)) { $TagId = (Get-NexposeTag -Asset $ObjectId).id }
        ElseIf (($ObjectType -eq 'sites' ) -and ($TagId[0] -eq 0)) { $TagId = (Get-NexposeTag -Site  $ObjectId).id }

        If ($PSCmdlet.ShouldProcess($ObjectId)) {
            If ($TagId[0] -gt 0) {
                ForEach ($tag In $TagId) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "$uri/$tag" -RestMethod Delete)
                }
            }
            Else {
                Write-Output (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Delete)
            }
        }
    }

    End {
    }
}
