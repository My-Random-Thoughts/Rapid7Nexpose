Function Remove-NexposeLink {
<#
    .SYNOPSIS
        Removes any 'LINKS' items from returned REST data

    .DESCRIPTION
        Removes any 'LINKS' items from returned REST data

    .PARAMETER InputObject
        The REST API data object

    .EXAMPLE
        Remove-NexposeLink -InputObject $Data

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [object[]]$InputObject
    )

    If ($PSCmdlet.ShouldProcess('InputObject')) {
        ForEach ($obj In $InputObject) {
            # Check to see if there is anything other than links
            [string[]]$pNames = (($obj | Get-Member -MemberType *Property).Name)
            If (($pNames.Count -eq 1) -and ($pNames[0] -eq 'links')) {
                Write-Output $obj
            }
            Else {
                # Remove top level links
                If ($obj.links) { $obj = ($obj | Select-Object -Property * -ExcludeProperty 'links') }

                # Remove sub-level links
                $obj | Get-Member -MemberType *Property | `
                    ForEach-Object -Process {
                        [string]$pName = ($_.Name)
                        If ($obj.$pName.links) {
                            $obj.$pName = ($obj.$pName | Select-Object -Property * -ExcludeProperty 'links')
                        }
                    }

                Write-Output $obj
            }
        }
    }
}
