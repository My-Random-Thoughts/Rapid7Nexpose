Function Set-NexposeSiteScanTemplate {
<#
    .SYNOPSIS
        Updates the assigned scan template to the site

    .DESCRIPTION
        Updates the assigned scan template to the site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER ScanTemplate
        The identifier of the scan template

    .EXAMPLE
        Set-NexposeSiteScanTemplate -Id 23 -ScanTemplate discovery

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/scan_template

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'ScanTemplate' -Type 'string' -ValidateSet ((Get-NexposeScanTemplate).id)
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$ScanTemplate = $($PSBoundParameters.ScanTemplate)
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byName' {
                [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
                Write-Output (Set-NexposeSiteOrganization -Id $Id -ScanTemplate $ScanTemplate)
            }

            'byId' {
                If ($PSCmdlet.ShouldProcess($Id)) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/scan_template" -ApiQuery $ScanTemplate -RestMethod Put)
                }
            }
        }
    }

    End {
    }
}
