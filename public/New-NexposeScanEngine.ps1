Function New-NexposeScanEngine {
<#
    .SYNOPSIS
        Creates a new scan engine

    .DESCRIPTION
        Creates a new scan engine

    .PARAMETER Name
        The name of the scan engine

    .PARAMETER Address
        The ip address of the scan engine

    .PARAMETER Port
        The port used by the scan engine to communicate with the Security Console

    .PARAMETER SiteId
        The identifier of a site the scan engine is assigned to

    .EXAMPLE
        New-NexposeScanEngine -Name 'ScanEngine001' -Address 192.168.1.101 -Port 40814

    .EXAMPLE
        New-NexposeScanEngine -Name 'ScanEngine001' -Address 192.168.1.101 -Port 40814 -SiteId (1, 2, 6, 10)

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
        [ipaddress]$Address,

        [ValidateRange(1, 65535)]
        [int]$Port = 40814 #,

        #[int[]]$SiteId    # BUG: 00166801
    )

    Begin {
        # Check Name and Address are unique
        If ($(Get-NexposeScanEngine -Name    $Name  -IncludeEnginePools)) { Throw "The name '$Name' is already in use." }
        If ($(Get-NexposeScanEngine -Address $Address.IPAddressToString)) { Throw "The address '$Address' is already in use." }
    }

    Process {
        $apiQuery = @{
            address = ($Address.IPAddressToString)
            name    =  $Name
            port    =  $Port
        }

# BUG: 00166801 - This does not work:
#        If ($SiteId.Count -gt 0) {
#            $apiQuery += @{ sites = $SiteId }
#        }

        If ($PSCmdlet.ShouldProcess("$Name ($($Address.IPAddressToString))")) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'scan_engines' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
