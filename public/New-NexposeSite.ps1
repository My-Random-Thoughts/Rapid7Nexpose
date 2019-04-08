Function New-NexposeSite {
<#
    .SYNOPSIS
        Create a new site

    .DESCRIPTION
        Create a new site

    .PARAMETER Name
        The site name. Name must be unique.

    .PARAMETER Description
        The site's description.

    .PARAMETER Importance
        The site importance. Defaults to "normal" if not specified.

    .PARAMETER ScanTemplateId
        The identifier of a scan template. Default scan template "discovery" is selected when not specified.

    .PARAMETER EngineId
        The identifier of a scan engine. Default scan engine is selected when not specified.

    .PARAMETER IncludeAddress
        Addresses to be included in the site's scan. At least one address must be specified in a static site. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation

    .PARAMETER IncludeAssetGroupId
        Assets associated with these asset groups will be included in the site's scan

    .PARAMETER ExcludeAddress
        Addresses to be excluded from the site's scan. Each address is a string that can represent either a hostname, ipv4 address, ipv4 address range, ipv6 address, or CIDR notation

    .PARAMETER ExcludeAssetGroupId
        Assets associated with these asset groups will be excluded from the site's scan

    .EXAMPLE
        New-NexposeSite -Name 'Site 1' -Description 'Live site' -Importance very_high -ScanTemplateId 'discovery' -EngineId 1 -IncludeAddress @('1.1.1.0/24')

    .EXAMPLE
        New-NexposeSite -Name 'Site 2' -Description 'DR Site' -IncludeAddress @('2.2.2.0/24', '3.3.3.0/24') -ExcludeAddress @('1.1.1.10')

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: sites

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Description,

        [ValidateSet('very_high', 'high', 'normal', 'low', 'very_low')]
        [string]$Importance = 'normal',

        [string]$ScanTemplateId = 'discovery',

        [string[]]$IncludeAddress,

        [int[]]$IncludeAssetGroupId,

        [string[]]$ExcludeAddress,

        [int[]]$ExcludeAssetGroupId
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'EngineId' -Type 'string' -ValidateSet @((Get-NexposeScanEngine).Name)
        Return $dynParam
    }

    Begin {
        [string]$EngineName = $($PSBoundParameters.EngineId)
        [int]   $EngineId   = ((Get-NexposeScanEngine -Name $EngineName).id)
    }

    Process {
        $apiQuery = @{
            name           = $Name
            description    = $Description
            importance     = $Importance
            scanTemplateId = $ScanTemplateId
            scan = @{
                assets = @{}
            }
        }

        If ($EngineId -gt 0) {
            $apiQuery += @{
                engineId = $EngineId
            }
        }

        If ([string]::IsNullOrEmpty($ExcludeAssetGroupId) -eq $false) {
            $apiQuery.scan.assets += @{
                excludeAssetGroups = @{
                    assetGroupIDs = @(
                        $ExcludeAssetGroupId
                    )
                }
            }
        }

        If ([string]::IsNullOrEmpty($ExcludeAddress) -eq $false) {
            $apiQuery.scan.assets += @{
                excludedTargets = @{
                    addresses = @(
                        $ExcludeAddress
                    )
                }
            }
        }

        If ([string]::IsNullOrEmpty($IncludeAssetGroupId) -eq $false) {
            $apiQuery.scan.assets += @{
                includeAssetGroups = @{
                    assetGroupIDs = @(
                        $IncludeAssetGroupId
                    )
                }
            }
        }

        If ([string]::IsNullOrEmpty($IncludeAddress) -eq $false) {
            $apiQuery.scan.assets += @{
                includedTargets = @{
                    addresses = @(
                        $IncludeAddress
                    )
                }
            }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'sites' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
