Function Add-NexposeUserToAssetGroup {
<#
    .SYNOPSIS
        Grants a user with sufficient privileges access to the asset group

    .DESCRIPTION
        Grants a user with sufficient privileges access to the asset group

    .PARAMETER UserId
        The identifier of the user to add

    .PARAMETER AssetGroupId
        The identifier of the asset group

    .EXAMPLE
        Add-NexposeUserToAssetGroup -UserId 5 -AssetGroupId 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: users/{id}/asset_groups/{assetgroupId}
        PUT: SKIPPED - users/{id}/asset_groups
        PUT: SKIPPED - asset_groups/{id}/users
        PUT: SKIPPED - asset_groups/{id}/users/{userId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,

        [Parameter(Mandatory = $true)]
        [string[]]$AssetGroupId
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($UserId)) {
            ForEach ($group In $AssetGroupId) {
                [int]$id = (ConvertTo-NexposeId -Name $group -ObjectType AssetGroup)
                Write-Output (Invoke-NexposeQuery -UrlFunction "users/$UserId/asset_groups/$id" -RestMethod Put)
            }
        }
    }

    End {
    }
}
