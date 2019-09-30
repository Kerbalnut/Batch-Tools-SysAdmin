
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

#

#=======================================================================================================================

#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------

#

$TodayDay = Get-Date -UFormat %d

$TodayDay = Get-Date

$TodayDay

$Yesterday = (Get-Date).AddDays(-1)

$Yesterday

#

$Midnight = Get-Date -Hour 23 -Minute 52 -Second 0 -Millisecond 0

$Midnight

$PastMidnight = Get-Date -Hour 0 -Minute 15 -Second 0 -Millisecond 0

$PastMidnight

#PAUSE

#

#=======================================================================================================================

#



#

#=======================================================================================================================

#

Write-Host "# Start Time #`n`r`n"

#Write-HorizontalRuleAdv -SingleLine

#$StartHour = Read-Host -Prompt "Enter Start hour"
#$StartHour = ReadPrompt-Hour -Verbose
$StartHour = ReadPrompt-Hour

#Write-HorizontalRuleAdv -DashedLine

#$StartMin = Read-Host -Prompt "Enter Start minute"
#$StartMin = ReadPrompt-Minute -Verbose
$StartMin = ReadPrompt-Minute

#Write-HorizontalRuleAdv -DashedLine

If ($StartHour -gt 12 -Or $StartHour -eq 0) {
	$StartAMPM = 24
} else {
	$StartAMPM = ReadPrompt-AMPM24
}

#Write-HorizontalRuleAdv -SingleLine

If ($StartAMPM -eq "AM") {
    #$24hour = Convert-AMPMhourTo24hour $StartHour -AM -Verbose
    $24hour = Convert-AMPMhourTo24hour $StartHour -AM
} elseif ($StartAMPM -eq "PM") {
    #$24hour = Convert-AMPMhourTo24hour $StartHour -PM -Verbose
    $24hour = Convert-AMPMhourTo24hour $StartHour -PM
} elseif ($StartAMPM -eq 24) {
    $24hour = $StartHour
} else {
	Write-Error "AM/PM/24-hour time not recognized."
}

$Timestamp = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

$StartTime = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

Write-Host "Start time = $StartTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n# End Time #`n`r`n"

#$EndHour = Read-Host -Prompt "Enter End hour"
$EndHour = ReadPrompt-Hour

#$EndMin = Read-Host -Prompt "Enter End minute"
$EndMin = ReadPrompt-Minute

If ($EndHour -gt 12 -Or $EndHour -eq 0) {
	$EndAMPM = 24
} else {
	$EndAMPM = ReadPrompt-AMPM24
}

#Write-HorizontalRuleAdv -SingleLine

If ($EndAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -AM -Verbose
    #$24hour = Convert-AMPMhourTo24hour $EndHour -AM
} elseif ($EndAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -PM -Verbose
    #$24hour = Convert-AMPMhourTo24hour $EndHour -PM
} elseif ($EndAMPM -eq 24) {
    $24hour = $EndHour
} else {
	Write-Error "AM/PM/24-hour time not recognized."
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

Write-Host "End tiem = $EndTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

$TimeDuration = $EndTime - $StartTime

Write-Host "Time Duration = $TimeDuration"


#

#=======================================================================================================================

#



