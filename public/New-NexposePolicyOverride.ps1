Function New-NexposePolicyOverride {
<#
    .SYNOPSIS
        Creates a policy override.

    .DESCRIPTION
        Creates a policy override.

    .PARAMETER Type
        The scope of assets affected by the policy override. Can be one of the following values: "all-assets" "specific-asset" "specific-asset-until-next-scan"

    .PARAMETER AssetId
        The identifier of the asset whose compliance results are to be overridden.
        Property is required if the property scope is set to either "specific-asset" or "specific-asset-until-next-scan"

    .PARAMETER PolicyResult
        The new policy rule result after the override is applied.  Valid values: "pass" "fail" "not-applicable" "fixed"

    .PARAMETER Rule
        The identifier of the policy rule whose compliance results are to be overridden

    .PARAMETER ExpiryDate
        The date and time the policy override is set to expire.

    .PARAMETER Comment
        A comment from the submitter as to why the override was submitted.  This parameter has a maximum length of 1024 characters.

    .EXAMPLE
        New-NexposePolicyOverride

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: policy_overrides

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('all-assets','specific-asset','specific-asset-until-next-scan')]
        [string]$Type,

        [int]$AssetId,

        [Parameter(Mandatory = $true)]
        [ValidateSet('pass','fail','not-applicable','fixed')]
        [string]$PolicyResult,

        [Parameter(Mandatory = $true)]
        [int]$Rule,

        [datetime]$ExpiryDate,

        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 1024)]
        [string]$Comment
    )

    Begin {
        If (($Type -ne 'all-assets') -and ($AssetId -lt 1)) {
            Throw "Invalid or missing 'AssetId' value"
        }

        If ($Type -ne 'all-assets') {
            If ((Test-NexposePolicyRule -RuleId $Rule -AssetId $AssetId) -ne $true) {
                Throw 'Policy rule is not associated with this asset'
            }
        }
    }

    Process {
        $apiQuery = @{
            state = 'under-review'
            submit = @{
                comment = $Comment
            }
            scope = @{
                type = $Type
                rule = $Rule
                newResult = $PolicyResult
            }
        }

        If (($AssetId) -and ($Type -ne 'all-assets')) {
            $apiQuery.scope += @{
                asset = $AssetId
            }
        }

        If ($ExpiryDate) {
            $apiQuery += @{
                expires = $ExpiryDate
            }
        }

        If ($PSCmdlet.ShouldProcess($VulnerabilityId, 'Create new policy override')) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'policy_overrides' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
