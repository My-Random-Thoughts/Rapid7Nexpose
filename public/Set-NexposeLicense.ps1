Function Set-NexposeLicense {
<#
    .SYNOPSIS
        Licenses the product with an activation key or a provided license file. If both are provided, the license file is preferred

    .DESCRIPTION
        Licenses the product with an activation key or a provided license file. If both are provided, the license file is preferred

    .PARAMETER Key
        A license activation key

    .PARAMETER FilePath
        The path to a license (.lic) file

    .EXAMPLE
        Set-NexposeLicense -Key 'aaaa-bbbb-cccc-dddd'

    .EXAMPLE
        Set-NexposeLicense -FilePath 'c:\nexpose.lic'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        POST: administration/license

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byKey')]
        [string]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = 'byFile')]
        [string]$FilePath
    )

    Begin {
        If ((Test-Path -Path variable:global:NexposeSession) -eq $false) {
            Throw "A valid session token has not been created, please use 'Connect-NexposeAPI' to create one"
        }

        If (($PSCmdlet.ParameterSetName) -eq 'byFile') {
            If ((Test-Path -Path $FilePath) -eq $false) {
                Throw 'Invalid file specified, please make sure it exists'
            }
        }
    }

    Process {
        [string]$Host = $($global:NexposeSession.Headers['HostName'])
        [int]   $Port = $($global:NexposeSession.Headers['Port'])
        [string]$URI  = ('https://{0}:{1}/api/3/administration/license' -f $Host, $Port)
        [string]$guid = (([guid]::NewGuid().ToString()).Split('-')[0])
        [string]$body = ''

        Switch ($PSCmdlet.ParameterSetName) {
            'byKey' {
                $URI += "?key=$Key"
            }

            'byFile' {
                $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
                $fileEnc   = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes)
                $lineFeed  = "`r`n"

                $body = (
                    "--$guid",
                    "Content-Disposition: form-data; name=`"license`"; filename=`"not.blank`"",
                    "Content-Type: application/octet-stream$LF",
                    $fileEnc,
                    "--$guid--$lineFeed"
                ) -join $lineFeed

            }
        }

        Try {
            If ($PSCmdlet.ShouldProcess("$Key$FilePath")) {    # Timeout of 10 minutes, as it checks for updates as part of the licence update.
                 Write-Output (Invoke-RestMethod -Method Post -Uri $URI -WebSession $global:NexposeSession -ContentType "multipart/form-data; boundary=$guid" -Body $body -TimeoutSec 600)
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
