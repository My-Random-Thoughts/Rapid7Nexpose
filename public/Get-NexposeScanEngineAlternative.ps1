Function Get-NexposeScanEngineAlternative {
<#
    .SYNOPSIS
        Returns scan engines available to use for scanning

    .DESCRIPTION
        Returns scan engines available to use for scanning using the builtin system command 'version engines'

    .PARAMETER Name
        The name of the scan engine

    .PARAMETER Status
        The status of a scan engine.
        This is limited to one of the built in values: Active, Pending-Auth, Incompatible, Not-Responding, Unknown

    .PARAMETER Version
        The version of a scan engine

    .PARAMETER Address
        The IP Address of a scan engine

    .PARAMETER Platform
        The platform type of a scan engine

    .EXAMPLE
        Get-NexposeScanEngineAlternative

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(DefaultParameterSetName = 'None')]
    Param (
        [Parameter(ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(ParameterSetName = 'byStatus')]
        [ValidateSet('Active','Pending-Auth','Incompatible','Not-Responding','Unknown')]
        [string]$Status,

        [Parameter(ParameterSetName = 'byVersion')]
        [version]$Version,

        [Parameter(ParameterSetName = 'byAddress')]
        [string]$Address,

        [Parameter(ParameterSetName = 'byPlatform')]
        [string]$Platform
    )

    [string[]]$cmdResult = ((Invoke-NexposeSystemCommand -Command 'version engines' -ErrorAction Stop) -split '\r?\n')
    $engineObject = [pscustomobject]@{}
    [pscustomobject[]]$engines = @()

    ForEach ($line In $cmdResult) {
        If ($line -like '*:*') {
            $addMember = ($line -split ':').Replace('Local Engine','').Replace('Remote Engine','').Trim()
            $engineObject | Add-Member -MemberType NoteProperty -Name $addMember[0] -Value $addMember[1]
        }

        If ($line -eq '') {
            $engines += $engineObject
            $engineObject = [pscustomobject]@{}
        }
    }

    Switch ($PSCmdlet.ParameterSetName) {
        'byName'     { Write-Output @($engines | Where-Object {  $_.Name             -like  $Name      }) }
        'byStatus'   { Write-Output @($engines | Where-Object {  $_.Status           -like  $Status    }) }
        'byVersion'  { Write-Output @($engines | Where-Object {  $_.Version          -like  $Version   }) }
        'byAddress'  { Write-Output @($engines | Where-Object { ($_.'Address(FQDN)') -like "$Address*" }) }
        'byPlatform' { Write-Output @($engines | Where-Object {  $_.Platform         -like  $Platform  }) }
        Default      { Write-Output @($engines) }
    }
}
