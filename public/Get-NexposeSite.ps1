Function Get-NexposeSite {
<#
    .SYNOPSIS
        Returns site details

    .DESCRIPTION
        Returns site details by id, name, or tag

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER Tag
        The tag of the sites

    .EXAMPLE
        Get-NexposeSite -SiteId 5

    .EXAMPLE
        Get-NexposeSite -Name 'DR Site'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites
        GET: sites/{id}
        GET: tags/{id}/sites

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byTag')]
        [string]$Tag
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'sites' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Get-NexposeSite -Id $Name
        }

        'byTag' {
            $Tag = (ConvertTo-NexposeId -Name $Tag -ObjectType 'Tag')
            [object]$varis = @((Invoke-NexposeQuery -UrlFunction "tags/$Tag/sites" -RestMethod Get).links | Where-Object { $_.rel -eq 'Site' })

            If ([string]::IsNullOrEmpty($varis) -eq $false) {
                ForEach ($getId In $varis) {
                    $getId = (($getId.href -split '/')[-1])
                    Get-NexposeSite -Id $getId
                }
            }
        }
    }
}
