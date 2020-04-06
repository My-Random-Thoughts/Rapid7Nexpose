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

    .PARAMETER UpdateTimeSpan
        The length of time between checking for updates.  Defaults to 30 seconds

    .PARAMETER WaitTimeOut
        The maximum length of time to wait for the process to complete.  Defaults 30 minutes

    .EXAMPLE
        Start-NexposeAssetScan -Name 'Scan 1' -SiteId 4 -AssetId 42

    .EXAMPLE
        Start-NexposeAssetScan -Name 'Scan 1' -SiteId 4 -AssetId 42 -Wait

    .EXAMPLE
        Start-NexposeAssetScan -Name 'Scan 1' -SiteId 4 -AssetId 42 -Wait -UpdateTimeSpan (New-TimeSpan -Seconds 10)

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: asset/scan    # Not a valid APIv3 endpoint - Action is not possible in v3

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

        If ($Wait.IsPresent) {
            New-DynamicParameter -Dictionary $dynParam -Name 'UpdateTimeSpan' -Type 'timespan'
            New-DynamicParameter -Dictionary $dynParam -Name 'WaitTimeOut'    -Type 'timespan'
        }

        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string]$TemplateId     = $($PSBoundParameters.TemplateId )
        [string]$UpdateTimeSpan = $($PSBoundParameters.TimeSpan   )
        [string]$WaitTimeOut    = $($PSBoundParameters.WaitTimeOut)
        If ([string]::IsNullOrEmpty($TemplateId)     -eq $true) { $TemplateId     = 'discovery'                }
        If ([string]::IsNullOrEmpty($UpdateTimeSpan) -eq $true) { $UpdateTimeSpan = (New-TimeSpan -Seconds 30) }
        If ([string]::IsNullOrEmpty($WaitTimeOut)    -eq $true) { $WaitTimeOut    = (New-TimeSpan -Minutes 30) }
    }

    Process {
        $apiQuery = @{
            asset_id         = $AssetId
            scan_name        = $Name
            scan_template_id = $TemplateId
            site_id          = $SiteId
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            $scan = (Invoke-NexposeQuery -UrlFunction 'asset/scan' -ApiQuery $apiQuery -RestMethod Post)

            If ($scan -is [int]) {
                If ($Wait.IsPresent) {
                    Write-Output (Wait-NexposeScan -Id $scan -UpdateTimeSpan $UpdateTimeSpan -WaitTimeOut $WaitTimeOut)
                }
                Else {
                    Write-Output (Get-NexposeScan -Id $scan | Select-Object -Property id, scanName, scanType, startTime, status)
                }
            }
        }
    }

    End {
    }
}
