Function Remove-NexposeReport {
<#
    .SYNOPSIS
        Deletes the configuration of a report

    .DESCRIPTION
        Deletes the configuration of a report

    .PARAMETER Id
        The identifier of the report

    .EXAMPLE
        Remove-NexposeReport -Id 'custom-user-01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: reports/{id}

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
                Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
