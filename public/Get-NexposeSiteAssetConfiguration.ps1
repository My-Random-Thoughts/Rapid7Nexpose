Function Get-NexposeSiteAssetConfiguration {
<#
    .SYNOPSIS
        Retrieves the included and excluded targets and asset groups in a static site

    .DESCRIPTION
        Retrieves the included and excluded targets and asset groups in a static site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .EXAMPLE
        Get-NexposeSiteAssetConfiguration -Id 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/included_targets
        GET: sites/{id}/excluded_targets
        GET: sites/{id}/included_asset_groups
        GET: sites/{id}/excluded_asset_groups

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byName' {
            [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Write-Output (Get-NexposeSiteAssetConfiguration -Id $id)
        }

        'byId' {
            [hashtable]$result = @{
                IncludedTargets     = @()
                ExcludedTargets     = @()
                IncludedAssetGroups = @()
                ExcludedAssetGroups = @()
            }

            $result.IncludedTargets     = ((Invoke-NexposeQuery -UrlFunction "sites/$Id/included_targets"      -RestMethod Get).addresses)
            $result.IncludedAssetGroups = ((Invoke-NexposeQuery -UrlFunction "sites/$Id/included_asset_groups" -RestMethod Get) | Select-Object ('id', 'name'))
            $result.ExcludedTargets     = ((Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_targets"      -RestMethod Get).addresses)
            $result.ExcludedAssetGroups = ((Invoke-NexposeQuery -UrlFunction "sites/$Id/excluded_asset_groups" -RestMethod Get) | Select-Object ('id', 'name'))

            Write-Output $result
        }
    }
}
