Function Skip-SSLError {
<#
    .SYNOPSIS
        Allows the bypassing of invalid SSL certificates,
        useful for self-signed ones.
#>

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
