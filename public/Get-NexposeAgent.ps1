Function Get-NexposeAgent {
<#
    .SYNOPSIS
        Returns the details for all agents

    .DESCRIPTION
        Returns the details for all agents

    .EXAMPLE
        Get-NexposeAgent

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: agents

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
    )

    Write-Output @(Invoke-NexposeQuery -UrlFunction 'agents' -RestMethod Get)
}
