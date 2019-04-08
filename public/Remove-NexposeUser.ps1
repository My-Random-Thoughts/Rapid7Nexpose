Function Remove-NexposeUser {
<#
    .SYNOPSIS
        Deletes a user account.

    .DESCRIPTION
        Deletes a user account.

    .PARAMETER Id
        The identifier of the user.

    .PARAMETER Name
        The user or login name of the user.

    .EXAMPLE
        Remove-NexposeUser -Id 23

    .EXAMPLE
        Remove-NexposeUser -Name 'JoeB'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: users/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [string]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    Begin {
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byId'   { [int]$uid = (Get-NexposeUser -Id   $Id  ).id }
            'byName' { [int]$uid = (Get-NexposeUser -Name $Name).id }
        }

        If ($uid -gt 0) {
            If ($PSCmdlet.ShouldProcess($uid)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "users/$uid" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
