Function Get-NexposeReport {
<#
    .SYNOPSIS
        Retrieves a list of reports

    .DESCRIPTION
        Retrieves a list of reports

    .PARAMETER Id
        The identifier of the report

    .PARAMETER Name
        The name of the report

    .PARAMETER Policy
        The policy being used in the report

    .PARAMETER Scope
        The scope of the report

    .PARAMETER ScopeType
        The scope type to search for

    .EXAMPLE
        Get-NexposeReport -id 13

    .EXAMPLE
        Get-NexposeReport -Scope 'DR Site' -ScopeType 'sites'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: reports
        GET: reports/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byPolicy')]
        [string]$Policy,

        [Parameter(ParameterSetName = 'byScope')]
        [string]$Scope,

        [Parameter(ParameterSetName = 'byScope')]
        [ValidateSet('Assets', 'AssetGroups', 'Sites', 'Tags')]
        [string]$ScopeType
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "reports/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction 'reports' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            $Name = (ConvertTo-NexposeId -Name $Name -ObjectType Report)
            Get-NexposeReport -Id $Name
        }

        'byPolicy' {
            $Policy = (ConvertTo-NexposeId -Name $Policy -ObjectType 'Policy')
            Write-Output @((Get-NexposePagedData -UrlFunction 'reports' -RestMethod Get) | Where-Object { $Policy -in $_.Policies})
        }

        'byScope' {
            Switch ($ScopeType) {
                'Assets'      { $scope = ((ConvertTo-NexposeId -Name $scope -ObjectType 'Asset'     ).id) }
                'AssetGroups' { $scope = ((ConvertTo-NexposeId -Name $scope -ObjectType 'AssetGroup').id) }
                'Sites'       { $scope = ((ConvertTo-NexposeId -Name $scope -ObjectType 'Site'      ).id) }
                'Tags'        { $scope = ((ConvertTo-NexposeId -Name $scope -ObjectType 'Tag'       ).id) }
            }

            Write-Output @((Get-NexposePagedData -UrlFunction 'reports' -RestMethod Get) | Where-Object { $Scope -in ($_.Scope.$ScopeType) })
        }
    }
}
