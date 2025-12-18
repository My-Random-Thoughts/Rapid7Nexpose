Function Get-NexposeUserLastLogon {
<#
    .SYNOPSIS
        Returns the last login time for a user

    .DESCRIPTION
        Returns the last login time for a user

    .PARAMETER Id
        The identifier of the user

    .PARAMETER Name
        The login name of the user

    .PARAMETER ForceData
        Forces the return of a date value if instead of 'No data returned'

    .EXAMPLE
        Get-NexposeUserLastLogon -Id 42

    .EXAMPLE
        Get-NexposeUserLastLogon -Name JoeBlogg

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    [OutputType([string])]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [switch]$ForceDate
    )

    Begin {
    }

    Process {
        # Using interal call as the API does not support this
        $userList = @(Invoke-NexposeRestMethod -Uri '/data/admin/users?printDocType=0&tableID=UserAdminSynopsis' -Method 'Get' -TimeOut 300)

        If (-not $userList) {
            Throw 'Unable to retreive user list'
        }

        If ($PSCmdlet.ParameterSetName -eq 'byName') {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType 'User')
            If ([string]::IsNullOrEmpty($Name) -eq $false) { $Id = $Name }
        }

<#
    Column  0 = "Authentication Module"
    Column  1 = "User ID"                <--
    Column  2 = "Authenticator"
    Column  3 = "User Name"
    Column  4 = "Full Name"
    Column  5 = "Email"
    Column  6 = "Administrator"
    Column  7 = "User Role"
    Column  8 = "SSO Enabled"
    Column  9 = "Last Logon"             <---
    Column 10 = "Expiration Time"
    Column 11 = "Disabled"
    Column 12 = "Locked"
    Column 13 = "Site Count"
    Column 14 = "Group Count"
    Column 15 = "Silo Count"
#>

        ForEach ($user In ($userList.DynTable.Data.tr)) {
            $xmlId    = $user.ChildNodes[1].InnerText
            $xmlLogin = $user.ChildNodes[9].InnerText

            If ((-not $xmlLogin) -and (-not $ForceDate)) {
                Return 'No data returned'
            }
            If ($xmlId -eq $Id) {
                Return ((Get-Date -Date '1970-01-01').AddMilliseconds($xmlLogin) -as [datetime])
            }
        }

        Return 'Unknown user account'
    }

    End {
    }
}

