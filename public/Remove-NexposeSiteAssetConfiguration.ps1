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

    .PARAMETER IncludedTarget
        List of addresses to be the site's new included scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation

    .PARAMETER ExcludedTarget
        List of addresses to be the site's new excluded scan targets. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation

    .PARAMETER IncludedAssetGroup
        List of asset group identifiers or names

    .PARAMETER ExcludedAssetGroup
        List of asset group identifiers or names

    .EXAMPLE
        Remove-NexposeSiteAssetConfiguration -Id 23 -IncludedTargets '1.2.3.4'

    .EXAMPLE
        Remove-NexposeSiteAssetConfiguration -Name 'Site C' -ExcludedAssetGroups 'AssetGroup 3'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/included_targets
        DELETE: sites/{id}/excluded_targets
        DELETE: sites/{id}/included_asset_groups
        DELETE: sites/{id}/excluded_asset_groups

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [string[]]$IncludedTarget,

        [string[]]$ExcludedTarget,

        [string[]]$IncludedAssetGroup,

        [string[]]$ExcludedAssetGroup
    )

    Begin {
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byName' {
                [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
                Write-Output (Remove-NexposeSiteAssetConfiguration -Id $id `
                    -IncludedTarget $IncludedTarget `
                    -ExcludedTarget $ExcludedTarget `
                    -IncludedAssetGroup $IncludedAssetGroup `
                    -ExcludedAssetGroup $ExcludedAssetGroup
                )
            }

            'byId' {
                If ([string]::IsNullOrEmpty($IncludedTarget) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($IncludedTarget)) {
                        If ($IncludedTarget.Count -eq 1) { $IncludedTarget += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_targets" -RestMethod Delete -ApiQuery $IncludedTarget)
                    }
                }

                If ([string]::IsNullOrEmpty($ExcludedTarget) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($ExcludedTarget)) {
                        If ($ExcludedTarget.Count -eq 1) { $ExcludedTarget += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_targets" -RestMethod Delete -ApiQuery $ExcludedTarget)
                    }
                }

                If ([string]::IsNullOrEmpty($IncludedAssetGroup) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($IncludedAssetGroup)) {
                        If ($IncludedAssetGroup.Count -eq 1) { $IncludedAssetGroup += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_asset_groups" -RestMethod Delete -ApiQuery $IncludedAssetGroup)
                    }
                }

                If ([string]::IsNullOrEmpty($ExcludedAssetGroup) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($ExcludedAssetGroup)) {
                        If ($ExcludedAssetGroup.Count -eq 1) { $ExcludedAssetGroup += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_asset_groups" -RestMethod Delete -ApiQuery $ExcludedAssetGroup)
                    }
                }
            }
        }
    }

    End {
    }
}
