Function Get-NexposeReportTemplate {
<#
    .SYNOPSIS
        Returns the details of a report template

    .DESCRIPTION
        Returns the details of a report template. Report templates govern the contents generated within a report

    .PARAMETER Id
        The identifier of the template

    .EXAMPLE
        Get-NexposeReportTemplate -Id 'audit-report'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: report_templates
        GET: report_templates/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [string]$Id = ''
    )

    If (-not [string]::IsNullOrEmpty($Id)) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "report_templates/$Id" -RestMethod Get)
    }
    Else {
        Write-Output (Invoke-NexposeQuery -UrlFunction 'report_templates' -RestMethod Get)    # Return All
    }
}
