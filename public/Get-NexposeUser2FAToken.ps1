Function Get-NexposeUser2FAToken {
<#
    .SYNOPSIS
        Retrieves the current authentication token seed (key) for the user, if configured

    .DESCRIPTION
        Retrieves the current authentication token seed (key) for the user, if configured

    .PARAMETER Id
        The identifier of the user

    .EXAMPLE
        Get-NexposeUser2FAToken -Id 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/settings
        GET: users/{id}/2FA

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    # First, see if 2FA is turned on
    $settings = (Invoke-NexposeQuery -UrlFunction 'administration/settings' -RestMethod Get)
    If ($settings.authentication.'2fa' -eq $false) {
        Write-Output 'Two factor authentication is not currently enabled'
    }
    Else {
        Write-Output (Invoke-NexposeQuery -UrlFunction "users/$Id/2FA" -RestMethod Get)
    }
}
