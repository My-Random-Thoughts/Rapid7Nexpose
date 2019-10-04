Function Get-NexposeScanEngineAlternative {
<#
    .SYNOPSIS
        Returns scan engines available to use for scanning

    .DESCRIPTION
        Returns scan engines available to use for scanning using the builtin system command 'version engines'

    .EXAMPLE
        Get-NexposeScanEngineAlternative

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
    )

    [string[]] $cmdResult = ((Invoke-NexposeSystemCommand -Command 'version engines' -ErrorAction Stop) -split '\r?\n')
    $engineObject = [pscustomobject]@{}
    [pscustomobject[]]$engines = @()

    ForEach ($line In $cmdResult) {
        If ($line -like '*:*') {
            $memberName  = (((($line -split ':')[0]).Substring(14)).Replace(' ', ''))
            $memberValue =  ((($line -split ':')[1]).Trim())
            $engineObject | Add-Member -MemberType NoteProperty -Name $memberName -Value $memberValue
        }

        If ($line -eq '') {
            $engines += $engineObject
            $engineObject = [pscustomobject]@{}
        }
    }

    Write-Output $engines
}
