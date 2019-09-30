
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

Write-Host "# Start Time #`n`r`n"

Write-HorizontalRuleAdv -SingleLine

#$StartHour = Read-Host -Prompt "Enter Start hour"
#$StartHour = ReadPrompt-Hour -Verbose
$StartHour = ReadPrompt-Hour -Verbose

Write-HorizontalRuleAdv -DashedLine

#

#-----------------------------------------------------------------------------------------------------------------------

<#

$StartHour = (0000004 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = ('0000004' | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = ("0000000" | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = (24 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = (2.4 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = (-2 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = (0.01 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

$StartHour = (-0000.0010 | ReadPrompt-Hour -Verbose)

#>

#-----------------------------------------------------------------------------------------------------------------------

#

Write-HorizontalRuleAdv -SingleLine

#$StartMin = Read-Host -Prompt "Enter Start minute"
#$StartMin = ReadPrompt-Minute -Verbose
$StartMin = ReadPrompt-Minute -Verbose

Write-HorizontalRuleAdv -DashedLine

Write-HorizontalRuleAdv -SingleLine

$StartAMPM = ReadPrompt-AMPM24

Write-HorizontalRuleAdv -SingleLine

If ($StartAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -AM -Verbose
}

If ($StartAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -PM -Verbose
}

If ($StartAMPM -eq 24) {
    $24hour = $StartHour
}

$Timestamp = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

$StartTime = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

$StartTime

#

$EndHour = Read-Host -Prompt "Enter End hour"

$EndMin = Read-Host -Prompt "Enter End minute"

$EndAMPM = ReadPrompt-AMPM24

If ($EndAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -AM -Verbose
}

If ($EndAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -PM -Verbose
}

If ($EndAMPM -eq 24) {
    $24hour = $EndHour
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime





