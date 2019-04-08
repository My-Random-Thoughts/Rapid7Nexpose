Function Get-NexposeSystemInfo {
<#
    .SYNOPSIS
        Returns system details, including host and version information

    .DESCRIPTION
        Returns system details, including host and version information

    .EXAMPLE
        Get-NexposeSystemInformation

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/info

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Write-Output (Invoke-NexposeQuery -UrlFunction 'administration/info' -RestMethod Get)
}
