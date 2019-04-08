Function New-NexposeScanEngine {
<#
    .SYNOPSIS
        Creates a new scan engine

    .DESCRIPTION
        Creates a new scan engine

    .PARAMETER Name
        The name of the scan engine

    .PARAMETER Address
        The address the scan engine is hosted

    .PARAMETER Port
        The port used by the scan engine to communicate with the Security Console.  Defaults to 40894

    .PARAMETER Site
        A list of identifiers of each site the scan engine is assigned to

    .EXAMPLE
        New-NexposeScanEngine -Name 'Engine B' -Address '1.2.3.4' -Site @(4, 5, 6)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scan_engines

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Address,

        [int]$Port = 40894,

        [int[]]$Site
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            name    = $Name
            address = $Address
            port    = $Port
        }

        If ($Site.Count -gt 0) { $apiQuery += @{ sites = @($Site) }}

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'scan_engines' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
