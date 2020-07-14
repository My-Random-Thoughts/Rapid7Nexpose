Function Get-NexposeSolution {
<#
    .SYNOPSIS
        Returns the details for a solution that can remediate one or more vulnerabilities

    .DESCRIPTION
        Returns the details for a solution that can remediate one or more vulnerabilities

    .PARAMETER Id
        The identifier of the solution

    .PARAMETER IncludePrerequisites
        Returns the solutions that must be executed in order for a solution to resolve a vulnerability

    .PARAMETER IncludeSupersedes
        Returns the solutions that are superseded by this solution

    .PARAMETER IncludeSuperseding
        Returns the solutions that supersede this solution

    .EXAMPLE
        Get-NexposeSolution -Id 'xp-unsafe-security-center-settings'

    .EXAMPLE
        Get-NexposeSolution -Id 'xp-unsafe-security-center-settings' -IncludePrerequisites -IncludeSupersedes

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: solutions
        GET: solutions/{id}
        GET: solutions/{id}/prerequisites
        GET: solutions/{id}/supersedes
        GET: solutions/{id}/superseding

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding()]
    Param (
        [string]$Id,

        [switch]$IncludePrerequisites,

        [switch]$IncludeSupersedes,

        [switch]$IncludeSuperseding
    )

    If ([string]::IsNullOrEmpty($Id) -eq $true) {
        Write-Output @(Invoke-NexposeQuery -UrlFunction 'solutions' -RestMethod Get)    # Return All
    }
    Else {
        [string]$uri = "solutions/$Id"
        $solu = (Invoke-NexposeQuery -UrlFunction $uri -RestMethod Get -ErrorAction Stop)

        # Include the additional properties if required...
        If ($IncludePrerequisites.IsPresent) {
            $solu | Add-Member -Name 'prerequisites' -Value @(Invoke-NexposeQuery -UrlFunction "$uri/prerequisites" -RestMethod Get) -MemberType NoteProperty
        }

        If ($IncludeSupersedes.IsPresent) {
            $solu | Add-Member -Name 'supersedes'    -Value @(Invoke-NexposeQuery -UrlFunction "$uri/supersedes"    -RestMethod Get) -MemberType NoteProperty
        }

        If ($IncludeSuperseding.IsPresent) {
            $solu | Add-Member -Name 'superseding'   -Value @(Invoke-NexposeQuery -UrlFunction "$uri/superseding"   -RestMethod Get) -MemberType NoteProperty
        }

        Write-Output $solu
    }
}
