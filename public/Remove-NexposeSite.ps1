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
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Id
    )

    Begin {
    }

    Process {
        [string[]]$pipeLine = $input | ForEach-Object { $_ }    # $input is an automatic variable
        If ($pipeLine) { $Id = $pipeLine }

        ForEach ($item In $Id) {
            $itemId = (ConvertTo-NexposeId -Name $item -ObjectType Site)

            If ($itemId -gt 0) {
                If ($PSCmdlet.ShouldProcess()) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$itemId" -RestMethod Delete)
                }
            }
        }
    }

    End {
    }
}
