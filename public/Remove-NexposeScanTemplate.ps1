Function Remove-NexposeScanTemplate {
<#
    .SYNOPSIS
        Deletes a scan template

    .DESCRIPTION
        Deletes a scan template

    .PARAMETER Id
        The identifier of the scan template

    .EXAMPLE
        Remove-NexposeScanTemplate -Id 'abc

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: scan_templates/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string[]]$Id
    )

    Begin {
    }

    Process {
        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "scan_templates/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
