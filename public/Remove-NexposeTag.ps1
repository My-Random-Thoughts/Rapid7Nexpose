Function Remove-NexposeTag {
<#
    .SYNOPSIS
        Deletes the tag

    .DESCRIPTION
        Deletes the tag

    .PARAMETER Id
        The identifier or name of the tag

    .EXAMPLE
        Remove-NexposeTag -Id 23

    .EXAMPLE
        Remove-NexposeTag -Id 'DR_Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: tags/{id}

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
            If ($PSCmdlet.ShouldProcess()) {
                $item = (ConvertTo-NexposeId -Name $item -ObjectType Tag)
                Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
