Function New-NexposeAsset {
<#
    .SYNOPSIS
        Add a new asset into a site

    .DESCRIPTION
        Add a new asset into a site using its IP address

    .PARAMETER IpAddress
        The primary IPv4 or IPv6 address of the asset

    .EXAMPLE
        New-NexposeAsset -SiteId 2 -IpAddress 10.1.1.10

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: sites/{id}/assets

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string[]]$IpAddress
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            date = (((Get-Date).Date).ToString('yyyy-MM-dd'))
            ip   = '0.0.0.0'
        }

        ForEach ($ip In $IpAddress) {
            If ($PSCmdlet.ShouldProcess($ip)) {

                $apiQuery.ip = $ip

                # Check to see if the asset already exists first
                [object]$checkExisting = (Get-NexposeAsset -IpAddress $ip)

                If ([string]::IsNullOrEmpty($checkExisting) -eq $true) {
                    [int]$Site = (Find-NexposeIpTargetSite -IpAddress $ip)
                    If ($Site -gt 0) {
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Site/assets" -ApiQuery $apiQuery -RestMethod Post)
                    }
                    Else {
                        Write-Error 'No valid site found for this IP address'
                    }
                }
                Else {
                    Write-Error 'This IP already exists'
                }
            }
        }
    }

    End {
    }
}
