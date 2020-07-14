Function Set-NexposeSiteAssetConfiguration {
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
        Set-NexposeSiteAssetConfiguration -Id 23 -IncludedTarget @('1.1.1.1-1.2.255.255', '192.168.1.0/24')

    .EXAMPLE
        Set-NexposeSiteAssetConfiguration -Name 'Site B' -ExcludedAssetGroup @('AssetGroup 1', 12)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/included_targets
        PUT: sites/{id}/excluded_targets
        PUT: sites/{id}/included_asset_groups
        PUT: sites/{id}/excluded_asset_groups

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
        # Convert all asset group names to Id numbers
        [int[]]$IncAssGrp = @()
        [int[]]$ExcAssGrp = @()

        If ([string]::IsNullOrEmpty($IncludedAssetGroup) -eq $false) {
            ForEach ($itemI In $IncludedAssetGroup) {
                $IncAssGrp += (ConvertTo-NexposeId -Name $itemI -ObjectType AssetGroup)
            }
        }
        If ([string]::IsNullOrEmpty($ExcludedAssetGroup) -eq $false) {
            ForEach ($itemE In $ExcludedAssetGroup) {
                $ExcAssGrp += (ConvertTo-NexposeId -Name $itemE -ObjectType AssetGroup)
            }
        }
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byName' {
                [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
                Write-Output (Set-NexposeSiteAssetConfiguration -Id $id -IncludedTarget $IncludedTarget -IncludedAssetGroup $IncludedAssetGroup `
                                                                -ExcludedTarget $ExcludedTarget -ExcludedAssetGroup $ExcludedAssetGroup)
            }

            'byId' {
                If ([string]::IsNullOrEmpty($IncludedTarget) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($IncludedTarget)) {
                        If ($IncludedTarget.Count -eq 1) { $IncludedTarget += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_targets"      -RestMethod Put -ApiQuery (@($IncludedTarget) | ConvertTo-Json))
                    }
                }

                If ([string]::IsNullOrEmpty($ExcludedTarget) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($ExcludedTarget)) {
                        If ($ExcludedTarget.Count -eq 1) { $ExcludedTarget += '' }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_targets"      -RestMethod Put -ApiQuery (@($ExcludedTarget) | ConvertTo-Json))
                    }
                }

                If ([string]::IsNullOrEmpty($IncAssGrp) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($IncAssGrp)) {
                        If ($IncAssGrp.Count -eq 1) { $IncAssGrp += $IncAssGrp }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/included_asset_groups" -RestMethod Put -ApiQuery (@($IncAssGrp) | ConvertTo-Json))
                    }
                }

                If ([string]::IsNullOrEmpty($ExcAssGrp) -eq $false) {
                    If ($PSCmdlet.ShouldProcess($ExcAssGrp)) {
                        If ($ExcAssGrp.Count -eq 1) { $ExcAssGrp += $ExcAssGrp }
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_asset_groups" -RestMethod Put -ApiQuery (@($ExcAssGrp) | ConvertTo-Json))
                    }
                }
            }
        }
    }

    End {
    }
}
