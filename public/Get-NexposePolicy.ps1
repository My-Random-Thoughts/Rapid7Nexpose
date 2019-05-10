Function Get-NexposePolicy {
<#
    .SYNOPSIS
        Retrieves a list of policies

    .DESCRIPTION
        Retrieves a list of policies

    .PARAMETER Id
        The identifier of the policy

    .PARAMETER AssetId
        The identifier of the asset

    .PARAMETER IncludeAssets
        Retrieves asset resources with rule compliance results for the specified policy

    .PARAMETER IncludeChildren
        Retrieves policy rules, or groups, that are defined directly underneath the specified policy

    .PARAMETER IncludeGroups
        Retrieves policy groups for the specified policy

    .PARAMETER IncludeRules
        Retrieves policy rules for the specified policy

    .PARAMETER Search
        Filters the retrieved policies with those whose titles that match the parameter

    .PARAMETER IncludeDeprecated
        Inlcude any policies that have been deprecated

    .EXAMPLE
        Get-NexposePolicy -Id 636

    .EXAMPLE
        Get-NexposePolicy -Search 'Windows 2008 R2'

    .EXAMPLE
        Get-NexposePolicy -AssetId 123

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{assetId}/policies
        GET: policies
        GET: policies/{id}/children
        GET: policies/{policyId}
        GET: policies/{policyId}/assets
        GET: policies/{policyId}/groups
        GET: policies/{policyId}/rules
        GET: SKIPPED - assets/{assetId}/policies/{policyId}/children                     # Data is covered below
        GET: SKIPPED - assets/{assetId}/policies/{policyId}/groups/{groupId}/children    # Data is covered below
        GET: SKIPPED - assets/{assetId}/policies/{policyId}/groups/{groupId}/rules       # Data is covered below
        GET: SKIPPED - assets/{assetId}/policies/{policyId}/rules                        # Data is covered below
        GET: SKIPPED - policies/{policyId}/assets/{assetId}                              #
        GET: SKIPPED - policies/{policyId}/groups/{groupId}/assets                       #
        GET: SKIPPED - policies/{policyId}/groups/{groupId}/assets/{assetId}             #

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(Mandatory = $true, ParameterSetName = 'byAsset')]
        [int]$AssetId,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeAssets,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeChildren,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeGroups,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeRules,

        [Parameter(Mandatory = $true, ParameterSetName = 'bySearch')]
        [string]$Search,

        [Parameter(ParameterSetName = 'bySearch')]
        [switch]$IncludeDeprecated
    )

    If (($IncludeAssets.IsPresent -or $IncludeChildren.IsPresent -or $IncludeGroups.IsPresent -or $IncludeRules.IsPresent) -and ($Id -eq 0)) {
        Throw 'A surrogate id must be entered'
    }

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                [string]$uri = "policies/$Id"
                $policy = (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Get)
                If ($IncludeAssets.IsPresent)   { $policy | Add-Member -Name 'assets'   -Value @(Invoke-NexposeQuery -UrlFunction "$uri/assets"   -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeChildren.IsPresent) { $policy | Add-Member -Name 'children' -Value @(Invoke-NexposeQuery -UrlFunction "$uri/children" -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeGroups.IsPresent)   { $policy | Add-Member -Name 'groups'   -Value @(Invoke-NexposeQuery -UrlFunction "$uri/groups"   -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeRules.IsPresent)    { $policy | Add-Member -Name 'rules'    -Value @(Invoke-NexposeQuery -UrlFunction "$uri/rules"    -RestMethod Get) -MemberType NoteProperty }
                Write-Output $policy
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'policies' -RestMethod Get)    # Return All
            }
        }

        'bySearch' {
            [hashtable]$apiQuery = @{ filter = $Search }
            $results = @(Invoke-NexposeQuery -UrlFunction 'policies' -ApiQuery $apiQuery -RestMethod Get)
            If (-not $IncludeDeprecated.IsPresent) {
                $results = $results | Where-Object { $_.title -notlike '*(deprecated)' }
            }
            Write-Output $results
        }

        'byAsset' {
            [hashtable]$apiQuery = @{ applicableOnly = $true }
            Write-Output @(Invoke-NexposeQuery -UrlFunction "assets/$AssetId/policies" -ApiQuery $apiQuery -RestMethod Get)
        }
    }
}
