Function Get-NexposeTag {
<#
    .SYNOPSIS
        Returns the specified tag

    .DESCRIPTION
        Returns the specified tag by id, name, asset, asset group, or site

    .PARAMETER Id
        The identifier of the tag

    .PARAMETER Name
        The name of the tag

    .PARAMETER Asset
        An asset assigned to the tag (name or id)

    .PARAMETER AssetGroup
        A asset group assigned to the tag (name or id)

    .PARAMETER Site
        A site assigned to the tag (name or id)

    .EXAMPLE
        Get-NexposeTag -Id 5

    .EXAMPLE
        Get-NexposeTag -Name 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: tags
        GET: tags/{id}
        GET: assets/{id}/tags
        GET: asset_groups/{id}/tags
        GET: sites/{id}/tags
        GET: SKIPPED - tags/{id}/assets             # Due to data already present in return object
        GET: SKIPPED - tags/{id}/search_criteria    # Due to data already present in return object

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byAsset')]
        [string]$Asset,

        [Parameter(ParameterSetName = 'byGroup')]
        [string]$AssetGroup,

        [Parameter(ParameterSetName = 'bySite')]
        [string]$Site
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'tags' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            [int]$getId = (ConvertTo-NexposeId -Name $Name -ObjectType Tag)
            Get-NexposeTag -Id $getId
        }

        Default {
            Switch ($PSCmdlet.ParameterSetName) {
                'byAsset' { [string]$vari = $Asset;      [string]$path = 'assets';       [string]$type = 'Asset'      }
                'byGroup' { [string]$vari = $AssetGroup; [string]$path = 'asset_groups'; [string]$type = 'AssetGroup' }
                'bySite'  { [string]$vari = $Site;       [string]$path = 'sites';        [string]$type = 'Site'       }
            }

            [int]   $ObjId   = (ConvertTo-NexposeId -Name $vari -ObjectType $type)
            [object]$results = (Invoke-NexposeQuery -UrlFunction "$path/$ObjId/tags" -RestMethod Get)

            ForEach ($result In $results) {
                If ($result -is [int]) {
                    Write-Output (Get-NexposeTag -Id $result)
                }
                Else {
                    Write-Output $result
                }
            }
        }
    }
}
