
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
The AM/PM hour value, from 1-12. Must be an integer.

.PARAMETER AM
Use the AM parameter to specify the -Hours <VALUE> as AM (Ante Meridiem: Before noon)

.PARAMETER PM
Use the PM parameter to specify the -Hours <VALUE> as PM (Post Meridiem: After noon)

.EXAMPLE
$OutputVar = Convert-AMPMhourTo24hour 4 -PM

This line will convert a PM hour value (in this case, 4 PM) into its 24-hour equivalent, and save the result into the $OutputVar variable.

PS C:\> Write-Host "4 PM = $OutputVar:00"

In this example, the output would read:

"4 PM = 16:00"

since 4:00 PM is equivalent to 16:00 on a 24-hour clock.

.EXAMPLE
Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM

The above line script will get the current hour in AM/PM format, and convert it to 24-hour format. For example, if the current time was 8 PM, the above line would print out the result:

"20"

since 8:00 PM is equivalent to 20:00 on a 24-hour clock.

To store the output value in a variable first, then print the result:

PS C:\> $OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -PM)
PS C:\> Write-Host "$(Get-Date -UFormat %I) PM = $OutputVar:00"

For example, if the current time was 2 PM, the output would of this would read:

"2 PM = 14:00"

For the same thing but with AM times, simply change the -PM switch to the -AM switch:

PS C:\> $OutputVar = (Get-Date -UFormat %I | Convert-AMPMhourTo24hour -AM)
PS C:\> Write-Host "$(Get-Date -UFormat %I) AM = $OutputVar:00"

For example, if the current time was 8 AM, the output would read:

"8 AM = 8:00"

.EXAMPLE
$StartHour = Read-Host -Prompt "Enter Start hour"
PS C:\> $StartMin = Read-Host -Prompt "Enter Start minute"

# To get today's date, but with a different time-value, then use a script block like this invloving Read-Host, Get-Date, and (this function) Convert-AMPMhourTo24hour.

PS C:\> do {
PS C:\>   $ChoiceAMPM24hour = Read-Host -Prompt "[A]M, [P]M, or [2]4 hour? [A\P\2]"
PS C:\>   switch ($ChoiceAMPM24hour) {
PS C:\> 	'A' { # A - AM time
PS C:\>            $AntePost = "AM"
PS C:\>            Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
PS C:\>            $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -AM
PS C:\>     }
PS C:\>     'P' { # P - PM time
PS C:\>            $AntePost = "PM"
PS C:\>            Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
PS C:\>            $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -PM
PS C:\>     }
PS C:\>     2 { # 2 - 24-hour time
PS C:\>            $AntePost = "(24-hour)"
PS C:\>            Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
PS C:\>            $24hourFormat = $StartHour
PS C:\>     }
PS C:\>     default { # Choice not recognized.
PS C:\>            Write-Host `r`n
PS C:\>            Write-Warning "Choice `"$ChoiceAMPM24hour`" not recognized. Options must be AM, PM, or 24-hour."
PS C:\>            Write-Host `r`n
PS C:\>            PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
PS C:\>            #Clear-Host # CLS
PS C:\>            #Break #help about_Break
PS C:\>            Write-Host `r`n
PS C:\>     }
PS C:\>   }
PS C:\> } until ($ChoiceAMPM24hour -eq 'A' -Or $ChoiceAMPM24hour -eq 'P' -Or $ChoiceAMPM24hour -eq 2)
PS C:\> Write-Verbose "12-hour time '$StartHour:$StartMin $AntePost' converted to 24-hour time ('$24hourFormat:$StartMin')"

The above script will prompt the user:

"Enter Start hour: "
"Enter Start minute: "
"[A]M, [P]M, or [2]4 hour? [A\P\2]: "

PS C:\> $DifferentTimeToday = Get-Date -Hour $24hourFormat -Minute $StartMin -Second 0 -Millisecond 0

Then set a variable called $DifferentTimeToday of <DateTime>-type that is has same date as today, but with the time entered by the user.

.INPUTS
Requires a "Hours" time value as input, and selection of AM or PM. Hour value must be a positive integer (whole number, non-decimal) between 1 and 12. "Hours" value can be piped in from other commands, but a choice between -AM or -PM switch must still be made. See Examples for more info.

.OUTPUTS
Returns a [int32] integer number (whole number, not decimal, not negative) between 0 and 23, according to 24-hour time formats, equivalent to the AM/PM input time (hour).

.NOTES
Conversion table between AM/PM hours and 24-hour time format:

--AM/PM----24-hr--------------------------------------------------------------------------------
12:00 AM = 00:00____*** exception: if AM-hours = 12, then 24-hours = 0			\
 1:00 AM = 01:00	\															 |
 2:00 AM = 02:00	 |															 |
 3:00 AM = 03:00	 |															 |
 4:00 AM = 04:00	 |															 |
 5:00 AM = 05:00	 |															 |
 6:00 AM = 06:00	 |------- AM-hour = 24-hours								 |-------  AM
 7:00 AM = 07:00	 |															 |
 8:00 AM = 08:00	 |															 |
 9:00 AM = 09:00	 |															 |
10:00 AM = 10:00	 |															 |
11:00 AM = 11:00____/___________________________________________________________/_______________
12:00 PM = 12:00____*** exception: if PM-hours = 12, then 24-hours = 12			\
 1:00 PM = 13:00	\															 |
 2:00 PM = 14:00	 |															 |
 3:00 PM = 15:00	 |															 |
 4:00 PM = 16:00	 |															 |
 5:00 PM = 17:00	 |															 |
 6:00 PM = 18:00	 |------- (PM-hours + 12) = 24-hours						 |-------  PM
 7:00 PM = 19:00	 |															 |
 8:00 PM = 20:00	 |															 |
 9:00 PM = 21:00	 |															 |
10:00 PM = 22:00	 |															 |
11:00 PM = 23:00____/															/
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
		#-----------------------------------------------------------------------------------------------------------------------
		#	(?<![-.])		# Assert that the previous character isn't a minus sign or a dot.
		#	\b				# Anchor the match to the start of a number.
		#	[0-9]+			# Match a number.
		#	\b				# Anchor the match to the end of the number.
		#	(?!\.[0-9])		# Assert that no decimal part follows.
		#$RegEx = "(?<![-.])\b[0-9]+\b(?!\.[0-9])"
		#[ValidatePattern("(?<![-.])\b[0-9]+\b(?!\.[0-9])")]
		# This [ValidateScript({))] does the exact same thing as the [ValidatePattern("")] above, it just throws much nicer, customizable error messages that actually explain why if failed (rather than "(?<![-.])\b[0-9]+\b(?!\.[0-9])").
		[ValidateScript({
            If ($_ -match "(?<![-.])\b[0-9]+\b(?!\.[0-9])") {
                $True
            } else {
                Throw "$_ must be a positive integer (whole number, no decimals)."
            }
        })]
		#-----------------------------------------------------------------------------------------------------------------------
		[ValidateRange(1,12)]
		# Bugfix: For the [ValidatePattern("")] or [ValidateScript({})] regex validation checks to work e.g. for integer validation (throw an error if a decimal value is provided) do not use define the var-type e.g. [int]$var since PowerShell will automatically round the input value before performing the [ValidatePattern("")] regex comparison. Instead, declare parameter without [int] e.g. $var,
		$Hours,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='AMtag')]
		[switch]$AM,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='PMtag')]
		[switch]$PM
	)
	
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

Write-Host "help Convert-AMPMhourTo24hour -full"
Write-Warning "Executing `"help Convert-AMPMhourTo24hour -full`" from a script environment during run will not display any of the extra information from the -Full switch. The command must be executed from the command line to get entire help content."

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



