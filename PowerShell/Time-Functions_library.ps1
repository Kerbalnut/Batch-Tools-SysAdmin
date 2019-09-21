
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


#doesn't work
$Midnight = Get-Date -Hour 24

$Midnight


$Midnight = Get-Date -Hour 23

$Midnight


$PastMidnight = Get-Date -Hour 0

$PastMidnight

$PastMidnight = Get-Date -Hour 1

$PastMidnight

  


:: We now have the time in 24-hour hh-mm-ss format e.g. 21-31-39 or 01-57-25
::ECHO Sortable time = "%_TIME_SORT%"
SET "_TIME_ANTE_POST=AM"
:: Extract hours
SET "_TIME_24HOUR=%_TIME_SORT:~0,2%"
IF %_TIME_24HOUR% LSS 10 SET "_TIME_24HOUR=%_TIME_24HOUR:~1%"
:: https://ss64.com/nt/if.html
IF %_TIME_24HOUR% GEQ 12 (
	SET "_TIME_ANTE_POST=PM"
	REM https://ss64.com/nt/set.html
	IF %_TIME_24HOUR% GTR 12 (
		SET /A "_TIME_12HOUR=_TIME_24HOUR-12"
	) ELSE (
		SET "_TIME_12HOUR=%_TIME_24HOUR%"
	)
) ELSE (
	SET "_TIME_12HOUR=%_TIME_24HOUR%"
)
:: If 24hr time 'hours' is 00, change to 12 (for 12:00 AM)
IF %_TIME_24HOUR% EQU 0 SET "_TIME_12HOUR=12"
:: Add spaces
IF %_TIME_12HOUR% LSS 10 SET "_TIME_12HOUR= %_TIME_12HOUR%"
:: Skip the hours and extract the rest of :mm:ss from hh:mm:ss e.g. :31:39
SET "_TIME_COLONS=%_TIME_SML:~2%"
SET "_TIME_AMPM=%_TIME_12HOUR%%_TIME_COLONS% %_TIME_ANTE_POST%"
::ECHO 12-hour time with spaces = "%_TIME_AMPM%"
:: We now have the time in 12-hour hh:mm:ss AM/PM format e.g. " 9:31:39 PM"








$StartTime = Get-Date -Hour $StartHour -Minute $StartMin

$StartTime

#

$EndHour = Read-Host -Prompt "Enter End hour"

$EndMin = Read-Host -Prompt "Enter End minute"

$EndAMPM

$EndTime = Get-Date -Hour $EndHour -Minute $EndMin

$EndTime

