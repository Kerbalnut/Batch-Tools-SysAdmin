
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

#

$TodayDay = Get-Date -UFormat %d

$TodayDay = Get-Date

$TodayDay

$Yesterday = (Get-Date).AddDays(-1)

$Yesterday

#

$StartHour = Read-Host -Prompt "Enter Start hour"

$StartMin = Read-Host -Prompt "Enter Start minute"

do {
	$ChoiceAMPM24hour = Read-Host -Prompt "[A]M, [P]M, or [2]4 hour? [A\P\2]"
	switch ($ChoiceAMPM24hour) {
		'A'	{ # A - AM time
            $StartAMPM = "AM"
			Write-Host "AM time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		'P' { # P - PM time
            $StartAMPM = "PM"
			Write-Host "PM time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		2 { # 2 - 24-hour time
            $StartAMPM = "24"
			Write-Host "24-hour time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		default { # Choice not recognized.
            Write-Host `r`n
			Write-Host "Choice `"$ChoiceAMPM24hour`" not recognized. Options must be AM, PM, or 24-hour."
			Write-Host `r`n
			#Break #help about_Break
			PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
			Write-Host `r`n
		}
	}
}
until ($ChoiceAMPM24hour -eq 'A' -Or $ChoiceAMPM24hour -eq 'P' -Or $ChoiceAMPM24hour -eq 2)

If ($StartAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -AM
}

If ($StartAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -PM
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
    $24hour = Convert-AMPMhourTo24hour $EndHour -AM
}

If ($EndAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -PM
}

If ($EndAMPM -eq 24) {
    $24hour = $EndHour
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime

