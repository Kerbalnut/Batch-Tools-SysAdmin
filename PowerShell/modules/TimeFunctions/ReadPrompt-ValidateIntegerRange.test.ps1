    
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

. "C:\Users\Grant\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-ValidateIntegerRange.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
#4. Testing ReadPrompt-Hour
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Begin Pester testing.
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

#=======================================================================================================================
Describe 'Testing ReadPrompt-Hour' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #-----------------------------------------------------------------------------------------------------------------------
    
    Context ':: Foobar ::' {

        It 'Test1' {
            $true | Should Be $true
        }
        
        It 'Test2' {
            $False | Should Be $false
        }
    }
    
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    Context ':: Piping in valid integer ranges. No user prompt should be expected. ::' {

        #It 'Test3' {
        It 'Integer 4, within range, with leading zeros (no quotes)' {
            0000004 | ReadPrompt-Hour | Should Be 4
        }
        
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        It 'Integer 4, within range, with leading zeros (single quotes)' {
            '0000004' | ReadPrompt-Hour | Should Be 4
        }
        
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        It 'Integer 0, within range, with leading zeros (double quotes)' {
            "0000000" | ReadPrompt-Hour | Should Be 0
        }
        


    }

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    Context ':: Negative tests, which will trigger Read-Host user input prompt ::' {
        
        It "Read-ValidateInteger - Has a Mandatory 'ValueInput' parameter. If no input is given, PowerShell will prompt user for the missing parameter." {
            #https://stackoverflow.com/questions/45935954/testing-for-mandatory-parameters-with-pester
            #https://github.com/PowerShell/PowerShell/issues/2408#issuecomment-251140889
            ((Get-Command Read-ValidateInteger).Parameters['ValueInput'].Attributes | ? { $_ -is [parameter] }).Mandatory | Should Be $true
        }

        #Mocks
        
        Mock ReadPrompt-Hour { Return 0..23 }

        It 'Integer, out-of-range' {
            24 | ReadPrompt-Hour | Out-Null | Should Be $null
            
        }
        
        It 'Integer, out-of-range' {
            21 | ReadPrompt-Hour | Should Be $null
            
        }
            <#
Context 'MyModule' {
    Mock -ModuleName MyModule Test-Foo { return 'C:\example' }

    It 'gets user input' {
        Test-Foo | Should -Be 'C:\example'
    }
}
            #>



        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
        It 'Decimal value, within range' {
            2.4 | ReadPrompt-Hour | Should Throw
        }
    
        #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    }

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    #-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

If ($true -eq $false) {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host `r`n
Write-Host `r`n

#

Write-Host "# Start Time #`n`r`n"

Write-Host `r`n

#Write-HorizontalRuleAdv -SingleLine

#$StartHour = Read-Host -Prompt "Enter Start hour"
#$StartHour = ReadPrompt-Hour -Verbose
$StartHour = ReadPrompt-Hour -Verbose

#

#Write-HorizontalRuleAdv

#

#-----------------------------------------------------------------------------------------------------------------------

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = (0000004 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = ('0000004' | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = ("0000000" | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (24 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (2.4 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (-2 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (0.01 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (-0000.0010 | ReadPrompt-Hour -Verbose)

#Write-HorizontalRuleAdv -DashedLine

#-----------------------------------------------------------------------------------------------------------------------

#

#Write-HorizontalRuleAdv

#

Write-Host `r`n

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

