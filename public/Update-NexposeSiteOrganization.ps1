Function Update-NexposeSiteOrganization {
<#
    .SYNOPSIS
        Updates the site organization information

    .DESCRIPTION
        Updates the site organization information

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER OrganizationName
        The organization name

    .PARAMETER Url
        The organization URL

    .PARAMETER PrimaryContact
        The contact person name

    .PARAMETER JobTitle
        The job title

    .PARAMETER Email
        The e-mail address

    .PARAMETER Telephone
        The phone number

    .PARAMETER BusinessAddress
        The address

    .PARAMETER City
        The city

    .PARAMETER Country
        The country

    .PARAMETER StateProvince
        The state or province

    .PARAMETER Zip
        The zip or region code

    .PARAMETER ClearExistingEntries
        Remove all values except for the ones specified

    .EXAMPLE
        Update-NexposeSiteOrganization -Id 23 -OrganizationName 'ACME Inc.' -PrimaryContact 'Wile E. Coyote'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}/organization

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [string]$OrganizationName,

        [string]$Url,

        [string]$PrimaryContact,

        [string]$JobTitle,

        [string]$Email,

        [string]$Telephone,

        [string]$BusinessAddress,

        [string]$City,

        [ValidateSet('Albania','Algeria','Argentina','Australia','Austria','Bahrain','Belarus','Belgium','Bolivia','Bosnia and Herzegovina', `
                     'Brazil','Bulgaria','Canada','Chile','China','Colombia','Costa Rica','Croatia','Cuba','Cyprus','Czech Republic','Denmark', `
                     'Dominican Republic','Ecuador','Egypt','El Salvador','Estonia','Finland','France','Germany','Greece','Guatemala','Honduras', `
                     'Hong Kong','Hungary','Iceland','India','Indonesia','Iraq','Ireland','Israel','Italy','Japan','Jordan','Kuwait','Latvia', `
                     'Lebanon','Libya','Lithuania','Luxembourg','Macedonia','Malaysia','Malta','Mexico','Montenegro','Morocco','Netherlands', `
                     'New Zealand','Nicaragua','Norway','Oman','Panama','Paraguay','Peru','Philippines','Poland','Portugal','Puerto Rico', `
                     'Qatar','Romania','Russia','Saudi Arabia','Serbia','Serbia and Montenegro','Singapore','Slovakia','Slovenia','South Africa', `
                     'South Korea','Spain','Sudan','Sweden','Switzerland','Syria','Taiwan','Thailand','Tunisia','Turkey','Ukraine','United Arab Emirates', `
                     'United Kingdom','United States','Uruguay','Venezuela','Vietnam','Yemen')]
        [string]$Country,

        [string]$StateProvince,

        [string]$Zip,

        [switch]$ClearExistingEntries
    )

    Begin {
        # Validate Email address
        If ([string]::IsNullOrEmpty($Email) -eq $false) {
            If (($Email -as [System.Net.Mail.MailAddress]).Address -ne $Email) { Throw 'Invalid email address given' }
        }

        # Get current values
        If (-not $ClearExistingEntries.IsPresent) {
            $site = (Get-NexposeSiteOrganization -Id $Id)
            If ([string]::IsNullOrEmpty($BusinessAddress)  -eq $true) { $BusinessAddress  = $site.address  }
            If ([string]::IsNullOrEmpty($City)             -eq $true) { $City             = $site.city     }
            If ([string]::IsNullOrEmpty($PrimaryContact)   -eq $true) { $PrimaryContact   = $site.contact  }
            If ([string]::IsNullOrEmpty($Country)          -eq $true) { $Country          = $site.country  }
            If ([string]::IsNullOrEmpty($Email)            -eq $true) { $Email            = $site.email    }
            If ([string]::IsNullOrEmpty($JobTitle)         -eq $true) { $JobTitle         = $site.jobTitle }
            If ([string]::IsNullOrEmpty($OrganizationName) -eq $true) { $OrganizationName = $site.name     }
            If ([string]::IsNullOrEmpty($Telephone)        -eq $true) { $Telephone        = $site.phone    }
            If ([string]::IsNullOrEmpty($StateProvince)    -eq $true) { $StateProvince    = $site.state    }
            If ([string]::IsNullOrEmpty($Url)              -eq $true) { $Url              = $site.url      }
            If ([string]::IsNullOrEmpty($Zip)              -eq $true) { $Zip              = $site.zipCode  }
        }
    }

    Process {
        Switch ($PSCmdlet.ParameterSetName) {
            'byName' {
                [int]$id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
                Write-Output (Update-NexposeSiteOrganization -Id $id -OrganizationName $OrganizationName -Url $Url -PrimaryContact $PrimaryContact `
                                                             -JobTitle $JobTitle -Email $Email -Telephone $Telephone -BusinessAddress $BusinessAddress `
                                                             -City $City -Country $Country -StateProvince $StateProvince -Zip $Zip -ClearExistingEntries:$ClearExistingEntries)
            }

            'byId' {
                If ($ClearExistingEntries.IsPresent) {
                    $apiQuery = @{
                        address  = $null
                        city     = $null
                        contact  = $null
                        country  = $null
                        email    = $null
                        jobTitle = $null
                        name     = $null
                        phone    = $null
                        state    = $null
                        url      = $null
                        zipCode  = $null
                    }

                    If ($PSCmdlet.ShouldProcess($Id)) {
                        Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/organization" -ApiQuery $apiQuery -RestMethod Put)
                    }
                }

                $apiQuery = @{}
                If ([string]::IsNullOrEmpty($BusinessAddress)  -eq $false) { $apiQuery += @{ address  = $BusinessAddress  }}
                If ([string]::IsNullOrEmpty($City)             -eq $false) { $apiQuery += @{ city     = $City             }}
                If ([string]::IsNullOrEmpty($PrimaryContact)   -eq $false) { $apiQuery += @{ contact  = $PrimaryContact   }}
                If ([string]::IsNullOrEmpty($Country)          -eq $false) { $apiQuery += @{ country  = $Country          }}
                If ([string]::IsNullOrEmpty($Email)            -eq $false) { $apiQuery += @{ email    = $Email            }}
                If ([string]::IsNullOrEmpty($JobTitle)         -eq $false) { $apiQuery += @{ jobTitle = $JobTitle         }}
                If ([string]::IsNullOrEmpty($OrganizationName) -eq $false) { $apiQuery += @{ name     = $OrganizationName }}
                If ([string]::IsNullOrEmpty($Telephone)        -eq $false) { $apiQuery += @{ phone    = $Telephone        }}
                If ([string]::IsNullOrEmpty($StateProvince)    -eq $false) { $apiQuery += @{ state    = $StateProvince    }}
                If ([string]::IsNullOrEmpty($Url)              -eq $false) { $apiQuery += @{ url      = $Url              }}
                If ([string]::IsNullOrEmpty($Zip)              -eq $false) { $apiQuery += @{ zipCode  = $Zip              }}

                If ($PSCmdlet.ShouldProcess($Id)) {
                    Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/organization" -ApiQuery $apiQuery -RestMethod Put)
                }
            }
        }
    }

    End {
    }
}
