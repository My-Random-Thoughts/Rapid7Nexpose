Function Remove-NexposeScanEnginePool {
<#
    .SYNOPSIS
        Deletes the specified scan engine pool

    .DESCRIPTION
        Deletes the specified scan engine pool

    .PARAMETER Id
        The identifier of the scan engine pool

    .EXAMPLE
        Remove-NexposeScanEnginePool -Id 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: scan_engine_pools/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Id
    )

    Begin {
    }

    Process {
        [string[]]$pipeLine = $input | ForEach-Object { $_ }    # $input is an automatic variable
        If ($pipeLine) { $Id = $pipeLine }

        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "scan_engine_pools/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
