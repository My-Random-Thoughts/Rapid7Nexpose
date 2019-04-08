Function Remove-NexposeSiteAlert {
<#
    .SYNOPSIS
        Deletes the alerts defined in the site

    .DESCRIPTION
        Deletes the alerts defined in the site

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER AlertType
        The type of the alert

    .PARAMETER AlertId
        The identifier of the alert

    .EXAMPLE
        Remove-NexposeSiteAlert -SiteId 12

    .EXAMPLE
        Remove-NexposeSiteAlert -SiteId 23 -AlertType syslog -AlertId 3

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/alerts
        DELETE: sites/{id}/alerts/smtp
        DELETE: sites/{id}/alerts/smtp/{alertId}
        DELETE: sites/{id}/alerts/snmp
        DELETE: sites/{id}/alerts/snmp/{alertId}
        DELETE: sites/{id}/alerts/syslog
        DELETE: sites/{id}/alerts/syslog/{alertId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
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

    If ($PSCmdlet.ShouldProcess($SiteId)) {
        Write-Output (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Delete)
    }
}
