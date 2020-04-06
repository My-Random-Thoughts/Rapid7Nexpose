Function Test-NexposePolicyRule {
<#
    .SYNOPSIS
        Test to see if a policy rule is applied to a specific asset

    .DESCRIPTION
        Test to see if a policy rule is applied to a specific asset

    .PARAMETER AssetId
        The identifier of the asset

    .PARAMETER RuleId
        The identifier of the policy rule

    .EXAMPLE
        Test-NexposePolicyRule

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        GET: assets/{assetId}/policies
        GET: policies/{policyId}/rules/{ruleId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    [OutputType([boolean])]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$RuleId,

        [Parameter(Mandatory = $true)]
        [int]$AssetId
    )

    Begin {
        # Check Asset exists, and is assessed with a policy
        [object]$asset = (Get-NexposeAsset -Id $AssetId -ErrorAction SilentlyContinue)
        If (-not $asset) { Throw 'Asset does not exist' }
        If (-not $asset.assessedForPolicies) { Throw 'Asset is not assessed by any policies' }
    }

    Process {
        [int[]]$policies = ((Invoke-NexposeQuery -UrlFunction "assets/$AssetId/policies" -RestMethod Get).surrogateId)
        If (-not $policies) { Return $false }

        ForEach ($item In $policies) {
            $rule = (Invoke-NexposeQuery -UrlFunction "policies/$item/rules/$RuleId" -RestMethod Get -ErrorAction SilentlyContinue)
            If ($rule) { Return $true }
        }

        Return $false
    }

    End {
    }
}
