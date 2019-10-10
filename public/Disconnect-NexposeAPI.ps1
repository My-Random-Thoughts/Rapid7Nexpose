Function Disconnect-NexposeAPI {
<#
    .SYNOPSIS
        Removes the authentication session to Nexpose

    .DESCRIPTION
        Removes the authentication session to Nexpose

    .EXAMPLE
        Disconnect-NexposeAPI

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
    )

    If (Get-Variable -Name 'NexposeSession' -ErrorAction SilentlyContinue) {
        If ($PSCmdlet.ShouldProcess("$($NexposeSession.Headers.Hostname):$($NexposeSession.Headers.Port)")) {
            Remove-Variable -Name 'NexposeSession' -Force
        }
    }
}
