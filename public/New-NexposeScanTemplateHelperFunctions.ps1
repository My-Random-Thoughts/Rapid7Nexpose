Function Invoke-NexposeScanTemplateHelper_AssetDiscovery {
    Param (
    # ASSET DISCOVERY
        [switch]$SendIcmpPings,

        [switch]$SendArpPings,

        [int[]]$TcpPorts = @(),

        [int[]]$UdpPorts = @(),

        ### Find other assets on the network

        [switch]$CollectWhoisInformation,

        [switch]$IpFingerprintingEnabled,

        [ValidateRange(0, 1000)]
        [int]$FingerprintRetries = 4,

        [ValidatePattern('^(0(?:\.?(?<=\.)[0-9][0-9]?)?|1(?:\.?(?<=\.)00?)?)$')]    # 0.00 - 1.00
        [double]$FingerprintMinimumCertainty = 0.16,

    # SERVICE DISCOVERY
        [ValidateSet('SYN','SYN+RST','SYN+FIN','SYN+ECE','Full')]
        [string]$ServiceTcpMethod = 'SYN',

        [ValidateSet('All','Well-Known','Custom','None')]
        [string]$ServiceTcpPorts  = 'Well-Known',

        [int[]]$ServiceTcpAdditionalPorts = @(),

        [int[]]$ServiceTcpExcludedPorts = @(),

        [ValidateSet('All','Well-Known','Custom','None')]
        [string]$ServiceUdpPorts = 'Well-Known',

        [int[]]$ServiceUdpAdditionalPorts = @(),

        [int[]]$ServiceUdpExcludedPorts = @(),

        [string]$ServiceNameFile = '',

    # DISCOVERY PERFORMANCE
        [ValidateRange(1, 15)]
        [int]$PerformanceRetryLimit = 3,

        [ValidateRange(0.5, 30)]
        [double]$PerformanceTimeoutInitial = 0.5,    # Convert to PTxY (from seconds)

        [ValidateRange(0.5, 30)]
        [double]$PerformanceTimeoutMinimum = 0.5,    # Convert to PTxY (from seconds)

        [ValidateRange(0.5, 30)]
        [double]$PerformanceTimeoutMaximum = 3,    # Convert to PTxY (from seconds)

        [ValidateRange(0, 30)]
        [int]$PerformanceScanDelayMinimum = 0,    # Convert to PTxY (from seconds)

        [ValidateRange(0, 30)]
        [int]$PerformanceScanDelayMaximum = 0,    # Convert to PTxY (from seconds)

        [switch]$PerformancePacketRateDefeatRateLimit,

        [ValidateRange(0, 15000)]
        [int]$PerformancePacketRateMinimum = 450,

        [ValidateRange(0, 15000)]
        [int]$PerformancePacketRateMaximum = 15000,

        [ValidateRange(0, 1000)]
        [int]$PerformanceParallelismMinimum = 0,

        [ValidateRange(0, 1000)]
        [int]$PerformanceParallelismMaximum = 0
    )

    Return @{
        discovery = @{
            asset = @{
                collectWhoisInformation = ($CollectWhoisInformation.IsPresent)
                fingerprintMinimumCertainty = $FingerprintMinimumCertainty
                fingerprintRetries = $FingerprintRetries
                ipFingerprintingEnabled = ($IpFingerprintingEnabled.IsPresent)
                sendArpPings = ($SendArpPings.IsPresent)
                sendIcmpPings = ($SendIcmpPings.IsPresent)
                tcpPorts = @($TcpPorts)
                treatTcpResetAsAsset = 'true'
                udpPorts = @($UdpPorts)
            }
            performance = @{
                packetRate = @{
                    defeatRateLimit = ($PerformancePacketRateDefeatRateLimit.IsPresent)
                    maximum = $PerformancePacketRateMaximum
                    minimum = $PerformancePacketRateMinimum
                }
                parallelism = @{
                    maximum = $PerformanceParallelismMaximum
                    minimum = $PerformanceParallelismMinimum
                }
                retryLimit = $PerformanceRetryLimit
                scanDelay = @{
                    maximum = (Convert-TimeSpan -Duration $PerformanceScanDelayMaximum -Format Time)
                    minimum = (Convert-TimeSpan -Duration $PerformanceScanDelayMinimum -Format Time)
                }
                timeout = @{
                    initial = (Convert-TimeSpan -Duration $PerformanceTimeoutInitial -Format Time)
                    maximum = (Convert-TimeSpan -Duration $PerformanceTimeoutMaximum -Format Time)
                    minimum = (Convert-TimeSpan -Duration $PerformanceTimeoutMinimum -Format Time)
                }
            }
            service = @{
                serviceNameFile = $ServiceServiceNameFile
                tcp = @{
                    additionalPorts = $ServiceTcpAdditionalPorts
                    excludedPorts = $ServiceTcpExcludedPorts
                    method = $ServiceTcpMethod
                    ports = ($ServiceTcpPorts.ToLower())
                }
                udp = @{
                    additionalPorts = $ServiceUdpAdditionalPorts
                    excludedPorts = $ServiceUdpExcludedPorts
                    ports = ($ServiceUdpPorts.ToLower())
                }
            }
        }
    }
}

Function Invoke-NexposeScanTemplateHelper_Policies {
    Param (
        [switch]$StoreSCAP,

        [switch]$RecursiveWindowsFSSearch,

        [int[]]$PoliciesEnabled = @()
    )

    Return @{
        policyEnabled = 'true'
        policy = @{
            enabled = @($PoliciesEnabled)
            recursiveWindowsFSSearch = ($RecursiveWindowsFSSearch.IsPresent)
            storeSCAP = ($StoreSCAP.IsPresent)
        }
    }
}

Function Invoke-NexposeScanTemplateHelper_WebSpidering {
    Param (
    # WEB SPIDERING
        [switch]$IncludeQueryStrings,

        [switch]$TestXssInSingleScan,

        [string]$UserAgent = 'Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',

        [switch]$TestCommonUsernamesAndPasswords,

        [ValidateRange(0, 1000)]
        [int]$PerformanceMaximumForeignHosts = 100,

        [ValidateRange(0, 3600)]
        [int]$PerformanceResponseTimeout = 120,    # Number of seconds: convert to 'PTxY', range between to PT0S and PT1H

        [ValidateRange(0, 100)]
        [int]$PerformanceMaximumDirectoryLevels = 6,

        [ValidateRange(60, 59997600)]
        [int]$PerformanceMaximumTime = 60,    # Number of seconds: convert to 'PTxY', range between to PT1M and PT16666H

        [ValidateRange(0, 1000000)]
        [int]$PerformanceMaximumPages = 3000,

        [ValidateRange(0, 999)]
        [int]$PerformanceMaximumRetries = 2,

        [ValidateRange(0, 999)]
        [int]$PerformanceThreadsPerServer = 3,

        [string[]]$PerformanceHttpDaemonsToSkip = ('Virata-EmWeb','Allegro-Software-RomPager','JetDirect','HP JetDirect','HP Web Jetadmin','HP-ChaiSOE','HP-ChaiServer','CUPS','DigitalV6-HTTPD','Rapid Logic','Agranat-EmWeb','cisco-IOS','RAC_ONE_HTTP','RMC Webserver','EWS-NIC3','EMWHTTPD','IOS','ESWeb'),

        [ValidateRange(0, 100)]
        [int]$PerformanceMaximumLinkDepth = 6,

        [string]$PatternsSensitiveField = '(p|pass)(word|phrase|wd|code)',

        [string]$PatternsSensitiveContent = '',

        [switch]$PathsHonorRobotDirectives,

        [string]$PathsBoostrap = '',

        [string]$PathsExcluded = '',

        [switch]$DontScanMultiUseDevices
    )

    Return @{
        webEnabled = 'true'
        web = @{
            dontScanMultiUseDevices = ($DontScanMultiUseDevices.IsPresent)
            includeQueryStrings = ($IncludeQueryStrings.IsPresent)
            paths = @{
                boostrap = $PathsBoostrap
                excluded = $PathsExcluded
                honorRobotDirectives = ($PathsHonorRobotDirectives.IsPresent)
            }
            patterns = @{
                sensitiveContent = $PatternsSensitiveContent
                sensitiveField = $PatternsSensitiveField
            }
            performance = @{
                httpDaemonsToSkip = @('string')
                maximumDirectoryLevels = $PerformanceMaximumDirectoryLevels
                maximumForeignHosts = $PerformanceMaximumForeignHosts
                maximumLinkDepth = $PerformanceMaximumLinkDepth
                maximumPages = $PerformanceMaximumPages
                maximumRetries = $PerformanceMaximumRetries
                maximumTime = (Convert-TimeSpan -Duration $PerformanceMaximumTime -Format Time)
                responseTimeout = (Convert-TimeSpan -Duration $PerformanceResponseTimeout -Format Time)
                threadsPerServer = $PerformanceThreadsPerServer
            }
            testCommonUsernamesAndPasswords = ($TestCommonUsernamesAndPasswords.IsPresent)
            testXssInSingleScan = ($TestXssInSingleScan.IsPresent)
            userAgent = $UserAgent
        }
    }
}

Function Invoke-NexposeScanTemplateHelper_Vulnerabilities {
    Param (
    # VULNERABILITIES
        [switch]$ChecksUnsafe,

        [switch]$ChecksPotential,

        [switch]$ChecksCorrelate,

        [string[]]$ChecksCategoriesDisabled = @(),

        [string[]]$ChecksCategoriesEnabled = @(),

        [string[]]$ChecksTypesDisabled = @(),

        [string[]]$ChecksTypesEnabled = @(),

        [string[]]$ChecksIndividualDisabled = @(),

        [string[]]$ChecksIndividualEnabled = @(),

    # FILE SEARCHING
        # ???

    # SPAM RELAYING
        # ???

    # DATABASE SERVERS
        [string]$DatabaseDB2 = '',

        [string[]]$DatabaseOracle = @(),

        [string]$DatabasePostgres = '',
        
    # MAIL SERVERS
        # ???

    # CVS SERVERS
        # ???

    # DHCP SERVERS
        # ???

    # TELNET SERVERS
        [string]$TelnetCharacterSet = '',

        [string]$TelnetFailedLoginRegex = '',

        [string]$TelnetLoginRegex = '',

        [string]$TelnetPasswordPromptRegex = '',

        [string]$TelnetQuestionableLoginRegex = ''
    )

    Return @{
        vulnerabilityEnabled = 'true'
        checks = @{
            categories = @{
                disabled = @($ChecksCategoriesDisabled)
                enabled = @($ChecksCategoriesEnabled)
            }
            correlate = ($ChecksCorrelate.IsPresent)
            individual = @{
                disabled = @($ChecksIndividualDisabled)
                enabled = @($ChecksIndividualEnabled)
            }
            potential = ($ChecksPotential.IsPresent)
            types = @{
                disabled = @($ChecksTypesDisabled)
                enabled = @($ChecksTypesEnabled)
            }
            unsafe = ($ChecksUnsafe.IsPresent)
        }
        database = @{
            db2 = $DatabaseDB2
            oracle = $DatabaseOracle
            postgres = $DatabasePostgres
        }
        telnet = @{
            characterSet = $TelnetCharacterSet
            failedLoginRegex = $TelnetFailedLoginRegex
            loginRegex = $TelnetLoginRegex
            passwordPromptRegex = $TelnetPasswordPromptRegex
            questionableLoginRegex = $TelnetQuestionableLoginRegex
        }
    }
}



