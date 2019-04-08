Function Update-NexposeScanEngine {
<#
    .SYNOPSIS
        Updates the specified scan engine

    .DESCRIPTION
        Updates the specified scan engine

    .PARAMETER Id
        The identifier of the scan engine

    .PARAMETER Name
        The name of the scan engine

    .PARAMETER Address
        The address the scan engine is hosted

    .PARAMETER Port
        The port used by the scan engine to communicate with the Security Console.  Defaults to 40894

    .PARAMETER Site
        A list of identifiers of each site the scan engine is assigned to

    .EXAMPLE
        Update-NexposeScanEngine -Id 2 -Name 'Engine B' -Address '1.2.3.4' -Site @(4, 5, 6)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: scan_engines/{id}
        PUT: sites/{id}/scan_engine    # Handled below

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [string]$Name,

        [string]$Address,

        [int]$Port,

        [int[]]$Site
    )

    Begin {
        # Get current values
        $engine = (Get-NexposeScanEngine -Id $Id)

        If ([string]::IsNullOrEmpty($Name)    -eq $true) { $Name    = $engine.name    }
        If ([string]::IsNullOrEmpty($Address) -eq $true) { $Address = $engine.address }
        If ([string]::IsNullOrEmpty($Port)    -eq $true) { $Port    = $engine.port    }
        If ([string]::IsNullOrEmpty($Site)    -eq $true) { $Site    = $engine.site    }
    }

    Process {
        $apiQuery = @{
            name    = $Name
            address = $Address
            port    = $Port
        }

        If ($Site.Count -gt 0) { $apiQuery += @{ sites = @($Site) }}

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "scan_engines/$Id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
