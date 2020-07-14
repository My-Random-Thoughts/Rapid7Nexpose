Function Invoke-NexposeScanTemplateHelperWebSpidering {
<#
    .SYNOPSIS
        Helper function to generate required Web Spidering object for New-NexposeScanTemplate

    .DESCRIPTION
        Helper function to generate required Web Spidering object for New-NexposeScanTemplate

    .PARAMETER IncludeQueryStrings
        Whether query strings are using in URLs when web spidering. This causes the web spider to make many more requests to the Web server. This will increase overall scan time and possibly affect the Web server's performance for legitimate users

    .PARAMETER TestCommonUsernamesAndPasswords
        Whether to determine if discovered logon forms accept commonly used user names or passwords. The process may cause authentication services with certain security policies to lock out accounts with these credentials

    .PARAMETER TestXssInSingleScan
        Whether to test for persistent cross-site scripting during a single scan. This test helps to reduce the risk of dangerous attacks via malicious code stored on Web servers. Enabling it may increase Web spider scan times

    .PARAMETER UserAgent
        The User-Agent to use when web spidering. Defaults to "Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 6.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)"

    .PARAMETER PerformanceMaximumForeignHosts
        The maximum number of unique host names that the spider may resolve. This function adds substantial time to the spidering process, especially with large Web sites, because of frequent cross-link checking involved

    .PARAMETER PerformanceResponseTimeout
        The duration to wait for a response from a target web server. The value is specified as a ISO8601 duration

    .PARAMETER PerformanceMaximumDirectoryLevels
        The directory depth limit for web spidering. Limiting directory depth can save significant time, especially with large sites. A value of 0 signifies unlimited directory traversal

    .PARAMETER PerformanceMaximumTime
        The maximum length of time to web spider. This limit prevents scans from taking longer than the allotted scan schedule

    .PARAMETER PerformanceMaximumPages
        The maximum the number of pages that are spidered. This is a time-saving measure for large sites

    .PARAMETER PerformanceMaximumRetries
        The maximum the number of times to retry a request after a failure. A value of 0 means no retry attempts are made

    .PARAMETER PerformanceThreadsPerServer
        The number of threads to use per web server being spidered

    .PARAMETER PerformanceHttpDaemonsToSkip
        The names of HTTP Daemons (HTTPd) to skip when spidering. For example, 'CUPS'

    .PARAMETER PerformanceMaximumLinkDepth
        The maximum depth of links to traverse when spidering

    .PARAMETER PatternsSensitiveField
        A regular expression that is used to find fields that may contain sensitive input. Defaults to "(p|pass)(word|phrase|wd|code)"

    .PARAMETER PatternsSensitiveContent
        A regular expression that is used to find sensitive content on a page

    .PARAMETER PathsHonorRobotDirectives
        Whether to honor robot directives

    .PARAMETER PathsBoostrap
        Paths to bootstrap spidering with

    .PARAMETER PathsExcluded
        Paths excluded from spidering

    .PARAMETER DontScanMultiUseDevices
        Whether scanning of multi-use devices, such as printers or print servers should be avoided

    .EXAMPLE
        Invoke-NexposeScanTemplateHelperWebSpidering

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

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

        [string[]]$PerformanceHttpDaemonsToSkip = @('Virata-EmWeb','Allegro-Software-RomPager','JetDirect','HP JetDirect','HP Web Jetadmin','HP-ChaiSOE','HP-ChaiServer','CUPS','DigitalV6-HTTPD','Rapid Logic','Agranat-EmWeb','cisco-IOS','RAC_ONE_HTTP','RMC Webserver','EWS-NIC3','EMWHTTPD','IOS','ESWeb'),

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
                httpDaemonsToSkip = $PerformanceHttpDaemonsToSkip
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
