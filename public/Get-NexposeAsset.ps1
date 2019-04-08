Function Get-NexposeAsset {
<#
    .SYNOPSIS
        Returns the specified asset

    .DESCRIPTION
        Returns the specified asset by id, name, group, site or tag

    .PARAMETER Id
        The identifier of the asset

    .PARAMETER Name
        The name of the asset

    .PARAMETER IpAddress
        The IpAddress of the asset

    .PARAMETER InstalledSoftware
        The name of the software installed on assets

    .PARAMETER Group
        The asset group of the assets (name or id)

    .PARAMETER Site
        The site of the assets (name or id)

    .PARAMETER Tag
        The tag of the assets (name or id)

    .PARAMETER TagType
        The type of the tag being specified.  One of 'Criticality', 'Custom', 'Location', 'Owner'

    .EXAMPLE
        Get-NexposeAsset -Id 325

    .EXAMPLE
        Get-NexposeAsset -Site 3

    .EXAMPLE
        Get-NexposeAsset -Group 'LIVE'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets
        GET: assets/{id}
        GET: asset_groups/{id}/assets
        POST: assets/search
        GET: SKIPPED - assets/{id}/user_groups    #
        GET: SKIPPED - assets/{id}/users          # Duplicate of above
        GET: SKIPPED - sites/{id}/assets          # Duplicate of above

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byGroup')]
        [string]$Group,

        [Parameter(ParameterSetName = 'byIPAddress')]
        [string]$IpAddress,

        [Parameter(ParameterSetName = 'bySoftware')]
        [string]$InstalledSoftware,

        [Parameter(ParameterSetName = 'bySite')]
        [string]$Site,

        [Parameter(ParameterSetName = 'byTag')]
        [string]$Tag,

        [Parameter(Mandatory = $true, ParameterSetName = 'byTag')]
        [ValidateSet('Criticality', 'Custom', 'Location', 'Owner')]
        [string]$TagType
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "assets/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction 'assets' -RestMethod Get)    # Return All
            }
        }

        'byGroup' {
            $Group = (ConvertTo-NexposeId -Name $Group -ObjectType 'AssetGroup')
            [object]$assets = @(Get-NexposePagedData -UrlFunction "asset_groups/$Group/assets" -RestMethod Get)

            If ([string]::IsNullOrEmpty($assets) -eq $false) {
                ForEach ($id In $assets) {
                    Write-Output (Get-NexposeAsset -Id $id)
                }
            }
        }

        Default {
            Switch ($PSCmdlet.ParameterSetName) {
                'byName' {
                    $field    = 'host-name'
                    $operator = 'is'
                    $value    = $Name
                }

                'byIPAddress' {
                    $field    = 'ip-address'
                    $operator = 'is'
                    $value    = $IpAddress
                }

                'bySite' {
                    $Site = (ConvertTo-NexposeId -Name $Site -ObjectType 'Site')
                    $field    = 'site-id'
                    $operator = 'in'
                    $value    = @($Site)
                }

                'bySoftware' {
                    $field    = 'software'
                    $operator = 'contains'
                    $value    = $InstalledSoftware
                }

                'byTag' {
                    # Do not use ConvertTo-NexposeId as we require the name for the search filter
                    If ([int]::TryParse($Tag, [ref]$null)) { $Tag = ((Get-NexposeTag -Id $Tag).name) }
                    $field    = "$($TagType.ToLower())-tag"
                    $operator = 'is'
                    $value    = $Tag
                }
            }

            $apiQuery = @{
                filters = @(
                    @{
                        field    = $field
                        operator = $operator
                        value    = $value
                        values   = $value
                    }
                )
                match = 'all'
            }

            If ($value -is [array]) { $apiQuery.filters[0].Remove('value')  }
            Else                    { $apiQuery.filters[0].Remove('values') }

            [object]$assetData = @(Get-NexposePagedData -UrlFunction 'assets/search' -ApiQuery $apiQuery -RestMethod Post)
            If ([string]::IsNullOrEmpty($assetData.id) -eq $false) {
                Write-Output $assetData
            }
        }
    }
}
