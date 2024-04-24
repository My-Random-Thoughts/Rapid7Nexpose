Function Update-NexposeScanEnginePool {
<#
    .SYNOPSIS
        Updates an existing scan engine pool

    .DESCRIPTION
        Updates an existing scan engine pool

    .PARAMETER Id
        The identifier of the engine pool

    .PARAMETER NewName
        The new name of the scan engine pool

    .PARAMETER ScanEngine
        The identifiers or names of the scan engines in the engine pool.  This will replace all existing scan engines with the provided list

    .PARAMETER Site
        The identifiers or names of the sites in the engine pool.  This will replace all existing scan engines with the provided list

    .EXAMPLE
        Update-NexposeScanEnginePool -Id 3 -NewName 'UK West'

    .EXAMPLE
        Update-NexposeScanEnginePool -Id 6 -ScanEngine @('uk-west-engine-01','uk-west-engine-02')

    .EXAMPLE
        Update-NexposeScanEnginePool -Id 4 -Site 'uk-west-01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: scan_engine_pools/{id}
        PUT: SKIPPED - scan_engine_pools/{id}/engines    # Covered in this script

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [string]$NewName,

        [string[]]$ScanEngine,

        [string[]]$Site
    )

    Begin {
        If ([string]::IsNullOrEmpty($NewName) -and [string]::IsNullOrEmpty($ScanEngine) -and [string]::IsNullOrEmpty($Site)) {
            Throw 'At least one parameter must be supplied'
        }

        # Get current values
        $pool = (Get-NexposeScanEnginePool -Id $id)
        If ([string]::IsNullOrEmpty($NewName)    -eq $true) { $NewName    = $pool.name    }
        If ([string]::IsNullOrEmpty($ScanEngine) -eq $true) { $ScanEngine = $pool.engines }
        If ([string]::IsNullOrEmpty($Site)       -eq $true) { $Site       = $pool.sites   }

        # Create ENGINE list
        If (-not [string]::IsNullOrEmpty($ScanEngine)) {
            [int[]]$ScanEngineIds = @()
            ForEach ($seId In $ScanEngine) {
                If ((($seId -as [int]) -eq $seId) -and ($seId -gt 0)) {
                    $ScanEngineIds += $seId
                }
                Else {
                    $seId = ((Get-NexposeScanEngine -Name $seId).id)
                    If (($seId -is [int]) -and ($seId -gt 0)) {
                        $ScanEngineIds += $seId
                    }
                }
            }
        }

        # Create SITE list
        If (-not [string]::IsNullOrEmpty($Site)) {
            [int[]]$SiteIds = @()
            ForEach ($sId In $Site) {
                If ((($sId -as [int]) -eq $sId) -and ($sId -gt 0)) {
                    $SiteIds += $sId
                }
                Else {
                    $sId = ((Get-NexposeSite -Name $sId).id)
                    If (($sId -is [int]) -and ($sId -gt 0)) {
                        $SiteIds += $sId
                    }
                }
            }
        }
    }

    Process {
        $apiQuery = @{
            id      =   $Id
            name    =   $NewName
            engines = @($ScanEngineIds)
            sites   = @($SiteIds)
        }

        If ($PSCmdlet.ShouldProcess($Id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "scan_engine_pools/$Id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
