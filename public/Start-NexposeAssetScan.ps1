Function Start-NexposeAssetScan {
<#
    .SYNOPSIS
        Starts a scan for the specified asset

    .DESCRIPTION
        Starts a scan for the specified asset

    .PARAMETER Name
        The user-driven scan name for the scan

    .PARAMETER SiteId
        The identifier of the site the asset is located

    .PARAMETER AssetId
        The asset that should be scaned

    .PARAMETER TemplateId
        The identifier of the scan template.  Defaults to 'Discovery'

    .PARAMETER Wait
        Switch to wait for the scan to complete

    .EXAMPLE
        Start-NexposeAssetScan -Name 'Scan 1' -SiteId 4 -AssetId 42

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: asset/scan

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [Parameter(Mandatory = $true)]
        [int]$AssetId,

        [switch]$Wait
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'TemplateId' -Type 'string' -ValidateSet @((Get-NexposeScanTemplate).id)
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$TemplateId = $($PSBoundParameters.TemplateId)
        If ([string]::IsNullOrEmpty($TemplateId) -eq $true) { $TemplateId = 'discovery' }
    }

    Process {
        $apiQuery = @{
            asset_id         = $AssetId
            scan_name        = $Name
            scan_template_id = $TemplateId
            site_id          = $SiteId
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            $scans = (Invoke-NexposeQuery -UrlFunction 'asset/scan' -ApiQuery $apiQuery -RestMethod Post)

            If ($Wait.IsPresent -eq $false) {
                Write-Output $scans
            }
            Else {
                If ($scans -is [int]) {
                    Wait-NexposeScan -Id $scans
                }
            }
        }
    }

    End {
    }
}
