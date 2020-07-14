Function New-NexposeScanTemplate {
<#
    .SYNOPSIS
        Creates a new scan template

    .DESCRIPTION
        Creates a new scan template.  For the objects 'Discovery', 'Policies', 'Vulnerabilities' and 'WebSpidering', see the helper functions for more information.  If you do not select any check types, the scan will only include asset discovery

    .PARAMETER Name
        A concise name for the scan template

    .PARAMETER Description
        A verbose description of the scan template

    .PARAMETER EnableEnhancedLogging
        Whether enhanced logging is gathered during scanning. Collection of enhanced logs may greatly increase the disk space used by a scan

    .PARAMETER EnableWindowsServices
        Whether Windows services are enabled during a scan. Windows services will be temporarily reconfigured when this option is selected. Original settings will be restored after the scan completes, unless it is interrupted

    .PARAMETER MaxParallelAssets
        The maximum number of assets scanned simultaneously per scan engine during a scan

    .PARAMETER MaxScanProcesses
        The maximum number of scan processes simultaneously allowed against each asset during a scan

    .PARAMETER Discovery
        Hashtable object of properties for the discovery settings used during a scan.  See the helper function for more information

    .PARAMETER Policies
        Hashtable object of properties for the policy configuration settings used during a scan.  See the helper function for more information

    .PARAMETER Vulnerabilities
        Hashtable object of properties for the vulnerability settings used during a scan.  See the helper function for more information

    .PARAMETER WebSpidering
        Hashtable object of properties for the web spider settings used during a scan.  If this option is used, Vulnerabilities must also be used.  See the helper function for more information

    .EXAMPLE
        New-NexposeScanTemplate

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scan_templates

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Description,

        [switch]$EnableEnhancedLogging,

        [switch]$EnableWindowsServices,

        [int]$MaxParallelAssets = 10,

        [int]$MaxScanProcesses = 10,

        [Parameter(Mandatory = $true)]
        [hashtable]$Discovery,

        [hashtable]$Policies,

        [hashtable]$Vulnerabilities,

        [hashtable]$WebSpidering
    )

    Begin {
        If ($WebSpidering -and (-not $Vulnerabilities)) {
            Throw 'When specifying Web Spidering, Vulnerabilities must also be specified'
        }
    }

    Process {
        $apiQuery = @{
            name = $Name
            description = $Description
            discoveryOnly = 'true'

            enableWindowsServices = ($EnableWindowsServices.IsPresent)
            enhancedLogging = ($EnableEnhancedLogging.IsPresent)
            maxParallelAssets = $MaxParallelAssets
            maxScanProcesses = $MaxScanProcesses
        }

        $apiQuery += $Discovery
        If ($Policies)        { $apiQuery.discoveryOnly = 'false'; $apiQuery += $Policies        }
        If ($Vulnerabilities) { $apiQuery.discoveryOnly = 'false'; $apiQuery += $Vulnerabilities }
        If ($WebSpidering)    { $apiQuery.discoveryOnly = 'false'; $apiQuery += $WebSpidering    }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'scan_templates' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
