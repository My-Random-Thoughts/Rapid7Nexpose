Function Remove-NexposeAsset {
<#
    .SYNOPSIS
        Deletes the asset

    .DESCRIPTION
        Deletes the asset

    .PARAMETER Id
        The identifier of the asset

    .EXAMPLE
        Remove-NexposeAsset -Id 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: assets/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int[]]$Id
    )

    Begin {
    }

    Process {
        [int[]]$pipeLine = $input | ForEach-Object { $_ }    # $input is an automatic variable
        If ($pipeLine) { $Id = $pipeLine }

        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "assets/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
