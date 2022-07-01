Function Get-NexposeLicense {
<#
    .SYNOPSIS
        Returns the enabled features and limits of the current license

    .DESCRIPTION
        Returns the enabled features and limits of the current license

    .EXAMPLE
        Get-NexposeLicenseKey

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/license

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param ()

    Write-Output (Invoke-NexposeQuery -UrlFunction 'administration/license' -RestMethod Get)
}
