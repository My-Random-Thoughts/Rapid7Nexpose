Function Remove-NexposeUserFromSite {
<#
    .SYNOPSIS
        Revokes access from a user to the site

    .DESCRIPTION
        Revokes access from a user to the site

    .PARAMETER UserId
        The identifier of the user to remove

    .PARAMETER SiteId
        The identifier of the site

    .EXAMPLE
        Remove-NexposeUserFromSite -UserId 5 -SiteId 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: users/{id}/sites/{siteId}
        DELETE: SKIPPED - sites/{id}/users/{userId}    # Duplicate of above
        DELETE: SKIPPED - users/{id}/sites             # Will remove all sites from a user

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,

        [Parameter(Mandatory = $true)]
        [int]$SiteId
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($UserId)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "users/$UserId/sites/$SiteId" -RestMethod Delete)
        }
    }

    End {
    }
}
