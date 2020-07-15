Function Invoke-NexposeRestMethod {
<#
    .SYNOPSIS
        Wrapper for built-in Invoke-RestMethod

    .DESCRIPTION
        Wrapper for built-in Invoke-RestMethod to cut down on code duplication

    .PARAMETER Uri
        Specifies the Uniform Resource Identifier (URI) of the internet resource to which the web request is sent

    .PARAMETER Method
        Specifies the method used for the web request

    .PARAMETER ContentType
        Specifies the content type of the web request

    .PARAMETER TimeOut
        Specifies how long the request can be pending before it times out. Enter a value in seconds

    .PARAMETER Body
        Specifies the body of the request. The body is the content of the request that follows the headers

    .PARAMETER OutFile
        Saves the response body in the specified output file. Enter a path and file name. If you omit the path, the default is the current location

    .EXAMPLE
        Invoke-NexposeRestMethod -Uri $Uri -Method 'Post' -ContentType $Content -TimeOut 600 -Body $body

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope = 'Function')]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $true)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [string]$ContentType,

        [object]$Body,

        [int]$TimeOut = 15,

        [string]$OutFile
    )

    Begin {
        [string]$HostName = $($global:NexposeSession.Headers['HostName'])
        [int]   $Port     = $($global:NexposeSession.Headers['Port'    ])

        [hashtable]$invokeRestMethod = @{
            Uri                  = ("https://{0}:{1}$Uri" -f $HostName, $Port)
            Method               =   $Method
            WebSession           =   $global:NexposeSession
            TimeOut              =   $TimeOut
            UseBasicParsing      =   $true
            ErrorAction          =  'Stop'
        }

        If ($PSVersionTable.PSVersion.Major -gt 5) {
            $invokeRestMethod += @{
                SkipCertificateCheck = $($global:NexposeSession.Headers['SkipSSL' ] -as [boolean])
            }
        }
    }

    Process {
        If (-not [string]::IsNullOrEmpty($Body       )) { $invokeRestMethod += @{ Body        = $Body        }}
        If (-not [string]::IsNullOrEmpty($OutFile    )) { $invokeRestMethod += @{ OutFile     = $OutFile     }}
        If (-not [string]::IsNullOrEmpty($ContentType)) { $invokeRestMethod += @{ ContentType = $ContentType }}

        Return (Invoke-RestMethod @invokeRestMethod)
    }

    End {
    }
}
