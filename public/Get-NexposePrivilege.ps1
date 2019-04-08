Function Get-NexposePrivilege {
<#
    .SYNOPSIS
        Retrieves the details of a privilege

    .DESCRIPTION
        Retrieves the details of a privilege

    .EXAMPLE
        Get-NexposePrivilege

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: privileges
        GET: SKIPPED - privileges/{id}    # This returns no useful data

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Write-Output (Invoke-NexposeQuery -UrlFunction 'privileges' -RestMethod Get)    # Return All
}
