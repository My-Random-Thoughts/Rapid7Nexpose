Function Update-NexposeSite {
<#
    .SYNOPSIS
        Updates the configuration of the site with the specified identifier

    .DESCRIPTION
        Updates the configuration of the site with the specified identifier

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The site name. Name must be unique

    .PARAMETER Description
        The site's description

    .PARAMETER Importance
        The site importance. Defaults to "normal" if not specified.

    .PARAMETER ScanTemplateId
        The identifier of a scan template. Default scan template "discovery" is selected when not specified.

    .PARAMETER EngineId
        The identifier of a scan engine. Default scan engine is selected when not specified.

    .EXAMPLE
        Update-NexposeSite -Id 1 -Name 'Site 1A' -Description 'DR Site' -ScanTemplateId 'discovery'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: sites/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [string]$Name,

        [string]$Description,

        [ValidateSet('very_high', 'high', 'normal', 'low', 'very_low')]
        [string]$Importance,

        [string]$ScanTemplateId,

        [int]$EngineId = 0
    )

    Begin {
        # Get current values
        $site = (Get-NexposeSite -Id $Id)

        If ([string]::IsNullOrEmpty($Name)           -eq $true) { $Name           = $site.name         }
        If ([string]::IsNullOrEmpty($Description)    -eq $true) { $Description    = $site.description  }
        If ([string]::IsNullOrEmpty($Importance)     -eq $true) { $Importance     = $site.importance   }
        If ([string]::IsNullOrEmpty($ScanTemplateId) -eq $true) { $ScanTemplateId = $site.scanTemplate }
        If (                        $EngineId        -eq 0    ) { $EngineId       = $site.scanEngine   }
    }

    Process {
        $apiQuery = @{
            name           = $Name
            description    = $Description
            importance     = $Importance
            engineId       = $EngineId
            scanTemplateId = $ScanTemplateId
        }

        If ($PSCmdlet.ShouldProcess($Name)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
