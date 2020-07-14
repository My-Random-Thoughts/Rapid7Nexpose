Function Set-NexposeSiteCredentialEnablement {
<#
    .SYNOPSIS
        Enable or disable the site credential for scans

    .DESCRIPTION
        Enable or disable the site credential for scans

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER CredId
        The identifier of the site credential

    .PARAMETER IsSharedCredential
        Flag indicating whether the credential is a shared one or site specific

    .PARAMETER Enabled
        Flag indicating whether the credential is enabled for use during the scan

    .PARAMETER Disabled
        Flag indicating whether the credential is disabled for use during the scan

    .EXAMPLE
        Set-NexposeSiteCredentialEnablement -SiteId 12 -CredId 34 -Enabled $false

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/shared_credentials/{credentialId}/enabled
        PUT: sites/{id}/site_credentials/{credentialId}/enabled

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [Parameter(Mandatory = $true)]
        [int]$CredId,

        [switch]$IsSharedCredential,

        [Parameter(Mandatory = $true, ParameterSetName = 'byEnabled')]
        [switch]$Enabled,

        [Parameter(Mandatory = $true, ParameterSetName = 'byDisabled')]
        [switch]$Disabled
    )

    Begin {
        If ($PSCmdlet.ParameterSetName -eq 'byEnabled' ) { [string]$Setting = 'True'  }
        If ($PSCmdlet.ParameterSetName -eq 'byDisabled') { [string]$Setting = 'False' }
    }

    Process {
        If ($PSCmdlet.ShouldProcess("$SiteId-$CredId")) {
            If ($IsSharedCredential.IsPresent) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/shared_credentials/$CredId/enabled" -ApiQuery $Setting -RestMethod Put)
            }
            Else {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials/$CredId/enabled" -ApiQuery $Setting -RestMethod Put)
            }
        }
    }

    End {
    }
}
