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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int[]]$Id
    )

    Begin {
    }

    Process {
        [int[]]$pipeLine = $input | ForEach-Object { $_ }    # $input is an automatic variable
        If ($pipeLine) { $Id = $pipeLine }

        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sonar_queries/$Id" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
