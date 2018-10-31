[![Build status](https://ci.appveyor.com/api/projects/status/6kt3iyjhgr7txdx0?svg=true)](https://ci.appveyor.com/project/ozthe2/adtools)

# README
This module, ADTools, will contain all of the helpful tools that make my life (and yours) easier.

This will be expanded over time so that you will only need to update this module as I add more functionality.

### One time setup
    # Download the repository
    # Unblock the zip
    # Extract the ADTools folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
    Install-Module ADTools

### Import the module.
    Import-Module ADTools    #Alternatively, Import-Module \\Path\To\ADTools

### Get commands in the module
    Get-Command -Module ADTools

### Get help
    Help Get-OHStaleAccount -Full
    Help ADTools
    Help Get-OHStaleAccount -Online


## Get-OHStaleAccount
A function to get a list of either computer or user accounts that have not logged in to AD in x number of days. You can specify your own OU and choose not to search recursively.





