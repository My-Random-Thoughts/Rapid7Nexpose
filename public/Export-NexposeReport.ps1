Function Export-NexposeReport {
<#
    .SYNOPSIS
        Returns the contents of a generated report

    .DESCRIPTION
        Returns the contents of a generated report

    .PARAMETER Id
        The identifier of the report

    .PARAMETER Latest
        Return the latest report

    .PARAMETER HistoryId
        The identifier of the report instance

    .PARAMETER SaveAs
        The full path and name of the file to save the report as

    .EXAMPLE
        Export-NexposeReport -Id -Latest -SaveAs "$env:temp\report1.pdf"

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: reports/{id}/history/{instance}/output

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byLatest')]
        [switch]$Latest,

        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$HistoryId,

        [Parameter(Mandatory = $true)]
        [string]$SaveAs
    )

    Begin {
        If ((Test-Path -Path variable:global:NexposeSession) -eq $false) {
            Throw "A valid session token has not been created, please use 'Connect-NexposeAPI' to create one"
        }
    }

    Process {
        If ($Latest.IsPresent) { [string]$HId = 'latest' } Else { [string]$HId = $HistoryId }

        [string]$Host = $($global:NexposeSession.Headers['HostName'])
        [int]   $Port = $($global:NexposeSession.Headers['Port'])
        [string]$URI  = ('https://{0}:{1}/api/3/{2}' -f $Host, $Port, "reports/$Id/history/$HId/output")

        Try {
            [void](Invoke-RestMethod -Uri $URI -Method Get -WebSession $global:NexposeSession -OutFile $SaveAs)
            Write-Output $SaveAs
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
