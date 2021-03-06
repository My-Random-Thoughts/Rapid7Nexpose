# Rapid7 Nexpose PowerShell Module
## Description
This module talks to the Rapid 7 Nexpose API v3 to help in managing your installation.
The API can be located at `https://<DNS Name or IP>:3780/api/3`

This module also works with 'insightVM' - They are basically the same product


## Download And Import
Download all the files into your PowerShell module path (usually C:\Program Files\WindowsPowerShell\Modules) and import it

`Import-Module -Name 'Rapid7Nexpose'`

## Basic Usage
To start using the module, you need to authenticate with your Nexpose installation:

`Connect-NexposeAPI -HostName '<DNS Name or IP>' -Port '3780' -Credential <PSCredential>`

If you are using a self-signed certificate, you will also need to add `-SkipSSLCheck` to the end of the above command.

Once connected, you can start using any of the other commands.
For example, to list all sites in your environment, use `Get-NexposeSite`

### TLS Security
You may find that you can't connect to the API with and error message similar to `Invoke-WebRequest : The underlying connection was closed: An unexpected error occurred on a receive.`.  This is a known issue and can be fixed by adding `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` in your scripts or PowerShell Profile should help.  Have a look at https://stackoverflow.com/questions/36265534/invoke-webrequest-ssl-fails for more information.


## Comment Based Help
Every command has its own comment based help, so there should be no issues with getting information for the commands.
Most of the help comes from the API itself, so blame them for mistakes  :)


## Please Note
This is an inital public offering, and as such, there is a lot of work that is still needed.
In addition to wanting to support pipeline processing correctly, I want to make it API complete as much as I can.

### Bugs / Issues
I have several bugs open with Rapid7 for API issues.
Some of them are minor ones that I may have coded around, others are much larger breaking issues.

### API Coverage
Due to the size of the API and the number of functions I have written, it's quite difficult to keep track of the what has been done and what hasn't.  To help this every function has a comment based header containing "`.FUNCTIONALITY`"  that lists all the API endpoints that are covered in that particular function.  Have a look at the **api-coverage.md** file for the full list.

