Function Remove-NexposeUserFromAssetGroup {
<#
    .SYNOPSIS
        Revokes access from a user to the asset group

    .DESCRIPTION
        Revokes access from a user to the asset group

    .PARAMETER UserId
        The identifier of the user to remove

    .PARAMETER AssetGroupId
        The identifier of the asset group

    .EXAMPLE
        Remove-NexposeUserFromAssetGroup -UserId 5 -AssetGroupId 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: users/{id}/asset_groups/{assetGroupId}
        DELETE: SKIPPED - users/{id}/asset_groups
        DELETE: SKIPPED - asset_groups/{id}/users/{userId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,

        [Parameter(Mandatory = $true)]
        [int]$AssetGroupId
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($UserId)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "users/$UserId/asset_groups/$AssetGroupId" -RestMethod Delete)
        }
    }

    End {
    }
}
