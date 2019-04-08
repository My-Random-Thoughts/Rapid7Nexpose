Function New-NexposeUser2FAToken {
<#
    .SYNOPSIS
        Regenerates a new authentication token seed (key) and updates it for the user. This key may be then be used in the appropriate 2FA authenticator

    .DESCRIPTION
        Regenerates a new authentication token seed (key) and updates it for the user. This key may be then be used in the appropriate 2FA authenticator

    .PARAMETER Id
        The identifier of the user

    .EXAMPLE
        New-NexposeUser2FAToken -Id 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/settings
        POST: users/{id}/2FA

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    # First, see if 2FA is turned on
    $settings = (Invoke-NexposeQuery -UrlFunction 'administration/settings' -RestMethod Get)
    If ($settings.authentication.'2fa' -eq $false) {
        Write-OUtput 'Two factor authentication is not currently enabled'
    }
    Else {
        If ($PSCmdlet.ShouldProcess($Id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "users/$Id/2FA" -RestMethod Post)
        }
    }
}
