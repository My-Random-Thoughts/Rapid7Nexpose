Function Get-NexposeSoftware {
<#
    .SYNOPSIS
        Returns software details

    .DESCRIPTION
        Returns software details by id, name, vendor, or asset

    .PARAMETER Id
        The identifier of the software

    .PARAMETER Name
        The name of the software

    .PARAMETER Vendor
        The vendor of the software

    .PARAMETER Asset
        The identifier of the asset

    .EXAMPLE
        Get-NexposeSoftware -Id 5

    .EXAMPLE
        Get-NexposeSoftware -Name '.NET Framework 3.0'

    .EXAMPLE
        Get-NexposeSoftware -Vendor 'Microsoft'

    .EXAMPLE
        Get-NexposeSoftware -Asset 'server01'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{id}/software
        GET: software
        GET: software/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byVendor')]
        [string]$Vendor,

        [Parameter(ParameterSetName = 'byAsset')]
        [string]$Asset
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "software/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'software' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            Write-Output @((Invoke-NexposeQuery -UrlFunction 'software' -RestMethod Get) |
                Where-Object { ($_.product -like "*$Name*") -or ($_.description -like "*$Name*") })
        }

        'byVendor' {
            Write-Output @((Invoke-NexposeQuery -UrlFunction 'software' -RestMethod Get) | Where-Object { $_.vendor -eq $Vendor })
        }

        'byAsset' {
            $Asset = (ConvertTo-NexposeId -Name $Asset -ObjectType 'Asset')
            Write-Output @(Invoke-NexposeQuery -UrlFunction "assets/$Asset/software" -RestMethod Get)
        }
    }
}
