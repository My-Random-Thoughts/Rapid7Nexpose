Function New-NexposeAssetGroup {
<#
    .SYNOPSIS
        Creates a new asset group

    .DESCRIPTION
        Creates a new asset group

    .PARAMETER Name
        The name of the asset group

    .PARAMETER Description
        The description of the asset group

    .PARAMETER Type
        The type of the asset group

    .PARAMETER SearchCriteria
        Search criteria used to determine dynamic membership

    .EXAMPLE
        New-NexposeAssetGroup -Type static -Name 'Group A' -Description 'New Static Group'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: asset_groups

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('static','dynamic')]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Description,

        [hashtable]$SearchCriteria
    )

    Begin {
        # Validate Search Criteria
        If ([string]::IsNullOrEmpty($SearchCriteria) -eq $false) {
            [string]$result = (Test-NexposeSearchCriteria -SearchCriteria $SearchCriteria)
            If ($result -ne 'Success') { Throw $result }
        }

        If ([string]::IsNullOrEmpty($Description) -eq $true) {
            $Description = $Name
        }
    }

    Process {
        $apiQuery = @{
            type        = $Type
            name        = $Name
            description = $Description
        }

        If ([string]::IsNullOrEmpty($SearchCriteria) -eq $false) {
            $apiQuery += @{
                searchCriteria = $SearchCriteria
            }
        }
        Else {
            # Must be used in case of a blank $SearchCriteria
            $apiQuery += @{
                searchCriteria = @{
                    match   = 'all'
                    filters = @()
                }
            }
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'asset_groups' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
