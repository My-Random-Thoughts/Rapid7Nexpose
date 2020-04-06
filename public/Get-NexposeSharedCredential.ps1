Function Get-NexposeSharedCredential {
<#
    .SYNOPSIS
        Retrieves the specified shared credential

    .DESCRIPTION
        Retrieves the specified shared credential

    .PARAMETER Id
        The identifier of the credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Domain
        The address of the domain

    .PARAMETER Username
        The user name for the account that will be used for authenticating

    .PARAMETER Site
        The identifier of the site

    .PARAMETER IncludeShared
        Return all shared credentials for a site

    .EXAMPLE
        Get-NexposeSharedCredential -Id 2

    .EXAMPLE
        Get-NexposeSharedCredential -Name 'Domain Admin'

    .EXAMPLE
        Get-NexposeSharedCredential Site 'DR Site' -IncludeAll

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        GET: shared_credentials
        GET: shared_credentials/{id}
        GET: SKIPPED - sites/{id}/shared_credentials    # Sites parameter covers this

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byDomain')]
        [string]$Domain,

        [Parameter(ParameterSetName = 'byUsername')]
        [string]$Username,

        [Parameter(ParameterSetName = 'bySite')]
        [string]$Site,

        [Parameter(ParameterSetName = 'bySite')]
        [switch]$IncludeShared
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "shared_credentials/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get)    # Return All
            }
        }

        'byName' {
            [int]$getId = (((Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get) | Where-Object { $_.name -eq $Name }).id)
            If ($getId -gt 0) {
                Get-NexposeSharedCredential -Id $getId
            }
        }

        'bySite' {
            If ($IncludeShared.IsPresent) {
                Write-Output @(Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get)
            }
            Else {
                # Call external function
                Write-Output (Get-NexposeSiteCredential -Site $Site)
            }
        }

        Default {
            Switch ($PSCmdlet.ParameterSetName) {
                'byDomain'   { [string]$object = 'domain';   [string]$vari = $Domain   }
                'byUsername' { [string]$object = 'username'; [string]$vari = $Username }
            }

            Write-Output @((Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get) | Where-Object { $_.account.$object -eq $vari })
        }
    }
}
