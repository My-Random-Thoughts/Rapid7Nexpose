Function ConvertFrom-NexposeTable {
<#
    .SYNOPSIS
        Convert a system command result table to into a PowerShell object

    .DESCRIPTION
        Convert a system command result table to into a PowerShell object

    .PARAMETER InputTable
        Output from system command containing a text drawn table

    .EXAMPLE
        ConvertFrom-NexposeTable -InputTable $commandResult

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [string]$InputTable
    )

    Begin {
        [int]     $lineCnt = 0
        [object[]]$result  = @()
        [string[]]$headers = @()

        [long]    $refLng  = New-Object -TypeName 'Long'
        [double]  $refDbl  = New-Object -TypeName 'Double'
        [datetime]$refDtm  = New-Object -TypeName 'DateTime'
        [timespan]$refSpn  = New-Object -TypeName 'TimeSpan'

        [type]  $selectedType  = 'string'
        [string]$timeSpanRegex = '^(\d+)h(\d+)m(\d+)s$'
        [string]$dateTimeRegex = '^(\w{3})\s(\w{3})\s(\d{2})\s(\d\d:\d\d:\d\d)\sUTC\s(\d{4})$|^(\d{4}-)(\d{2}-)(\d{2}\s)(\d{2}:\d{2})() UTC$'
    }

    Process {
        ForEach ($line In ($InputTable -split '\r?\n')) {
            [boolean]$lineContinuation = $false
            If ([string]::IsNullOrEmpty($line)) { Continue }
            If (($line.StartsWith('+---')) -or ($line.StartsWith('|---'))) { $lineCnt++; Continue }

            [string[]]$data = ($line.Trim().Trim('|') -split '\|').Trim()

            If ($lineCnt -eq 1) { $headers = $data -replace '\s','' }
            if ($lineCnt -gt 1) {
                $object = [pscustomobject]@{}
                [int]$isBlank   = 0
                [int]$columnCnt = 0
                [boolean]$lineContinuation = $false

                # Check for line continuation
                ForEach ($item In $data) {
                    If ([string]::IsNullOrEmpty($item)) { $isBlank++; }
                }
                If (($isBlank -gt 0) -and ($isBlank -eq $data.Count -1)) { $lineContinuation = $true }

                ForEach ($item In $data) {
                    If ($item.Trim() -match $dateTimeRegex) {
                        $item = $item.Trim() -replace $dateTimeRegex, '$1 $2 $3 $5 $4 $6$7$8$9'
                        $selectedType = 'datetime'
                    }
                    ElseIf ($item -match $timeSpanRegex) {
                        $item = (New-TimeSpan -Hours $matches.1 -Minutes $matches.2 -Seconds $matches.3)
                        $selectedType = 'timespan'
                    }
                    ElseIf (($item.StartsWith('[')) -and (($item.EndsWith(']')))) {
                        $item = @($item.TrimStart('[').TrimEnd(']').Split(',').Trim())
                        $selectedType = 'string[]'
                    }
                    ElseIf (    [long]::TryParse($item, [ref]$refLng)) { $selectedType = 'long'     }
                    ElseIf (  [double]::TryParse($item, [ref]$refDbl)) { $selectedType = 'double'   }
                    ElseIf ([datetime]::TryParse($item, [ref]$refDtm)) { $selectedType = 'datetime' }
                    ElseIf ([timespan]::TryParse($item, [ref]$refSpn)) { $selectedType = 'timespan' }
                    Else                                               { $selectedType = 'string'   }    # Default fallback option

                    If ($lineContinuation -eq $false) {
                        Add-Member -InputObject $object -MemberType NoteProperty -Name $headers[$columnCnt] -Value ($item -as $selectedType)
                    }
                    Else {
                        If (-not [string]::IsNullOrEmpty($item.Trim())) {
                            $result[-1].$($headers[$columnCnt]) += " $item"
                        }
                    }

                    $columnCnt++
                }

                If ($lineContinuation -eq $false) { $result += $object }
            }
        }

        Return $result
    }

    End {
    }
}
