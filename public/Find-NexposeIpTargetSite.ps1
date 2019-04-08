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

        ForEach ($ip In $ipRangeInclude) {
            [version]$ipStart, [version]$ipEnd = (($ip.ToString()).Split('-'))
            If (($ipConvert -ge $ipStart) -and ($ipConvert -le $ipEnd)) {
                [void]$ReturnedSites.Add($site)
            }
        }

        ForEach ($ip In $ipRangeExclude) {
            [version]$ipStart, [version]$ipEnd = (($ip.ToString()).Split('-'))
            If (($ipConvert -ge $ipStart) -and ($ipConvert -le $ipEnd)) {
                If ($ReturnedSites.Contains($site)) { [void]$ReturnedSites.Remove($site) }
            }
        }
    }

    If ($ReturnedSites[0] -gt 0) {
        Write-Output $ReturnedSites[0]
    }
}
