Function Invoke-NexposeAssetSearch {
<#
    .SYNOPSIS
        Starts a custom asset search

    .DESCRIPTION
        Starts a custom asset search

    .PARAMETER SearchQuery
        The custom query to use for searching the assets

    .EXAMPLE
        Invoke-NexposeAssetSearch -SearchQuery @{filters=@(@{field='criticality-tag'; operator='is-applied';}); match='all'}

    .EXAMPLE
        Invoke-NexposeAssetSearch -SearchQuery @{filters=@(@{field='last-scan-date'; operator='is-on-or-before'; value='2018-08-25'}); match='all'}

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
