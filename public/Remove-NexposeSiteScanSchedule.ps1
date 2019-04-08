Function Remove-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Deletes the specified scan schedule from the site

    .DESCRIPTION
        Deletes the specified scan schedule from the site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER ScheduleId
        The identifier of the scan schedule

    .EXAMPLE
        Remove-NexposeSiteScanSchedule -Id 23

    .EXAMPLE
        Remove-NexposeSiteScanSchedule -Name 'Site B' -ScheduleId 4

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        DELETE: sites/{id}/scan_schedules/{scheduleId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$ScheduleId
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byName' {
            [int]$Id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Write-Output (Remove-NexposeSiteScanSchedule -Id $Id -ScheduleId $ScheduleId)
        }

        'byId' {
            If ($PSCmdlet.ShouldProcess($item)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/scan_schedules/$ScheduleId" -RestMethod Delete)
            }
        }
    }
}
