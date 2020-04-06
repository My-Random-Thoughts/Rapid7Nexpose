Function Remove-NexposeSiteScanSchedule {
<#
    .SYNOPSIS
        Deletes the specified scan schedule from the site

    .DESCRIPTION
        Deletes the specified scan schedule from the site

    .PARAMETER SiteId
        The identifier of the site

    .PARAMETER Name
        The name of the site

    .PARAMETER ScheduleId
        The identifier of the scan schedule

    .EXAMPLE
        Remove-NexposeSiteScanSchedule -SiteId 23 -ScheduleId 2

    .EXAMPLE
        Remove-NexposeSiteScanSchedule -Name 'Site B' -ScheduleId 4

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        DELETE: sites/{id}/scan_schedules/{scheduleId}

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'byId')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'byId')]
        [int]$SiteId,

        [Parameter(Mandatory = $true, ParameterSetName = 'byName')]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [int]$ScheduleId
    )

    Switch ($PSCmdlet.ParameterSetName) {
        'byId' {
            If ($PSCmdlet.ShouldProcess($SiteId)) {
                Write-Output (Invoke-NexposeQuery -UrlFunction "sites/$SiteId/scan_schedules/$ScheduleId" -RestMethod Delete)
            }
        }

        'byName' {
            [int]$SiteId = (ConvertTo-NexposeId -Name $Name -ObjectType Site)
            Write-Output (Remove-NexposeSiteScanSchedule -Id $SiteId -ScheduleId $ScheduleId)
        }
    }
}
