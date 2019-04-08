Function Get-NexposePolicyOverride {
<#
    .SYNOPSIS
        Returns the specified policy override

    .DESCRIPTION
        Returns the specified policy override

    .PARAMETER Id
        The identifier if the override

    .PARAMETER AssetId
        The identifier if the asset

    .PARAMETER SubmittedBy
        Filter all overrides by the submitted user

    .PARAMETER ReviewedBy
        Filter all overrides by the reviewing user

    .PARAMETER State
        Filter all overrides by the approval state

    .EXAMPLE
        Get-NexposePolicyOverride -Id 42

    .EXAMPLE
        Get-NexposePolicyOverride -SubmittedBy 'JoeB' -State 'approved'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: assets/{id}/policy_overrides
        GET: policy_overrides
        GET: policy_overrides/{id}
        GET: SKIPPED - policy_overrides/{id}/expires    # Given as part of the returned data

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byAsset')]
        [int]$AssetId,

        [Parameter(ParameterSetName = 'byOther')]
        [string]$SubmittedBy,

        [Parameter(ParameterSetName = 'byOther')]
        [string]$ReviewedBy,

        [Parameter(ParameterSetName = 'byOther')]
        [ValidateSet('deleted','expired','approved','rejected','under-review')]
        [string]$State
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "policy_overrides/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction 'policy_overrides' -RestMethod Get)    # Return All
            }
        }

        'byAsset' {
            Write-Output (Invoke-NexposeQuery -UrlFunction "asset/$Id/policy_overrides" -RestMethod Get)
        }

        'byOther' {
            $polOvr = @(Get-NexposePagedData -UrlFunction 'policy_overrides' -RestMethod Get)

            If ([string]::IsNullOrEmpty($SubmittedBy) -eq $false) {
                [int]$UserSId = (ConvertTo-NexposeId -Name $SubmittedBy -ObjectType User)
                $polOvr = ($polOvr | Where-Object { $_.submit.user -eq $UserSId })
            }

            If ([string]::IsNullOrEmpty($ReviewedBy) -eq $false) {
                [int]$UserRId = (ConvertTo-NexposeId -Name $ReviewedBy -ObjectType User)
                $polOvr = ($polOvr | Where-Object { $_.review.user -eq $UserRId })
            }

            If ([string]::IsNullOrEmpty($State) -eq $false) {
                $polOvr = ($polOvr | Where-Object { $_.state -eq $State })
            }

            Write-Output $polOvr
        }
    }
}
