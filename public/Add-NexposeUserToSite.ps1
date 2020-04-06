Function Add-NexposeUserToSite {
<#
    .SYNOPSIS
        Grants a user with sufficient privileges access to the site

    .DESCRIPTION
        Grants a user with sufficient privileges access to the site

    .PARAMETER UserId
        The identifier of the user to add

    .PARAMETER SiteId
        The identifier of the site

    .EXAMPLE
        Add-NexposeUserToSite -UserId 5 -SiteId 23

    .EXAMPLE
        Add-NexposeUserToSite -UserId 5 -SiteId (23, 'Site B')

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: users/{id}/sites/{siteId}
        PUT: SKIPPED - users/{id}/sites     # Reverse of this function
        PUT: SKIPPED - sites/{id}/users     # Duplicate of above
        POST: SKIPPED - sites/{id}/users    # Duplicate of above

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,

        [Parameter(Mandatory = $true)]
        [string[]]$SiteId
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($UserId)) {
            ForEach ($site In $SiteId) {
                [int]$id = (ConvertTo-NexposeId -Name $site -ObjectType Site)
                Write-Output (Invoke-NexposeQuery -UrlFunction "users/$UserId/sites/$id" -RestMethod Put)
            }
        }
    }

    End {
    }
}
