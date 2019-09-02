Function New-NexposeScanEnginePool {
<#
    .SYNOPSIS
        Creates a new scan engine pool

    .DESCRIPTION
        Creates a new scan engine pool

    .PARAMETER Name
        The name of the scan engine pool

    .PARAMETER ScanEngine
        The identifiers or names of the scan engines in the engine pool

    .EXAMPLE
        New-NexposeScanEnginePool -Name 'UK West' -ScanEngine @(10, 11)

    .EXAMPLE
        New-NexposeScanEnginePool -Name 'UK West' -ScanEngine @('uk-west-engine-01','uk-west-engine-02')

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: scan_engine_pools

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string[]]$ScanEngine
    )

    Begin {
        [int[]]$ScanEngineIds = @()

        ForEach ($id In $ScanEngine) {
            If ((($id -as [int]) -eq $id) -and ($id -gt 0)) {
                $ScanEngineIds += $id
            }
            Else {
                $id = ((Get-NexposeScanEngine -Name $Engine).id)
                If (($id -is [int]) -and ($id -gt 0)) {
                    $ScanEngineIds += $id
                }
            }
        }
    }

    Process {
        $apiQuery = @{
            name    =   $Name
            engines = @($ScanEngineIds)
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'scan_engine_pools' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
