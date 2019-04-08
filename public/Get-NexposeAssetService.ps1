Function Get-NexposeAssetService {
<#
    .SYNOPSIS
        Returns the service running a port and protocol on the asset.

    .DESCRIPTION
        Returns the service running a port and protocol on the asset.

    .PARAMETER Id
        The identifier of the asset

    .PARAMETER Protocol
        The protocol of the service

    .PARAMETER Port
        The port of the service

    .EXAMPLE
        Get-NexposeAssetService -Id 3

    .EXAMPLE
        Get-NexposeAssetService -Id 3 -Protocol tcp -Port 135

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{id}/services
        GET: assets/{id}/services/{protocol}/{port}
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/configurations
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/databases
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/user_groups
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/users
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/vulnerabilities
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/web_applications
        GET: SKIPPED - assets/{id}/services/{protocol}/{port}/web_applications/{webApplicationId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [ValidateSet('ip','icmp','igmp','ggp','tcp','pup','udp','idp','esp','nd','raw')]
        [string]$Protocol,

        [int]$Port
    )

    If (([string]::IsNullOrEmpty($Protocol) -eq $true) -or ([string]::IsNullOrEmpty($Port) -eq $true)) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "assets/$Id/services/" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-NexposeQuery -UrlFunction "assets/$Id/services/$Protocol/$Port" -RestMethod Get)
    }
}
