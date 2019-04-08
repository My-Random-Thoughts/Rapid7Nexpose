Function Get-NexposePagedData {
<#
    .SYNOPSIS
        Gets more data if it's available

    .DESCRIPTION
        Helps to avoid code duplication in functions when calling the Nexpose API

    .PARAMETER UrlFunction
        The Rest API URL to use, excluding the hostname and port

    .PARAMETER ApiQuery
        The API query parameters

    .PARAMETER RestMethod
        One of "Default, Delete, Get, Head, Merge, Options, Patch, Post, Put, Trace"

    .PARAMETER IncludeLinks
        By default all hyperlinks are removed from the resutls

    .EXAMPLE
        Get-NexposePagedData -UrlFunction 'sites/5/assets' -RestMethod Get

    .EXAMPLE
        Get-NexposePagedData -UrlFunction 'sites/3/scans' -ApiQuery $apiQuery -RestMethod Post

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$UrlFunction,

        [object]$ApiQuery,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$RestMethod,

        [switch]$IncludeLinks
    )

    If ([string]::IsNullOrEmpty($ApiQuery) -eq $true) { $ApiQuery = @{} }
    If ($ApiQuery.ContainsKey('page') -eq $false) { $ApiQuery.Add('page',   0) }

    [object]$data = (Invoke-NexposeQuery -UrlFunction $UrlFunction -ApiQuery $apiQuery -RestMethod $RestMethod)
    If ([string]::IsNullOrEmpty($data)) { Return }

    [boolean]$script:moreData = $false
    $data | Get-Member -MemberType *Property | `
        ForEach-Object -Process {
            If (($_.Name) -eq 'resources') { $script:moreData = $true }
        }

    If ($script:moreData -eq $false)  { Return $data }    # Return the single instance
    If ($data.resources.length -eq 0) { Return       }    # No data to return

    If ((Get-Variable -Name 'NexposeShowLinks' -ValueOnly -ErrorAction SilentlyContinue) -eq $true) { $IncludeLinks = $true }
    If (-not $IncludeLinks.IsPresent) { $resData = (Remove-NexposeLink -InputObject ($data.resources)) }
    Write-Output $resData

    If ($data.page.totalPages -gt 1) {
        Write-Verbose "There are $($data.page.totalResources) objects, over $($data.page.totalPages) pages."
        [int]$totalLength = $($data.page.totalPages).ToString().Trim().Length

        1..$($data.page.totalPages) | ForEach-Object -Process {
            Write-Verbose "Retreving page $($_.ToString().PadLeft($totalLength)) of $($data.page.totalPages) ..."

            $apiQuery.page = $_
            $data = (Invoke-NexposeQuery -UrlFunction $UrlFunction -ApiQuery $apiQuery -RestMethod $RestMethod)

            If ($($data.resources.Count) -gt 0) {
                If (-not $IncludeLinks.IsPresent) { $data.resources = (Remove-NexposeLink -InputObject ($data.resources)) }
            }

            Write-Output ($data.resources)
        }
    }
}
