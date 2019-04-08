Function Get-NexposeSiteCredential {
<#
    .SYNOPSIS
        Retrieves the specified site credential

    .DESCRIPTION
        Retrieves the specified site credential

    .PARAMETER Site
        The identifier of the site

    .PARAMETER Id
        The identifier of the credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Domain
        The address of the domain

    .PARAMETER Username
        The user name for the account that will be used for authenticating

    .PARAMETER IncludeShared
        Return all shared credentials for a site

    .PARAMETER IncludeWebAuthentication
        Return all web application credentials for a site

    .EXAMPLE
        Get-NexposeSiteCredential -Id 2

    .EXAMPLE
        Get-NexposeSiteCredential -Name 'Domain Admin'

    .EXAMPLE
        Get-NexposeSiteCredential -Site 'DR Site' -IncludeAll

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/site_credentials
        GET: sites/{id}/site_credentials/{credentialId}
        GET: sites/{id}/web_authentication/html_forms
        GET: sites/{id}/web_authentication/http_headers

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Site,

        [Parameter(ParameterSetName = 'byId')]
        [int]$Id = 0,

        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byDomain')]
        [string]$Domain,

        [Parameter(ParameterSetName = 'byUsername')]
        [string]$Username,

        [Parameter(ParameterSetName = 'byInclude')]
        [switch]$IncludeShared,

        [Parameter(ParameterSetName = 'byInclude')]
        [switch]$IncludeWebAuthentication
    )

    $Site = (ConvertTo-NexposeId -Name $Site -ObjectType 'Site')

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($Id -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Site/site_credentials/$Id" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction "sites/$Site/site_credentials"                -RestMethod Get)    # Return All
            }
        }

        'byName' {
            [int]$getId = (((Get-NexposePagedData -UrlFunction "sites/$Site/site_credentials" -RestMethod Get) | Where-Object { $_.name -eq $Name }).id)
            If ($getId -gt 0) {
                Get-NexposeSiteCredential -Site $Site -Id $getId
            }
        }

        'byInclude' {
            If ($IncludeShared.IsPresent) {
                # Call external function
                Write-Output (Get-NexposeSharedCredential -Site $Site -IncludeShared)
            }

            If ($IncludeWebAuthentication.IsPresent) {
                Write-Output @(Invoke-NexposeQuery  -UrlFunction "sites/$Site/web_authentication/html_forms"   -RestMethod Get)
                Write-Output @(Invoke-NexposeQuery  -UrlFunction "sites/$Site/web_authentication/http_headers" -RestMethod Get)
            }
        }

        Default {
            Switch ($PSCmdlet.ParameterSetName) {
                'byDomain'   { [string]$object = 'domain';   [string]$vari = $Domain   }
                'byUsername' { [string]$object = 'username'; [string]$vari = $Username }
            }

            Write-Output @((Get-NexposePagedData -UrlFunction "sites/$Site/site_credentials" -RestMethod Get) | Where-Object { $_.account.$object -eq $vari })
        }
    }
}
