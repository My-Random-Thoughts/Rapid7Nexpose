Function Get-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Returns all scan schedules for the site

    .DESCRIPTION
        Returns all scan schedules for the site

    .PARAMETER Id
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER ScheduleId
        The identifier of the scan schedule

    .EXAMPLE
        Get-NexposeSiteScanSchedule -Id 23

    .EXAMPLE
        Get-NexposeSiteScanSchedule -Name 'Site B' -ScheduleId 4

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        GET: sites/{id}/scan_schedules
        GET: sites/{id}/scan_schedules/{scheduleId}
        PUT: SKIPPED - sites/{id}/scan_schedules       # This updates all schedules for a site
        DELETE: SKIPPED - sites/{id}/scan_schedules    # This removes all schedules for a site

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$Id,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [int]$ScheduleId = 0
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byName' {
            [int]$Id = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Write-Output (Get-NexposeSiteScanSchedule -Id $Id -ScheduleId $ScheduleId)
        }

        'byId' {
            If ($ScheduleId -gt 0) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$Id/scan_schedules/$ScheduleId" -RestMethod Get)
            }
            Else {
                Write-Output @(Get-NexposePagedData -UrlFunction "sites/$Id/scan_schedules" -RestMethod Get)    # Return All
            }
        }
    }
}
