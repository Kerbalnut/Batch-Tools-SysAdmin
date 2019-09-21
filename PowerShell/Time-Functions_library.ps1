
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
            $StartAMPM
			Write-Host "AM time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		'P' { # P - PM time
            $StartAMPM
			Write-Host "PM time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		2 { # 2 - 24-hour time
            $StartAMPM
			Write-Host "24-hour time ('$ChoiceAMPM24hour') option selected."
			Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
			Write-Host `r`n
		}
		default { # Choice not recognized.
			$StartAMPM
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


$StartAMPM

$StartTime = Get-Date -Hour $StartHour -Minute $StartMin

$StartTime

#

$EndHour = Read-Host -Prompt "Enter End hour"

$EndMin = Read-Host -Prompt "Enter End minute"

$EndAMPM

$EndTime = Get-Date -Hour $EndHour -Minute $EndMin

$EndTime

