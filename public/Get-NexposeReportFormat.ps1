Function Get-NexposeReportFormat {
<#
    .SYNOPSIS
        Returns all available report formats

    .DESCRIPTION
        Returns all available report formats. A report format indicates an output file format specification (e.g. PDF, XML, etc). Some printable formats may be templated, and others may not. The supported templates for each formated are provided

    .EXAMPLE
        Get-NexposeReportFormat

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: report_formats

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Write-Output (Invoke-NexposeQuery -UrlFunction 'report_formats' -RestMethod Get)
}
