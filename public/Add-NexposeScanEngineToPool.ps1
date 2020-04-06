Function Add-NexposeScanEngineToPool {
<#
    .SYNOPSIS
        Add and existing scan engine into an existing scan engine pool

    .DESCRIPTION
        Add and existing scan engine into an existing scan engine pool

    .PARAMETER PoolId
        The identifier of the scan enginepool

    .PARAMETER EngineId
        The identifier of the scan engine

    .EXAMPLE
        Add-NexposeScanEngineToPool -PoolId 42 -EngineId (100, 101, 102)

    .EXAMPLE
        Add-NexposeScanEngineToPool -PoolId 42 -EngineId (100, 101) -ReplaceExisting

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        PUT: scan_engine_pools/{id}/engines/{engineId}
        DELETE: scan_engine_pools/{id}/engines/{engineId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [int]$PoolId,

        [int[]]$EngineId
    )

    Begin {
        # Check that everything exists
        [object]$currPool = (Get-NexposeScanEnginePool -Id $PoolId -ErrorAction Stop)
        ForEach ($id In $EngineId) {
            [void](Get-NexposeScanEngine -Id $id -ErrorAction Stop)
        }
    }

    Process {
        $EngineId += $($currPool.engines)

        If ($PSCmdlet.ShouldProcess($PoolId)) {
            ForEach ($Engine In $EngineId) {
                Invoke-NexposeQuery -UrlFunction "scan_engine_pools/$PoolId/engines/$Engine" -RestMethod Put
            }
        }
    }

    End {
    }
}
