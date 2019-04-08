Function Remove-NexposeReport {
<#
    .SYNOPSIS
        Deletes the configuration of a report

    .DESCRIPTION
        Deletes the configuration of a report

    .PARAMETER Id
        The identifier of the report

    .EXAMPLE
        Remove-NexposeReport -Id 'custom-user-01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: reports/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Id
    )

    Begin {
    }

    Process {
        If ($PSCmdlet.ShouldProcess($Command)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$Id" -RestMethod Delete)
        }
    }

    End {
    }
}
