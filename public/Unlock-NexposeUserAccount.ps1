Function Unlock-NexposeUserAccount {
<#
    .SYNOPSIS
        Unlocks a locked user account that has too many failed authentication attempts. Disabled accounts may not be unlocked.

    .DESCRIPTION
        Unlocks a locked user account that has too many failed authentication attempts. Disabled accounts may not be unlocked.

    .PARAMETER Id
        The identifier of the user.

    .PARAMETER Name
        The name of the user

    .EXAMPLE
        Unlock-NexposeUserAccount -Id 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: users/{id}/lock

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    If ($PSCmdlet.ParameterSetName -eq 'byName') {
        $Id = (ConvertTo-NexposeId -Name $Name -ObjectType 'User')
    }

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "users/$Id/lock" -RestMethod Delete)
    }
}
