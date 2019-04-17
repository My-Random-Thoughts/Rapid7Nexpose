Function Test-NexposeSearchCriteria {
<#
    .SYNOPSIS
        Validates a given search criteria

    .DESCRIPTION
        Validates a given search criteria.

    .PARAMETER SearchCriteria
        Criteria presented as a hashtable

    .EXAMPLE
        Test-NexposeSearchCriteria -SearchCriteria @{filters = @(@{field='ip-address'; operator='is-like'; value='172.16.*'}, @{field='host-name'; operator='starts-with'; value='SVR'}); match='all'}

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    [OutputType([string])]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Scope = 'Function')]
    Param (
        [hashtable]$SearchCriteria
    )

    Begin {
        If ($SearchCriteria.filters.Count -lt 1) {
            Throw 'No filters presented'
        }

        # Set up the values
        $types     = @{
            'alternate-address-type'         = ('0','1')                # 0=ipv4, 1=ipv6
            'containers'                     = ('present','not-present')
            'container-status'               = ('created','running','paused','restarting','exited','dead','unknown')
            'criticality-tag'                = ('Very Low','Low','Medium','High','Very High')
            'cvss-access-complexity'         = ('L','M','H')            # L=Low, M=Medium, H=High
            'cvss-access-vector'             = ('L','A','N')            # L=Local, A=Adjacent, N=Network
            'cvss-availability-impact'       = ('N','P','C')            # N=None, P=Partial, C=Complete
            'cvss-integrity-impact'          = ('N','P','C')            # N=None, P=Partial, C=Complete
            'cvss-confidentiality-impact'    = ('N','P','C')            # N=None, P=Partial, C=Complete
            'cvss-authentication-required'   = ('N','S','M')            # N=None, S=Single, M=Multiple
            'cvss-v3-confidentiality-impact' = ('L','N','H')            # L=Local/Low, N=None, H=High
            'cvss-v3-integrity-impact'       = ('L','N','H')            # L=Local/Low, N=None, H=High
            'cvss-v3-availability-impact'    = ('L','N','H')            # L=Local/Low, N=None, H=High
            'cvss-v3-attack-vector'          = ('N','A','L','P')        # N=Network, A=Adjacent, L=Local, P=Physical
            'cvss-v3-attack-complexity'      = ('L','H')                # L=Low, H=High
            'cvss-v3-user-interaction'       = ('N','R')                # N=None, R=Required
            'cvss-v3-privileges-required'    = ('L','N','H')            # L=Local/Low, N=None, H=High
            'host-type'                      = ('0','1','2','3','4')    # 0=Unknown, 1=Guest, 2=Hypervisor, 3=Physical, 4=Mobile
            'ip-address-type'                = ('0','1')                # 0=ipv4, 1=ipv6
            'pci-compliance'                 = ('0','1')                # 0=fail, 1=pass
            'vulnerability-validated-status' = ('present','not-present')
            'vasset-power state'             = ('poweredOn','poweredOff','suspended')

            # CUSTOM WORK AROUND REQURIED FOR THIS WHEN WRITING THE QUERIES
            #'vulnerability-exposures'        = ('malwarekit_exploits','metasploit_exploits','exploit_database_exploits')
            'vulnerability-exposures'        = ('type:"malware_type", name:"malwarekit"','type:"exploit_source_type", name:"107"','type:"exploit_source_type", name:"108"')
                # Malware Kit Exploits:       "values": ["type:\"malware_type\", name:\"malwarekit\""]
                # Metasploit Exploits:        "values": ["type:\"exploit_source_type\", name:\"108\""]
                # Exploit Database Exploits:  "values": ["type:\"exploit_source_type\", name:\"107\""]
        }
        $fields    = @{
            'alternate-address-type'         = ('in')
            'container-image'                = ('is','is-not','starts-with','ends-with','contains','does-not-contain','is-like','not-like')
            'container-status'               = ('is','is-not')
            'containers'                     = ('are')
            'criticality-tag'                = ('is','is-not','is-greater-than','is-less-than','is-applied','is-not-applied')
            'custom-tag'                     = ('is','is-not','starts-with','ends-with','contains','does-not-contain','is-applied','is-not-applied')
            'cve'                            = ('is','is-not','contains','does-not-contain')
            'cvss-access-complexity'         = ('is','is-not')
            'cvss-access-vector'             = ('is','is-not')
            'cvss-authentication-required'   = ('is','is-not')
            'cvss-availability-impact'       = ('is','is-not')
            'cvss-confidentiality-impact'    = ('is','is-not')
            'cvss-integrity-impact'          = ('is','is-not')
            'cvss-v3-attack-complexity'      = ('is','is-not')
            'cvss-v3-attack-vector'          = ('is','is-not')
            'cvss-v3-availability-impact'    = ('is','is-not')
            'cvss-v3-confidentiality-impact' = ('is','is-not')
            'cvss-v3-integrity-impact'       = ('is','is-not')
            'cvss-v3-privileges-required'    = ('is','is-not')
            'cvss-v3-user-interaction'       = ('is','is-not')
            'host-name'                      = ('is','is-not','starts-with','ends-with','contains','does-not-contain','is-empty','is-not-empty','is-like','not-like')
            'host-type'                      = ('in','not-in')
            'ip-address'                     = ('is','is-not','in-range','not-in-range','is-like','not-like')
            'ip-address-type'                = ('in','not-in')
            'last-scan-date'                 = ('is-on-or-before','is-on-or-after','is-between','is-earlier-than','is-within-the-last')
            'location-tag'                   = ('is','is-not','starts-with','ends-with','contains','does-not-contain','is-applied','is-not-applied')
            'mobile-device-last-sync'        = ('is-within-the-last','is-earlier-than')
            'open-ports'                     = ('is','is-not','in-range')
            'operating-system'               = ('contains','does-not-contain','is-empty','is-not-empty')
            'owner-tag'                      = ('is','is-not','starts-with','ends-with','contains','does-not-contain','is-applied','is-not-applied')
            'pci-compliance'                 = ('is')
            'risk-score'                     = ('is','is-not','in-range','is-greater-than','is-less-than')
            'service-name'                   = ('contains','does-not-contain')
            'site-id'                        = ('in','not-in')
            'software'                       = ('contains','does-not-contain')
            'vasset-cluster'                 = ('is','is-not','contains','does-not-contain','starts-with')
            'vasset-datacenter'              = ('is','is-not')
            'vasset-host name'               = ('is','is-not','contains','does-not-contain','starts-with')
            'vasset-power state'             = ('in','not-in')
            'vasset-resource pool path'      = ('contains','does-not-contain')
            'vulnerability-assessed'         = ('is-on-or-before','is-on-or-after','is-between','is-earlier-than','is-within-the-last')
            'vulnerability-category'         = ('is','is-not','starts-with','ends-with','contains','does-not-contain')
            'vulnerability-cvss-score'       = ('is','is-not','in-range','is-greater-than','is-less-than')
            'vulnerability-cvss-v3-score'    = ('is','is-not')
            'vulnerability-exposures'        = ('includes','does-not-include')
            'vulnerability-title'            = ('contains','does-not-contain','is','is-not','starts-with','ends-with')
            'vulnerability-validated-status' = ('are')
        }
        $operators = @{
            'are'                = 'string'
            'contains'           = 'string'
            'does-not-contain'   = 'string'
            'ends-with'          = 'string'
            'in'                 = 'array'
            'in-range'           = 'upper-lower'
            'includes'           = 'array'
            'is'                 = 'string'
            'is-string'          = 'none'
            'is-applied'         = 'none'
            'is-between'         = 'upper-lower'
            'is-earlier-than'    = 'numeric'
            'is-empty'           = 'none'
            'is-greater-than'    = 'numeric'
            'is-on-or-after'     = 'datetime'
            'is-on-or-before'    = 'datetime'
            'is-not'             = 'string'
            'is-not-applied'     = 'none'
            'is-not-empty'       = 'none'
            'is-within-the-last' = 'numeric'
            'is-less-than'       = 'numeric'
            'is-like'            = 'string'
            'not-contains'       = 'string'
            'not-in'             = 'array'
            'not-in-range'       = 'upper-lower'
            'not-like'           = 'string'
            'starts-with'        = 'string'
        }
    }

    Process {
        [int]$ReturnCounter = 0
        $ReturnValue = New-Object -TypeName 'boolean[]' $($SearchCriteria.filters).Count

        # Check there is a correct "match" value
        If (($SearchCriteria.match -ne 'all') -and ($SearchCriteria.match -ne 'any')) {
            Return "Invalid 'match' statement.  Valid values are: all, any"
        }

        ForEach ($filter In $($SearchCriteria.filters)) {
            [string]$f = $filter.field
            [string]$o = $filter.operator
            [object]$v = $filter.value
            [object]$a = $filter.values
            [object]$l = $filter.lower
            [object]$u = $filter.upper

            $ReturnValue[$ReturnCounter] = $false

            If ($fields.Keys -contains $f) {
                If ($fields.$f -contains $o) {
                    Switch ($($operators.$o)) {
                        'array' {
                            If (([string]::IsNullOrEmpty($a) -eq $false) -and ($a.Count -gt 0)) {
                                $ReturnValue[$ReturnCounter] = $true
                            }
                        }

                        'datetime' {
                            If (([string]::IsNullOrEmpty($v) -eq $false) -and ($v -as [datetime])) {
                                $ReturnValue[$ReturnCounter] = $true
                            }
                        }

                        'numeric' {
                            If (([string]::IsNullOrEmpty($v) -eq $false) -and ($v -match '^[0-9]+(?:.[0-9]+)?$') -and ($v.GetType().ToString() -ne 'system.string')) {
                                $ReturnValue[$ReturnCounter] = $true
                            }
                        }

                        'string' {
                            If (([string]::IsNullOrEmpty($v) -eq $false) -and ($v.GetType().ToString() -is [string]) -and ($v.Count -eq 1)) {
                                $ReturnValue[$ReturnCounter] = $true
                            }
                        }

                        'upper-lower' {
                            If (([string]::IsNullOrEmpty($l) -eq $false) -and ([string]::IsNullOrEmpty($u) -eq $false)) {
                                If (($l -match '^[0-9]+$') -and ($u -match '^[0-9]+$')) {
                                    If (($l -as [int]) -lt ($u -as [int])) {
                                        $ReturnValue[$ReturnCounter] = $true
                                    }
                                }
                                Else {
                                    If (($l -as [version]) -lt ($u -as [version])) {
                                        $ReturnValue[$ReturnCounter] = $true
                                    }
                                }
                            }
                        }

                        'none' {
                            If ($null -eq $v) {
                                $ReturnValue[$ReturnCounter] = $true
                            }
                        }

                        default {
                            $ReturnValue[$ReturnCounter] = $false
                        }
                    }

                    # Does the TYPES list contain this FIELD
                    If (($ReturnValue[$ReturnCounter] -eq $true) -and ($operators.$o -ne 'none')) {
                        If ($types.Keys -contains $f) {
                            $ReturnValue[$ReturnCounter] = $false
                            If ([string]::IsNullOrEmpty($v) -eq $false) {
                                If ($types.$f -contains $v) { $ReturnValue[$ReturnCounter] = $true }
                            }
                            If ([string]::IsNullOrEmpty($a) -eq $false) {
                                ForEach ($x in $a) {
                                    If ($types.$f -contains $x)    { $ReturnValue[$ReturnCounter] = $true  }
                                    If ($types.$f -notcontains $x) { $ReturnValue[$ReturnCounter] = $false }
                                }
                            }
                        }
                    }
                }
                Else {
                    Return "Invalid filter operator for this field.  Valid entries are: '$($fields.$f -join ', ')"
                }
            }
            Else {
                Return "Invalid filter field.  Valid entries are: $($fields.Keys -join ', ')"
            }

            If ($($ReturnValue[$ReturnCounter]) -eq $false) {
                Return "Invalid filter value or input type."
            }
            $ReturnCounter++
        }

        Return 'Success'
    }

    End {
    }
}
