Function Invoke-NexposeScanTemplateHelperAssetDiscovery {
<#
    .SYNOPSIS
        Helper function to generate required Asset Discovery object for New-NexposeScanTemplate

    .DESCRIPTION
        Helper function to generate required Asset Discovery object for New-NexposeScanTemplate

    .PARAMETER SendIcmpPings
        Whether ICMP pings are sent during asset discovery

    .PARAMETER SendArpPings
        Whether ARP pings are sent during asset discovery

    .PARAMETER TcpPorts
        TCP ports to send packets and perform discovery

    .PARAMETER UdpPorts
        UDP ports to send packets and perform discovery

    .PARAMETER TreatTcpResetAsAsset
        Whether TCP reset responses are treated as live assets

    .PARAMETER CollectWhoisInformation
        Whether to query Whois during discovery

    .PARAMETER IpFingerprintingEnabled
        Whether to fingerprint TCP/IP stacks for hardware, operating system and software information

    .PARAMETER FingerprintRetries
        The number of fingerprinting attempts made to determine the operating system fingerprint

    .PARAMETER FingerprintMinimumCertainty
        The minimum certainty required for a fingerprint to be considered valid during a scan

    .PARAMETER ServiceTcpMethod
        The method of TCP discovery.  Valid values are 'SYN', 'SYN+RST', 'SYN+FIN', 'SYN+ECE', 'Full'

    .PARAMETER ServiceTcpPorts
        The TCP ports to scan.  Valid values are 'all', 'well-known', 'custom', 'none'

    .PARAMETER ServiceTcpAdditionalPorts
        Additional TCP ports to scan. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. '7892-7898')

    .PARAMETER ServiceTcpExcludedPorts
        TCP ports to exclude from scanning. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. "7892-7898")

    .PARAMETER ServiceUdpPorts
        The UD ports to scan.  Valid values are 'all', 'well-known', 'custom', 'none'

    .PARAMETER ServiceUdpAdditionalPorts
        Additional UDP ports to scan. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. '7892-7898')

    .PARAMETER ServiceUdpExcludedPorts
        UDP ports to exclude from scanning. Individual ports can be specified as numbers or a string, but port ranges must be strings (e.g. "7892-7898")

    .PARAMETER ServiceNameFile
        An optional file that lists each port and the service that commonly resides on it. If scans cannot identify actual services on ports, service names will be derived from this file in scan results

    .PARAMETER PerformanceRetryLimit
        The maximum number of attempts to contact target assets. If the limit is exceeded with no response, the given asset is not scanned

    .PARAMETER PerformanceTimeoutInitial
        The initial timeout to wait between retry attempts. The value is specified as a ISO8601 duration

    .PARAMETER PerformanceTimeoutMinimum
        The minimum time to wait between retries. The value is specified as a ISO8601 duration

    .PARAMETER PerformanceTimeoutMaximum
        The maximum time to wait between retries. The value is specified as a ISO8601 duration

    .PARAMETER PerformanceScanDelayMinimum
        The minimum duration to wait between sending packets to each target host. The value is specified as a ISO8601 duration

    .PARAMETER PerformanceScanDelayMaximum
        The maximum duration to wait between sending packets to each target host. The value is specified as a ISO8601 duration

    .PARAMETER PerformancePacketRateDefeatRateLimit
        Whether defeat rate limit (defeat-rst-ratelimit) is enforced on the minimum packet setting, which can improve scan speed. If it is disabled, the minimum packet rate setting may be ignored when a target limits its rate of RST (reset) responses to a port scan. This can increase scan accuracy by preventing the scan from missing ports

    .PARAMETER PerformancePacketRateMinimum
        The minimum number of packets to send each second during discovery attempts

    .PARAMETER PerformancePacketRateMaximum
        The maximum number of packets to send each second during discovery attempts

    .PARAMETER PerformanceParallelismMinimum
        The minimum number of discovery connection requests send in parallel

    .PARAMETER PerformanceParallelismMaximum
        The maximum number of discovery connection requests send in parallel

    .EXAMPLE
        Invoke-NexposeScanTemplateHelperAssetDiscovery

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
    # ASSET DISCOVERY
        [switch]$SendIcmpPings,

        [switch]$SendArpPings,

        [int[]]$TcpPorts = @(),

        [int[]]$UdpPorts = @(),

        [switch]$TreatTcpResetAsAsset,

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
                treatTcpResetAsAsset = ($treatTcpResetAsAsset.IsPresent)
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
