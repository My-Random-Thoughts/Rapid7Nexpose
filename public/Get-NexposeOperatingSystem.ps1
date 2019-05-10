Function Get-NexposeOperatingSystem {
<#
    .SYNOPSIS
        Returns all operating systems discovered across all assets or a specific asset.

    .DESCRIPTION
        Returns all operating systems discovered across all assets.

    .PARAMETER Id
        The identifier of the operating system

    .EXAMPLE
        Get-NexposeOperatingSystem -Id 123

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: operating_systems
        GET: operating_systems/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [string]$Id = 0
    )

    If ($Id -gt 0) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "operating_systems/$Id" -RestMethod Get)
    }
    Else {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'operating_systems' -RestMethod Get)    # Return All
    }
}
