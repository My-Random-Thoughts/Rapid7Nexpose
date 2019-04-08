Function Get-NexposePolicyGroup {
<#
    .SYNOPSIS
        Retrieves a list of policy groups

    .DESCRIPTION
        Retrieves a list of policy groups

    .PARAMETER PolicyId
        The identifier of the policy

    .PARAMETER GroupId
        The identifier of the group

    .PARAMETER IncludeChildren
        Retrieves policy groups that are defined directly underneath the specified policy group

    .PARAMETER IncludeRules
        Retrieves policy rules that are defined directly underneath the specified policy group

    .EXAMPLE
        Get-NexposePolicyGroup -PolicyId 123

    .EXAMPLE
        Get-NexposePolicyGroup -PolicyId 123 -GroupId 23 -IncludeChildren

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: policies/{policyId}/groups
        GET: policies/{policyId}/groups/{groupId}
        GET: policies/{policyId}/groups/{groupId}/children
        GET: policies/{policyId}/groups/{groupId}/rules

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$PolicyId,

        [Parameter(ParameterSetName = 'byId')]
        [int]$GroupId = 0,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeChildren,

        [Parameter(ParameterSetName = 'byId')]
        [switch]$IncludeRules

#        [Parameter(ParameterSetName = 'byStatus')]
#        [ValidateSet('Pass','Fail','Not_Applicable')]
#        [string]$Status
    )

    If (($IncludeChildren.IsPresent -or $IncludeRules.IsPresent) -and ($GroupId -eq 0)) {
        Throw 'A group id must be entered'
    }

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($GroupId -gt 0) {
                [string]$uri = "policies/$PolicyId/groups/$GroupId"
                $group = (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Get)
                If ($IncludeChildren.IsPresent) { $group | Add-Member -Name 'children' -Value @(Get-NexposePagedData -UrlFunction "$uri/children" -RestMethod Get) -MemberType NoteProperty }
                If ($IncludeRules.IsPresent)    { $group | Add-Member -Name 'rules'    -Value @(Get-NexposePagedData -UrlFunction "$uri/rules"    -RestMethod Get) -MemberType NoteProperty }
                Write-Output $group
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction "policies/$PolicyId/groups" -RestMethod Get)    # Return All
            }
        }

        'byStatus' {
            # TODO:
        }
    }
}
