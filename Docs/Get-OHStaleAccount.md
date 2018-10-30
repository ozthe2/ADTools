---
external help file: ADTools-help.xml
Module Name: adtools
online version: 0.1.0
schema: 2.0.0
---

# Get-OHStaleAccount

## SYNOPSIS
Displays user or computer accounts that have not logged into AD in x number of days.

## SYNTAX

```
Get-OHStaleAccount [-OU] <String> [[-DaysInactive] <Int32>] [[-Object] <String>] [[-Scope] <String>]
 [-DoNotSearchRecursively] [<CommonParameters>]
```

## DESCRIPTION
Displays user or computer accounts from specified OU's that have not logged in to Active Directory in X amount of days. 
By default the search is recursive, meaning the specified OU and all child OU's will be searched too, unless you add the switch -DoNotSearchRecursively

## EXAMPLES

### EXAMPLE 1
```
Get-OHStaleAccount -OU 'ou=MyChildOU,ou=myOU,dc=MyCompany,dc=com' -DaysInactive 60 -Object User -Scope Enabled
```

This example displays all user objects that have not logged in to AD in 60 days or more from the date you run the command. (Searching recursively in the OU specified.)

### EXAMPLE 2
```
Get-OHStaleAccount  -DaysInactive 45 -OU 'ou=myOU,dc=MyCompany,dc=com' -Object Computer | ? {$_.name -like "*LAP*"}
```

This example searches for all computer objects that have not logged in to AD in 45 days or more from the date you run the command, searching in the OU specified, (Including Child-OUs), and only displays computers whose computer name contains the word 'LAP' in it.  Eg the computer is named MyLaptop or LAP001

### EXAMPLE 3
```
(Get-OHStaleAccount -DaysInactive 60 -OU 'ou=MyChildOU,ou=myOU,dc=MyCompany,dc=com').samAccountName | Disable-ADAccount
```

This command displays all user accounts that have not logged in to AD in 60 days or more from the date you run the command, searching in the OU specified, (Including Child-OUs), and then disables the accounts.

### EXAMPLE 4
```
Get-OHStaleAccount -DaysInactive 60 -OU 'ou=MyChildOU,ou=myOU,dc=MyCompany,dc=com' -DoNotSearchRecursively
```

This example displays all user accounts that have not logged in to AD for 60 days or more from the date you run the command, searching only in the OU specified. (Child-OU's will not be searched)

## PARAMETERS

### -OU
This is the FQDN of the OU that you wish to search in for stale accounts. 
By default, the search is recursive meaning child OU's are also searched.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DaysInactive
This is the number of days that the account has not logged in for.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -Object
Specify if you wish to search for just computer accounts, just user accounts or both computer and user accounts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: User
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Specify if you wish to search for just accounts that are enabled, disabled or both enabled and disabled.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Enabled
Accept pipeline input: False
Accept wildcard characters: False
```

### -DoNotSearchRecursively
By including this switch, the search for stale accounts is explicitly contained to the OU defined by the OU parameter and will not search Child-OU's.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Created By: OH
       Web: https://www.fearthepanda.com
   Twitter: @ozthe2

## RELATED LINKS
