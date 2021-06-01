Function New-NexposeTag {
<#
    .SYNOPSIS
        Creates a new tag

    .DESCRIPTION
        Creates a new tag, and give it a colour if the type is 'Custom'

    .PARAMETER Name
        The name (label) of the tab

    .PARAMETER Type
        The type of the tag

    .PARAMETER Colour
        The color to use when rendering the tag in a user interface (used for Custom types only)

    .PARAMETER SearchCriteria
        Search criteria used to determine dynamic membership, if type is "dynamic"
        Example of a SearchCriteria: @{ match = 'all'; filters = @(@{ field = 'ip-address'; operator = 'in-range'; lower = '1.1.1.1'; upper = '1.255.255.255' })}

    .EXAMPLE
        New-NexposeTag -Name 'NewTag_1' -Type 'Custom' -Colour 'Red'

    .EXAMPLE
        New-NexposeTag -Name 'DR_Site' -Type 'Location'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: tags

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [string[]]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Custom', 'Location', 'Owner')]
        [string]$Type,

        [ValidateSet('Default', 'Blue', 'Green', 'Orange', 'Red', 'Purple')]
        [string]$Colour = 'Default',

        [hashtable]$SearchCriteria
    )

    Begin {
        # Validate Search Criteria
        If ([string]::IsNullOrEmpty($SearchCriteria) -eq $false) {
            [string]$result = (Test-NexposeSearchCriteria -SearchCriteria $SearchCriteria)
            If ($result -ne 'Success') { Throw $result }
        }

        If ($Type -ne 'Custom') {
            $Colour = 'Default'
        }
    }

    Process {
        $apiQuery = @{
            type  = $Type.ToLower()
            color = $Colour.ToLower()
            searchCriteria = $SearchCriteria
        }

        ForEach ($tag In $Name) {
            $apiQuery.name = $tag
            If ($PSCmdlet.ShouldProcess($tag)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction 'tags' -ApiQuery $apiQuery -RestMethod Post)
            }
        }
    }

    End {
    }
}
