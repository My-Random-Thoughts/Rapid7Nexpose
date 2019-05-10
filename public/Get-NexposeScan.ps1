Function Get-NexposeScan {
<#
    .SYNOPSIS
        Get scans

    .DESCRIPTION
        Get scans by Id, site or everything

    .PARAMETER Id
        The identifier of the scan

    .PARAMETER Site
        The identifier of the site

    .PARAMETER EngineId
        The identifier of the scan engine

    .PARAMETER ReturnStatus
        Filter by scan status

    .EXAMPLE
        Get-NexposeScan

    .EXAMPLE
        Get-NexposeScan -Id 23

    .EXAMPLE
        Get-NexposeScan -Site 2

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scans
        GET: scans/{id}
        GET: sites/{id}/scans
        GET: scan_engines/{id}/scans

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySite')]
        [string]$Site,

        [Parameter(Mandatory = $true, ParameterSetName = 'byEngine')]
        [int]$EngineId,

        [ValidateSet('aborted', 'unknown', 'running', 'finished', 'stopped', 'error', 'paused', 'dispatched', 'integrating')]
        [string]$ReturnStatus
    )

    Function Get-ScanList {
        Param (
            [Parameter(Mandatory = $true)]
            [string]$URI,

            [string]$Filter
        )

        [System.Collections.ArrayList]$results = @()
        $results.AddRange(@(Invoke-NexposeQuery -UrlFunction $URI -ApiQuery @{ active = 'true'  } -RestMethod Get))
        $results.AddRange(@(Invoke-NexposeQuery -UrlFunction $URI -ApiQuery @{ active = 'false' } -RestMethod Get))

        If ([string]::IsNullOrEmpty($Filter) -eq $false) {
            $data = ($results | Where-Object { $_.status -eq $Filter })
        }
        Else {
            $data = $results
        }

        Write-Output $data
    }

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "scans/$Id" -RestMethod Get)
            }
            Else {
                Write-Output (Get-ScanList -URI 'scans' -Filter $ReturnStatus)
            }
        }

        'bySite' {
            $Site = (ConvertTo-NexposeId -Name $Site -ObjectType Site)
            Write-Output (Get-ScanList -URI "sites/$Site/scans" -Filter $ReturnStatus)
        }

        'byEngine' {
            Write-Output (Get-ScanList -URI "scan_engines/$EngineId/scans" -Filter $ReturnStatus)
        }
    }
}
