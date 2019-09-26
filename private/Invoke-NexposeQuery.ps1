Function Invoke-NexposeQuery {
<#
    .SYNOPSIS
        Invokes the RestAPI for Nexpose

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
        Invoke-NexposeQuery -UrlFunction 'sites/5/assets' -RestMethod Get

    .EXAMPLE
        Invoke-NexposeQuery -UrlFunction 'sites/3/scans' -ApiQuery $apiQuery -RestMethod Post

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

    Begin {
        If ((Test-Path -Path variable:global:NexposeSession) -eq $false) {
            Throw "A valid session token has not been created, please use 'Connect-NexposeAPI' to create one"
        }
    }

    Process {
        [string]$HostName = $($global:NexposeSession.Headers['HostName'])
        [int]   $Port     = $($global:NexposeSession.Headers['Port'])
        [string]$ApiUri   = ('https://{0}:{1}/api/3/{2}' -f $HostName, $Port, $UrlFunction)

        # Hack for 'Start-NexposeAssetScan'
        If ($UrlFunction -eq 'asset/scan')  { $ApiUri = $ApiUri.Replace('/api/3/', '/api/2.1/') }

        [hashtable]$iRestM = @{
            Uri        = $ApiUri
            Method     = $RestMethod
            WebSession = $global:NexposeSession
        }

        # Force retreving the maximum number of entries (POST comes from Get-NexposeAsset search)
        If (($RestMethod -eq 'GET') -or ($RestMethod -eq 'POST')) { $iRestM.Uri += '?size=100' }

        If (($RestMethod -eq 'GET') -or ($RestMethod -eq 'DELETE')) {
            If ([string]::IsNullOrEmpty($ApiQuery) -eq $false) {
                $ApiQuery.GetEnumerator() | ForEach-Object -Process {
                    $iRestM.Uri += "&$($_.Key.ToString())=$($_.Value.ToString())"
                }
            }
        }
        Else {
            [string]$ApiQueryJson = $ApiQuery    # Start as plain text, before
            If ($ApiQuery -is [hashtable]) {     # converting to JSON only if required
                [string]$ApiQueryJson = (ConvertTo-Json -InputObject $ApiQuery -Depth 100)
            }

            $iRestM += @{
                ContentType = 'application/json'
                Body        =  $ApiQueryJson
            }

            # Add page number to URL for "Get-NexposeAsset" search function
            If ($RestMethod -eq 'POST') {
                [int]$currPage = ([regex]::Match($iRestM.Uri, '(?:&page=)([0-9]{1,})(?:&)').Groups[1].Value)
                If ($currPage -eq 0) { $iRestM.Uri += '&page=0' }
            }
        }


        Try {
            Write-Verbose "Executing API method `"$($RestMethod.ToString().ToUpper())`" against `"$($iRestM.Uri)`""
            If ($ApiQuery) { Write-Verbose "ApiQuery:`n$($ApiQuery | ConvertTo-Json -Depth 100)" }
            $Output = (Invoke-RestMethod @iRestM -Verbose:$false -TimeoutSec 300 -ErrorAction Stop)

            If ([string]::IsNullOrEmpty($Output) -eq $true) {
                Return $null
            }

            # Remove the "LINKS" section of the output, by default
            If ((Get-Variable -Name 'NexposeShowLinks' -ValueOnly -ErrorAction SilentlyContinue) -eq $true) { $IncludeLinks = $true }
            If (-not $IncludeLinks.IsPresent) { $Output = (Remove-NexposeLink -InputObject $Output -WhatIf:$false) }

            # Check for single or multiple pages and resources
            [boolean]$script:resources = $false
            [boolean]$script:page      = $false
            $Output | Get-Member -MemberType *Property | ForEach-Object -Process {
                If (($_.Name) -eq 'resources') { $script:resources = $true }
                If (($_.Name) -eq 'page'     ) { $script:page      = $true }
            }

            If ($script:resources) {
                Write-Output $Output.resources
            }
            Else {
                Write-Output $Output
            }

            # Output for any additional pages
            [int]$totalPages = ($Output.page.totalPages)
            If (($script:page -eq $true) -and ($totalPages -gt 1)) {
                [int]$totalLength = $($totalPages).ToString().Trim().Length

                2..$totalPages | ForEach-Object -Process {
                    Write-Verbose "Retreving page $($_.ToString().PadLeft($totalLength)) of $totalPages ..."

                    [int]$currPage = ([regex]::Match($iRestM.Uri, '(?:&page=)([0-9]{1,})(?:&)').Groups[1].Value)
                    $iRestM.Uri = $iRestM.Uri.Replace("&page=$($currPage)", "&page=$($_ - 1)")

                    $Output = (Invoke-RestMethod @iRestM -Verbose:$false -TimeoutSec 300 -ErrorAction Stop).resources
                    If (-not $IncludeLinks.IsPresent) { $Output = (Remove-NexposeLink -InputObject $Output) }

                    Write-Output $Output.resources
                }
            }
        }
        Catch {
            $errMsg1 = $_.Exception.Message
            Try {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $reader.BaseStream.Position = 0
                $reader.DiscardBufferedData()
                $errMsg2 = $reader.ReadToEnd()
            }
            Catch {
                $errMsg3 = $_.Exception.Message
            }
            Write-Error "`n$errMsg1`n$errMsg2`n$errMsg3"
        }
    }

    End {
    }
}
