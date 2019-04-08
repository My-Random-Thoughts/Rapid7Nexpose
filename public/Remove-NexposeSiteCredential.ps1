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
        GET: shared_credentials
        DELETE: sites/{id}/site_credentials/{credentialId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$SiteId,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Begin {
    }

    Process {
        [int]$id = 0
        [object]$creds = (Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get)

        ForEach ($credential In $creds) {
            If ($credential.Name -eq $Name) {
                $id = ($credential.id)
                Break
            }
        }

        If ($id -gt 0) {
            If ($PSCmdlet.ShouldProcess($credential.Name)) {
                (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials/$id" -RestMethod Delete)
            }
        }
        Else {
            Throw 'Specified account does not exist'
        }
    }

    End {
    }
}
