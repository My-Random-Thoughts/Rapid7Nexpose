Function Update-NexposeRole {
<#
    .SYNOPSIS
        Creates or updates a role.

    .DESCRIPTION
        Creates or updates a role.

    .PARAMETER Name
        The human readable name of the role

    .PARAMETER Description
       The description of the role

    .PARAMETER Privilege
        The privileges granted to the role

    .EXAMPLE
        Update-NexposeRole -Name 'Custom Role 1' -Description 'New Admin Role' -Privilege @('all-permissions')

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: roles/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    DynamicParam {
        $dynParam = (New-Object -Type 'System.Management.Automation.RuntimeDefinedParameterDictionary')
        New-DynamicParameter -Dictionary $dynParam -Name 'Privilege' -Type 'string[]' -ValidateSet (Get-NexposePrivilege) -Mandatory
        Return $dynParam
    }

    Begin {
        # Define variables for dynamic parameters
        [string[]]$Privilege = $($PSBoundParameters.Privilege)
    }

    Process {
        $apiQuery = @{
            name        = $Name
            description = $Description
            privileges  = @($Privilege)
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "roles/$Name" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
