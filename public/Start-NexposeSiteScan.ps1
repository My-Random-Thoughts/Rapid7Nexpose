Function Start-NexposeSiteScan {
<#
    .SYNOPSIS
        Starts a scan for the specified site

    .DESCRIPTION
        Starts a scan for the specified site

    .PARAMETER Name
        The user-driven scan name for the scan

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER AssetId
        The assets that should be included as a part of the scan

    .PARAMETER Wait
        Switch to wait for the scan to complete

    .EXAMPLE
        Start-NexposeSiteScan -Name 'Scan 1' -SiteId '4'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: sites/{id}/scans

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$SiteId,

        [int[]]$AssetId,

        [switch]$Wait
    )

    Begin {
    }

    Process {
        $apiQuery = @{
            name = $Name
        }

        If ([string]::IsNullOrEmpty($ComputerName) -eq $false) {
            $apiQuery += @{
                hosts = @(
                    $AssetId
                )
            }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            $scans = (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/scans" -ApiQuery $apiQuery -RestMethod Post)

            If ($Wait.IsPresent -eq $false) {
                Write-Output $scans
            }
            Else {
                If ($scans.id -is [int]) {
                    Wait-NexposeScan -Id ($scans.id)
                }
            }
        }
    }

    End {
    }
}
