Function Remove-NexposeScanEngine {
<#
    .SYNOPSIS
        Deletes the specified scan engine

    .DESCRIPTION
        Deletes the specified scan engine

    .PARAMETER Id
        The identifier of the scan engine

    .EXAMPLE
        Remove-NexposeScanEngine -Id 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: scan_engines/{id}

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
            If ($PSCmdlet.ShouldProcess()) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "scan_engines/$Id" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
