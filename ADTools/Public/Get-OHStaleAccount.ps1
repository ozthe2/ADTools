function Get-OHStaleAccount{
   
    
  # .ExternalHelp ADTools-help.xml

    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
    SupportsShouldProcess=$false, 
    PositionalBinding=$false,
    HelpUri = 'https://github.com/ozthe2/ADTools/blob/master/Docs/Get-OHStaleAccount.md',
    ConfirmImpact='Medium')]

    Param(            
        [Parameter(Mandatory=$true,
        HelpMessage="Enter the FQDN of the OU that you wish to search eg 'ou=MyOU,ou=MySubOU,dc=MyCompany,dc=Com'",
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false, 
        Position=0)]
        [string]
        $OU,

        [Parameter(Mandatory=$false,
        HelpMessage="The number of days, since today, that the account has not logged in to AD.  eg 15",
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false, 
        Position=1)]
        [ValidateRange(0,365000)]
        [int]
        $DaysInactive=30,

        [Parameter(Mandatory=$false,
        HelpMessage="Enter either Computer or User depending on if you wish to search against computer or user accounts.",
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false, 
        Position=2)]
        [ValidateSet("Computer", "User")]
        [string]
        $Object = 'User',

        [Parameter(Mandatory=$false,
        HelpMessage="The results will be only from accounts that are enabled, only accounts that are disabled, or both enabled and disabled accounts.  Type enabled, disabled or both.",
        ValueFromPipeline=$false,
        ValueFromPipelineByPropertyName=$false, 
        Position=3)]
        [ValidateSet("Both", "Enabled", "Disabled")]
        [string]
        $Scope = 'Enabled',
        
        [parameter(Mandatory=$false)]
        [Switch]
        $DoNotSearchRecursively       
    )

    begin {
        $time = (Get-Date).Adddays(-($DaysInactive))
    }

    process {
        if ($DoNotSearchRecursively) {
            switch ($object) {
                'User' {
                    switch ($scope) {
                         'Enabled' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time -and Enabled -eq $true} -SearchBase $ou -Searchscope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                        'Disabled' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time -and Enabled -eq $false} -SearchBase $ou -SearchScope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                            'Both' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time} -SearchBase $ou -SearchScope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                    }
                }
            
                'Computer' {
                    switch ($scope) {
                         'Enabled' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time -and Enabled -eq $true} -SearchBase $ou -SearchScope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                        'Disabled' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time -and Enabled -eq $false} -SearchBase $ou -SearchScope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                            'Both' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time} -SearchBase $ou -SearchScope OneLevel -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                    }
                }
            }
        } else {
            switch ($object) {
                'User' {
                    switch ($scope) {
                         'Enabled' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time -and Enabled -eq $true} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                        'Disabled' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time -and Enabled -eq $false} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                            'Both' {$Result = Get-ADUser -Filter {LastLogonDate -lt $time} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate}
                    }
                }
            
                'Computer' {
                    switch ($scope) {
                         'Enabled' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time -and Enabled -eq $true} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                        'Disabled' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time -and Enabled -eq $false} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                            'Both' {$Result = Get-ADComputer -Filter {LastLogonDate -lt $time} -SearchBase $ou -SearchScope Subtree -ResultPageSize 2000 -ResultSetSize $null -Properties Name , OperatingSystem, SamAccountName, DistinguishedName,lastlogondate,operatingsystem}
                    }
                }
            }
        }

        foreach ($Item in $result) {
            if ($item.objectclass -eq 'Computer') {    
                $obj = [PSCustomObject]@{
                                         Name = $Item.Name
                            DistinguishedName = $Item.DistinguishedName
                               SamAccountName = $Item.samAccountName
                                LastLogonDate = $item.lastlogondate
                                 DaysInactive = (New-TimeSpan -Start $item.lastlogondate -End (get-date)).days
                                      Enabled = $item.enabled
                              OperatingSystem = $item.operatingSystem
                }
            } else {
              $obj = [PSCustomObject]@{
                                         Name = $Item.Name
                            DistinguishedName = $Item.DistinguishedName
                               SamAccountName = $Item.samAccountName
                            UserPrincipalName = $item.userprincipalname                            
                                LastLogonDate = $item.lastlogondate
                                 DaysInactive = (New-TimeSpan -Start $item.lastlogondate -End (get-date)).days
                                      Enabled = $item.enabled                            
               }
            }
            
            $obj.psobject.TypeNames.Insert(0, 'OH.ADTools.OHStaleAccounts')
            $obj
        }
    }

    end {}
}