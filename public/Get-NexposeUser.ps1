Function Get-NexposeUser {
<#
    .SYNOPSIS
        Returns the specified user

    .DESCRIPTION
        Returns the specified user by id, name, role or privilege

    .PARAMETER Id
        The identifier of the user

    .PARAMETER Name
        The name or login identifier of the user

    .PARAMETER Role
        The user accounts assigned to a specific role

    .PARAMETER Privilege
        The user accounts assigned a specific privilege

    .PARAMETER AuthenticationSource
        The user accounts that use the authentication source to authenticate

    .PARAMETER Site
        The name or identifier of the site to query

    .PARAMETER ShowAsignedGroups
        Show any asset groups assigned to this user.  This is only shown if the user is not assigned to all groups

    .PARAMETER ShowAsignedSites
        Show any sites assigned to this user.  This is only shown if the user is not assigned to all sites

    .EXAMPLE
        Get-NexposeUser -Id 3

    .EXAMPLE
        Get-NexposeUser -Name JoeBlogg

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: users
        GET: users/{id}
        GET: users/{id}/asset_groups
        GET: users/{id}/sites
        GET: roles/{id}/users
        GET: privileges/{id}/users
        GET: authentication_sources/{id}/users
        GET: SKIPPED - users/{id}/privileges
        GET: SKIPPED - assets/{id}/users          # Duplicate of above
        GET: SKIPPED - asset_groups/{id}/users    # Duplicate of above
        GET: SKIPPED - sites/{id}/users           # Duplicate of above

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byAuth')]
        [ValidateSet('normal','kerberos','ldap','saml','admin')]
        [string]$AuthenticationSource,

        [Parameter(ParameterSetName = 'bySite')]
        [string]$Site,

        [Parameter(ParameterSetName = 'byId')]
        [Parameter(ParameterSetName = 'byName')]
        [switch]$ShowAsignedGroups,

        [Parameter(ParameterSetName = 'byId')]
        [Parameter(ParameterSetName = 'byName')]
        [switch]$ShowAsignedSites
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'Privilege' -Type 'string' -ParameterSetName 'byPriv' -ValidateSet (Get-NexposePrivilege)
        New-DynamicParameter -Dictionary $dynParam -Name 'Role'      -Type 'string' -ParameterSetName 'byRole' -ValidateSet (@((Invoke-NexposeQuery -UrlFunction 'roles' -RestMethod Get).id))
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$Role      = $($PSBoundParameters.Role)
        [string]$Privilege = $($PSBoundParameters.Privilege)
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byId' {
                If ($Id -gt 0) {
                    $userDetails = (Invoke-NexposeQuery -UrlFunction "users/$Id" -RestMethod Get)

                    # Add all asset groups assigned to the user
                    If ($ShowAsignedGroups.IsPresent) {
                        If ($userDetails.role.allAssetGroups -eq $false) {
                            [object[]]$groupIDs = @(Invoke-NexposeQuery -UrlFunction "users/$Id/asset_groups" -RestMethod Get)
                            If (($groupIDs.Count -gt 0) -and ($groupIDs[0].GetType() -eq [int])) {
                                $userDetails.role | Add-Member -Name 'assetGroups' -Value $groupIDs -MemberType NoteProperty
                            }
                        }
                    }

                    # Add all sites assigned to the user
                    If ($ShowAsignedSites.IsPresent) {
                        If ($userDetails.role.allSites -eq $false) {
                            [object[]]$siteIDs = @(Invoke-NexposeQuery -UrlFunction "users/$Id/sites" -RestMethod Get)
                            If (($siteIDs.Count -gt 0) -and ($siteIDs[0].GetType() -eq [int])) {
                                $userDetails.role | Add-Member -Name 'sites' -Value $siteIDs -MemberType NoteProperty
                            }
                        }
                    }

                    Write-Output $userDetails
                }
                Else {
                    Write-Output @(Invoke-NexposeQuery -UrlFunction 'users' -RestMethod Get)    # Return All
                }
            }

            'byName' {
                $Name = (ConvertTo-NexposeId -Name $Name -ObjectType 'User')
                If ([string]::IsNullOrEmpty($Name) -eq $false) {
                    ForEach ($uid In $Name) {
                        Write-Output (Get-NexposeUser -Id $uid)
                    }
                }
            }

            'bySite' {
                $Site = (ConvertTo-NexposeId -Name $Name -ObjectType 'Site')
                If ([string]::IsNullOrEmpty($Site) -eq $false) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Site/users" -RestMethod Get)
                }
            }

            Default {
                Switch ($PSCmdlet.ParameterSetName) {
                    'byRole' { $users = @(Invoke-NexposeQuery -UrlFunction "roles/$Role/users"           -RestMethod Get) }
                    'byPriv' { $users = @(Invoke-NexposeQuery -UrlFunction "privileges/$Privilege/users" -RestMethod Get) }
                    'byAuth' {
                        $authId = (ConvertTo-NexposeId -Name $AuthenticationSource -ObjectType AuthSource)
                        $users  = @(Invoke-NexposeQuery -UrlFunction "authentication_sources/$authId/users"   -RestMethod Get)
                    }
                }

                If ([string]::IsNullOrEmpty($users) -eq $false) {
                    ForEach ($uid In $users) {
                        Write-Output (Get-NexposeUser -Id $uid)
                    }
                }
            }
        }
    }

    End {
    }
}
