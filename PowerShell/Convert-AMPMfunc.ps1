
Function Convert-AMPMhourTo24hour {
<#
.SYNOPSIS
Convert an hour value in AM/PM format to a 24-hour value.

.DESCRIPTION
Enter a 12-hour format value plus its AM/PM value, and this cmdlet will return the equivalent 24-hour format hour value from 0-23. Must specify either -AM or -PM switch.

The abbreviations AM and PM derive from Latin:

AM = Ante meridiem: Before noon
PM = Post meridiem: After noon

https://www.timeanddate.com/time/am-and-pm.html

.PARAMETER Hours
The AM/PM hour value, from 1-12.

.PARAMETER AM
Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>

.PARAMETER PM
Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>

.EXAMPLE
#1.
The following 3 lines will convert any PM Hour value (in this case, 4) and convert it into its 24-hour equivalent.
C:\PS> $AMPMhour = 4
C:\PS> $OutputVar = Convert-AMPMhourTo24hour $AMPMhour -PM
C:\PS> Write-Host "$AMPMhour PM = $OutputVar           (24-hour)"
In this example, the output would read:
"4 PM = 16           (24-hour)"
Because 4:00 PM is equivalent to 16:00 on a 24-hour clock.

.EXAMPLE
#2.

The following single-line script will get the current hour in AM/PM format (Get-Date -UFormat %I) and convert it to 24-hour format.

C:\PS> Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM

To capture this output in a variable first, then print it out:

C:\PS> $OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM)
C:\PS> Write-Host "`$OutputVar = $OutputVar"
C:\PS> Write-Host "$(Get-Date -UFormat %I) PM = $OutputVar           (24-hour)"

For example, if the current time was 2 PM, the output would read:
"$OutputVar = 14"
"2 PM = 14           (24-hour)"

For the same thing but with AM times, simply change the -PM switch to the -AM switch:

C:\PS> $OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -AM)
C:\PS> Write-Host "`$OutputVar = $OutputVar"
C:\PS> Write-Host "$(Get-Date -UFormat %I) AM = $OutputVar           (24-hour)"

For example, if the current time was 8 PM, the output would read:
"$OutputVar = 8"
"8 AM = 8           (24-hour)"

.EXAMPLE
#3.

To get today's date, but with a different time-value, use a script block invloving Read-Host, Get-Date, and Convert-AMPMhourTo24hour, such as this:

\> $StartHour = Read-Host -Prompt "Enter Start hour"

\> $StartMin = Read-Host -Prompt "Enter Start minute"

\> do {
\>   $ChoiceAMPM24hour = Read-Host -Prompt "[A]M, [P]M, or [2]4 hour? [A\P\2]"
\>   switch ($ChoiceAMPM24hour) {
\> 	   'A' { # A - AM time
\>            $AntePost = "AM"
\>            Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
\>            $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -AM
\>     }
\>     'P' { # P - PM time
\>            $AntePost = "PM"
\>            Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
\>            $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -PM
\>     }
\>     2 { # 2 - 24-hour time
\>            $AntePost = "(24-hour)"
\>            Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
\>            $24hourFormat = $StartHour
\>     }
\>     default { # Choice not recognized.
\>            Write-Host `r`n
\>            Write-Warning "Choice `"$ChoiceAMPM24hour`" not recognized. Options must be AM, PM, or 24-hour."
\>            Write-Host `r`n
\>            #Break #help about_Break
\>            PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
\>            #Clear-Host # CLS
\>            Write-Host `r`n
\>     }
\>   }
\> } until ($ChoiceAMPM24hour -eq 'A' -Or $ChoiceAMPM24hour -eq 'P' -Or $ChoiceAMPM24hour -eq 2)
\> Write-Verbose "12-hour time '$StartHour:$StartMin $AntePost' converted to 24-hour time ('$24hourFormat:$StartMin')"

\> $DifferentTimeToday = Get-Date -Hour $24hourFormat -Minute $StartMin

This script above will set a <DateTime> type variable called $DifferentTimeToday that is the same date as today, but with a time entered by manually by the user.

.INPUTS
Requires a "Hours" time value as input, and selection of AM or PM. Hour value must be a positive integer (whole number, non-decimal) between 1 and 12. "Hours" value can be piped int from other commands, but a choice between -AM or -PM switch must still be made. See Examples for more info.

.OUTPUTS
Returns a [int32] integer number (whole number, not decimal, not negative) between 0 and 23, according to 24-hour time formats, equivalent to the AM/PM input time (hour).

.NOTES

Conversion table between AM/PM hours and 24-hour time format:

--AM/PM----24-hr--------------------------------------------------------------------------------
12:00 AM = 00:00	*** exception: if AM hours = 12, then 24-hours = 0			\
 1:00 AM = 01:00	\															 |
 2:00 AM = 02:00	 |															 |
 3:00 AM = 03:00	 |															 |
 4:00 AM = 04:00	 |															 |
 5:00 AM = 05:00	 |															 |
 6:00 AM = 06:00	 |------- AM time = 24-hour time							 |-------  AM
 7:00 AM = 07:00	 |															 |
 8:00 AM = 08:00	 |															 |
 9:00 AM = 09:00	 |															 |
10:00 AM = 10:00	 |															 |
11:00 AM = 11:00____/___________________________________________________________/_______________
12:00 PM = 12:00	*** exception: if PM hours = 12, then 24-hours = 12			\
 1:00 PM = 13:00	\															 |
 2:00 PM = 14:00	 |															 |
 3:00 PM = 15:00	 |															 |
 4:00 PM = 16:00	 |															 |
 5:00 PM = 17:00	 |															 |
 6:00 PM = 18:00	 |------- PM hours + 12 = 24-hours							 |-------  PM
 7:00 PM = 19:00	 |															 |
 8:00 PM = 20:00	 |															 |
 9:00 PM = 21:00	 |															 |
10:00 PM = 22:00	 |															 |
11:00 PM = 23:00	/															/
------------------------------------------------------------------------------------------------

.LINK
https://www.lsoft.com/manuals/maestro/4.0/htmlhelp/interface%20user/TimeConversionTable.html

.LINK
https://stackoverflow.com/questions/16774064/regular-expression-for-whole-numbers-and-integers

.LINK
https://www.gngrninja.com/script-ninja/2016/5/15/powershell-getting-started-part-8-accepting-pipeline-input

.LINK
https://www.timeanddate.com/time/am-and-pm.html

#>
	
	Param (
		#Script parameters go here
		[Parameter(Mandatory=$true,Position=0,
		ValueFromPipeline = $true)]
		# Validate a positive integer (whole number) using Regular Expressions, thanks to:
		#https://stackoverflow.com/questions/16774064/regular-expression-for-whole-numbers-and-integers
		#	(?<![-.])		# Assert that the previous character isn't a minus sign or a dot.
		#	\b				# Anchor the match to the start of a number.
		#	[0-9]+			# Match a number.
		#	\b				# Anchor the match to the end of the number.
		#	(?!\.[0-9])		# Assert that no decimal part follows.
		#$RegEx = "(?<![-.])\b[0-9]+\b(?!\.[0-9])"
		#[ValidatePattern("(?<![-.])\b[0-9]+\b(?!\.[0-9])")]
		# This [ValidateScript({))] does the exact same thing as the [ValidatePattern("")] above, it just throws much nicer, customizable error messages.
		[ValidateScript({
            If ($_ -match "(?<![-.])\b[0-9]+\b(?!\.[0-9])") {
                $True
            } else {
                Throw "$_ must be a positive integer (whole number, no decimals)."
            }
        })]
		[ValidateRange(1,12)]
		# Bugfix: To properly validate regex for integer ranges, and throw an error if a decimal value is provided, do not use [int]$var since PowerShell will automatically round the input value before performing the [ValidatePattern("")] regex comparison. Instead, declare parameter without [int] e.g. $var,
		$Hours,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='AMtag')]
		[switch]$AM,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='PMtag')]
		[switch]$PM
	)
	
	<#
	------------------------------------------------------------------------------------------------
	12:00 AM = 00:00	*** exception: if AM hours = 12, subtract 12 for 24-hours	\
	1:00 AM = 01:00		\															 |
	2:00 AM = 02:00		 |															 |
	3:00 AM = 03:00		 |															 |
	4:00 AM = 04:00		 |															 |
	5:00 AM = 05:00		 |															 |
	6:00 AM = 06:00		 |------- AM time = 24-hour time							 |-------  AM
	7:00 AM = 07:00		 |															 |
	8:00 AM = 08:00		 |															 |
	9:00 AM = 09:00		 |															 |
	10:00 AM = 10:00	 |															 |
	11:00 AM = 11:00____/___________________________________________________________/_______________
	12:00 PM = 12:00	*** exception: if PM hours = 12, 24-hours = 12				\
	1:00 PM = 13:00		\															 |
	2:00 PM = 14:00		 |															 |
	3:00 PM = 15:00		 |															 |
	4:00 PM = 16:00		 |															 |
	5:00 PM = 17:00		 |															 |
	6:00 PM = 18:00		 |------- PM hours + 12 = 24-hours							 |-------  PM
	7:00 PM = 19:00		 |															 |
	8:00 PM = 20:00		 |															 |
	9:00 PM = 21:00		 |															 |
	10:00 PM = 22:00	 |															 |
	11:00 PM = 23:00	/															/
	------------------------------------------------------------------------------------------------
	#>
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Convert AM hours
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($AM) {
		If ($AM -eq 12) {
			$24hour = 0
		} else {
			$24hour = $Hours
		}
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Convert PM hours
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($PM) {
		If ($PM -eq 12) {
			$24hour = 12
		} else {
			$24hour = [Int]$Hours + 12
		}
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Write out result of function
	#-----------------------------------------------------------------------------------------------------------------------
	
	#$24hour
	
	Return $24hour
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End Convert-AMPMhourTo24hour function -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------



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

help Convert-AMPMhourTo24hour -full

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host "--------------------------------------------------------------------------------------------------"

<#
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

#>

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



