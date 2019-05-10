Function Get-NexposeReportHistory {
<#
    .SYNOPSIS
        Retrieves a list of report history

    .DESCRIPTION
        Retrieves a list of report history

    .PARAMETER Id
        The identifier of the report

    .PARAMETER Name
        The name of the report

    .PARAMETER HistoryId
        The identifier of the report instance

    .EXAMPLE
        Get-NexposeReportHistory -id 13

    .EXAMPLE
        Get-NexposeReportHistory -Name 'DR Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: reports
        GET: reports/{id}/history
        GET: reports/{id}/history/{instance}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [int]$HistoryId = 0
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($HistoryId -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$Id/history/$HistoryId" -RestMethod Get)
            }
            Else {
                Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$Id/history" -RestMethod Get)
            }
        }

        'byName' {
            $Name = (((Invoke-NexposeQuery -UrlFunction 'reports' -RestMethod Get) | Where-Object { $_.Name -eq $Name }).id)
            Get-NexposeReportHistory -Id $Name -HistoryId $HistoryId
        }
    }
}
