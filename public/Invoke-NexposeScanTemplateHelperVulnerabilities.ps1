Function Invoke-NexposeScanTemplateHelperVulnerabilities {
<#
    .SYNOPSIS
        Helper function to generate required Vulnerabilities object for New-NexposeScanTemplate

    .DESCRIPTION
        Helper function to generate required Vulnerabilities object for New-NexposeScanTemplate

    .PARAMETER ChecksUnsafe
        Whether checks considered "unsafe" are assessed during a scan

    .PARAMETER ChecksPotential
        Whether checks that result in potential vulnerabilities are assessed during a scan

    .PARAMETER ChecksCorrelate
        Whether an extra step is performed at the end of the scan where more trust is put in OS patch checks to attempt to override the results of other checks which could be less reliable

    .PARAMETER ChecksCategoriesDisabled
        The categories of vulnerability checks to disable during a scan

    .PARAMETER ChecksCategoriesEnabled
        The categories of vulnerability checks to enable during a scan

    .PARAMETER ChecksTypesDisabled
        The types of vulnerability checks to disable during a scan

    .PARAMETER ChecksTypesEnabled
        The types of vulnerability checks to enable during a scan

    .PARAMETER ChecksIndividualDisabled
        The individual vulnerability checks to disable during a scan

    .PARAMETER ChecksIndividualEnabled
        The individual vulnerability checks to enable during a scan

    .PARAMETER DatabaseDB2
        Database name for DB2 database instance

    .PARAMETER DatabaseOracle
        Database name (SID) for an Oracle database instance

    .PARAMETER DatabasePostgres
        Database name for PostgesSQL database instance

    .PARAMETER TelnetCharacterSet
        The character set to use

    .PARAMETER TelnetFailedLoginRegex
        Regular expression to match a failed login response

    .PARAMETER TelnetLoginRegex
        Regular expression to match a login response

    .PARAMETER TelnetPasswordPromptRegex
        Regular expression to match a password prompt

    .PARAMETER TelnetQuestionableLoginRegex
        Regular expression to match a potential false negative login response

    .EXAMPLE
        Invoke-NexposeScanTemplateHelperVulnerabilities

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Scope = 'Function')]
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
