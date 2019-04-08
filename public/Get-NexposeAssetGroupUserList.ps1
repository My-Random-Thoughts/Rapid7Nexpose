Function Get-NexposeAssetGroupUserList {
<#
    .SYNOPSIS
        Returns a list of users with access to this asset group

    .DESCRIPTION
        Returns a list of users with access to this asset group

    .PARAMETER Id
        The identifier of the asset group

    .PARAMETER Name
        The name of the asset group

    .EXAMPLE
        Get-NexposeAssetGroupUserList -Id 325

    .EXAMPLE
        Get-NexposeAssetGroupUserList -Name 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: asset_groups/{id}/users

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

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            [int[]]$users = @(Invoke-NexposeQuery -UrlFunction "asset_groups/$Id/users" -RestMethod Get)

            If ($users[0] -gt 0) {
                ForEach ($user In $Users) {
                    Write-Output (Get-NexposeUser -Id $user)
                }
            }
        }

        'byName' {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType AssetGroup)
            Write-Output (Get-NexposeAssetGroupUserList -Id $Name)
        }
    }
}
