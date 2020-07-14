Function Get-NexposePolicyRule {
<#
    .SYNOPSIS
        Retrieves a list of policy rules

    .DESCRIPTION
        Retrieves a list of policy rules

    .PARAMETER PolicyId
        The identifier of the policy

    .PARAMETER RuleId
        The identifier of the rule

    .PARAMETER IncludeAssets
        Retrieves the policy rule assets for the specified policy

    .PARAMETER IncludeControls
        Retrieves all NIST SP 800-53 controls mappings for each CCE within the specified policy rule

    .PARAMETER IncludeRationale
        Retrieves the policy rule rationale for the specified policy

    .PARAMETER IncludeRemediation
        Retrieves the policy rule remediation for the specified policy

    .PARAMETER ShowDisabledRules
        Retrieves disabled policy rules for the specified policy

    .EXAMPLE
        Get-NexposePolicyRule -PolicyId 123

    .EXAMPLE
        Get-NexposePolicyRule -PolicyId 123 -RuleId 23 -IncludeControls -IncludeRemediation

    .EXAMPLE
        Get-NexposePolicyRule -PolicyId 123 -ShowDisabledRules

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: policies/{policyId}/rules
        GET: policies/{policyId}/rules/disabled
        GET: policies/{policyId}/rules/{ruleId}
        GET: policies/{policyId}/rules/{ruleId}/assets
        GET: policies/{policyId}/rules/{ruleId}/controls
        GET: policies/{policyId}/rules/{ruleId}/rationale
        GET: policies/{policyId}/rules/{ruleId}/remediation
        GET: SKIPPED - policies/{policyId}/rules/{ruleId}/assets/{assetId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'byDisabled')]
        [int]$PolicyId,

        [Parameter(ParameterSetName = 'byId')]
        [int]$RuleId = 0,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeAssets,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeControls,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeRationale,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeRemediation,

        [Parameter(ParameterSetName = 'byDisabled')]
        [switch]$ShowDisabledRules
    )

    If (($IncludeControls.IsPresent -or $IncludeRationale.IsPresent -or $IncludeRemediation.IsPresent) -and ($RuleId -eq 0)) {
        Throw 'A rule id must be entered'
    }

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($RuleId -gt 0) {
                [string]$uri = "policies/$PolicyId/rules/$RuleId"
                $rule = (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Get)
                If ($IncludeAssets.IsPresent)      { $rule | Add-Member -Name 'assets'      -Value @(Invoke-NexposeQuery -UrlFunction "$uri/assets"      -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeControls.IsPresent)    { $rule | Add-Member -Name 'controls'    -Value @(Invoke-NexposeQuery -UrlFunction "$uri/controls"    -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeRationale.IsPresent)   { $rule | Add-Member -Name 'rationale'   -Value @(Invoke-NexposeQuery -UrlFunction "$uri/rationale"   -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeRemediation.IsPresent) { $rule | Add-Member -Name 'remediation' -Value @(Invoke-NexposeQuery -UrlFunction "$uri/remediation" -RestMethod Get) -MemberType NoteProperty }
                Write-Output $rule
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction "policies/$PolicyId/rules" -RestMethod Get)    # Return All
            }
        }

        'byDisabled' {
            If ($ShowDisabledRules) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "policies/$PolicyId/rules/disabled" -RestMethod Get)
            }
        }
    }
}
