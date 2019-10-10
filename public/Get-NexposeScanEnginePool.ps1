Function Get-NexposeScanEnginePool {
<#
    .SYNOPSIS
        Returns engine pools available to use for scanning

    .DESCRIPTION
        Returns engine pools available to use for scanning

    .PARAMETER Id
        The identifier of the engine pool

    .PARAMETER Name
        The name of the engine pool

    .PARAMETER IncludeEngines
        Include the list of scan engines a particular engine pool will use
        Applies only when specifying a specific engine pool

    .PARAMETER IncludeSites
        Include the list of sites a particular engine pool will scan
        Applies only when specifying a specific engine pool

    .EXAMPLE
        Get-NexposeScanEnginePool -Id 10

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: scan_engine_pools
        GET: scan_engine_pools/{Id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [switch]$IncludeEngines,

        [switch]$IncludeSites
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                $Output = (Invoke-NexposeQuery -UrlFunction "scan_engine_pools/$Id" -RestMethod Get)

                If ($IncludeEngines.IsPresent) {
                    $engines = (Get-NexposeScanEnginePoolEngine -Id $Id)
                    $Output | Add-Member -Name 'engines' -Value $engines -MemberType NoteProperty
                }

                If ($IncludeSites.IsPresent) {
                    $sites = (Get-NexposeScanEnginePoolSite -Id $Id)
                    $Output | Add-Member -Name 'sites' -Value $sites -MemberType NoteProperty
                }

                Write-Output $Output
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'scan_engine_pools' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType ScanEnginePool)
            If ($id -gt 0) {
                Get-NexposeScanEnginePool -Id $Id -IncludeEngines:$IncludeEngines -IncludeSites:$IncludeSites
            }
        }
    }
}
