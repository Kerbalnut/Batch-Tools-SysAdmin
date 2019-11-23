
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

#. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"

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
	
	Context ':: Success tests. Piping in valid integers. ::' {
		
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
	
	Context ':: Success tests. Testing valid integers, using positional parameters. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			Read-ValidateInteger 0000004 | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			Read-ValidateInteger '0000004' | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			Read-ValidateInteger "0000000" | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for non-/mandatory parameter(s) ::' {
		
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

#=======================================================================================================================
Describe 'Read-PromptHour' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: Success tests. Piping in valid integer ranges. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			0000004 | Read-PromptHour | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			'0000004' | Read-PromptHour | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			"0000000" | Read-PromptHour | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Success tests. Testing valid integer ranges, using positional parameters. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			Read-PromptHour 0000004 | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			Read-PromptHour '0000004' | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			Read-PromptHour "0000000" | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for non-/mandatory parameter(s) ::' {
		
		It "Has non-mandatory 'VarInput' parameter. If no input is given, Read-PromptHour will prompt user for the missing parameter." {
			#https://stackoverflow.com/questions/45935954/testing-for-mandatory-parameters-with-pester
			#https://github.com/PowerShell/PowerShell/issues/2408#issuecomment-251140889
			((Get-Command Read-PromptHour).Parameters['VarInput'].Attributes | ? { $_ -is [parameter] }).Mandatory | Should Be $false
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, will prompt user for input if it fails integer & range validation checks in a loop until valid input is given. ::' {
		
		Mock Read-Host {return 21}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour
		
		It "No input given. Failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput 24
		
		It "Was given out-of-range value 24, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput 2.4
		
		It "Was given decimal value 2.4, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput -2
		
		It "Was given decimal value -2, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput -00009
		
		It "Was given decimal value -00009, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput -00009.1
		
		It "Was given decimal value -00009.1, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput 0.01
		
		It "Was given decimal value 0.01, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptHour -VarInput -0000.0010
		
		It "Was given decimal value -0000.0010, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
Describe 'Read-PromptMinute' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: Success tests. Piping in valid integer ranges. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			0000004 | Read-PromptMinute | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			'0000004' | Read-PromptMinute | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			"0000000" | Read-PromptMinute | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Success tests. Testing valid integer ranges, using positional parameters. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			Read-PromptMinute 0000004 | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			Read-PromptMinute '0000004' | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			Read-PromptMinute "0000000" | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for non-/mandatory parameter(s) ::' {
		
		It "Has non-mandatory 'VarInput' parameter. If no input is given, Read-PromptMinute will prompt user for the missing parameter." {
			#https://stackoverflow.com/questions/45935954/testing-for-mandatory-parameters-with-pester
			#https://github.com/PowerShell/PowerShell/issues/2408#issuecomment-251140889
			((Get-Command Read-PromptMinute).Parameters['VarInput'].Attributes | ? { $_ -is [parameter] }).Mandatory | Should Be $false
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, will prompt user for input if it fails integer & range validation checks in a loop until valid input is given. ::' {
		
		Mock Read-Host {return 21}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute
		
		It "No input given. Failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput 60
		
		It "Was given out-of-range value 60, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput 2.4
		
		It "Was given decimal value 2.4, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput -2
		
		It "Was given decimal value -2, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput -00009
		
		It "Was given decimal value -00009, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput -00009.1
		
		It "Was given decimal value -00009.1, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput 0.01
		
		It "Was given decimal value 0.01, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		$result = Read-PromptMinute -VarInput -0000.0010
		
		It "Was given decimal value -0000.0010, but failed over to mocked value 21" {
			$result | Should Be 21
		}
		
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
Describe 'Read-PromptYear' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: Success tests. Piping in valid integer ranges. ::' {
		
		It 'Integer 4, with leading zeros (no quotes)' {
			0000004 | Read-PromptYear | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 4, with leading zeros (single quotes)' {
			'0000004' | Read-PromptYear | Should -Be 4
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		It 'Integer 0, with leading zeros (double quotes)' {
			"0000000" | Read-PromptYear | Should -Be 0
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -




