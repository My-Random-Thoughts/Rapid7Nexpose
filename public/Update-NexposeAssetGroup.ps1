Function Update-NexposeAssetGroup {
<#
    .SYNOPSIS
        Updates the details of an asset group

    .DESCRIPTION
        Updates the details of an asset group

    .PARAMETER Id
        The identifier of the asset group

    .PARAMETER Name
        The name of the asset group

    .PARAMETER Description
        The description of the asset group

    .PARAMETER SearchCriteria
        Search criteria used to determine dynamic membership

    .EXAMPLE
        Update-NexposeAssetGroup -Id 2 -Name 'New Name'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: asset_groups/{id}
        PUT: SKIPPED - asset_groups/{id}/search_criteria    # Covered below

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

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

        # Get current values
        $group = ((Get-NexposeAssetGroup -Id $Id | ConvertTo-Json -Depth 100) | ConvertFrom-Json)
        $Type  = $group.type

        If ([string]::IsNullOrEmpty($Name)           -eq $true) { $Name           = $group.name           }
        If ([string]::IsNullOrEmpty($Description)    -eq $true) { $Description    = $group.description    }
        If ([string]::IsNullOrEmpty($SearchCriteria) -eq $true) { $SearchCriteria = $group.searchCriteria }

        If ([string]::IsNullOrEmpty($Description)    -eq $true) { $Description    =  ' '                  }
    }

    Process {
        $apiQuery = @{
            type           = $Type
            name           = $Name
            description    = $Description
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
            Write-Output (Invoke-NexposeQuery -UrlFunction "asset_groups/$id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
