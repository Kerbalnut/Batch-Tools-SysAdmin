
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\PromptForChoice-DayDate.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Begin Pester testing.
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

#=======================================================================================================================
Describe 'Get-MondayOfWeekInt' {
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		#-----------------------------------------------------------------------------------------------------------------------
		
		Context ':: Foobar ::' {
			
			It 'Test1' {
				$true | Should -Be $true
			}
			
			It 'Test2' {
				$False | Should -Be $false
			}
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		Context ':: Test Parameter Input methods ::' {
			
			It 'No parameters given.' {
				Get-MondayOfWeekInt | Should -Be $true
			}
			
			It 'Named parameters.' {
				Get-MondayOfWeekInt -DoWInput | Should -Be $true
			}
			
			It 'Positional parameters.' {
				Get-MondayOfWeekInt | Should -Be $true
			}
			
			It 'Passed from pipeline parameters.' {
				Get-MondayOfWeekInt | Should -Be $true
			}
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		#-----------------------------------------------------------------------------------------------------------------------
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#=======================================================================================================================
Describe 'PromptForChoice-DayDate' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: Foobar ::' {
		
		It 'Test1' {
			$true | Should -Be $true
		}
		
		It 'Test2' {
			$False | Should -Be $false
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
