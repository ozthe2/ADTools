#Requires -Module Pester

if ((Get-Module).Name -contains 'ADTools') {
    Remove-Module -Name ADTools
}

Import-Module "$PSScriptRoot\..\ADTools\ADTools.psm1"

InModuleScope ADTools {
   


    describe "ADTools" { 

    BeforeAll {
        Mock Get-ADUser {
            [PSCustomObject]@{
                name = 'joe'; 
                DistinguishedName = 'CN=someone,OU=something,DC=domain,DC=root,DC=com';
                   SamAccountName = 'Someone';
                    LastLogonDate = '18 October 2018 19:29:55';
                    enabled = $true
            }
    }

        Context "Prereqs" {       

            It 'Passes Test-ModuleManifest' {
                Test-ModuleManifest -Path "$PSScriptRoot\..\ADTools\ADTools.psd1"
                $? | Should Be $true
            }
        }

        Context "Input" {            
            
        }
            It "Should not throw when a valid OU is entered as a parameter" {
               { Get-OHStaleAccount -ou "CN=someone,OU=something,DC=domain,DC=root,DC=com" } | Should not throw

            }

            Assert-MockCalled Get-ADUser -Exactly 1

            
        }
    }
}