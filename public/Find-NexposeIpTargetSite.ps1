Function Find-NexposeIpTargetSite {
<#
    .SYNOPSIS
        Retreive the site that an IP address belongs too

    .DESCRIPTION
        Retreive the site that an IP address belongs too

    .PARAMETER IpAddress
        The IP address to search for

    .EXAMPLE
        Find-NexposeIpTargetSite -IpAddress '10.1.2.3'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/included_targets
        GET: sites/{id}/excluded_targets

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ipaddress]$IpAddress
    )

    [int[]]  $siteId    = (Get-NexposeSite).id
    [version]$ipConvert = $IpAddress.ToString()    # [version] is more reliable than [ipaddress] for checking ranges

    [System.Collections.ArrayList]$ReturnedSites = @()
    ForEach ($site In $siteId) {
        [string[]]$ipRangeInclude = ((Invoke-NexposeQuery -UrlFunction "sites/$site/included_targets" -RestMethod Get).addresses)
        [string[]]$ipRangeExclude = ((Invoke-NexposeQuery -UrlFunction "sites/$site/excluded_targets" -RestMethod Get).addresses)

        [string]$ipv4 = '(?:(?:2(?:[0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9])\.){3}(?:(?:2([0-4][0-9]|5[0-5])|[0-1]?[0-9]?[0-9]))'

        ForEach ($ip In $ipRangeInclude) {
            If ($ip -match "$ipv4 - $ipv4") {
                [version]$ipStart, [version]$ipEnd = (($ip.ToString()).Split('-'))
                If (($ipConvert -ge $ipStart) -and ($ipConvert -le $ipEnd)) {
                    [void]$ReturnedSites.Add($site)
                }
            }
            ElseIf ($ip -match $ipv4) {
                If ($ip -eq $IpAddress) {
                    [void]$ReturnedSites.Add($site)
                }
            }
            Else {
                Try {
                    [string]$hostName = ([System.Net.Dns]::GetHostEntry($IpAddress).HostName)
                    If ($hostName -like "$ip*") {
                        [void]$ReturnedSites.Add($site)
                    }
                }
                Catch {
                    Write-Warning -Message $($Error[0].Exception.Message)
                }
            }
        }

        ForEach ($ip In $ipRangeExclude) {
            If ($ip -match "$ipv4 - $ipv4") {
                [version]$ipStart, [version]$ipEnd = (($ip.ToString()).Split('-'))
                If (($ipConvert -ge $ipStart) -and ($ipConvert -le $ipEnd)) {
                    [void]$ReturnedSites.Remove($site)
                }
            }
            ElseIf ($ip -match $ipv4) {
                If ($ip -eq $IpAddress) {
                    [void]$ReturnedSites.Remove($site)
                }
            }
            Else {
                Try {
                    [string]$hostName = ([System.Net.Dns]::GetHostEntry($IpAddress).HostName)
                    If ($hostName -like "$ip*") {
                        [void]$ReturnedSites.Remove($site)
                    }
                }
                Catch {
                    Write-Warning -Message $($Error[0].Exception.Message)
                }
            }
        }
    }

    If ($ReturnedSites[0] -gt 0) {
        Write-Output $ReturnedSites[0]
    }
}
