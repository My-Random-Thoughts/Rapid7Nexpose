Function Set-NexposeUser2FAToken {
<#
    .SYNOPSIS
        Sets the authentication token seed (key) for the user. This key may be then be used in the appropriate 2FA authenticator

    .DESCRIPTION
        Sets the authentication token seed (key) for the user. This key may be then be used in the appropriate 2FA authenticator

    .PARAMETER Id
        The identifier of the user

    .PARAMETER TokenCode
        The authentication token seed (key) to use for the user

    .EXAMPLE
        Set-NexposeUser2FAToken -Id 42 -TokenCode

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/settings
        PUT: users/{id}/2FA

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [string]$TokenCode
    )

    Begin {
        $settings = (Invoke-NexposeQuery -UrlFunction 'administration/settings' -RestMethod Get)
        If ($settings.authentication.'2fa' -eq $false) {
            Throw 'Two factor authentication is not currently enabled'
        }

        # Validate input string

    }

    Process {
        If ($PSCmdlet.ShouldProcess($Id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "users/$Id/2FA" -ApiQuery $TokenCode -RestMethod Put)
        }
    }

    End {
    }
}
