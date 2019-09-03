Function Update-NexposeTagSearchCriteria {
<#
    .SYNOPSIS
        Updates the search criteria associated with the tag

    .DESCRIPTION
        Updates the search criteria associated with the tag

    .PARAMETER Id
        The identifier of the tag

    .PARAMETER Name
        The name of the tag

    .PARAMETER SearchCriteria
        Search criteria used to determine dynamic membership, if type is "dynamic"

    .EXAMPLE
        Update-NexposeTagSearchCriteria -Name 'RangeTag' -SearchCriteria @{ match = 'all'; filters = @(@{ field = 'ip-address'; operator = 'in-range'; lower = '1.1.1.1'; upper = '1.255.255.255' })}

    .NOTES
        For additional information please contact PlatformBuild@callcreditgroup.com

    .FUNCTIONALITY
        PUT: tags/{id}/search_criteria

    .LINK
        https://callcreditgroup.sharepoint.com/cto/dev%20ops/PlatformBuild/default.aspx
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [hashtable]$SearchCriteria
    )

    Begin {
        # Validate Search Criteria
        If ([string]::IsNullOrEmpty($SearchCriteria) -eq $false) {
            [string]$result = (Test-NexposeSearchCriteria -SearchCriteria $SearchCriteria)
            If ($result -ne 'Success') { Throw $result }
        }
    }

    Process {
        If ($PSCmdlet.ParameterSetName -eq 'byName') {
            [int]$Id = ((Get-NexposeTag -Name $Name).id)
        }

        If ($PSCmdlet.ShouldProcess($tag)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$Id/search_criteria" -ApiQuery $SearchCriteria -RestMethod Put)
        }
    }

    End {
    }
}
