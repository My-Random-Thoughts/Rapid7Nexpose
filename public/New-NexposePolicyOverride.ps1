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

    .PARAMETER NewResult
        The new policy rule result after the override is applied.  Valid values: "pass" "fail" "not-applicable" "fixed"

    .PARAMETER Rule
        The identifier of the policy rule whose compliance results are to be overridden

    .PARAMETER ExpiryDate
        The date and time the policy override is set to expire.

    .PARAMETER Comment
        A comment from the submitter as to why the override was submitted.

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
        [string]$NewResult,

        [Parameter(Mandatory = $true)]
        [int]$Rule,

        [datetime]$ExpiryDate,

        [Parameter(Mandatory = $true)]
        [string]$Comment
    )

    Begin {
        [string]$State = 'under-review'
        If (($Type -ne 'all-assets') -and ($AppliesToId -lt 1)) { Throw 'Invalid or missing "AssetId" value' }
    }

    Process {
        $apiQuery = @{
            state = $State
            submit = @{
                comment = $Comment
            }
            scope = @{
                type = $Type
                rule = $Rule
                asset = $AssetId
                newResult = $NewResult
            }
        }

        If ($ExpiryDate) {
            $apiQuery += @{
                expires = $ExpiryDate
            }
        }

        If ($PSCmdlet.ShouldProcess($VulnerabilityId)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'policy_overrides' -ApiQuery $apiQuery -RestMethod Post)
        }
    }

    End {
    }
}
