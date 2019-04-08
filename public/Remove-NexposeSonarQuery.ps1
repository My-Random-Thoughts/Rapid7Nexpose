Function Remove-NexposeSonarQuery {
<#
    .SYNOPSIS
        Removes a sonar query

    .DESCRIPTION
        Removes a sonar query

    .PARAMETER Id
        The identifier of the sonar query

    .EXAMPLE
        Remove-NexposeSonarQuery -Id 32

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sonar_queries/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id
    )

    If ($PSCmdlet.ShouldProcess($Id)) {
        Write-Output (Invoke-NexposeQuery -UrlFunction "sonar_queries/$Id" -RestMethod Delete)
    }
}
