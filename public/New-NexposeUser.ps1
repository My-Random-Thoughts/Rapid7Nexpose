Function New-NexposeUser {
<#
    .SYNOPSIS
        Creates a new user

    .DESCRIPTION
        Creates a new user

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

    .PARAMETER SiteAccess
        The name or identifier of one or more sites to assign this user to.  This option is ignored if the user is an administrator

    .PARAMETER AssetGroupAccess
        The name or identifier of one or more asset groups to assign this user to.  This option is ignored if the user is an administrator

    .EXAMPLE
        New-NexposeUser -Login 'JoeB' -FullName 'Joe Bloggs' -SecurePassword $pass -Email 'jb@example.com' -Disabled

    .EXAMPLE
        New-NexposeUser -Login 'JoeB' -FullName 'Joe Bloggs' -SecurePassword $pass -Email 'jb@example.com' -Disabled -SiteAccess ('Site A', 23)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: roles
        POST: users

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Login,

        [Parameter(Mandatory = $true)]
        [string]$FullName,

        [Parameter(Mandatory = $true)]
        [securestring]$SecurePassword,

        [Parameter(Mandatory = $true)]
        [string]$Email,

        [ValidateSet('normal','admin','kerberos','ldap','saml')]
        [string]$AuthType = 'normal',

        [switch]$Disabled,

        [switch]$PasswordResetOnLogin,

        [Parameter(Mandatory = $true)]
        [string[]]$SiteAccess,

        [Parameter(Mandatory = $true)]
        [string[]]$AssetGroupAccess
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'Role' -Type 'string' -ValidateSet @((Get-NexposePagedData -UrlFunction 'roles' -RestMethod Get).id)
        Return $dynParam
    }

    Begin {
        [string]$Role = $($PSBoundParameters.Role)
        If ([string]::IsNullOrEmpty($Role) -eq $true) { $Role = 'user' }

        # Convert securestring password into plaintext
        [string]$Password = (ConvertFrom-SecureString -SecureString $SecurePassword)
        [string]$Password = ((New-Object System.Net.NetworkCredential('Null', $(ConvertTo-SecureString -String $Password), 'Null')).Password)
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
                allSites       = $allSites
                allAssetGroups = $allAssetGroups
            }
            authentication = @{ type = $AuthType.ToLower() }
        }

        If (($AuthType -eq 'normal') -or ($AuthType -eq 'admin')) {
            $apiQuery += @{
                password             =  $Password
                passwordResetOnLogin = ($PasswordResetOnLogin.IsPresent)
            }
        }

        If ($PSCmdlet.ShouldProcess($Login)) {
            $user = (Invoke-NexposeQuery -UrlFunction 'users' -ApiQuery $apiQuery -RestMethod Post)
            If ($user.id -is [int]) {

                If (($allSites -eq $false) -and ($SiteAccess.Count -gt 0)) {
                    Add-NexposeUserToSite -UserId $($user.id) -SiteId $SiteAccess
                }

                If (($allAssetGroups -eq $false) -and ($AssetGroupAccess.Count -gt 0)) {
                    Add-NexposeUserToAssetGroup -UserId ($user.id) -AssetGroupId $AssetGroupAccess
                }

                Write-Output (Get-NexposeUser -Id ($user.id))
            }
        }
    }

    End {
    }
}
