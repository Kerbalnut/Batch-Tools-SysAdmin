
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

#. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Begin Pester testing.
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

#=======================================================================================================================
Describe 'Convert-AMPMhourTo24hour' {
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
		
		It 'Cannot be both AM and PM, should fail' {
			{Convert-AMPMhourTo24hour -AM -PM} | Should Throw
		}
		
		It 'Cannot be both AM and PM, should fail' {
			{Convert-AMPMhourTo24hour 1 -AM -PM} | Should Throw
		}
		
		It 'Cannot be both AM and PM, should fail' {
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
