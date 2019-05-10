Function ConvertTo-NexposeId {
<#
    .SYNOPSIS
        Returns the specified asset id

    .DESCRIPTION
        Returns the specified asset by id, name, group, site, tag or policy

    .PARAMETER Name
        The name of the object

    .PARAMETER ObjectType
        The type of the tag being specified.  One of 'AuthSource', 'Asset', 'AssetGroup', 'Report', 'Policy', 'Site', 'Tag', 'User'

    .EXAMPLE
        ConvertTo-NexposeId -Name 'asset_1' -ObjectType 'Asset'

    .EXAMPLE
        ConvertTo-NexposeId -Name 'tag_1' -ObjectType 'Tag'

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('AuthSource','Asset','AssetGroup','Report','Policy','Site','Tag','User')]
        [string]$ObjectType
    )

    [string]$result = $null

    If (-not ([int]::TryParse($Name, [ref]$null))) {
        # If value is NOT an integer
        Switch ($ObjectType) {
            'Asset'      {
                If ([ipaddress]::TryParse($Name, [ref]$null)) { $result = ((Get-NexposeAsset -IpAddress $Name).id) }
                Else                                          { $result = ((Get-NexposeAsset -Name      $Name).id) }
            }
            'AssetGroup' { $result = (((Invoke-NexposeQuery -UrlFunction 'asset_groups'                           -RestMethod Get) | Where-Object {  $_.name -eq $Name                          }).id) }
            'AuthSource' { $result = (((Invoke-NexposeQuery -UrlFunction 'authentication_sources'                 -RestMethod Get) | Where-Object {  $_.type -eq $Name                          }).id) }
            'Policy'     { $result = (((Invoke-NexposeQuery -UrlFunction 'policies' -ApiQuery @{ filter = $Name } -RestMethod Get) | Select-Object -First 1                                      ).id) }
            'Report'     { $result = (((Invoke-NexposeQuery -UrlFunction 'reports'                                -RestMethod Get) | Where-Object {  $_.name -eq $Name                          }).id) }
            'Site'       { $result = (((Invoke-NexposeQuery -UrlFunction 'sites'                                  -RestMethod Get) | Where-Object {  $_.name -eq $Name                          }).id) }
            'Tag'        { $result = (((Invoke-NexposeQuery -UrlFunction 'tags'                                   -RestMethod Get) | Where-Object {  $_.name -eq $Name                          }).id) }
            'User'       { $result = (((Invoke-NexposeQuery -UrlFunction 'users'                                  -RestMethod Get) | Where-Object { ($_.name -eq $Name) -or ($_.login -eq $Name)}).id) }
        }
    }
    Else {
        $result = $Name
    }

    Write-Output $result
}
