# Rapid7 Nexpose PowerShell Module
## Description
This module talks to the Rapid 7 Nexpose API v3 to help in managing your installation.
The API can be located at `https://<DNS Name or IP>:3870/api/3`

This module also works with 'insightVM' - They are basically the same product


## Download And Import
Download the all the files into your PowerShell module path (usually C:\Program Files\WindowsPowerShell\Modules) and import it

`Import-Module -Name 'Rapid7Nexpose'`

## Basic Usage
To start using the module, you need to authenticate with your Nexpose installation:

`Connect-NexposeAPI -HostName '<DNS Name or IP>' -Port '3870' -Credential <PSCredential>`

If you are using a self-signed certificate, you will also need to add `-SkipSSLCheck` to the end of the above command.

Once connected, you can start using any of the other commands.
For example, to list all sites in your environment, use `Get-NexposeSite`

## Comment Based Help
Every command has its own comment based help, so there should be no issues with getting information for the commands.
Most of the help comes from the API itself, so blame them for mistakes  :)


# Please Note
This is an inital public offering, and as such there is a lot of work is still needed.
In addition to wanting to support pipeline processing correctly, I want to make it API complete as much as I can.

### Bugs / Issues
I have several bugs open with Rapid7 for API issues, and I will be tracking those with the bug tracker here on GitHub
Some of them are minor ones that I may have coded around, others are much larger breaking issues.

### API Coverage
Due to the size of the API and the number of modules I have written, it's quite difficult to keep track of the what has been done and what hasn't.  To help this every module has a `.FUNCTIONALITY` comment based header that lists all the API endpoints that are covered in that particular function.  Have a look at the **api-coverage.md** file for the full list.

