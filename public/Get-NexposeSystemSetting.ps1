Function Get-NexposeSystemSetting {
<#
    .SYNOPSIS
        Returns the current administration settings

    .DESCRIPTION
        Returns the current administration settings

    .EXAMPLE
        Get-NexposeSystemSetting

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: administration/settings

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Write-Output (Invoke-NexposeQuery -UrlFunction 'administration/settings' -RestMethod Get)
}
