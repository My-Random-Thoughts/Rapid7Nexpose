Function New-DynamicParameter {
<#
    .SYNOPSIS
        Helper function to simplify creating dynamic parameters

    .DESCRIPTION
        Helper function to simplify creating dynamic parameters
        Example use cases:
            Include parameters only if your environment dictates it
            Include parameters depending on the value of a user-specified parameter
            Provide tab completion and intellisense for parameters, depending on the environment
        Please keep in mind that all dynamic parameters you create will not have corresponding variables created.
           One of the examples illustrates a generic method for populating appropriate variables from dynamic parameters
           Alternatively, manually reference $PSBoundParameters for the dynamic parameter value
    .NOTES
        For additional information please see my GitHub wiki page
        Credit to http://jrich523.wordpress.com/2013/05/30/powershell-simple-way-to-add-dynamic-parameters-to-advanced-function/
            Added logic to make option set optional
            Added logic to add RuntimeDefinedParameter to existing Dictionary
            Added a little comment based help
        Credit to BM for alias and type parameters and their handling

    .PARAMETER Name
        Name of the dynamic parameter

    .PARAMETER Type
        Type for the dynamic parameter.  Default is string

    .PARAMETER ValidateSet
        If specified, set the ValidateSet attribute of this dynamic parameter

    .PARAMETER Mandatory
        If specified, set the Mandatory attribute for this dynamic parameter

    .PARAMETER ParameterSetName
        If specified, set the ParameterSet attribute for this dynamic parameter

    .PARAMETER Dictionary
        If specified, add resulting RuntimeDefinedParameter to an existing RuntimeDefinedParameterDictionary (appropriate for multiple dynamic parameters)
        If not specified, create and return a RuntimeDefinedParameterDictionary (appropriate for a single dynamic parameter)
        See final example for illustration

    .EXAMPLE
        New-DynamicParameter

        Function Show-Free {
            [CmdletBinding()]
            Param ()
            DynamicParam {
                $options = @( Get-WmiObject -Class 'Win32_Volume' | ForEach-Object -Process { $_.DriveLetter} | Sort-Object )
                New-DynamicParam -Name Drive -ValidateSet $options -Mandatory
            }
            Begin {
                # Have to manually populate
                $drive = $PSBoundParameters.drive
            }
            Process {
                $vol = (Get-WmiObject -Class 'Win32_Volume' -Filter "DriveLetter = '$drive'")
                "{0:N2}% free on {1}" -f ($vol.Capacity / $vol.FreeSpace),$drive
            }
        }
        Show-Free -Drive <tab>

        # This example illustrates the use of New-DynamicParam to create a single dynamic parameter
        # The Drive parameter ValidateSet populates with all available volumes on the computer for handy tab completion / intellisense

    .EXAMPLE
        New-DynamicParameter

        # I found many cases where I needed to add more than one dynamic parameter
        # The Dictionary parameter lets you specify an existing dictionary
        # The block of code in the Begin block loops through bound parameters and defines variables if they don't exist

        Function Test-DynPar {
            [CmdletBinding()]
            Param (
                [string[]]$x = $null
            )
            DynamicParam {
                #Create the RuntimeDefinedParameterDictionary
                $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

                New-DynamicParam -Name AlwaysParam -ValidateSet @( Get-WmiObject -Class 'Win32_Volume' | ForEach-Object -Process { $_.DriveLetter} | Sort-Object ) -Dictionary $Dictionary
                #Add dynamic parameters to $dictionary
                If ($x -eq 1) {
                    New-DynamicParam -Name X1Param1 -ValidateSet 1,2 -Mandatory -Dictionary $Dictionary
                    New-DynamicParam -Name X2Param2 -Dictionary $Dictionary
                    New-DynamicParam -Name X3Param3 -Dictionary $Dictionary -Type DateTime
                }
                Else {
                    New-DynamicParam -Name OtherParam1 -Mandatory -Dictionary $Dictionary
                    New-DynamicParam -Name OtherParam2 -Dictionary $Dictionary
                    New-DynamicParam -Name OtherParam3 -Dictionary $Dictionary -Type DateTime
                }

                # Return RuntimeDefinedParameterDictionary
                $Dictionary
            }
            Begin {
                #This standard block of code loops through bound parameters...
                #If no corresponding variable exists, one is created
                #Get common parameters, pick out bound parameters not in that set
                Function _Temp { [CmdletBinding()] Param() }
                $BoundKeys = $PSBoundParameters.keys | Where-Object { (Get-Command _Temp | Select-Object -ExpandProperty Parameters).Keys -notcontains $_ }
                ForEach ($param in $BoundKeys) {
                    If (-not ( Get-Variable -Name $param -Scope 0 -ErrorAction SilentlyContinue ) ) {
                        New-Variable -Name $Param -Value $PSBoundParameters.$param
                        Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
                    }
                }
            }
        }

        # This example illustrates the creation of many dynamic parameters using New-DynamicParam
        # You must create a RuntimeDefinedParameterDictionary object ($dictionary here)
        # To each New-DynamicParam call, add the -Dictionary parameter pointing to this RuntimeDefinedParameterDictionary
        # At the end of the DynamicParam block, return the RuntimeDefinedParameterDictionary
        # Initialize all bound parameters using the provided block or similar code

    .FUNCTIONALITY
        PowerShell Language
#>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Borrowed helper function, not exported')]
    Param(
        [string]$Name,

        [System.Type]$Type = [string],

        [string[]]$ValidateSet,

        [switch]$Mandatory,

        [string]$ParameterSetName = '__AllParameterSets',

        [ValidateScript( {
            If (-not ( $_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary] -or -not $_) ) {
                Throw 'Dictionary must be a "System.Management.Automation.RuntimeDefinedParameterDictionary" object, or not exist'
            }
            $True
        })]
        $Dictionary = $false

    )

    # Create attribute object, add attributes, add to collection
    $ParamAttr = New-Object System.Management.Automation.ParameterAttribute
    $ParamAttr.ParameterSetName = $ParameterSetName

    If ($mandatory) {
        $ParamAttr.Mandatory = $True
    }

    $AttributeCollection = New-Object 'Collections.ObjectModel.Collection[System.Attribute]'
    $AttributeCollection.Add($ParamAttr)

    # Param validation set if specified
    If ($ValidateSet) {
        $ParamOptions = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
        $AttributeCollection.Add($ParamOptions)
    }

    # Create the dynamic parameter
    $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection)

    # Add the dynamic parameter to an existing dynamic parameter dictionary, or create the dictionary and add it
    If ($Dictionary) {
        $Dictionary.Add($Name, $Parameter)
    }
    Else {
        $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $Dictionary.Add($Name, $Parameter)
        $Dictionary
    }
}
