Function Test-FrequencyString {
<#
    .SYNOPSIS
        Tests a natural language text input for time intervals

    .DESCRIPTION
        Tests a natural language text input for time intervals.  This returns a regex match object with the results, $false boolean value

    .PARAMETER InputInterval
        Natural language text of the interval to test

    .EXAMPLE
        Test-FrequencyString -Frequency 'Every first wednesay of the month'

    .EXAMPLE
        Test-FrequencyString -Frequency 'Every 31st of the month repeated every 3 months'

    .EXAMPLE
        Test-FrequencyString -Frequency 'Every 3rd of the month repeat every 2 months'

    .NOTES
        For additional information please contact PlatformBuild@transunion.co.uk

    .FUNCTIONALITY
        None

    .LINK
        https://callcreditgroup.sharepoint.com/cto/dev%20ops/PlatformBuild/default.aspx
#>

    [CmdletBinding()]
    Param (
        [string]$Frequency
    )

    # Define the interval regex
    [System.Text.StringBuilder]$regexString = ''

    # Capture groups used in 'Convert-IntervalString'
    [void]($regexString.Append('^(?:once|every (?:(?:(?:1 )?(hour|day|week)|([2-9]|[1-9][0-9][0-9]?) (hours|days|weeks))|'))    # Capture groups 1, 2 and 3
    [void]($regexString.Append('(monday|tuesday|wednesday|thursday|friday|saturday|sunday)|'))                                  # Capture group  4
    [void]($regexString.Append('(?:(1st|2nd|3rd|4th|5th) (monday|tuesday|wednesday|thursday|friday|saturday|sunday)|'))         # Capture groups 5 and 6
    [void]($regexString.Append('((?:[23]?(?<!1)1st|2?(?<!1)2nd|2?(?<!1)3rd)|(?:(?:[4-9]|[1-2][04-9])|11|12|13|30)th))'))        # Capture group  7
    [void]($regexString.Append('(?: of the month(?: repeat(?:ed)? every ([2-9]|[1-9][0-9][0-9]?) months)?)))$'))                # Capture group  8
    Write-Verbose -Message $regexString

    # Validate input string
    Return ([regex]::Match($Frequency.ToLower(), $regexString.ToString(), 'IgnoreCase'))
}
