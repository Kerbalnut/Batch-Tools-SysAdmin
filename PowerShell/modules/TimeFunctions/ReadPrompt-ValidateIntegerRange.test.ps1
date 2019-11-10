
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

#. "C:\Users\Grant\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-ValidateIntegerRange.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Begin Pester testing.
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

#=======================================================================================================================
Describe 'Read-ValidateInteger' {
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
	
	Context ':: Success tests. Piping in valid integer ranges. ::' {

		It 'Integer 4, with leading zeros (no quotes)' {
			0000004 | Read-ValidateInteger | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It 'Integer 4, with leading zeros (single quotes)' {
			'0000004' | Read-ValidateInteger | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It 'Integer 0, with leading zeros (double quotes)' {
			"0000000" | Read-ValidateInteger | Should -Be 0
		}
		
	}

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for mandatory parameter, input value. ::' {
		
		It "Has a Mandatory 'ValueInput' parameter. If no input is given, PowerShell will prompt user for the missing parameter." {
			#https://stackoverflow.com/questions/45935954/testing-for-mandatory-parameters-with-pester
			#https://github.com/PowerShell/PowerShell/issues/2408#issuecomment-251140889
			((Get-Command Read-ValidateInteger).Parameters['ValueInput'].Attributes | ? { $_ -is [parameter] }).Mandatory | Should Be $true
		}
	}
		
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests: setting named parameters as non-integer values, which will throw an error. ::' {
		
		It "Decimal 2.4" {
			{Read-ValidateInteger -ValueInput 2.4} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number -2" {
			{Read-ValidateInteger -ValueInput -2} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number with leading zeroes -00009" {
			{Read-ValidateInteger -ValueInput -00009} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative decimal with leading zeroes -00009.1" {
			{Read-ValidateInteger -ValueInput -00009.1} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Decimal with leading zero 0.01" {
			{Read-ValidateInteger -ValueInput 0.01} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Negative decimal with leading zeroes-0000.0010" {
			{Read-ValidateInteger -ValueInput -0000.0010} | Should -Throw
		}
		
	}

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests: setting positional parameters as non-integer values, which will throw an error. ::' {
		
		It "Decimal 2.4" {
			{Read-ValidateInteger 2.4} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number -2" {
			{Read-ValidateInteger -2} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number with leading zeroes -00009" {
			{Read-ValidateInteger -00009} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative decimal with leading zeroes -00009.1" {
			{Read-ValidateInteger -00009.1} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Decimal with leading zero 0.01" {
			{Read-ValidateInteger 0.01} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Negative decimal with leading zeroes-0000.0010" {
			{Read-ValidateInteger -0000.0010} | Should -Throw
		}
		
	}

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests: piping in non-integer values which, will throw an error. ::' {
		
		It "Decimal 2.4" {
			{2.4 | Read-ValidateInteger} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number -2" {
			{-2 | Read-ValidateInteger} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative whole number with leading zeroes -00009" {
			{-00009 | Read-ValidateInteger} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It "Negative decimal with leading zeroes -00009.1" {
			{-00009.1 | Read-ValidateInteger} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Decimal with leading zero 0.01" {
			{0.01 | Read-ValidateInteger} | Should -Throw
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		It "Negative decimal with leading zeroes-0000.0010" {
			{-0000.0010 | Read-ValidateInteger} | Should -Throw
		}
		
	}

	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
