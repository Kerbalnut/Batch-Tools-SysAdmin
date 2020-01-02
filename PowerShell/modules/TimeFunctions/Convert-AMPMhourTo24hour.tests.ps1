
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

#. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Begin Pester testing.
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

#=======================================================================================================================
Describe 'Convert-AMPMhourTo24hour Success/Failure Tests' {
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
	
	Context ':: Success tests, different input methods ::' {
		
		It 'Valid integer input using named parameters, AM' {
			Convert-AMPMhourTo24hour -Hours 1 -AM | Should Be 1
		}
		
		It 'Valid integer input using positional parameters, AM' {
			Convert-AMPMhourTo24hour 1 -AM | Should Be 1
		}
		
		It 'Valid integer input using positional parameters, single-quotes, AM' {
			Convert-AMPMhourTo24hour '1' -AM | Should Be 1
		}
		
		It 'Valid integer input using positional parameters, double-quotes, AM' {
			Convert-AMPMhourTo24hour "1" -AM | Should Be 1
		}
		
		It 'Valid integer input using piped-in parameters, AM' {
			1 | Convert-AMPMhourTo24hour -AM | Should Be 1
		}
		
		It 'Valid integer input using piped-in parameters, single-quotes, AM' {
			'1' | Convert-AMPMhourTo24hour -AM | Should Be 1
		}
		
		It 'Valid integer input using piped-in parameters, double-quotes, AM' {
			"1" | Convert-AMPMhourTo24hour -AM | Should Be 1
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for aliases ::' {
		
		It "Input using positional parameters, selecting AM using '-a' switch alias" {
			Convert-AMPMhourTo24hour 1 -a | Should Be 1
		}
		
		It "Input using positional parameters, selecting PM using '-p' switch alias" {
			Convert-AMPMhourTo24hour 1 -p | Should Be 13
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	<#
	12.1
	11.6
	11.4
	11
	011
	9.6
	9.4
	09
	9
	-9
	.9
	0.9
	.0
	0.0
	#>
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Testing for non-/mandatory parameter(s) ::' {
		
		It 'Missing all parameters, should fail' {
			{Convert-AMPMhourTo24hour} | Should Throw
		}
		
		It 'Declares a valid positional parameter input, but with no AM/PM switch choice selection, should fail' {
			{Convert-AMPMhourTo24hour 1} | Should Throw
		}
		
		Write-Verbose "Convert-AMPMhourTo24hour -AM"
		Write-Verbose "Convert-AMPMhourTo24hour -PM"
		It "With only an AM/PM switch choice selection, and no Hours value provided, PowerShell should prompt user for mandatory parameter 'Hours'. `"Hours`" is mandatory:" {
			#https://stackoverflow.com/questions/45935954/testing-for-mandatory-parameters-with-pester
			#https://github.com/PowerShell/PowerShell/issues/2408#issuecomment-251140889
			((Get-Command Convert-AMPMhourTo24hour).Parameters['Hours'].Attributes | ? { $_ -is [parameter] }).Mandatory | Should Be $true
		}
		
		It 'Cannot be both AM and PM, should fail (no value)' {
			{Convert-AMPMhourTo24hour -AM -PM} | Should Throw
		}
		
		It 'Cannot be both AM and PM, should fail (valid positional parameter)' {
			{Convert-AMPMhourTo24hour 1 -AM -PM} | Should Throw
		}
		
		It 'Cannot be both AM and PM, should fail (valid piped-in parameter)' {
			{1 | Convert-AMPMhourTo24hour -AM -PM} | Should Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Whole numbers, positional parameters, AM ::' {
		
		It '0 below range 1-12 for AM/PM hours, should fail' {
			{Convert-AMPMhourTo24hour 0 -AM} | Should Throw
		}
		
		It '1 within range 1-12 for AM/PM hours, should pass 1 back' {
			Convert-AMPMhourTo24hour 1 -AM | Should Be 1
		}
		
		It '11 within range 1-12 for AM/PM hours, should pass 11 back' {
			Convert-AMPMhourTo24hour 11 -AM | Should Be 11
		}
		
		It '13 above range 1-12 for AM hours, should fail' {
			{Convert-AMPMhourTo24hour 13 -AM} | Should Throw
		}
		
		It '13 above range 1-12 for PM hours, should fail' {
			{Convert-AMPMhourTo24hour 13 -PM} | Should Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Success tests, leading zeros, AM ::' {
		
		It '9 within range 1-12 for AM/PM hours, should pass 9 back' {
			Convert-AMPMhourTo24hour 9 -AM | Should Be 9
		}
		
		It '09 within range 1-12 for AM/PM hours, should pass 9 back' {
			Convert-AMPMhourTo24hour 09 -AM | Should Be 9
		}
		
		It '009 within range 1-12 for AM/PM hours, should pass 9 back' {
			Convert-AMPMhourTo24hour 009 -AM | Should Be 9
		}
		
		It '011 within range 1-12 for AM/PM hours, should pass 11 back' {
			Convert-AMPMhourTo24hour 011 -AM | Should Be 11
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, negative input, AM/PM ::' {
		
		It 'Positional parameter: -12 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -12 -AM} | Should Throw
		}
		
		It 'Positional parameter: -12 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -12 -PM} | Should Throw
		}
		
		It 'Positional parameter: -1 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -1 -AM} | Should Throw
		}
		
		It 'Positional parameter: -1 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -1 -PM} | Should Throw
		}
		
		It 'Piped-in parameter: -1 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-1 | Convert-AMPMhourTo24hour -AM -ErrorAction Stop} | Should Throw
		}
		
		It 'Piped-in parameter: -1 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-1 | Convert-AMPMhourTo24hour -PM -ErrorAction Stop} | Should Throw
		}
		
		It 'Positional parameter: -0 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -0 -AM} | Should Throw
		}
		
		It 'Positional parameter: -0 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -0 -PM} | Should Throw
		}
		
		It 'Piped-in parameter: -0 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-0 | Convert-AMPMhourTo24hour -AM -ErrorAction Stop} | Should Throw
		}
		
		It 'Piped-in parameter: -0 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-0 | Convert-AMPMhourTo24hour -PM -ErrorAction Stop} | Should Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, negative input w/ leading zeros, AM/PM ::' {
		
		It 'Positional parameter: -012 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -012 -AM} | Should Throw
		}
		
		It 'Positional parameter: -012 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -012 -PM} | Should Throw
		}
		
		It 'Positional parameter: -001 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -001 -AM} | Should Throw
		}
		
		It 'Positional parameter: -001 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -001 -PM} | Should Throw
		}
		
		It 'Piped-in parameter: -001 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{ -001 | Convert-AMPMhourTo24hour -AM -ErrorAction Stop} | Should -Throw
		}
		
		It 'Piped-in parameter: -001 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-001 | Convert-AMPMhourTo24hour -PM -ErrorAction Stop} | Should -Throw
		}
		
		It 'Positional parameter: -0000000 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -0000000 -AM} | Should Throw
		}
		
		It 'Positional parameter: -0000000 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -0000000 -PM} | Should Throw
		}
		
		It 'Piped-in parameter: -0000000 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-0000000 | Convert-AMPMhourTo24hour -AM -ErrorAction Stop} | Should -Throw
		}
		
		It 'Piped-in parameter: -0000000 is not positive, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{-0000000 | Convert-AMPMhourTo24hour -PM -ErrorAction Stop} | Should -Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, decimal input, AM/PM ::' {
		
		It 'Positional parameter: 12.1 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour 12.1 -AM} | Should Throw
		}
		
		It 'Positional parameter: 11.6 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour 11.6 -AM} | Should Throw
		}
		
		It 'Positional parameter: 9.4 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour 9.4 -AM} | Should Throw
		}
		
		It 'Positional parameter: .9 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values.. Should fail.' {
			{Convert-AMPMhourTo24hour .9 -AM} | Should Throw
		}
		
		It 'Positional parameter: .0 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values.. Should fail.' {
			{Convert-AMPMhourTo24hour .0 -AM} | Should Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, decimal input w/ leading zeros, AM/PM ::' {
		
		It 'Positional parameter: 09.6 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour 09.6 -AM} | Should Throw
		}
		
		It 'Positional parameter: 09.4 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour 09.4 -AM} | Should Throw
		}
		
		It 'Positional parameter: 0.9 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour 0.9 -AM} | Should Throw
		}
		
		It 'Positional parameter: 0.0 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour 0.0 -AM} | Should Throw
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Failure tests, negative decimal w/ leading zeros, AM/PM ::' {
		
		It 'Positional parameter: -09.6 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour -09.6 -AM} | Should Throw
		}
		
		It 'Positional parameter: -09.4 is a decimal, not an integer. Should fail.' {
			{Convert-AMPMhourTo24hour -09.4 -AM} | Should Throw
		}
		
		It 'Positional parameter: 0.9 is a decimal, not an integer, not within the 1-12 range of AM/PM hour values. Should fail.' {
			{Convert-AMPMhourTo24hour -00000.00010 -AM} | Should Throw
		}
		
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
Describe 'Convert-AMPMhourTo24hour Examples' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: Exampe #1: ::' {
		
		It 'Help example:' {
			$AMPMhour = 4
			$OutputVar = Convert-AMPMhourTo24hour $AMPMhour -PM
			$OutputVar | Should -Be 16
		}
		
		It 'Variation #1: AM' {
			$AMPMhour = 4
			$OutputVar = Convert-AMPMhourTo24hour $AMPMhour -AM
			$OutputVar | Should -Be 4
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Exampe #2: ::' {
		
		Mock Get-Date { return "01" } -Verifiable -ParameterFilter {$UFormat -match "%I"}
		
		It 'Help example: Pt. 1' {
			Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM | Should -Be 13
		}
		
		$NowHour = Get-Date -UFormat %I
		
		It 'Help example: Pt. 2' {
			$NowHour | Should -Be 1
		}
		
		$OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM)
		
		It 'Help example: Pt. 3' {
			$OutputVar | Should -Be 13
		}
		
		It 'Help example: Pt. 4.a' {
			Write-Output "$NowHour PM = $OutputVar           (24-hour)" | Should -Be "01 PM = 13           (24-hour)"
		}
		
		It 'Help example: Pt. 4.b' {
			Write-Output "$(Get-Date -UFormat %I) PM = $OutputVar           (24-hour)" | Should -Be "01 PM = 13           (24-hour)"
		}
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Context ':: Exampe #3: ::' {
		
		Mock Get-Random { return "1" } -Verifiable
		
		It 'Help example: Pt. 1' {
			Get-Random -Minimum 1 -Maximum 12 | Convert-AMPMhourTo24hour -PM | Should -Be 13
		}
		
		It 'Help example: Pt. 2' {
			Get-Random -Minimum 1 -Maximum 12 | Tee-Object -Variable Randomvar | Convert-AMPMhourTo24hour -PM | Should -Be 13
			$Randomvar | Should -Be 1
		}
		
		It 'Help example: Pt. 3' {
			Get-Random -Minimum 1 -Maximum 12 | Tee-Object -Variable Randomvar | Convert-AMPMhourTo24hour -PM | Should -Be 13
			$Randomvar | Should -Be 1
		}
		
		$OutputVar = (Get-Random -Minimum 1 -Maximum 12 | Tee-Object -Variable Randomvar | Convert-AMPMhourTo24hour -PM)
		
		It 'Help example: Pt. 4.a' {
			$OutputVar | Should -Be 13
		}
		
		It 'Help example: Pt. 4.b' {
			$Randomvar | Should -Be 1
		}
		
	}
	
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
Describe 'Convert-AMPMhourTo24hour 0 thru 23 conversion test' {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#-----------------------------------------------------------------------------------------------------------------------
	
	Context ':: 24-hour range input = result check ::' {
		
<#Conversion table between AM/PM hours and 24-hour time format:

--AM/PM----24-hr-------------------------------------------------------------------------------------
12:00 AM = 00:00____*** exception: if AM-hours = 12, then 24-hours = 0			\--------  (Midnight)
 1:00 AM = 01:00	\															 |
 2:00 AM = 02:00	 |															 |
 3:00 AM = 03:00	 |															 |
 4:00 AM = 04:00	 |															 |
 5:00 AM = 05:00	 |															 |
 6:00 AM = 06:00	 |------- AM-hour = 24-hours								 |-------  AM
 7:00 AM = 07:00	 |															 |
 8:00 AM = 08:00	 |															 |
 9:00 AM = 09:00	 |															 |
10:00 AM = 10:00	 |															 |
11:00 AM = 11:00____/___________________________________________________________/____________________
12:00 PM = 12:00____*** exception: if PM-hours = 12, then 24-hours = 12			\--------  (Noon)
 1:00 PM = 13:00	\															 |
 2:00 PM = 14:00	 |															 |
 3:00 PM = 15:00	 |															 |
 4:00 PM = 16:00	 |															 |
 5:00 PM = 17:00	 |															 |
 6:00 PM = 18:00	 |------- (PM-hours + 12) = 24-hours						 |-------  PM
 7:00 PM = 19:00	 |															 |
 8:00 PM = 20:00	 |															 |
 9:00 PM = 21:00	 |															 |
10:00 PM = 22:00	 |															 |
11:00 PM = 23:00____/___________________________________________________________/
12:00 AM = 00:00____*** exception: if AM-hours = 12, then 24-hours = 0			\--------  (Midnight)
-----------------------------------------------------------------------------------------------------
#>
		
		It '12:00 AM = 00:00 (Midnight)' {
			# AM hour = 24-hour, EXCEPT if AM-hours = 12, then 24-hours = 0
			Convert-AMPMhourTo24hour 12 -AM | Should -Be 0
		}
		
		It '1:00 AM = 01:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 1 -AM | Should -Be 1
		}
		
		It '2:00 AM = 02:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 2 -AM | Should -Be 2
		}
		
		It '3:00 AM = 03:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 3 -AM | Should -Be 3
		}
		
		It '4:00 AM = 04:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 4 -AM | Should -Be 4
		}
		
		It '5:00 AM = 05:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 5 -AM | Should -Be 5
		}
		
		It '6:00 AM = 06:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 6 -AM | Should -Be 6
		}
		
		It '7:00 AM = 07:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 7 -AM | Should -Be 7
		}
		
		It '8:00 AM = 08:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 8 -AM | Should -Be 8
		}
		
		It '9:00 AM = 09:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 9 -AM | Should -Be 9
		}
		
		It '10:00 AM = 10:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 10 -AM | Should -Be 10
		}
		
		It '11:00 AM = 11:00' {
			# AM hour = 24-hour
			Convert-AMPMhourTo24hour 11 -AM | Should -Be 11
		}
		
		It '12:00 PM = 12:00 (Noon)' {
			# (PM hour + 12) = 24-hour, EXCEPT if PM-hours = 12, then 24-hours = 12
			Convert-AMPMhourTo24hour 12 -PM | Should -Be 12
		}
		
		It '1:00 PM = 13:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 1 -PM | Should -Be 13
		}
		
		It '2:00 PM = 14:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 2 -PM | Should -Be 14
		}
		
		It '3:00 PM = 15:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 3 -PM | Should -Be 15
		}
		
		It '4:00 PM = 16:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 4 -PM | Should -Be 16
		}
		
		It '5:00 PM = 17:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 5 -PM | Should -Be 17
		}
		
		It '6:00 PM = 18:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 6 -PM | Should -Be 18
		}
		
		It '7:00 PM = 19:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 7 -PM | Should -Be 19
		}
		
		It '8:00 PM = 20:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 8 -PM | Should -Be 20
		}
		
		It '9:00 PM = 21:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 9 -PM | Should -Be 21
		}
		
		It '10:00 PM = 22:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 10 -PM | Should -Be 22
		}
		
		It '11:00 PM = 23:00' {
			# (PM hour + 12) = 24-hour
			Convert-AMPMhourTo24hour 11 -PM | Should -Be 23
		}
		
		It '12:00 AM = 00:00 (Midnight)' {
			# AM hour = 24-hour, EXCEPT if AM-hours = 12, then 24-hours = 0
			Convert-AMPMhourTo24hour 12 -AM | Should -Be 0
		}
		
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
