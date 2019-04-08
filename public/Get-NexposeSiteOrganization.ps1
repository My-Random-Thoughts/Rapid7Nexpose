Function Get-NexposeSiteOrganization {
<#
    .SYNOPSIS
        Retrieves the site organization information

    .DESCRIPTION
        Retrieves the site organization information

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .EXAMPLE
        Get-NexposeSiteOrganization -Id 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/organization

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byName' {
            [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Write-Output (Get-NexposeSiteOrganization -Id $Id)
        }

        'byId' {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/organization" -RestMethod Get)
        }
    }
}
