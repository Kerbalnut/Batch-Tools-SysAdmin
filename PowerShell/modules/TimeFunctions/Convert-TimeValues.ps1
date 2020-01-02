
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\PromptForChoice-DayDate.ps1"

#

#=======================================================================================================================

#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n`r`n"

#$TodayDay = Get-Date -UFormat %d

$TodayDay = Get-Date

Write-Verbose "`rToday: $TodayDay`r"

$Yesterday = (Get-Date).AddDays(-1)

Write-Verbose "Yesterday: $Yesterday"

$Tomorrow = (Get-Date).AddDays(1)

Write-Verbose "Tomorrow: $Tomorrow"

#

#-----------------------------------------------------------------------------------------------------------------------

Write-Host "`r`n`r`n"

#-----------------------------------------------------------------------------------------------------------------------

#PAUSE

#

#=======================================================================================================================

#

# Select Day:

#

#=======================================================================================================================

# Get Date to enter time for
$PickedDate = PromptForChoice-DayDate -TitleName "Select day to enter times for:"

# Collect time (display header)
Clear-Host
Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
Write-Host "`r`nSelected date: $($PickedDate.ToLongDateString())`n"
Write-Host "`r`n# Start Time #`n`r`n" -ForegroundColor Yellow

#Get Start time hour value
$StartHour = ReadPrompt-Hour

#Get Start time minute value
$StartMin = ReadPrompt-Minute

# Check if we even need to prompt the user for AM/PM time
If ($StartHour -gt 12 -Or $StartHour -eq 0) {
	$StartAMPM = 24
} else {
	$StartAMPM = ReadPrompt-AMPM24 # -Verbose
}

#Write-HorizontalRuleAdv -SingleLine

If ($StartAMPM -eq "AM") {
	$24hour = Convert-AMPMhourTo24hour $StartHour -AM
	#$24hour = Convert-AMPMhourTo24hour $StartHour -AM -Verbose
} elseif ($StartAMPM -eq "PM") {
	$24hour = Convert-AMPMhourTo24hour $StartHour -PM
	#$24hour = Convert-AMPMhourTo24hour $StartHour -PM -Verbose
} elseif ($StartAMPM -eq 24) {
	$24hour = $StartHour
} else {
	Write-Error "AM/PM/24-hour time mode not recognized."
}

$Timestamp = Get-Date -Date $PickedDate -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

Write-Host "Timestamp = $Timestamp"

#https://ss64.com/ps/syntax-dateformats.html
$Timestamp = Get-Date -Date $Timestamp -Format F

Write-Host "Timestamp = $Timestamp"

$StartTime = Get-Date -Date $PickedDate -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

Write-Host "Start time = $StartTime"

#https://ss64.com/ps/syntax-dateformats.html
#$StartTime = Get-Date -Date $StartTime -Format F

#Write-Host "Start time = $StartTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n# End Time #`n`r`n" -ForegroundColor Yellow

#$EndHour = Read-Host -Prompt "Enter End hour"
#$EndHour = ReadPrompt-Hour -Verbose
$EndHour = ReadPrompt-Hour

#$EndMin = Read-Host -Prompt "Enter End minute"
#$EndMin = ReadPrompt-Minute -Verbose
$EndMin = ReadPrompt-Minute

If ($EndHour -gt 12 -Or $EndHour -eq 0) {
	$EndAMPM = 24
} else {
	#$EndAMPM = ReadPrompt-AMPM24 -Verbose
	$EndAMPM = ReadPrompt-AMPM24
}

#Write-HorizontalRuleAdv -SingleLine

If ($EndAMPM -eq "AM") {
	#$24hour = Convert-AMPMhourTo24hour $EndHour -AM -Verbose
	$24hour = Convert-AMPMhourTo24hour $EndHour -AM
} elseif ($EndAMPM -eq "PM") {
	#$24hour = Convert-AMPMhourTo24hour $EndHour -PM -Verbose
	$24hour = Convert-AMPMhourTo24hour $EndHour -PM
} elseif ($EndAMPM -eq 24) {
	$24hour = $EndHour
} else {
	Write-Error "AM/PM/24-hour time mode not recognized."
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

Write-Host "Timestamp = $Timestamp"

#https://ss64.com/ps/syntax-dateformats.html
$Timestamp = Get-Date -Date $Timestamp -Format F

Write-Host "Timestamp = $Timestamp"

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

Write-Host "End time = $EndTime"

#https://ss64.com/ps/syntax-dateformats.html
#$EndTime = Get-Date -Date $EndTime -Format F

#Write-Host "End time = $EndTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n"

Write-HR

Write-Host "`r`n`r`n"

#

$StartTimeStr = Get-Date $StartTime -Format F

$EndTimeStr = Get-Date $EndTime -Format F

Write-Host "Start time = $(Get-Date $StartTime -Format F)"

Write-Host "End time = $(Get-Date $EndTime -Format F)"

#$StartTime | Get-Member

$StartTimeOnly = ($StartTime).TimeOfDay

$EndTimeOnly = ($EndTime).TimeOfDay

Write-Host "Start time = $StartTimeOnly"

Write-Host "End time = $EndTimeOnly"

#$StartTimeOnly | Get-Member

$StartTime = Get-Date $StartTime

$EndTime = Get-Date $EndTime

Write-Host "Start time = $StartTime"

Write-Host "End time = $EndTime"

#

$TimeDifference = $EndTime - $StartTime

Write-Host "Time Duration = $TimeDifference (hours:minutes)"

#$TimeDifference | Get-Member

#$TimeDifferenceHours = $TimeDifference.Hours

#Write-Host "Time Duration (hours) = $TimeDifferenceHours"

$TimeDifferenceHours = $TimeDifference.TotalHours

Write-Host "Time Duration = $TimeDifferenceHours (hours)"

#

#$TimeGoal = Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0

#Write-Host "Time goal = $TimeGoal"

#$TimeGoalStr = $TimeGoal.ToShortTimeString()

#Write-Host "Time goal = $TimeGoalStr"

#$TimeGoalStr = $TimeGoal.ToLongTimeString()

#Write-Host "Time goal = $TimeGoalStr"

#$TimeGoalStr = Get-Date -Date $TimeGoal -Format t

#Write-Host "Time goal = $TimeGoalStr"

$TimeGoal = (Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0) - (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
$TimeGoal = (Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0).TimeOfDay

Write-Host "Time goal = $TimeGoal (hours:minutes)"

#$TimeGoal | Get-Member

#$TimeGoalHours = $TimeGoal.Hours

#Write-Host "Time goal (hours) = $TimeGoalHours"

$TimeGoalHours = $TimeGoal.TotalHours

Write-Host "Time goal = $TimeGoalHours (hours)"

#

$TimeRemaining = $TimeGoal - ($EndTime - $StartTime)

Write-Host "Time left = $TimeRemaining (hours:minutes)"

#$TimeRemaining = Get-Date -Date $TimeRemaining -Format t

#Write-Host "Time left = $TimeRemaining"

#$TimeRemaining | Get-Member

#$TimeRemainingHours = $TimeRemaining.Hours

#Write-Host "Time left (hours) = $TimeRemainingHours"

$TimeRemainingHours = $TimeRemaining.TotalHours

Write-Host "Time left = $TimeRemainingHours (hours)"

#

$AccumulatedTime = (Get-Date -Hour 8 -Minute 10 -Second 0 -Millisecond 0).TimeOfDay
$AccumulatedTime += (Get-Date -Hour 8 -Minute 15 -Second 0 -Millisecond 0).TimeOfDay
$AccumulatedTime += (Get-Date -Hour 8 -Minute 45 -Second 0 -Millisecond 0).TimeOfDay

$TimeGoal = (Get-Date -Hour 33 -Minute 0 -Second 0 -Millisecond 0).TimeOfDay

$TimeRemaining = $TimeGoal - $AccumulatedTime
$TimeRemaining = 33 - $AccumulatedTime.TotalHours

$AccumulatedTimeToday = (Get-Date -Hour 12 -Minute 25 -Second 0 -Millisecond 0).TimeOfDay - (Get-Date -Hour 8 -Minute 45 -Second 0 -Millisecond 0).TimeOfDay

$HourFormatted = ReadPrompt-Hour


$TimeRemainingToday = 33 - ($AccumulatedTime.TotalHours + $AccumulatedTimeToday.TotalHours)
$TimeRemainingToday = $TimeRemainingToday

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n"

Write-HR

Write-Host "`r`n"

#


#

#=======================================================================================================================

#



