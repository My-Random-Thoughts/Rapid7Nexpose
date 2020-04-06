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

    .EXAMPLE
        Get-NexposeUserLastLogon -Id 42

    .EXAMPLE
        Get-NexposeUserLastLogon -Name JoeBlogg

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    Begin {
        If ((Test-Path -Path variable:global:NexposeSession) -eq $false) {
            Throw "A valid session token has not been created, please use 'Connect-NexposeAPI' to create one"
        }

        # Using interal call as API does not support this
        [string]$HostName  = $($global:NexposeSession.Headers['HostName'])
        [int]   $Port      = $($global:NexposeSession.Headers['Port'])
        [hashtable]$iRestM = @{
            Uri = ('https://{0}:{1}/data/admin/users?printDocType=0&tableID=UserAdminSynopsis' -f $HostName, $Port)
            Method = 'GET'
            WebSession = $global:NexposeSession
        }

        $userList = @(Invoke-RestMethod @iRestM -Verbose:$false -TimeoutSec 300 -ErrorAction Stop)
        If (-not $userList) {
            Throw 'Unable to retreive user list'
        }

        If ($PSCmdlet.ParameterSetName -eq 'byName') {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType 'User')
            If ([string]::IsNullOrEmpty($Name) -eq $false) { $Id = $Name }
        }
    }

    Process {
        ForEach ($user In ($userList.DynTable.Data.tr)) {
            $xmlId    = $user.ChildNodes[1].InnerText
            $xmlLogin = $user.ChildNodes[8].InnerText

            If (-not $xmlLogin) {
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
