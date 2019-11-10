
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

#. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"

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
	
	
	#-----------------------------------------------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}
#=======================================================================================================================

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
#1. Testing Convert-AMPMhourTo24hour
#=======================================================================================================================

$SectionName = "#1. Testing Convert-AMPMhourTo24hour"

$ChoiceSkip = PromptForChoice-YesNoSectionSkip $SectionName

If ($ChoiceSkip -eq 'N') {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

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

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

help Convert-AMPMhourTo24hour

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host "help Convert-AMPMhourTo24hour -full"
Write-Warning "Executing `"help Convert-AMPMhourTo24hour -full`" from a script environment during run will not display any of the extra information from the -Full switch. The command must be executed from the command line to get entire help content."

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 0 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 1 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 12 -AM


Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 09.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 09.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 12.1 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 11.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 11.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 11 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 011 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 9.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 9.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 009 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 09 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 9 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour -9 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour .9 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 0.9 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour .0 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 0.0 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host `r`n

Write-Host "Example #1:"

$AMPMhour = 4

$OutputVar = Convert-AMPMhourTo24hour $AMPMhour -PM

Write-Host "$AMPMhour PM = $OutputVar           (24-hour)"

Write-Host `r`n

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host `r`n

Write-Host "Example #2:"

Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM

$NowHour = Get-Date -UFormat %I
Write-Host "`$NowHour = $NowHour"

$OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM)
Write-Host "`$OutputVar = $OutputVar"

Write-Host "$NowHour PM = $OutputVar           (24-hour)"
Write-Host "$(Get-Date -UFormat %I) PM = $OutputVar           (24-hour)"

Write-Host `r`n

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host `r`n

Write-Host "Example #3:"

Get-Random -Minimum 1 -Maximum 12 | Convert-AMPMhourTo24hour -PM

Get-Random -Minimum 1 -Maximum 12 | Tee-Object -Variable Randomvar | Convert-AMPMhourTo24hour -PM
Write-Host "`$Randomvar = $Randomvar"

$OutputVar = (Get-Random -Minimum 1 -Maximum 12 | Tee-Object -Variable Randomvar | Convert-AMPMhourTo24hour -PM)
Write-Host "$Randomvar PM = $OutputVar           (24-hour)"

Write-Host `r`n

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

