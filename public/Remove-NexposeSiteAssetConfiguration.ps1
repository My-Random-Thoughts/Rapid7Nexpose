Function Remove-NexposeSiteAssetConfiguration {
<#
    .SYNOPSIS
        Updates the included and excluded targets and asset groups in a static site

    .DESCRIPTION
        Updates the included and excluded targets and asset groups in a static site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER ConfigurationItemType
        The type of configuration item to remove

    .PARAMETER ConfigurationItem
        The identifier of the target or asset group.  For targets, this much match exactly a current entry

    .EXAMPLE
        Remove-NexposeSiteAssetConfiguration -Id 23 -IncludedTargets '1.2.3.4'

    .EXAMPLE
        Remove-NexposeSiteAssetConfiguration -Name 'Site C' -ExcludedAssetGroups 'AssetGroup 3'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/included_asset_groups
        DELETE: sites/{id}/included_asset_groups/{assetGroupId}
        DELETE: sites/{id}/excluded_asset_groups
        DELETE: sites/{id}/excluded_asset_groups/{assetGroupId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
#        [ValidateSet('IncludedTargets','ExcludedTargets','IncludedAssetGroups','ExcludedAssetGroups')]
        [ValidateSet('IncludedAssetGroups','ExcludedAssetGroups')]
        [string]$ConfigurationItemType,

        [string]$ConfigurationItem = '0'
    )

    Begin {
        If ($ConfigurationItemType.EndsWith('AssetGroups')) {
            $ConfigurationItem = (ConvertTo-NexposeId -Name $ConfigurationItem -ObjectType AssetGroup)
        }
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byName' {
                [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
                Write-Output (Remove-NexposeSiteAssetConfiguration -Id $id -ConfigurationItemType $ConfigurationItemType -ConfigurationItem $ConfigurationItem)
            }

            'byId' {
                Switch ($ConfigurationItemType) {
#                    'IncludedTargets' {
#                        # TODO: Simple search/replace process, could be better
#                        [string[]]$currentValue = (Get-NexposeSiteAssetConfiguration -Id $Id).IncludedTargets
#                        $currentValue = $currentValue.Replace($ConfigurationItem, '')
#                        Set-NexposeSiteAssetConfiguration -Id $Id -IncludedTarget $currentValue
#                    }
#
#                    'ExcludedTargets' {
#                        # TODO: Simple search/replace process, could be better
#                        [string[]]$currentValue = (Get-NexposeSiteAssetConfiguration -Id $Id).ExcludedTargets
#                        $currentValue = $currentValue.Replace($ConfigurationItem, '')
#                        Set-NexposeSiteAssetConfiguration -Id $Id -ExcludedTargets $currentValue
#                    }
#
                    'IncludedAssetGroups' {
                        If ($PSCmdlet.ShouldProcess($ConfigurationItem)) {
                            If ($ConfigurationItem -eq '0') {
                                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_asset_groups" -RestMethod Delete)
                            }
                            Else {
                                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_asset_groups/$ConfigurationItem" -RestMethod Delete)
                            }
                        }
                    }

                    'ExcludedAssetGroups' {
                        If ($PSCmdlet.ShouldProcess($ConfigurationItem)) {
                            If ($ConfigurationItem -eq '0') {
                                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_asset_groups" -RestMethod Delete)
                            }
                            Else {
                                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_asset_groups/$ConfigurationItem" -RestMethod Delete)
                            }
                        }
                    }
                }
            }
        }
    }

    End {
    }
}
