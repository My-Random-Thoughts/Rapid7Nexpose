Function New-NexposeCredential {
<#
    .SYNOPSIS
        Creates a new site or shared credential

    .DESCRIPTION
        Creates a new site or shared credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Description
        The description of the credential

    .PARAMETER IsSiteCredential
        Toggle to specify the new credential is a site specific one.  Defaults to a shared credential

    .PARAMETER SiteId
        The identifier of the site for the site credential

    .PARAMETER Service
        Specify the type of service to authenticate as well as all of the information required by that service

    .PARAMETER HostRestriction
        The host name or IP address that you want to restrict the credentials to

    .PARAMETER PortRestriction
        Further restricts the credential to attempt to authenticate on a specific port. The port can only be restricted if the property hostRestriction is specified

    .PARAMETER SiteAssignment
        Assigns the shared scan credential either to be available to all sites or to a specific list of sites

    .PARAMETER Site
        List of site identifiers. These sites are explicitly assigned access to the shared scan credential, allowing the site to use the credential for authentication during a scan

    .EXAMPLE
        New-NexposeCredential -Name 'Domain Admin' -SiteId 3 -Service cifs -Domain 'example.com' -Username 'BillyJoeBob' -Password 'Password!'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/site_credentials
        GET: shared_credentials
        POST: sites/{id}/site_credentials
        POST: shared_credentials

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Description,

        [Parameter(ParameterSetName = 'bySite')]
        [switch]$IsSiteCredential,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySite')]
        [string]$SiteId = 0,

        [Parameter(Mandatory = $true)]
        [ValidateSet('as400','cifs','cifshash','cvs','db2','ftp','http','ms-sql','mysql','notes','oracle','pop','postgresql','remote-exec','snmp','snmpv3','ssh','ssh-key','sybase','telnet')]
        [string]$Service,

        [Parameter(ParameterSetName = 'byRestriction')]
        [Parameter(ParameterSetName = 'byShared')]
        [Parameter(ParameterSetName = 'bySite')]
        [string]$HostRestriction,

        [Parameter(ParameterSetName = 'byRestriction')]
        [Parameter(ParameterSetName = 'byShared')]
        [Parameter(ParameterSetName = 'bySite')]
        [ValidateRange(1, 65535)]
        [int]$PortRestriction,

        [Parameter(Mandatory = $true, ParameterSetName = 'byShared')]
        [ValidateSet('all-sites', 'specific-sites')]
        [string]$SiteAssignment = 'all-sites',

        [Parameter(ParameterSetName = 'byShared')]
        [int[]]$Site
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        Switch ($Service) {
            'as400' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'cifshash' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'NTLMHash' -Type 'string' -Mandatory
            }

            'cvs' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'   -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'db2' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ftp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'http' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Realm'    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'ms-sql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string' -Mandatory
            }

            'mysql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'notes' {
                New-DynamicParameter -Dictionary $dynParam -Name 'NotesIdPassword' -Type 'string' -Mandatory
            }

            'oracle' {
                New-DynamicParameter -Dictionary $dynParam -Name 'SID'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'               -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'               -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'EnumerateSids'          -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'OracleListenerPassword' -Type 'string'
            }

            'pop' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'postgresql' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'remote-exec' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }

            'snmp' {
                New-DynamicParameter -Dictionary $dynParam -Name 'CommunityName' -Type 'string' -Mandatory
            }

            'snmpv3' {
                New-DynamicParameter -Dictionary $dynParam -Name 'AuthenticationType' -Type 'string' -Mandatory -ValidateSet ('no-authentication','md5','sha')
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'           -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'           -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyType'        -Type 'string' -Mandatory -ValidateSet ('no-privacy','des','aes-128','aes-192','aes-192-with-3-des-key-extension','aes-256','aes-265-with-3-des-key-extension')
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivacyPassword'    -Type 'string'
            }

            'ssh' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -Mandatory -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string'
            }

            'ssh-key' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                    -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PrivateKeyPassword'          -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PEMKey'                      -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevation'         -Type 'string' -Mandatory -ValidateSet ('none','sudo','sudosu','su','pbrun','privileged-exec')
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationUsername' -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'PermissionElevationPassword' -Type 'string'
            }

            'sybase' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Database'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'UseWindowsAuthentication' -Type 'switch'
                New-DynamicParameter -Dictionary $dynParam -Name 'Domain'                   -Type 'string'
                New-DynamicParameter -Dictionary $dynParam -Name 'Username'                 -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password'                 -Type 'string' -Mandatory
            }

            'telnet' {
                New-DynamicParameter -Dictionary $dynParam -Name 'Username' -Type 'string' -Mandatory
                New-DynamicParameter -Dictionary $dynParam -Name 'Password' -Type 'string' -Mandatory
            }
        }
        Return $dynParam
    }

    Begin {
        # Validate SiteId has been filled if creating a site credential
        If (($IsSiteCredential.IsPresent) -and ($SiteId -eq 0)) {
            Throw 'SiteId must be specified when using IsSiteCredential switch'
        }

        # Validate account name does not already exist
        If ($IsSiteCredential.IsPresent) { [object]$creds = (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials" -RestMethod Get) }
        Else                             { [object]$creds = (Invoke-NexposeQuery -UrlFunction 'shared_credentials'             -RestMethod Get) }
        ForEach ($credential In $creds) {
            If ($credential.Name -eq $Name) { Throw 'Shared credentials already exist with this name' }
        }

        # This loops through bound parameters.  If no corresponding variable exists, one is created
        Function _temp { [cmdletbinding()] param() }
        $BoundKeys = ($PSBoundParameters.Keys | Where-Object { (Get-Command _temp | Select-Object -ExpandProperty Parameters).Keys -notcontains $_ })
        ForEach ($param in $BoundKeys) {
            If (-not (Get-Variable -Name $param -ErrorAction SilentlyContinue)) {
                Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
                New-Variable -Name $Param -Value $PSBoundParameters.$param
            }
        }
    }

    Process {
        $apiQuery = @{
            name        = $Name
            description = $Description
        }

        Switch ($PSCmdlet.ParameterSetName) {
            'bySite' {
                # Do Nothing
            }

            'byShared' {
                $apiQuery += @{ siteAssignment = $SiteAssignment }
                If ($SiteAssignment -eq 'specific-sites') { $apiQuery += @{ sites = @($Site) }}
            }

            'byRestriction' {
                If ([string]::IsNullOrEmpty($HostRestriction) -eq $false) {
                    $apiQuery += @{ hostRestriction = $HostRestriction }
                    If ([string]::IsNullOrEmpty($PortRestriction) -eq $false) { $apiQuery += @{ portRestriction = $PortRestriction }}
                }
            }
        }

        Switch ($Service) {
            'as400' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }}
            }

            'cifs' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }}
            }

            'cifshash' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    domain   = $Domain
                    username = $Username
                    htmlHash = $NTLMHash
                }}
            }

            'cvs' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    domain   = $Domain
                    username = $Username
                    password = $Password
                }}
            }

            'db2' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    database = $Database
                    username = $Username
                    password = $Password
                }}
            }

            'ftp' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    username = $Username
                    password = $Password
                }}
            }

            'http' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    realm    = $Realm
                    username = $Username
                    password = $Password
                }}
            }

            'ms-sql' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    database = $Database
                    useWindowsAuthentication = ($UseWindowsAuthentication.IsPresent)
                    username = $Username
                    password = $Password
                }}
                If ($UseWindowsAuthentication.IsPresent) { $apiQuery.account += @{ domain = $Domain }}
            }

            'mysql' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    database = $Database
                    username = $Username
                    password = $Password
                }}
            }

            'notes' {
                $apiQuery += @{ account = @{
                    service         = $Service
                    notesIDPassword = $NotesIdPassword
                }}
            }

            'oracle' {
                $apiQuery += @{ account = @{
                    service       = $Service
                    sid           =  $SID
                    username      =  $Username
                    password      =  $Password
                    enumerateSids = ($EnumerateSids.IsPresent)
                }}
                If ($EnumerateSids.IsPresent) { $apiQuery += @{ account = @{ oracleListenerPassword = $OracleListenerPassword }} }
            }

            'pop' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    username = $Username
                    password = $Password
                }}
            }

            'postgresql' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    database = $Database
                    username = $Username
                    password = $Password
                }}
            }

            'remote-exec' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    username = $Username
                    password = $Password
                }}
            }

            'snmp' {
                $apiQuery += @{ account = @{
                    service       = $Service
                    communityName = $CommunityName
                }}
            }

            'snmpv3' {
                $apiQuery += @{ account = @{
                    service            = $Service
                    authenticationType = $AuthenticationType
                    username           = $Username
                    privacyType        = $PrivacyType
                }}
                If ($AuthenticationType -ne 'no-authentication') {
                    $apiQuery += @{ account = @{ password = $Password }}

                    If ($PrivacyType -ne 'no-authentication') {
                        $apiQuery += @{ account = @{ privacyPassword = $PrivacyPassword }}
                    }
                }
            }

            'ssh' {
                $apiQuery += @{ account = @{
                    service                     = $Service
                    username                    = $Username
                    password                    = $Password
                    permissionElevation         = $PermissionElevation
                    permissionElevationUsername = $PermissionElevationUsername
                    permissionElevationPassword = $PermissionElevationPassword
                }}
            }

            'ssh-key' {
                $apiQuery += @{ account = @{
                    service                     = $Service
                    username                    = $Username
                    privateKeyPassword          = $PrivateKeyPassword
                    pemKey                      = $PEMKey
                    permissionElevation         = $PermissionElevation
                    permissionElevationUsername = $PermissionElevationUsername
                    permissionElevationPassword = $PermissionElevationPassword
                }}
            }

            'sybase' {
                $apiQuery += @{ account = @{
                    service                  =  $Service
                    database                 =  $Database
                    useWindowsAuthentication = ($UseWindowsAuthentication.IsPresent)
                    username                 =  $Username
                    password                 =  $Password
                }}
                If ($UseWindowsAuthentication.IsPresent) { $apiQuery.account += @{ domain = $Domain }}
            }

            'telnet' {
                $apiQuery += @{ account = @{
                    service  = $Service
                    username = $Username
                    password = $Password
                }}
            }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            If ($IsSiteCredential.IsPresent) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/site_credentials" -ApiQuery $apiQuery -RestMethod Post)
            }
            Else {
                Write-Output (Invoke-NexposeQuery -UrlFunction 'shared_credentials' -ApiQuery $apiQuery -RestMethod Post)
            }
        }
    }

    End {
    }
}
