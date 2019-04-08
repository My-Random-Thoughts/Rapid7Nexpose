Function Remove-NexposeRole {
<#
    .SYNOPSIS
        Removes a role with the specified identifier

    .DESCRIPTION
        Removes a role with the specified identifier. The role must not be built-in and cannot be currently assigned to any users.

    .PARAMETER Id
        The identifier of the role

    .EXAMPLE
        Remove-NexposeRole -Id 'custom-user-01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: roles/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Command)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "roles/$Id" -RestMethod Delete)
        }
    }

    End {
    }
}
