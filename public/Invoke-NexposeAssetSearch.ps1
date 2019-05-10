Function Invoke-NexposeAssetSearch {
<#
    .SYNOPSIS
        x

    .DESCRIPTION
        x

    .PARAMETER SearchQuery
        x

    .EXAMPLE
        Invoke-NexposeAssetSearch -SearchQuery ''

    .EXAMPLE
        Invoke-NexposeAssetSearch -SearchQuery ''

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: assets/search

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true)]
        [hashtable]$SearchQuery
    )

    Begin {
        # Validate the query is correctly formed
        $testResult = (Test-NexposeSearchCriteria -SearchCriteria $SearchQuery)
        If ($testResult -ne 'Success') {
            Throw $testResult
        }
    }

    Process {
        If ($PSCmdlet.ShouldProcess()) {
            Write-Output (Invoke-NexposeQuery -UrlFunction 'assets/search' -ApiQuery $SearchQuery -RestMethod Post)
        }
    }

    End {
    }
}
