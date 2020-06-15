Function Update-NexposeSiteAlert {
<#
    .SYNOPSIS
        Updates the specified SMTP, SNMP or Syslog alert

    .DESCRIPTION
        Updates the specified SMTP, SNMP or Syslog alert

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER AlertId
        The identifier of the alert

    .PARAMETER Name
        The name of the alert

    .PARAMETER Enabled
        Flag indicating the alert is enabled

    .PARAMETER MaxAlertsToSend
        The maximum number of alerts that will be issued

    .PARAMETER ScanStarted
        Generates an alert when a scan starts. Default value is false

    .PARAMETER ScanStopped
        Generates an alert when a scan stops. Default value is false

    .PARAMETER ScanFailed
        Generates an alert when a scan fails. Default value is false

    .PARAMETER ScanPaused
        Generates an alert when a scan pauses. Default value is false

    .PARAMETER ScanResumed
        Generates an alert when a scan resumes. Default value is false

    .PARAMETER VulnerabilitySeverity
        Generates an alert for vulnerability results of the selected vulnerability severity. Default value is "any_severity"

    .PARAMETER VulnNotConfirmed
        Generates an alert for vulnerability results of confirmed vulnerabilties. A vulnerability is "confirmed" when asset-specific vulnerability tests, such as exploits, produce positive results. Default value is true

    .PARAMETER VulnNotUnconfirmed
        Generates an alert for vulnerability results of unconfirmed vulnerabilties. A vulnerability is "unconfirmed" when a version of a scanned service or software is known to be vulnerable, but there is no positive verification. Default value is true

    .PARAMETER VulnNotPotential
        Generates an alert for vulnerability results of potential vulnerabilties. A vulnerability is "potential" if a check for a potential vulnerabilty is positive. Default value is true

    .PARAMETER NotificationType
        The type of alert

    .PARAMETER SyslogServer
        The Syslog server to send messages to

    .PARAMETER EmailServer
        The SMTP server/relay to send messages through

    .PARAMETER SMTPRecipients
        The recipient list. At least one recipient must be specified. Each recipient must be a valid e-mail address

    .PARAMETER SenderEmailAddress
        The sender e-mail address that will appear in the from field

    .PARAMETER LimitAlertText
        Reports basic information in the alert, if enabled

    .PARAMETER SNMPServer
        The SNMP management server

    .PARAMETER CommunityString
        The SNMP community name

    .EXAMPLE
        Update-NexposeSiteAlert

    .EXAMPLE
        Update-NexposeSiteAlert

    .EXAMPLE
        Update-NexposeSiteAlert

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/alerts/smtp
        PUT: sites/{id}/alerts/smtp/{alertId}
        PUT: sites/{id}/alerts/snmp
        PUT: sites/{id}/alerts/snmp/{alertId}
        PUT: sites/{id}/alerts/syslog
        PUT: sites/{id}/alerts/syslog/{alertId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [int]$AlertId = -1,

        [switch]$Enabled,

        [string]$Name,

        [int]$MaxAlertsToSend = -1,

        [switch]$ScanStarted,

        [switch]$ScanStopped,

        [switch]$ScanFailed,

        [switch]$ScanPaused,

        [switch]$ScanResumed,

        [ValidateSet('any_severity','severe_and_critical','only_critical')]
        [string]$VulnerabilitySeverity = 'any_severity',

        [switch]$VulnNotConfirmed,

        [switch]$VulnNotPotential,

        [switch]$VulnNotUnconfirmed,

        [Parameter(Mandatory = $true)]
        [ValidateSet('SMTP','SNMP','Syslog')]
        [string]$NotificationType,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySyslog')]
        [string]$SyslogServer,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySMTP')]
        [string]$EmailServer,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySMTP')]
        [string[]]$SMTPRecipients,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySMTP')]
        [string]$SenderEmailAddress,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySNMP')]
        [string]$SNMPServer,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySNMP')]
        [string]$CommunityString
    )

    Begin {
    }

    Process {
        # Build query
        $apiQuery = @{
            enabled = $Enabled.IsPresent
            enabledScanEvents = @{
                started = $ScanStarted.IsPresent
                stopped = $ScanStopped.IsPresent
                failed  = $ScanFailed.IsPresent
                paused  = $ScanPaused.IsPresent
                resumed = $ScanResumed.IsPresent
            }
            enabledVulnerabilityEvents = @{
                vulnerabilitySeverity      = $VulnerabilitySeverity
                confirmedVulnerabilities   = -not ($VulnNotConfirmed.IsPresent)
                potentialVulnerabilities   = -not ($VulnNotPotential.IsPresent)
                unconfirmedVulnerabilities = -not ($VulnNotUnconfirmed.IsPresent)
            }
            name         = $Name
            notification = $NotificationType
        }

        If ($MaxAlertsToSend -gt 0) {
            $apiQuery += @{
                maximumAlerts = $MaxAlertsToSend
            }
        }

        Switch ($NotificationType) {
            'SMTP' {
                $apiQuery += @{
                    relayServer = $EmailServer
                    senderEmailAddress = $SenderEmailAddress
                    recipients  = @(
                        $SMTPRecipients
                    )
                }
            }

            'SNMP' {
                $apiQuery += @{
                    server    = $SNMPServer
                    community = $CommunityString
                }
            }

            'Syslog' {
                $apiQuery += @{
                    server = $SyslogServer
                }
            }
        }

        If ($PSCmdlet.ShouldProcess($SiteId)) {
            [string]$uri = "sites/$SiteId/alerts/$($NotificationType.ToLower())"
            If ($AlertId -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "$uri/$AlertId" -ApiQuery $apiQuery -RestMethod Put)
            }
            Else {
                $alertIds = @((Get-NexposeSiteAlert -SiteId $SiteId -AlertType $NotificationType.ToLower()).Id)
                ForEach ($id In $alertIds) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "$uri/$id" -ApiQuery $apiQuery -RestMethod Put)
                }
            }
        }
    }

    End {
    }
}
