Function Remove-NexposeSiteCredential {
<#
    .SYNOPSIS
        Removes a site credential

    .DESCRIPTION
        Removes a site credential

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER Name
        The identifier of the site credential

    .EXAMPLE
        Remove-NexposeSiteCredential Id 12 -CredentialId 45

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/site_credentials
        DELETE: sites/{id}/site_credentials/{credentialId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$SiteId,

        [string]$Name
    )

    Begin {
    }

    Process {
        If ($Name.Trim().Length -gt 1) {
            # Remove specific credential
            [int]$id = ((Get-NexposeSiteCredential -Site $SiteId -Name $Name -ErrorAction Stop).id)
            If ($id -gt 0) {
                If ($PSCmdlet.ShouldProcess($Name)) {
                    (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials/$id" -RestMethod Delete)
                }
            }
            Else {
                Throw 'Specified account does not exist on this site'
            }
        }
        Else {
            # Remove all credentials
            If ($PSCmdlet.ShouldProcess($SiteId, 'Removing all site specific credentials')) {
                (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials" -RestMethod Delete)
            }
        }

    }

    End {
    }
}
