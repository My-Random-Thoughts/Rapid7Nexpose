Function Get-NexposeScanEnginePoolSites {
<#
    .SYNOPSIS
        Returns links to the sites associated with this engine pool

    .DESCRIPTION
        Returns links to the sites associated with this engine pool

    .PARAMETER Id
        The identifier of the engine pool

    .PARAMETER Name
        The name of the engine pool

    .EXAMPLE
        Get-NexposeScanEnginePoolSites -Id 10

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scan_engine_pools/{Id}/sites

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            Write-Output @(Invoke-NexposeQuery -UrlFunction "scan_engine_pools/$id/sites" -RestMethod Get)
        }

        'byName' {
            [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType ScanEnginePool)
            If ($Id -gt 0) {
                Write-Output (Get-NexposeScanEnginePoolSites -Id $Id)
            }
        }
    }
}
