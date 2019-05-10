Function Get-NexposeSonarQuery {
<#
    .SYNOPSIS
        Returns a sonar query

    .DESCRIPTION
        Returns a sonar query

    .PARAMETER Id
        The identifier of the sonar query

    .PARAMETER IncludeAssets
        Include any found assets

    .EXAMPLE
        Get-NexposeSonarQuery -Id 32

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sonar_queries
        GET: sonar_queries/{id}
        GET: sonar_queries/{id}/assets

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [int]$Id = 0,

        [switch]$IncludeAssets
    )

    If ($Id -gt 0) {
        $Output = (Invoke-NexposeQuery -UrlFunction "sonar_queries/$Id" -RestMethod Get)
        If ($IncludeAssets.IsPresent) {
            $Output | Add-Member -MemberType NoteProperty -Name 'assets' -Value (Invoke-NexposeQuery -UrlFunction "sonar_queries/$Id/assets" -RestMethod Get)
        }

        Write-Output $Output
    }
    Else {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'sonar_queries' -RestMethod Get)    # Return All
    }
}
