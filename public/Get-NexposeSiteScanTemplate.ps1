Function Get-NexposeSiteScanTemplate {
<#
    .SYNOPSIS
        Retrieves the resource of the scan template assigned to the site

    .DESCRIPTION
        Retrieves the resource of the scan template assigned to the site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .EXAMPLE
        Get-NexposeSiteScanTemplate -Id 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/scan_template

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
            Write-Output (Get-NexposeSiteScanTemplate -Id $Id)
        }

        'byId' {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/scan_template" -RestMethod Get)
        }
    }
}
