Function Remove-NexposePolicyOverride {
<#
    .SYNOPSIS
        Deletes a policy override

    .DESCRIPTION
        Deletes a policy override

    .PARAMETER Id
        The identifier of the policy

    .EXAMPLE
        Remove-NexposePolicyOverride -Id 23

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: policy_overrides/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int[]]$Id
    )

    Begin {
    }

    Process {
        ForEach ($item In $Id) {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "policy_overrides/$item" -RestMethod Delete)
            }
        }
    }

    End {
    }
}
