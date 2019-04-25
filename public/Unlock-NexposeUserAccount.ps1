Function Unlock-NexposeUserAccount {
<#
    .SYNOPSIS
        Unlocks a locked user account that has too many failed authentication attempts. Disabled accounts may not be unlocked.

    .DESCRIPTION
        Unlocks a locked user account that has too many failed authentication attempts. Disabled accounts may not be unlocked.

    .PARAMETER Id
        The identifier of one or more users.

    .PARAMETER Name
        The name of one or more users.

    .PARAMETER InputObject
        A user account object from 'Get-NexposeUser'

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
        [int[]]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string[]]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'byObject', ValueFromPipeline = $true)]
        [object[]]$InputObject
    )

    Begin {
        [int[]]$IdList = @()
        Switch ($PSCmdlet.ParameterSetName) {
            'byId'     { $IdList = $Id.Clone() }
            'byName'   { ForEach ($item In $Name)        { $IdList += (ConvertTo-NexposeId -ObjectType User -Name $item -Verbose:$false) } }
            'byObject' { ForEach ($item In $InputObject) { $IdList += $item.id } }
        }
    }

    Process {
        [int[]]$pipeLine = $input | ForEach-Object { $_.id }    # $input is an automatic variable
        If ($pipeLine) { $InputObject = $pipeLine } Else { $InputObject = $IdList }

        ForEach ($item In $InputObject) {
            If ($item -gt 0) {
                $account = (Get-NexposeUser -Id $item)
                Write-Verbose "Unlocking user account '$($account.login)'"

                If (($account.locked) -eq $true) {
                    [void](Invoke-NexposeQuery -UrlFunction "users/$item/lock" -RestMethod Delete)
                    Write-Output "Account '$($account.login)' unlocked"
                }
                Else {
                    Write-Output "Account '$($account.login)' not locked"
                }
            }
            ElseIf ($item -eq 0) {
                Write-Error "Unknown user account"
            }
            Else {
                Write-Error "Unknown input type"
            }
        }
    }

    End {
    }
}
