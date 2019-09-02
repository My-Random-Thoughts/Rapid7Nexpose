Function Get-NexposeScanEngine {
<#
    .SYNOPSIS
        Returns scan engines available to use for scanning

    .DESCRIPTION
        Returns scan engines available to use for scanning

    .PARAMETER Id
        The identifier of the scan engine

    .PARAMETER Name
        The name of the scan engine

    .PARAMETER Address
        The ip address of the scan engine

    .PARAMETER SiteId
        The identifier of a site the scan engine is assigned to

    .EXAMPLE
        Get-NexposeScanEngine -SiteId 5

    .EXAMPLE
        Get-NexposeScanEngine -Name 'DR Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scan_engines
        GET: scan_engines/{id}
        GET: sites/{id}/scan_engine
        GET: SKIPPED - scan_engines/{id}/scan_engine_pools    # Returned data has this information
        GET: SKIPPED - scan_engines/{id}/sites                # Returned data has this information

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'byAddress')]
        [string]$Address,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySite')]
        [string]$SiteId
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "scan_engines/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'scan_engines' -RestMethod Get)    # Return All
            }
        }

        'bySite' {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/scan_engine" -RestMethod Get)
        }

        Default {
            $Engines = @(Invoke-NexposeQuery -UrlFunction 'scan_engines' -RestMethod Get)
            Switch ($PSCmdlet.ParameterSetName) {
                'byName'    { Write-Output @($Engines | Where-Object { $_.name    -eq $Name    }) }
                'byAddress' { Write-Output @($Engines | Where-Object { $_.address -eq $Address }) }
            }
        }
    }
}
