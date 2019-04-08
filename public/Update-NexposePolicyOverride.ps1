Function Update-NexposePolicyOverride {
<#
    .SYNOPSIS
        Update the status of a policy override

    .DESCRIPTION
        Update the status of a policy override

    .PARAMETER Id
        The identifier of the policy

    .PARAMETER State
        Exception Status.  Valid values: "recall" "approve" "reject"

    .PARAMETER Comment
        Reviewers comments for this state change

    .PARAMETER NewExpiryDate
        Specify the new expiry date for the override

    .EXAMPLE
        Update-NexposePolicyOverride -Id 24 -State approve -Comment 'All OK'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: policy_overrides/{id}
        PUT: policy_overrides/{id}/expires
        POST: policy_overrides/{id}/{status}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId', SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [Parameter(Mandatory = $true, ParameterSetName = 'byState')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byState')]
        [ValidateSet('recall','approve','reject')]
        [string]$State,

        [Parameter(ParameterSetName = 'byState' )]
        [string]$Comment = "State changed by $($env:UserName)",

        [ValidateScript({ $_ -gt (Get-Date) })]
        [datetime]$NewExpiryDate
    )

    If ($PSCmdlet.ShouldProcess($Id)) {
        # Get current state of exception, ensure it's in a "Under Review" state.
        $CurrentState = (Invoke-NexposeQuery -UrlFunction "policy_overrides/$Id" -RestMethod Get)

        If ([string]::IsNullOrEmpty($State) -eq $false) {
            If (($CurrentState.State) -eq 'under-review') {
                Write-Output (Invoke-NexposeQuery -UrlFunction "policy_overrides/$Id/$State" -ApiQuery "$Comment" -RestMethod Post)
            }
        }

        If ([string]::IsNullOrEmpty($NewExpiryDate) -eq $false) {
            [string]$apiQuery = "$($NewExpiryDate.ToString('yyyy-MM-dd'))T23:59:59.999Z"
            Write-Output (Invoke-NexposeQuery -UrlFunction "policy_overrides/$Id/expires" -ApiQuery $apiQuery -RestMethod Put)
        }
    }
}
