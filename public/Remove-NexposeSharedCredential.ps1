Function Remove-NexposeSharedCredential {
<#
    .SYNOPSIS
        Removes a shared credential

    .DESCRIPTION
        Removes a shared credential

    .PARAMETER Name
        The name of the credential

    .PARAMETER Domain
        The address of the domain

    .PARAMETER Username
        The user name for the account that will be used for authenticating

    .EXAMPLE
        Remove-NexposeSharedCredential -Name 'Domain Account'

    .EXAMPLE
        Remove-NexposeSharedCredential -Domain 'example.com' -Username 'JoeBlogs'

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: shared_credentials
        DELETE: shared_credentials/{id}
        DELETE: SKIPPED - shared_credentials    # This would remove all shared creds

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'byName')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'byDomain')]
        [string]$Domain,

        [Parameter(Mandatory = $true, ParameterSetName = 'byDomain')]
        [string]$UserName
    )

    Begin {
    }

    Process {
        [int]$id = 0
        [object]$creds = (Invoke-NexposeQuery -UrlFunction 'shared_credentials' -RestMethod Get)

        If ($PSCmdlet.ParameterSetName -eq 'byName') {
            ForEach ($credential In $creds) {
                If ($credential.Name -eq $Name) {
                    $id = ($credential.id)
                    Break
                }
            }
        }
        Else {
            ForEach ($credential In $creds) {
                If (($credential.account.domain -eq $Domain) -and ($credential.account.username -eq $Username)) {
                    $id = ($credential.id)
                    Break
                }
            }
        }

        If ($id -gt 0) {
            If ($PSCmdlet.ShouldProcess($credential.Name)) {
                (Invoke-NexposeQuery -UrlFunction "shared_credentials/$id" -RestMethod Delete)
            }
        }
        Else {
            Throw 'Specified account does not exist'
        }
    }

    End {
    }
}
