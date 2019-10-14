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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Id
    )

    Begin {
    }

    Process {
        [string[]]$pipeLine = $input | ForEach-Object { $_ }    # $input is an automatic variable
        If ($pipeLine) { $Id = $pipeLine }

        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "roles/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
