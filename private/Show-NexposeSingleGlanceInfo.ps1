Function Show-NexposeSingleGlanceInfo {
<#
    .SYNOPSIS
        TODO

    .DESCRIPTION
        TODO

    .EXAMPLE
        Show-NexposeSingleGlanceInfo

    .NOTES
        For additional information please see my GitHub wiki page

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Begin {
        [object]  $sysInfo = (Get-NexposeSystemInfo)
        [string[]]$locked  = ((Invoke-NexposeSystemCommand -Command 'show locked accounts' -Verbose:$false) -split 'Acounts with failed login')
    }

    Process {
        $results = [pscustomObject]@{
            Version        = "$($sysInfo.version.semantic) ($($sysInfo.version.update.contentPartial))"
            LicenseExpiry  = ((Get-NexposeLicense).expires)
            DiskFree       = "$([math]::Round((100 / $($sysInfo.disk.total.bytes)) * $($sysInfo.disk.free.bytes), 2))%"
            LockedAccounts = (ConvertFrom-NexposeTable -InputTable $($locked[0]))
            FailedLogins   = (ConvertFrom-NexposeTable -InputTable $($locked[1]))
        }

        Return $results
    }

    End {
    }
}
