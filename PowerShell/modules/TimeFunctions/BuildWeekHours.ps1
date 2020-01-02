
# . Dot Source

. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\TimeFunctions.psm1"

. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Convert-AMPMhourTo24hour.ps1"
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\Read-PromptTimeValues.ps1"
. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\PromptForChoice-DayDate.ps1"

Function Get-UserInputDateTime {
	$UserInputDate = PromptForChoice-DayDate #-Verbose
	#Write-Host "`$UserInputDate = $UserInputDate"
	#Pause
	
	$UserInputHour = ReadPrompt-Hour
	
	$UserInputMinute = ReadPrompt-Minute
	
	# Check if we even need to prompt the user for AM/PM time
	If ($UserInputHour -gt 12 -Or $UserInputHour -eq 0) {
		$AMPM24mode = 24
	} else {
		$AMPM24mode = ReadPrompt-AMPM24 # -Verbose
	}
	
	If ($AMPM24mode -eq "AM") {
		$24hour = Convert-AMPMhourTo24hour $UserInputHour -AM
		#$24hour = Convert-AMPMhourTo24hour $UserInputHour -AM -Verbose
	} elseif ($AMPM24mode -eq "PM") {
		$24hour = Convert-AMPMhourTo24hour $UserInputHour -PM
		#$24hour = Convert-AMPMhourTo24hour $UserInputHour -PM -Verbose
	} elseif ($AMPM24mode -eq 24) {
		$24hour = $UserInputHour
	} else {
		Write-Error "AM/PM/24-hour time mode not recognized."
		Return
	}
	
	$UserPickedDateTime = Get-Date -Date $UserInputDate -Hour $24hour -Minute $UserInputMinute -Second 0 -Millisecond 0
	
	#https://ss64.com/ps/syntax-dateformats.html
	#$UserPickedDateTime = Get-Date -Date $UserPickedDateTime -Format F
	
	#
	
	Return $UserPickedDateTime
}


# Monday
$Monday = New-TimeSpan -Hours 8 -Minutes 25 -Seconds 0

# Tuesday
$Tuesday = New-TimeSpan -Hours 9 -Minutes 10 -Seconds 0


# Wednesday
$Wednesday = New-TimeSpan -Hours 9 -Minutes 5 -Seconds 0

# Thursday
$Thursday = New-TimeSpan -Hours 4 -Minutes 15 -Seconds 0
$Thursday += New-TimeSpan -Hours 2 -Minutes 50 -Seconds 0

# Friday
#$StartTime = Get-UserInputDateTime
#$EndTime = Get-UserInputDateTime

$Friday = $EndTime - $StartTime

#$Friday = New-TimeSpan -Hours 8 -Minutes 25 -Seconds 0

Clear-Host

Write-Host `r`n
Write-Host "Week's timespans:"
Write-Host `r`n

Write-Host "Monday:"
Write-Host "Hours:Mins = $($Monday.Hours):$($Monday.Minutes)"
Write-Host "     Hours = $($Monday.TotalHours) hours"
Write-Host `r`n


Write-Host "Tuesday:"
Write-Host "Hours:Mins = $($Tuesday.Hours):$($Tuesday.Minutes)"
Write-Host "     Hours = $($Tuesday.TotalHours) hours"
Write-Host `r`n


Write-Host "Wednesday:"
Write-Host "Hours:Mins = $($Wednesday.Hours):$($Wednesday.Minutes)"
Write-Host "     Hours = $($Wednesday.TotalHours) hours"
Write-Host `r`n


Write-Host "Thursday:"
Write-Host "Hours:Mins = $($Thursday.Hours):$($Thursday.Minutes)"
Write-Host "     Hours = $($Thursday.TotalHours) hours"
Write-Host `r`n


Write-Host "Friday:"
Write-Host "Hours:Mins = $($Friday.Hours):$($Friday.Minutes)"
Write-Host "     Hours = $($Friday.TotalHours) hours"
Write-Host `r`n

$TotalWeekHours = $Monday + $Tuesday + $Wednesday + $Thursday + $Friday

Write-Host "Total hours: $($TotalWeekHours.TotalHours)"
Write-Host `r`n



