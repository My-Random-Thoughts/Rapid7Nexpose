Function Repair-NexposeScanEngine {
<#
    .SYNOPSIS
        Remove and re-add any failed scan engine servers

    .DESCRIPTION
        Remove and re-add any failed scan engine servers.
        Will remove one or more scan engines, then re-add them, assigning back into their original scan engine pools

    .PARAMETER ScanEngineId
        One or more identifiers for a scan engine

    .PARAMETER IgnoreOnlineStatus
        Ignore the status of a scan engine.  By default only offline scan engines are restored

    .EXAMPLE
        Repair-NexposeScanEngine

    .EXAMPLE
        Repair-NexposeScanEngine -ScanEngineId 42 -IgnoreOnlineStatus

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [int[]]$ScanEngineId,

        [switch]$IgnoreOnlineStatus
    )

    Begin {
        $scanPools   = @(Get-NexposeScanEnginePool)
        $scanEngines = @()
        If ($ScanEngineId) {
            ForEach ($id In $ScanEngineId) {
                $scanEngines += (Get-NexposeScanEngine -Id $id)
            }
        }
        Else {
            $ScanEngines = @(Get-NexposeScanEngine -RefreshedOffset 2 | Where-Object { ($_.id -gt 3) })
        }
        Write-Verbose -Message ($ScanEngines | Format-Table -AutoSize | Out-String)
    }

    Process {
        ForEach ($engine In $ScanEngines) {
            If (($engine.status -eq 'online') -and (-not $IgnoreOnlineStatus.IsPresent)) { Continue }

            Write-Verbose -Message "Processing '$($engine.name)' ($($engine.status)) ..."
            [int]$poolCount = 0
            ForEach ($pool In $scanPools) {
                If ($pool.engines -eq $engine.id) {
                    If ($poolCount -eq 0) {
                        If ($PSCmdlet.ShouldProcess($($pool.name), 'Removing scan engine')) {
                            [void](Remove-NexposeScanEngine -Id $($engine.id) -WhatIf:($WhatIfPreference -eq $true))
                        }

                        If ($PSCmdlet.ShouldProcess("$($engine.name) ($($engine.address):$($engine.port))", 'Adding Scan Engine')) {
                            $id = ((New-NexposeScanEngine -Name $($engine.name) -IPAddress $($engine.address) -Port $($engine.port) -WhatIf:($WhatIfPreference -eq $true)).id)
                        }
                    }
                    $poolCount++

                    If ($PSCmdlet.ShouldProcess($($pool.name), 'Adding Scan Engine To Pool')) {
                        [void](Add-NexposeScanEngineToPool -PoolId $($pool.id) -EngineId $id -WhatIf:($WhatIfPreference -eq $true))
                    }
                }
            }
        }
    }

    End {
    }
}
