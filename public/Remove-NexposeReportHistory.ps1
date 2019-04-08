Function Remove-NexposeReportHistory {
<#
    .SYNOPSIS
        Deletes the instance of a report generation

    .DESCRIPTION
        Deletes the instance of a report generation

    .PARAMETER Id
        The identifier of the report

    .PARAMETER HistoryId
        The identifier of the report instance

    .EXAMPLE
        Remove-NexposeReportHistory -Id 13 -HistoryId 50

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: reports/{id}/history/{instance}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true)]
        [int]$HistoryId
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$Id/history/$HistoryId" -RestMethod Delete)
        }
    }

    End {
    }
}
