#Requires -Module Pester

if ((Get-Module).Name -contains 'ADTools') {
    Remove-Module -Name ADTools
}

Import-Module "$PSScriptRoot\..\ADTools\ADTools.psm1"

InModuleScope ADTools {
    describe "ADTools" { 
        Context "Prereqs" {
            It 'Passes Test-ModuleManifest' {
                Test-ModuleManifest -Path "$PSScriptRoot\..\ADTools\ADTools.psd1"
                $? | Should Be $true
            }
        }

        #Context "Input" {
        #    It "Should not throw when a valid OU is entered as a parameter" {
                   
        #    }
        #}
    }
}