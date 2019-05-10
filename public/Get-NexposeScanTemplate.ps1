Function Get-NexposeScanTemplate {
<#
    .SYNOPSIS
        Returns a scan template

    .DESCRIPTION
        Returns a scan template

    .PARAMETER Id
        The identifier of the template

    .EXAMPLE
        Get-NexposeScanTemplate

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scan_templates
        GET: scan_templates/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [string]$Id = 0
    )

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "scan_templates/$Id" -RestMethod Get)
    }
    Else {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'scan_templates' -RestMethod Get)    # Return All
    }
}
