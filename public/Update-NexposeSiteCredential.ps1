Function Update-NexposeSiteCredential {
<#
    .SYNOPSIS
        Updates a site credential

    .DESCRIPTION
        Updates a site credential.  Note you can't change the service type of a credential.  To do this, remove it and create a new one.  Additionally all passwords must be specified when changing any part of a credential, this is an API bug.

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER Id
        The identifier of the credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Description
        The description of the credential

    .PARAMETER HostRestriction
        The host name or IP address that you want to restrict the credentials to

    .PARAMETER PortRestriction
        Further restricts the credential to attempt to authenticate on a specific port. The port can only be restricted if the property hostRestriction is specified - This is an API bug

    .EXAMPLE
        Update-NexposeSiteCredential -SiteId 123 -Id 42 -Description 'New Cred Description' -Password 'Passw0rd!'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/site_credentials/{credentialId}
        PUT: SKIPPED - sites/{id}/site_credentials    # Not updating every credential in one go.

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$SiteId,

        [Parameter(Mandatory = $true)]
        [int]$Id,

        [string]$Name,

        [string]$Description,

        [string]$HostRestriction,

        [ValidateRange(1, 65535)]
        [int]$PortRestriction
    )

    DynamicParam {
        $currCredential = (Get-NexposeSiteCredential -Site $SiteId -Id $Id)
        [string]$service = ($currCredential.account.service)

        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        Switch ($service) {
            'as400' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifshash' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'NTLMHash' -Type 'string' -Mandatory
            }

            'cvs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'db2' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ftp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'http' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Realm'    -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ms-sql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string' -Mandatory
            }

            'mysql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'notes' {
                New-DynamicParameter -Dictionary $dynParam -Name 'NotesIdPassword' -Type 'string' -Mandatory
            }

            'oracle' {
                New-DynamicParameter -Dictionary $dynParam -Name 'SID'                    -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'               -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'               -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'EnumerateSids'          -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'OracleListenerPassword' -Type 'string'
            }

            'pop' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'postgresql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'remote-exec' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'snmp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'CommunityName' -Type 'string' -Mandatory
            }

            'snmpv3' {
                New-DynamicParameter -Dictionary $dynParam -Name 'AuthenticationType' -Type 'string' -ValidateSet ('no-authentication','md5','sha')
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'           -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'           -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyType'        -Type 'string' -ValidateSet ('no-privacy','des','aes-128','aes-192','aes-192-with-3-des-key-extension','aes-256','aes-265-with-3-des-key-extension')
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyPassword'    -Type 'string'
            }

            'ssh' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string' -Mandatory
            }

            'ssh-key' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivateKeyPassword'          -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PEMKey'                      -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string' -Mandatory
            }

            'sybase' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string' -Mandatory
            }

            'telnet' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }
        }
        Return $dynParam
    }

    Begin {
        [string[]]$accountParameters = @()
        $accountParameters += ($currCredential.account | Get-Member -MemberType NoteProperty).Name

        # Validate account name does not already exist
        [object]$creds = Get-NexposeSiteCredential -Site $SiteId
        ForEach ($credential In $creds) {
            If ($credential.Name -eq $Name) { Throw 'Site credentials already exist with this name' }
        }

        # This loops through bound parameters.  If no corresponding variable exists, one is created
        Function _temp { [cmdletbinding()] param() }
        $BoundKeys = ($PSBoundParameters.Keys | Where-Object { (Get-Command _temp | Select-Object -ExpandProperty Parameters).Keys -notcontains $_ })
        ForEach ($param in $BoundKeys) {
            If (-not (Get-Variable -Name $param -ErrorAction SilentlyContinue)) {
                If (-not ($param -match 'Password|PEMKey|NTLMHash|WhatIf')) {
                    Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
                }
                New-Variable -Name $param -Value $PSBoundParameters.$param -Visibility Private -WhatIf:$false
            }
            $accountParameters += $param
        }

        # Get current details
        If ([string]::IsNullOrEmpty($Name           ) -eq $true) { $Name            = $currCredential.name            }
        If ([string]::IsNullOrEmpty($Description    ) -eq $true) { $Description     = $currCredential.description     }
        If ([string]::IsNullOrEmpty($HostRestriction) -eq $true) { $HostRestriction = $currCredential.hostRestriction }
        If ([string]::IsNullOrEmpty($PortRestriction) -eq $true) { $PortRestriction = $currCredential.portRestriction }
    }

    Process {
        $apiQuery = @{
            name        = $Name
            description = $Description
            account     = @{}
        }

        If (-not [string]::IsNullOrEmpty($HostRestriction)) {
            $apiQuery += @{ hostRestriction = $HostRestriction }
            If ($PortRestriction -ne 0) { $apiQuery += @{ portRestriction = $PortRestriction }}    # BUG Workaround: 00229963
        }

        ForEach ($param In $accountParameters) {
            $camelCase = [string]::Concat($param.Substring(0,1).ToLower(), $param.Substring(1))
            $value = (Get-Variable -Name "$param" -ValueOnly -ErrorAction SilentlyContinue)
            If ($value) { $apiQuery.account += @{ "$camelCase" = $value } }
            Else        { $apiQuery.account += @{ "$param" = $currCredential.account.$param } }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials/$Id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
