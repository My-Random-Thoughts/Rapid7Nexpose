Function Invoke-NexposeSystemCommand {
<#
    .SYNOPSIS
        Executes a console command against the Security Console

    .DESCRIPTION
        Executes a console command against the Security Console

    .PARAMETER Command
        The console command to execute

    .EXAMPLE
        Invoke-NexposeSystemCommand -Command 'help'

    .EXAMPLE
        Invoke-NexposeSystemCommand -Command 'traceroute 1.2.3.4'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: administration/commands

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Command)) {
            Write-Output ((Invoke-NexposeQuery -UrlFunction 'administration/commands' -ApiQuery $Command -RestMethod Post).output)
        }
    }

    End {
    }
}
