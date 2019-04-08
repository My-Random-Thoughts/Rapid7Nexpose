Function Get-NexposeRole {
<#
    .SYNOPSIS
        Retrieves the details of a role

    .DESCRIPTION
        Retrieves the details of a role

    .PARAMETER Id
        The identifier of the role

    .EXAMPLE
        Get-NexposeRole -Id 'global-admin'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: roles
        GET: roles/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [string]$Id = 0
    )

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "roles/$Id" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-NexposeQuery -UrlFunction 'roles' -RestMethod Get)    # Return All
    }
}
