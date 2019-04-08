Function Get-NexposeAssetPolicyRuleProof {
<#
    .SYNOPSIS
        Retrieves the policy rule proof captured during evaluation against the specified asset

    .DESCRIPTION
        Retrieves the policy rule proof captured during evaluation against the specified asset

    .PARAMETER PolicyId
        The identifier of the policy

    .PARAMETER RuleId
        The identifier of the group

    .PARAMETER AssetId
        The identifier of the asset

    .EXAMPLE
        Get-NexposeAssetPolicyRuleProof -PolicyId 123 -GroupId -12 -AssetId 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: policies/{policyId}/rules/{ruleId}/assets/{assetId}/proof

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$PolicyId,

        [Parameter(Mandatory = $true)]
        [int]$RuleId,

        [Parameter(Mandatory = $true)]
        [int]$AssetId
    )

    Write-Output @(Get-NexposePagedData -UrlFunction "policies/$PolicyId/rules/$RuleId/assets/$AssetId/proof" -RestMethod Get)
}
