Function Get-NexposeAssetGroup {
<#
    .SYNOPSIS
        Returns an asset group

    .DESCRIPTION
        Returns an asset group by id, name, or tag

    .PARAMETER Id
        The identifier of the asset group

    .PARAMETER Name
        The name of the asset group

    .PARAMETER Tag
        The tag of the asset group

    .EXAMPLE
        Get-NexposeAssetGroup -Id 325

    .EXAMPLE
        Get-NexposeAssetGroup -Name 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: asset_groups
        GET: asset_groups/{id}
        GET: tags/{id}/asset_groups
        GET: SKIPPED - asset_groups/{id}/search_criteria    # Retuend in data below

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byTag')]
        [string]$Tag
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "asset_groups/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction 'asset_groups' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType AssetGroup)
            Write-Output (Get-NexposeAssetGroup -Id $Name)
        }

        'byTag' {
            $Tag = (ConvertTo-NexposeId -Name $Tag -ObjectType Tag)
            [object]$varis = @((Invoke-NexposeQuery -UrlFunction "tags/$Tag/asset_groups" -RestMethod Get).links | Where-Object { $_.rel -eq 'Asset Group' })

            If ([string]::IsNullOrEmpty($varis) -eq $false) {
                ForEach ($getId In $varis) {
                    $getId = (($getId.href -split '/')[-1])
                    Write-Output (Get-NexposeAssetGroup -Id $getId)
                }
            }
        }
    }
}
