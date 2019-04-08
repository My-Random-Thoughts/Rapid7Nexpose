Function Get-NexposePolicySummary {
<#
    .SYNOPSIS
        Retrieves a compliance summary of all policies.

    .DESCRIPTION
        Retrieves a compliance summary of all policies.

    .EXAMPLE
        Get-NexposePolicySummary

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: policy/summary

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Write-Output @(Get-NexposePagedData -UrlFunction 'policy/summary' -RestMethod Get)
}
