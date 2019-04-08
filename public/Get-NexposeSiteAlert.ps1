Function Get-NexposeSiteAlert {
<#
    .SYNOPSIS
        Retrieves all alerts defined in the site

    .DESCRIPTION
        Retrieves all alerts defined in the site

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER AlertType
        The type of the alert

    .PARAMETER AlertId
        The identifier of the alert

    .EXAMPLE
        Get-NexposeSiteAlert -SiteId 12

    .EXAMPLE
        Get-NexposeSiteAlert -SiteId 23 -AlertType syslog -AlertId 3

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/alerts
        GET: sites/{id}/alerts/smtp
        GET: sites/{id}/alerts/smtp/{alertId}
        GET: sites/{id}/alerts/snmp
        GET: sites/{id}/alerts/snmp/{alertId}
        GET: sites/{id}/alerts/syslog
        GET: sites/{id}/alerts/syslog/{alertId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [Parameter(ParameterSetName = 'byType')]
        [ValidateSet('all','smtp','snmp','syslog')]
        [string]$AlertType = 'all',

        [Parameter(ParameterSetName = 'byType')]
        [int]$AlertId = 0
    )

    [string]$uri = "sites/$SiteId/alerts"
    If (([string]::IsNullOrEmpty($AlertType) -eq $false) -and ($AlertType -ne 'all')) {
        $uri += "/$AlertType"
        If ($AlertId -gt 0) { $uri += "/$AlertId" }
    }

    Write-Output (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Get)
}
