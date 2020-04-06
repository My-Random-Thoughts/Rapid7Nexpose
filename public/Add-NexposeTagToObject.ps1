Function Add-NexposeTagToObject {
<#
    .SYNOPSIS
        Adds an asset, group, or site to a tag

    .DESCRIPTION
        Adds an asset, group, or site to a tag

    .PARAMETER TagId
        The identifier of the tag

    .PARAMETER ObjectId
        The identifier of the object

    .PARAMETER ObjectType
        The type of the object

    .EXAMPLE
        Add-NexposeTagToObject -TagId 3 -ObjectId 23 -ObjectType Asset

    .EXAMPLE
        Add-NexposeTagToObject -TagId 3 -ObjectId 2 -ObjectType Site

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: tags/{id}/assets/{assetId}
        PUT: tags/{id}/asset_groups/{assetGroupId}
        PUT: tags/{id}/sites/{siteId}
        PUT: SKIPPED - assets/{id}/tags/{tagId}
        PUT: SKIPPED - asset_groups/{id}/tags
        PUT: SKIPPED - asset_groups/{id}/tags/{tagId}
        PUT: SKIPPED - sites/{id}/tags
        PUT: SKIPPED - sites/{id}/tags/{tagId}
        PUT: SKIPPED - tags/{id}/asset_groups
        PUT: SKIPPED - tags/{id}/sites

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$TagId,

        [Parameter(Mandatory = $true)]
        [int]$ObjectId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('assets', 'asset_groups', 'sites')]
        [string]$ObjectType
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($ObjectId)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$TagId/$ObjectType/$ObjectId" -RestMethod Put)
        }
    }

    End {
    }
}
