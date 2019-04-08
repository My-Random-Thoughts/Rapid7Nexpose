Function Remove-NexposeSite {
<#
    .SYNOPSIS
        Deletes the site

    .DESCRIPTION
        Deletes the site

    .PARAMETER Id
        The identifier or name of the site

    .EXAMPLE
        Remove-NexposeSite -Id 23

    .EXAMPLE
        Remove-NexposeSite -Id 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}

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
        $Id = (ConvertTo-NexposeId -Name $Id -ObjectType Site)

        If ($Id -gt 0) {
            If ($PSCmdlet.ShouldProcess($Id)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
