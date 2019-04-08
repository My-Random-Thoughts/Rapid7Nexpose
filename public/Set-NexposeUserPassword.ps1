Function Set-NexposeUserPassword {
<#
    .SYNOPSIS
        Changes the password for the user. Users may only change their own password

    .DESCRIPTION
        Changes the password for the user. Users may only change their own password.
        Once this command is executed, the current API session will be invalidated.

    .PARAMETER NewPassword
        The new password to set

    .PARAMETER RecreateApiSession
        Create an API session using the new password

    .EXAMPLE
        Set-NexposeUserPassword -Id 42 -NewPassword $Creds

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: users/{id}/password

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [pscredential]$NewPassword,

        [switch]$RecreateApiSession
    )

    Begin {
    }

    Process {
        # Get current username from connection string and convert to id
        [string]$authString = (($global:NexposeSession.Headers.Authorization).Split(' ')[1])
        [int[]] $byteArray  = ([Convert]::FromBase64String($authString))
        [string]$username   = [Text.Encoding]::ASCII.GetString($byteArray).Split(':')[0]
        [int]   $Id         = (ConvertTo-NexposeId -Name $username -ObjectType User)

        # Convert credential object into clear-text password (it's how the API works)
        [string]$securePW = (ConvertFrom-SecureString -SecureString $NewPassword.Password)
        [string]$clearPW  = (New-Object System.Net.NetworkCredential('Null', $(ConvertTo-SecureString -String $securePW), 'Null')).Password

        If ($PSCmdlet.ShouldProcess("$UserName ($Id)")) {
            [object]$result = (Invoke-NexposeQuery -UrlFunction "users/$Id/password" -ApiQuery $clearPW -RestMethod Put -IncludeLinks)

            If ($($result.links.href).Length -gt 0) {
                Clear-Variable -Name 'NexposeSession'

                If ($RecreateApiSession.IsPresent) {
                    [string]      $hostName   = ($global:NexposeSession.Headers.HostName)
                    [int]         $hostPort   = ($global:NexposeSession.Headers.Port)
                    [pscredential]$credential = (New-Object -TypeName 'System.Management.Automation.PSCredential' -ArgumentList $username, $NewPassword.Password)

                    $Status = (Connect-NexposeAPI -HostName $hostName -Port $hostPort -Credential $credential)
                    Write-Verbose "$($status.StatusCode) $($Status.StatusDescription)"
                }
            }
        }
    }

    End {
        Clear-Variable -Name ('clearPW', 'securePW') -Force
    }
}
