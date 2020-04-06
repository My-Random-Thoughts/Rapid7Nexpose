Function Invoke-NexposeScanTemplateHelperPolicies {
<#
    .SYNOPSIS
        Helper function to generate required Policies object for New-NexposeScanTemplate

    .DESCRIPTION
        Helper function to generate required Policies object for New-NexposeScanTemplate

    .PARAMETER StoreSCAP
        Whether Asset Reporting Format (ARF) results are stored. If you are required to submit reports of your policy scan results to the U.S. government in ARF for SCAP certification, you will need to store SCAP data so that it can be exported in this format. Note that stored SCAP data can accumulate rapidly, which can have a significant impact on file storage

    .PARAMETER RecursiveWindowsFSSearch
        Whether recursive windows file searches are enabled, if your internal security practices require this capability. Recursive file searches can increase scan times by several hours, depending on the number of files and other factors, so this setting is disabled for Windows systems by default

    .PARAMETER PoliciesEnabled
        The identifiers of the policies enabled to be checked during a scan. No policies are enabled by default

    .EXAMPLE
        Invoke-NexposeScanTemplateHelperPolicies

    .NOTES
        For additional information please see my GitHub wiki page

    .FUNCTIONALITY
        None

    .LINK
        https://github.com/My-Random-Thoughts/Rapid7Nexpose
#>

    Param (
        [switch]$StoreSCAP,

        [switch]$RecursiveWindowsFSSearch,

        [int[]]$PoliciesEnabled = @()
    )

    Return @{
        policyEnabled = 'true'
        policy = @{
            enabled = @($PoliciesEnabled)
            recursiveWindowsFSSearch = ($RecursiveWindowsFSSearch.IsPresent)
            storeSCAP = ($StoreSCAP.IsPresent)
        }
    }
}
