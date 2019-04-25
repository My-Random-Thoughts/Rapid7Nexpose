Function Remove-NexposeTagSearchCriteria {
<#
    .SYNOPSIS
        Removes the search criteria associated with the tag

    .DESCRIPTION
        Removes the search criteria associated with the tag

    .PARAMETER Id
        The identifier or name of the tag

    .EXAMPLE
        Remove-NexposeTagSearchCriteria -Id 23

    .EXAMPLE
        Remove-NexposeTagSearchCriteria -Id 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: tags/{id}/search_criteria

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Scope = 'Function')]
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
            If ($PSCmdlet.ShouldProcess()) {
                $item = (ConvertTo-NexposeId -Name $item -ObjectType Tag)
                Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$item/search_criteria" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
