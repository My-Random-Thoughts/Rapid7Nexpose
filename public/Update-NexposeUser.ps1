Function Update-NexposeUser {
<#
    .SYNOPSIS
        Updates the details of a user

    .DESCRIPTION
        Updates the details of a user

    .PARAMETER Id
        The identifier of the user

    .PARAMETER Login
        The login name of the user.

    .PARAMETER FullName
        The full name of the user.

    .PARAMETER SecurePassword
        The password to use for the user.

    .PARAMETER Role
        The privileges and role to assign the user.

    .PARAMETER AuthType
        The details of the authentication source used to authenticate the user.  Defaults to 'normal'

    .PARAMETER Email
        The email address of the user.

    .PARAMETER Disabled
        Whether the user account is enabled.  Defaults to 'false'

    .PARAMETER PasswordResetOnLogin
        Whether to require a reset of the user's password upon first login.  Defaults to 'false'.

    .EXAMPLE
        Update-NexposeUser -Id 23 -FullName 'Joe BillyBob'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: users/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [string]$Login,

        [string]$FullName,

        [securestring]$SecurePassword,

        [string]$Email,

        [ValidateSet('normal','admin','kerberos','ldap','saml')]
        [string]$AuthType = 'normal',

        [switch]$Disabled,

        [switch]$PasswordResetOnLogin
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'Role' -Type 'string' -ValidateSet @((Invoke-NexposeQuery -UrlFunction 'roles' -RestMethod Get).id)
        Return $dynParam
    }

    Begin {
        [string]$Role = $($PSBoundParameters.Role)

        # Convert securestring password into plaintext
        If ([string]::IsNullOrEmpty($SecurePassword) -eq $false) {
            [string]$Password = (ConvertFrom-SecureString -SecureString $SecurePassword)
            [string]$Password = ((New-Object System.Net.NetworkCredential('Null', $(ConvertTo-SecureString -String $Password), 'Null')).Password)
        }

        # Get current values
        $user = (Get-NexposeUser -Id $Id -ShowAsignedGroups -ShowAsignedSites)

        If ([string]::IsNullOrEmpty($Login)    -eq $true) { $Login    = $user.login   }
        If ([string]::IsNullOrEmpty($FullName) -eq $true) { $FullName = $user.name    }
        If ([string]::IsNullOrEmpty($Email)    -eq $true) { $Email    = $user.email   }
        If ([string]::IsNullOrEmpty($AuthType) -eq $true) { $AuthType = $user.authentication.type }
        If ([string]::IsNullOrEmpty($Role)     -eq $true) { $Role     = $user.role.id }
    }

    Process {
        [boolean]$allSites       = $false
        [boolean]$allAssetGroups = $false

        # Make sure correct authentication type is set
        If     (($AuthType -eq 'normal') -and ($Role -eq 'global-admin')) { $AuthType = 'admin'  }
        ElseIf (($AuthType -eq 'admin')  -and ($Role -ne 'global-admin')) { $AuthType = 'normal' }

        # Ensure correct sites and assets privileges are set
        $privileges = @((Get-NexposeRole -Id $Role).privileges)

        If (($privileges -contains 'all-permissions') -or
            ($privileges -contains 'manage-dynamic-asset-groups')) {
            $allAssetGroups = $true
        }

        If (($privileges -contains 'all-permissions') -or
            ($privileges -contains 'manage-sites') -or
            ($privileges -contains 'manage-tags')) {
            $allSites = $true
        }

        $apiQuery = @{
            login   =  $Login
            name    =  $FullName
            email   =  $Email.ToLower()
            enabled =  (-not $Disabled.IsPresent)
            role    = @{
                id             = $Role.ToLower()
                allSites       = $user.role.allSites
                allAssetGroups = $user.role.allAssetGroups
            }
            authentication = @{ type = $AuthType.ToLower() }
        }

        If (($AuthType -eq 'normal') -or ($AuthType -eq 'admin')) {
            $apiQuery += @{
                passwordResetOnLogin = ($PasswordResetOnLogin.IsPresent)
            }

            If ([string]::IsNullOrEmpty($Password) -eq $false) {
                $apiQuery += @{
                    password =  $Password
                }
            }
        }

        If ($PSCmdlet.ShouldProcess($Login)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "users/$Id" -ApiQuery $apiQuery -RestMethod Put)
            If ($($user.role.allSites) -eq $false) {
                ForEach ($siteId In $($user.role.sites)) {
                    Add-NexposeUserToSite -UserId $Id -SiteId $siteId    # Add user sites back, as they get removed
                }
            }

            If ($($user.role.allAssetGroups) -eq $false) {
                ForEach ($assGrpId In $($user.role.assetGroups)) {
                    Add-NexposeUserToAssetGroup -UserId $Id -AssetGroupId $assGrpId    # Add user asset groups back, as they get removed
                }
            }
        }
    }

    End {
    }
}
