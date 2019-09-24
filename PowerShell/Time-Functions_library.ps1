
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

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

PAUSE

#

$StartHour = Read-Host -Prompt "Enter Start hour"

$StartMin = Read-Host -Prompt "Enter Start minute"

$StartAMPM = ReadPrompt-AMPM24

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

