Function Remove-NexposeScanTemplate {
<#
    .SYNOPSIS
        Deletes a scan template

    .DESCRIPTION
        Deletes a scan template

    .PARAMETER Id
        The identifier of the scan template

    .EXAMPLE
        Remove-NexposeScanTemplate -Id 'abc'

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        DELETE: scan_templates/{id}

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
                Write-Output (Invoke-NexposeQuery -UrlFunction "scan_templates/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
