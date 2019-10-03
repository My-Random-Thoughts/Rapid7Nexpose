Function ConvertTo-NexposeId {
<#
    .SYNOPSIS
        Returns the specified asset id

    .DESCRIPTION
        Returns the specified asset by id, name, group, site, tag or policy

    .PARAMETER Name
        The name of the object

    .PARAMETER ObjectType
        The type of the tag being specified.  One of 'AuthSource', 'Asset', 'AssetGroup', 'Credential', 'Report', 'Policy', 'Site', 'Tag', 'User'

    .EXAMPLE
        ConvertTo-NexposeId -Name 'asset_1' -ObjectType 'Asset'

    .EXAMPLE
        ConvertTo-NexposeId -Name 'tag_1' -ObjectType 'Tag'

    .NOTES
        For additonal information please contact PlatformBuild@callcreditgroup.com

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('AuthSource','Asset','AssetGroup','Credential','Report','Policy','ScanEnginePool','Site','Tag','User')]
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

            'Credential' {
                $sharedcred = (((Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get) | Where-Object {  $_.name -eq $Name }).id)

                If (-not $sharedcred) {
                    ForEach ($site In (Get-NexposeSite)) {
                        $sitecred = (((Invoke-NexposeQuery -UrlFunction "sites/$($site.id)/site_credentials" -RestMethod Get) | Where-Object {  $_.name -eq $Name }).id)
                        If ($sitecred) {
                            $result = $sitecred
                        }
                    }
                }
                Else {
                    $result = $sharedcred
                }
            }

            'Policy' { $result = (((Invoke-NexposeQuery -UrlFunction 'policies' -ApiQuery @{ filter = $Name } -RestMethod Get) | Select-Object -First 1).id) }
            'User'   { $result = (((Invoke-NexposeQuery -UrlFunction 'users'                                  -RestMethod Get) | Where-Object { ($_.name -eq $Name) -or ($_.login -eq $Name)}).id) }

            Default {
                Switch ($ObjectType) {
                    'AssetGroup'     { $url = 'asset_groups';           $obj = 'name' }
                    'AuthSource'     { $url = 'authentication_sources'; $obj = 'type' }
                    'Report'         { $url = 'reports';                $obj = 'name' }
                    'ScanEnginePool' { $url = 'scan_engine_pools';      $obj = 'name' }
                    'Site'           { $url = 'sites';                  $obj = 'name' }
                    'Tag'            { $url = 'tags';                   $obj = 'name' }
                }
                $result = (((Invoke-NexposeQuery -UrlFunction $url -RestMethod Get) | Where-Object {  $_.$obj -eq $Name }).id)
            }
        }
    }
    Else {
        $result = $Name
    }

    Write-Output $result
}
