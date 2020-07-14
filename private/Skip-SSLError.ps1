Function Skip-SSLError {
<#
    .SYNOPSIS
        Allows the bypassing of invalid SSL certificates, useful for self-signed ones.

    .DESCRIPTION
        Allows the bypassing of invalid SSL certificates, useful for self-signed ones.

    .EXAMPLE
        Skip-SSLError

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>
#>

If ($PSVersionTable.PSVersion.Major -le 5) {
    Add-Type @'
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
'@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object -TypeName 'TrustAllCertsPolicy'
    }
    Else {
        Write-Verbose -Message 'This function does not work with PowerShell Core!'
    }
}
