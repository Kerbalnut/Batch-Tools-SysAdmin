
#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-AMPM24 { #------------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param()
	
	do {
		$ChoiceAMPM24hour = Read-Host -Prompt "[A]M, [P]M, or [2]4 hour? [A\P\2]"
		switch ($ChoiceAMPM24hour) {
			'A'	{ # A - AM time
				$ResultAMPM = "AM"
				Write-Host "AM time ('$ChoiceAMPM24hour') option selected."
				Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
				Write-Host `r`n
			}
			'P' { # P - PM time
				$ResultAMPM = "PM"
				Write-Host "PM time ('$ChoiceAMPM24hour') option selected."
				Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
				Write-Host `r`n
			}
			2 { # 2 - 24-hour time
				$ResultAMPM = "24"
				Write-Host "24-hour time ('$ChoiceAMPM24hour') option selected."
				Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
				Write-Host `r`n
			}
			default { # Choice not recognized.
				Write-Host `r`n
				Write-Host "Choice `"$ChoiceAMPM24hour`" not recognized. Options must be AM, PM, or 24-hour:"
				Write-Host "                     [A] = AM"
				Write-Host "                     [P] = PM"
				Write-Host "                     [2] = 24-hour"
				Write-Host `r`n
				#Break #help about_Break
				PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
				Write-Host `r`n
			}
		}
	}
	until ($ChoiceAMPM24hour -eq 'A' -Or $ChoiceAMPM24hour -eq 'P' -Or $ChoiceAMPM24hour -eq 2)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return $ResultAMPM
	
} # End ReadPrompt-AMPM24 function -------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
