Function Update-NexposeTag {
<#
    .SYNOPSIS
        Updates the details of a tag

    .DESCRIPTION
        Updates the details of a tag

    .PARAMETER Id
        The identifier of the tag

    .PARAMETER Name
        The name (label) of the tab

    .PARAMETER Type
        The type of the tag

    .PARAMETER Colour
        The colour to use when rendering the tag in a user interface (used for Custom types only)

    .EXAMPLE
        Update-NexposeTag -Id 23 -Name 'NewTag_1' -Type 'Custom' -Colour 'Red'

    .EXAMPLE
        Update-NexposeTag -Id 2 -Name 'New_DR_Site' -Type 'Location'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        PUT: tags/{id}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Id,

        [string]$Name,

        [ValidateSet('Custom', 'Location', 'Owners')]
        [string]$Type,

        [ValidateSet('Default', 'Blue', 'Green', 'Orange', 'Red', 'Purple')]
        [string]$Colour
    )

    Begin {
        # Get current values
        $tag = (Get-NexposeTag -Id $Id)

        If ([string]::IsNullOrEmpty($Name)   -eq $true) { $Name   = $tag.name  }
        If ([string]::IsNullOrEmpty($Type)   -eq $true) { $Type   = $tag.type  }
        If ([string]::IsNullOrEmpty($Colour) -eq $true) { $Colour = $tag.color }
    }

    Process {
        $apiQuery = @{
            name  = $Name
            type  = $Type.ToLower()
            color = $Colour.ToLower()
        }

        If ($PSCmdlet.ShouldProcess($Id)) {
            Write-Output (Invoke-NexposeQuery -UrlFunction "tags/$Id" -ApiQuery $apiQuery -RestMethod Put)
        }
    }

    End {
    }
}
