Function Invoke-NexposeReport {
<#
    .SYNOPSIS
        Generates a configured report and returns the instance identifier of the report

    .DESCRIPTION
        Generates a configured report and returns the instance identifier of the report

    .PARAMETER Id
        The identifier of the report

    .PARAMETER Wait
        Wait for the report to finish being generated

    .EXAMPLE
        Invoke-NexposeReport -Id 123 -Wait

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: reports/{id}/generate

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [switch]$Wait
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Id)) {
            $report = (Invoke-NexposeQuery -UrlFunction "reports/$Id/generate" -RestMethod Post)

            If ($Wait.IsPresent) {
                Wait-NexposeReport -Id $Id
            }
            Else {
                Write-Output $report
            }
        }
    }

    End {
    }
}
