
#-----------------------------------------------------------------------------------------------------------------------
Function Convert-AMPMhourTo24hour { #-----------------------------------------------------------------------------------
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
PS C:\>     'A' { # A - AM time
PS C:\>         $AntePost = "AM"
PS C:\>         Write-Verbose "AM time ('$ChoiceAMPM24hour') option selected."
PS C:\>         $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -AM
PS C:\>     }
PS C:\>     'P' { # P - PM time
PS C:\>         $AntePost = "PM"
PS C:\>         Write-Verbose "PM time ('$ChoiceAMPM24hour') option selected."
PS C:\>         $24hourFormat = Convert-AMPMhourTo24hour -Hours $StartHour -PM
PS C:\>     }
PS C:\>     2 { # 2 - 24-hour time
PS C:\>         $AntePost = "(24-hour)"
PS C:\>         Write-Verbose "24-hour time ('$ChoiceAMPM24hour') option selected."
PS C:\>         $24hourFormat = $StartHour
PS C:\>     }
PS C:\>     default { # Choice not recognized.
PS C:\>         Write-Host `r`n
PS C:\>         Write-Warning "Choice `"$ChoiceAMPM24hour`" not recognized. Options must be AM, PM, or 24-hour."
PS C:\>         Write-Host `r`n
PS C:\>         PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
PS C:\>         #Clear-Host # or alias CLS
PS C:\>         #Break #help about_Break
PS C:\>         Write-Host `r`n
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

--AM/PM----24-hr-------------------------------------------------------------------------------------
12:00 AM = 00:00____*** exception: if AM-hours = 12, then 24-hours = 0			\--------  (Midnight)
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
11:00 AM = 11:00____/___________________________________________________________/____________________
12:00 PM = 12:00____*** exception: if PM-hours = 12, then 24-hours = 12			\--------  (Noon)
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
11:00 PM = 23:00____/___________________________________________________________/
12:00 AM = 00:00____*** exception: if AM-hours = 12, then 24-hours = 0			\--------  (Midnight)
-----------------------------------------------------------------------------------------------------

.LINK
about_Comment_Based_Help

.LINK
https://www.lsoft.com/manuals/maestro/4.0/htmlhelp/interface%20user/TimeConversionTable.html

.LINK
https://www.timeanddate.com/time/am-and-pm.html

.LINK
about_Functions_Advanced_Parameters

.LINK
https://docs.microsoft.com/en-us/powershell/developer/cmdlet/validating-parameter-input

.LINK
https://social.technet.microsoft.com/wiki/contents/articles/15994.powershell-advanced-function-parameter-attributes.aspx

.LINK
https://www.petri.com/validating-powershell-input-using-parameter-validation-attributes

.LINK
https://docs.microsoft.com/en-us/powershell/developer/cmdlet/validating-parameter-input

.LINK
https://stackoverflow.com/questions/16774064/regular-expression-for-whole-numbers-and-integers

.LINK
https://www.gngrninja.com/script-ninja/2016/5/15/powershell-getting-started-part-8-accepting-pipeline-input

#>
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
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
		# This [ValidateScript({})] does the exact same thing as the [ValidatePattern("")] above, it just throws much nicer, customizable error messages that actually explain why if failed (rather than "(?<![-.])\b[0-9]+\b(?!\.[0-9])").
		[ValidateScript({
			If ($_ -match "(?<![-.])\b[0-9]+\b(?!\.[0-9])") {
				$True
			} else {
				Throw "$_ must be a positive integer (whole number, no decimals)."
			}
		})]
		#-----------------------------------------------------------------------------------------------------------------------
		# Bugfix: For the [ValidatePattern("")] or [ValidateScript({})] regex validation checks to work e.g. for strict integer validation (throw an error if a non-integer value is provided) do not define the var-type e.g. [int]$var since PowerShell will automatically round the input value to an integer BEFORE performing the regex comparisons. Instead, declare parameter without [int] defining the var-type e.g. $var,
		[ValidateRange(1,12)]
		$Hours,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='AMtag')]
		[Alias('a')]
		[switch]$AM = $false,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='PMtag')]
		[Alias('p')]
		[switch]$PM = $false
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "Input hours = $Hours"
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Convert AM hours
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($AM) {
		Write-Verbose "AM hours selected."
		If ($Hours -eq 12) {
			Write-Verbose "Exception: hour equals 12"
			$24hour = 0
		} else {
			$24hour = $Hours
		}
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Convert PM hours
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($PM) {
		Write-Verbose "PM hours selected."
		If ($Hours -eq 12) {
			Write-Verbose "Exception: hour equals 12"
			$24hour = 12
		} else {
			$24hour = [Int]$Hours + 12
		}
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Write out result of function
	#-----------------------------------------------------------------------------------------------------------------------
	
	Write-Verbose "24-hour format Result = $24hour"
	
	Return $24hour
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End Convert-AMPMhourTo24hour function ------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Convert-TimeZone { #-------------------------------------------------------------------------------------------

	<#
	.SYNOPSIS
	Convert-TimeZone function converts times from one time zone to the same time in another time zone.

	.DESCRIPTION
	Thanks to:
	https://blogs.msdn.microsoft.com/rslaten/2014/08/04/converting-times-from-one-time-zone-to-another-time-zone-in-powershell/

	.PARAMETER Time
	Horizontal Rule types. Accepted types are 'SingleLine', 'DoubleLine', 'DashedLine', and 'BlankLine'. Defaults to 'SingleLine'.
	
	.PARAMETER FromTimeZone
	From
	
	.PARAMETER ToTimeZone
	To
	
	.LINK
	https://blogs.msdn.microsoft.com/rslaten/2014/08/04/converting-times-from-one-time-zone-to-another-time-zone-in-powershell/
	
	.LINK
	Get-TimeZone
	
	#>
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	param(
		[Parameter(Mandatory=$false)]
		$Time,
		[Parameter(Mandatory=$false)]
		$FromTimeZone,
		[Parameter(Mandatory=$false)]
		$ToTimeZone
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	function ConvertTime { #------------------------------------------------------------------------------------------------
		param($time, $FromTimeZone, $ToTimeZone)
		
		$oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($FromTimeZone)
		$oToTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($ToTimeZone)
		$utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
		$newTime = [System.TimeZoneInfo]::ConvertTime($utc, $oToTimeZone)
	
		return $newTime
	} # End ConvertTime function -------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#-----------------------------------------------------------------------------------------------------------------------
	function ConvertUTC { #-------------------------------------------------------------------------------------------------
		param($time, $FromTimeZone)
		
		$oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($FromTimeZone)
		$utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
		return $utc
	} # End ConvertUTC function -------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	if ($ToTimeZone)
	{
	
		[datetime]$time = $time
		$toUTC = ConvertUTC -time $time -FromTimeZone $FromTimeZone
		$toNewTimeZone = ConvertTime -time $time -FromTimeZone $FromTimeZone -ToTimeZone $ToTimeZone
		Write-Host ("Original Time ({0}): {1}" -f $FromTimeZone, $time)
		Write-Host ("UTC Time: {0}" -f $toUTC)
		Write-Host ("{0}: {1}" -f $ToTimeZone, $toNewTimeZone)
	}
	else
	{
		if (!($time)) 
		{
			$FromTimeZone = (([System.TimeZoneInfo]::Local).Id).ToString()
			$time = [DateTime]::SpecifyKind((Get-Date), [DateTimeKind]::Unspecified)
		}
		else { [datetime]$time = $time }
		
		Write-Host ("Original Time - {0}: {1}" -f $FromTimeZone, $time)
		$toUTC = ConvertUTC -time $time -FromTimeZone $FromTimeZone
		$times = @()
		foreach ($timeZone in ([system.timezoneinfo]::GetSystemTimeZones()))
		{
			$times += (New-Object psobject -Property @{'Name' = $timeZone.DisplayName; 'ID' = $timeZone.id; 'Time' = (ConvertTime -time $time -FromTimeZone $FromTimeZone -ToTimeZone $timeZone.id); 'DST' = $timeZone.SupportsDaylightSavingTime})
		}
		$times | Sort-Object Time | Format-Table -Property * -AutoSize
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End Convert-TimeZone function --------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#-----------------------------------------------------------------------------------------------------------------------
function Convert-DoWNumberToMonSun { #----------------------------------------------------------------------------------
	<#
	.INPUTS
	Accepts a DateTime format variable. For example:
	
	[DateTime]$var = Get-Date
	
	.OUTPUTS
	Returns and integer between 1 and 7, representing Monday thru Sunday. 
	
	.NOTES
	Converts the PowerShell default:
	
	Day-of-Week in number format, (Sun-Sat = 0-6):
	
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	
	to
	
	Day-of-Week in number format, (Mon-Sun = 1-7):
	
	1 = Monday    - Dow = $default
	2 = Tuesday   - Dow = $default
	3 = Wednesday - Dow = $default
	4 = Thursday  - Dow = $default
	5 = Friday    - Dow = $default
	6 = Saturday  - Dow = $default
	7 = Sunday    - Dow = 7
	
	.EXAMPLE
	Example
	Line2
	#>
	param(
		[parameter(Position=0)]
		[DateTime]$InputVal
	)
	$DoWNumberOneThruSeven = (Get-Date -Date $InputVal -UFormat %u)
	If ([int]$DoWNumberOneThruSeven -eq 0) {$DoWNumberOneThruSeven = 7}
	Write-Verbose "`$DoWNumberOneThruSeven = $DoWNumberOneThruSeven"
	Return [int]$DoWNumberOneThruSeven
} # End Convert-DoWNumberToMonSun function -----------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
function Convert-DoWNumberToSunSat { #----------------------------------------------------------------------------------
	<#
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.NOTES
	Day-of-Week in number format, (Sun-Sat = 0-6):
	
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	#>
	param(
		[parameter(Position=0)]
		[DateTime]$InputVal
	)
	$DoWNumberZeroThruSix = Get-Date -Date $InputVal -UFormat %u
	If ([int]$DoWNumberZeroThruSix -eq 7) {$DoWNumberZeroThruSix = 0}
	Write-Verbose "`$DoWNumberZeroThruSix = $DoWNumberZeroThruSix"
	Return [int]$DoWNumberZeroThruSix
} # End Convert-DoWNumberToSunSat function -----------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

# Get beginning of current week
#-----------------------------------------------------------------------------------------------------------------------
function Get-MondayOfWeekInt { #----------------------------------------------------------------------------------------
	<#	
	.SYNOPSIS
	Get Monday of current week
	
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.NOTES
	Day-of-Week in number format, (Mon-Sun = 1-7):
	
	1 = Monday    - Monday is 1 - 0 = 1
	2 = Tuesday   - Monday is 2 - 1 = 1
	3 = Wednesday - Monday is 3 - 2 = 1
	4 = Thursday  - Monday is 4 - 3 = 1
	5 = Friday    - Monday is 5 - 4 = 1
	6 = Saturday  - Monday is 6 - 5 = 1
	7 = Sunday    - Monday is 7 - 6 = 1
	
	1 = Monday    - Monday is $Input - 0 = 1
	2 = Tuesday   - Monday is $Input - 1 = 1
	3 = Wednesday - Monday is $Input - 2 = 1
	4 = Thursday  - Monday is $Input - 3 = 1
	5 = Friday    - Monday is $Input - 4 = 1
	6 = Saturday  - Monday is $Input - 5 = 1
	7 = Sunday    - Monday is $Input - 6 = 1
	#>
	param(
		[parameter(Position=0)]
		[int]$DoWInput
	)
	$ModifyBy = [int]$DoWInput - 1
	$MondayOfWeek = [int]$DoWInput - [int]$ModifyBy
	Return [int]$MondayOfWeek
} # End Get-MondayOfWeekInt function -----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

# Get beginning of current week
#-----------------------------------------------------------------------------------------------------------------------
function Get-SundayOfWeek { #-------------------------------------------------------------------------------------------
	<#	
	.SYNOPSIS
	Get Sunday of current week (Sun-Mon)
	
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.NOTES
	Day-of-Week in number format, (Sun-Mon = 0-6):
	
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	
	0 = Monday    - Monday is $Input - 0 = 0
	1 = Tuesday   - Monday is $Input - 1 = 0
	2 = Wednesday - Monday is $Input - 2 = 0
	3 = Thursday  - Monday is $Input - 3 = 0
	4 = Friday    - Monday is $Input - 4 = 0
	5 = Saturday  - Monday is $Input - 5 = 0
	6 = Sunday    - Monday is $Input - 6 = 0
	#>
	param(
		[parameter(Position=0)]
		[DateTime]$DoWInput
	)
	$ModifyBy = [int](Get-Date -Date $DoWInput -UFormat %u) * -1
	$MondayOfWeek = (Get-Date -Date $DoWInput).AddDays($ModifyBy)
	Return [DateTime]$MondayOfWeek
} # End Get-SundayOfWeek function --------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

# Get end of current week
#-----------------------------------------------------------------------------------------------------------------------
function Get-SundayOfWeekInt { #----------------------------------------------------------------------------------------
	<#
	.SYNOPSIS
	Get Sunday of current week (Mon-Sun)
	
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.NOTES
	Day-of-Week in number format, (Mon-Sun = 1-7):
	
	1 = Monday    - Sunday is 1 + 6 = 7
	2 = Tuesday   - Sunday is 2 + 5 = 7
	3 = Wednesday - Sunday is 3 + 4 = 7
	4 = Thursday  - Sunday is 4 + 3 = 7
	5 = Friday    - Sunday is 5 + 2 = 7
	6 = Saturday  - Sunday is 6 + 1 = 7
	7 = Sunday    - Sunday is 7 + 0 = 7
		
	1 = Monday    - Sunday is $Input + 6 = 7
	2 = Tuesday   - Sunday is $Input + 5 = 7
	3 = Wednesday - Sunday is $Input + 4 = 7
	4 = Thursday  - Sunday is $Input + 3 = 7
	5 = Friday    - Sunday is $Input + 2 = 7
	6 = Saturday  - Sunday is $Input + 1 = 7
	7 = Sunday    - Sunday is $Input + 0 = 7
	#>
	param(
		[parameter(Position=0)]
		[int]$DoWInput
	)
	[int]$ModifyBy = 7 - [int]$DoWInput
	[int]$SundayOfWeek = [int]$DoWInput + [int]$ModifyBy
	Return [int]$SundayOfWeek
} # End Get-SundayOfWeekInt function -----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

# Get end of current week
#-----------------------------------------------------------------------------------------------------------------------
function Get-SaturdayOfWeek { #-----------------------------------------------------------------------------------------
	<#
	.SYNOPSIS
	Get Sunday of current week (Sun-Sat)
	
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.NOTES
	Day-of-Week in number format, (Sun-Sat = 0-6):
	
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	
	0 = Monday    - Sunday is $Input + 6 = 6
	1 = Tuesday   - Sunday is $Input + 5 = 6
	2 = Wednesday - Sunday is $Input + 4 = 6
	3 = Thursday  - Sunday is $Input + 3 = 6
	4 = Friday    - Sunday is $Input + 2 = 6
	5 = Saturday  - Sunday is $Input + 1 = 6
	6 = Sunday    - Sunday is $Input + 0 = 6
	#>
	param(
		[parameter(Position=0)]
		[DateTime]$DoWInput
	)
	$ModifyBy = 6 - [int](Get-Date -Date $DoWInput -UFormat %u)
	$SundayOfWeek = (Get-Date -Date $DoWInput).AddDays($ModifyBy)
	Return [DateTime]$SundayOfWeek
} # End Get-SaturdayOfWeek function ------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function PromptForChoice-DayDate { #------------------------------------------------------------------------------------
	<#
	.INPUTS
	Input
	
	.OUTPUTS
	Output
	
	.LINK
	https://ss64.com/ps/syntax-dateformats.html
	#>
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[CmdletBinding()]
	#Param()
	
	[CmdletBinding()]
	Param (
		#Script parameters go here
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		[string]$TitleName = "Select day:",
		
		[Parameter(Mandatory=$false)]
		[string]$InfoDescription,
		
		[Parameter(Mandatory=$false)]
		[string]$HintPhrase
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VerbosePreferenceOrig = $VerbosePreference
	#$VerbosePreference = "SilentlyContinue" # Will suppress Write-Verbose messages. This is the default value.
	#$VerbosePreference = "Continue" # Will print out Write-Verbose messages. Gets set when -Verbose switch is used to run the script. (Or when you set the variable manually.)
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	# Collect date variables
	
	#https://ss64.com/ps/syntax-dateformats.html
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Today:
	
	$TodayDateTime = Get-Date
	
	$TodayDoWLong = Get-Date -UFormat %A
	Write-Verbose "`$TodayDoWLong = $TodayDoWLong"
	
	# Day-of-Week in 3 characters:
	<#
	Sun
	Mon
	Tue
	Wed
	Thu
	Fri
	Sat
	Sun
	#>
	$TodayDoWShort = Get-Date -UFormat %a
	Write-Verbose "`$TodayDoWShort = $TodayDoWShort"
	
	# Month/Day (MM/DD)
	$TodayMonthDay = Get-Date -Format 'm, M'
	Write-Verbose "`$TodayMonthDay = $TodayMonthDay"
	$TodayMonthDay = Get-Date -Format m
	Write-Verbose "`$TodayMonthDay = $TodayMonthDay"
	$TodayMonthDay = Get-Date -Format M
	Write-Verbose "`$TodayMonthDay = $TodayMonthDay"
	
	# Month/Day (MM/DD)
	$TodayMonthDay = Get-Date -UFormat %m/%d
	Write-Verbose "`$TodayMonthDay = $TodayMonthDay"
	
	# Day/Month (DD/MM)
	$TodayDayMonth = Get-Date -UFormat %d/%m
	Write-Verbose "`$TodayDayMonth = $TodayDayMonth"
	
	# Month name - abbreviated (Jan)
	<#
	01 - Jan
	02 - Feb
	03 - Mar
	04 - Apr
	05 - May
	06 - Jun
	07 - Jul
	08 - Aug
	09 - Sep
	10 - Oct
	11 - Nov
	12 - Dec
	#>
	$TodayMonthShort = Get-Date -UFormat %b
	Write-Verbose "`$TodayMonthShort - $TodayMonthShort"
	
	# Month name - full (January)
	$TodayMonthFull = Get-Date -UFormat %B
	Write-Verbose "`$TodayMonthFull = $TodayMonthFull"
	
	# Week of the Year (00-52)
	$TodayWeekOfYearZero = Get-Date -UFormat %W
	Write-Verbose "`$TodayWeekOfYearZero (00-52) = $TodayWeekOfYearZero"
	
	# Week of the Year (01-53)
	$TodayWeekOfYear = Get-Date -UFormat %V
	Write-Verbose "`$TodayWeekOfYear (01-53) = $TodayWeekOfYear"
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Yesterday:
	
	$YesterdayDateTime = $TodayDateTime.AddDays(-1)
	Write-Verbose "`$YesterdayDateTime = $YesterdayDateTime"
	
	$YesterdayDateTime = (Get-Date).AddDays(-1)
	Write-Verbose "`$YesterdayDateTime = $YesterdayDateTime"
	
	$YesterdayDoWLong = Get-Date -Date $YesterdayDateTime -UFormat %A
	Write-Verbose "`$YesterdayDoWLong = $YesterdayDoWLong"
	
	# Day-of-Week in 3 characters:
	<#
	Sun
	Mon
	Tue
	Wed
	Thu
	Fri
	Sat
	Sun
	#>
	$YesterdayDoWShort = Get-Date -Date $YesterdayDateTime -UFormat %a
	Write-Verbose "`$YesterdayDoWShort = $YesterdayDoWShort"
	
	# Month/Day (MM/DD)
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -Format 'm, M'
	Write-Verbose "`$YesterdayMonthDay = $YesterdayMonthDay"
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -Format m
	Write-Verbose "`$YesterdayMonthDay = $YesterdayMonthDay"
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -Format M
	Write-Verbose "`$YesterdayMonthDay = $YesterdayMonthDay"
	
	# Month/Day (MM/DD)
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -UFormat %m/%d
	Write-Verbose "`$YesterdayMonthDay = $YesterdayMonthDay"
	
	# Day/Month (DD/MM)
	$YesterdayDayMonth = Get-Date -Date $YesterdayDateTime -UFormat %d/%m
	Write-Verbose "`$YesterdayDayMonth = $YesterdayDayMonth"
	
	# Month name - abbreviated (Jan)
	<#
	01 - Jan
	02 - Feb
	03 - Mar
	04 - Apr
	05 - May
	06 - Jun
	07 - Jul
	08 - Aug
	09 - Sep
	10 - Oct
	11 - Nov
	12 - Dec
	#>
	$YesterdayMonthShort = Get-Date -Date $YesterdayDateTime -UFormat %b
	Write-Verbose "`$YesterdayMonthShort - $YesterdayMonthShort"
	
	# Month name - full (January)
	$YesterdayMonthFull = Get-Date -Date $YesterdayDateTime -UFormat %B
	Write-Verbose "`$YesterdayMonthFull = $YesterdayMonthFull"
	
	# Week of the Year (00-52)
	$YesterdayWeekOfYearZero = Get-Date -Date $YesterdayDateTime -UFormat %W
	Write-Verbose "`$YesterdayWeekOfYearZero (00-52) = $YesterdayWeekOfYearZero"
	
	# Week of the Year (01-53)
	$YesterdayWeekOfYear = Get-Date -Date $YesterdayDateTime -UFormat %V
	Write-Verbose "`$YesterdayWeekOfYear (01-53) = $YesterdayWeekOfYear"
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Tomorrow:
	
	$TomorrowDateTime = $TodayDateTime.AddDays(1)
	Write-Verbose "`$TomorrowDateTime = $TomorrowDateTime"
	
	$TomorrowDateTime = (Get-Date).AddDays(1)
	Write-Verbose "`$TomorrowDateTime = $TomorrowDateTime"
	
	$TomorrowDoWLong = Get-Date -Date $TomorrowDateTime -UFormat %A
	Write-Verbose "`$TomorrowDoWLong = $TomorrowDoWLong"
	
	# Day-of-Week in 3 characters:
	<#
	Sun
	Mon
	Tue
	Wed
	Thu
	Fri
	Sat
	Sun
	#>
	$TomorrowDoWShort = Get-Date -Date $TomorrowDateTime -UFormat %a
	Write-Verbose "`$TomorrowDoWShort = $TomorrowDoWShort"
	
	# Month/Day (MM/DD)
	$TomorrowMonthDay = Get-Date -Date $TomorrowDateTime -Format 'm, M'
	Write-Verbose "`$TomorrowMonthDay = $TomorrowMonthDay"
	$TomorrowMonthDay = Get-Date -Date $TomorrowDateTime -Format m
	Write-Verbose "`$TomorrowMonthDay = $TomorrowMonthDay"
	$TomorrowMonthDay = Get-Date -Date $TomorrowDateTime -Format M
	Write-Verbose "`$TomorrowMonthDay = $TomorrowMonthDay"
	
	# Month/Day (MM/DD)
	$TomorrowMonthDay = Get-Date -Date $TomorrowDateTime -UFormat %m/%d
	Write-Verbose "`$TomorrowMonthDay = $TomorrowMonthDay"
	
	# Day/Month (DD/MM)
	$TomorrowDayMonth = Get-Date -Date $TomorrowDateTime -UFormat %d/%m
	Write-Verbose "`$TomorrowDayMonth = $TomorrowDayMonth"
	
	# Month name - abbreviated (Jan)
	<#
	01 - Jan
	02 - Feb
	03 - Mar
	04 - Apr
	05 - May
	06 - Jun
	07 - Jul
	08 - Aug
	09 - Sep
	10 - Oct
	11 - Nov
	12 - Dec
	#>
	$TomorrowMonthShort = Get-Date -Date $TomorrowDateTime -UFormat %b
	Write-Verbose "`$TomorrowMonthShort - $TomorrowMonthShort"
	
	# Month name - full (January)
	$TomorrowMonthFull = Get-Date -Date $TomorrowDateTime -UFormat %B
	Write-Verbose "`$TomorrowMonthFull = $TomorrowMonthFull"
	
	# Week of the Year (00-52)
	$TomorrowWeekOfYearZero = Get-Date -Date $TomorrowDateTime -UFormat %W
	Write-Verbose "`$TomorrowWeekOfYearZero (00-52) = $TomorrowWeekOfYearZero"
	
	# Week of the Year (01-53)
	$TomorrowWeekOfYear = Get-Date -Date $TomorrowDateTime -UFormat %V
	Write-Verbose "`$TomorrowWeekOfYear (01-53) = $TomorrowWeekOfYear"
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$TodayDoWNumber = Get-Date -Date $TodayDateTime -UFormat %u
	Write-Verbose "`$TodayDoWNumber = $TodayDoWNumber"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# / removed funcs /
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Fill in earlier days of the week.
	
	# 'Today' and 'Yesterday' will be constant. But we'll fill in every day earlier as an option, up to Monday. So starting at Wednesday and later, we'll calculate those values. And to do that we'll need the Day-of-Week as an integer value for Monday through Sunday.
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-HR -IsVerbose -DashedLine
	Write-HR -IsVerbose -DashedLine
	Write-HR -IsVerbose
	Write-HR -IsVerbose
	
	#-----------------------------------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	# Build week info.
	
	$SelectedWeek = 0
	$TodayDateTime = Get-Date
	#Test case
	#$TodayDateTime = Get-Date -Day 28
	
	$YesterdayDateTime = $TodayDateTime.AddDays(-1)
	$TomorrowDateTime = $TodayDateTime.AddDays(1)
	
	$TomorrowOption = $true
	#$TomorrowOption = $false
	
	$SatSunEnabled = $true
	$SatSunEnabled = $false
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# Build out currently selected week, out until Monday (Mon-Sun week display)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Get how many days we are away from Monday. 
	
	# Since the default output of PowerShell DoW is Sun-Sat = 0-6, we must convert it to our choice of a Monday through Sunday week format, Mon-Sun = 1-7.
	
	$TodayDoWNumberOneThruSeven = Convert-DoWNumberToMonSun (Get-Date)
	
	[int]$SelectedDoW = [int]$TodayDoWNumberOneThruSeven
	[int]$TodayDoW = [int]$TodayDoWNumberOneThruSeven
	
	[DateTime]$SelectedDateTime = [DateTime]$TodayDateTime
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#PAUSE
	
	$UserSelectedDateTime = $null
	
	Do {
		Clear-Host
		Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
		
		Write-HR -IsVerbose -DoubleLine
		
		If ($SelectedWeek -eq 0) {
			$ConvertedDoWMonSun = (Convert-DoWNumberToMonSun -Input $TodayDateTime)
			[int]$SelectedDoW = (Get-SundayOfWeekInt -DoWInput $ConvertedDoWMonSun)
			If ($TodayDoW -ne 7) {
				$SelectedDateTime = (Get-SaturdayOfWeek -DoWInput $TodayDateTime)
				$SelectedDateTime = $SelectedDateTime.AddDays(1) # Shift foward 1 day since we want (Mon-Sun) week instead of (Sun-Sat)
			} else { #Bugfix:
				$SelectedDateTime = $TodayDateTime
				<#
				#Bugfix:
				Since the system default of powershell is:
				
				Day-of-Week in number format, (Sun-Sat = 0-6):
				
				0 = Sunday
				1 = Monday
				2 = Tuesday
				3 = Wednesday
				4 = Thursday
				5 = Friday
				6 = Saturday
				
				If $Today is Sunday, asking Get-SaturdayOfWeek using $Today will count all the way out to next Saturday, 6 days ahead.
				
				This is because if it is Sunday, the new week has already started. But we want to use:
				
				Day-of-Week in number format, (Mon-Sun = 1-7):
				
				1 = Monday    - Dow = $default
				2 = Tuesday   - Dow = $default
				3 = Wednesday - Dow = $default
				4 = Thursday  - Dow = $default
				5 = Friday    - Dow = $default
				6 = Saturday  - Dow = $default
				7 = Sunday    - Dow = 7
				
				where Sunday is just the last day of THIS week, we don't need to ask Get-SaturdayOfWeek anything.
				#>
			}
		} Else {
			If ($SelectedWeek -lt 0) {
				$SelectedWeekPos = $SelectedWeek * -1
			} Else {
				$SelectedWeekPos = $SelectedWeek
			}
			
			$DaysToCountBackward = ([int]$TodayDoWNumberOneThruSeven)
			Write-Verbose "`$DaysToCountBackward = $DaysToCountBackward"
			
			If ($SelectedWeekPos -gt 1) {
				$DaysToCountBackward = $DaysToCountBackward + (($SelectedWeekPos - 1) * 7)
				Write-Verbose "`$DaysToCountBackward = $DaysToCountBackward"
			}
			
			$DaysToCountBackward = $DaysToCountBackward * -1
			Write-Verbose "`$DaysToCountBackward = $DaysToCountBackward"
			
			$SelectedDateTime = $TodayDateTime.AddDays($DaysToCountBackward)
			
			$SelectedDoW = 7
			
		}
		
		#$StartOfWeekMonthLong = Get-Date -Date (Get-MondayOfWeekInt -DoWInput $SelectedDoW) -UFormat %B
		$StartOfWeekSunSat = Get-SundayOfWeek -DoWInput $SelectedDateTime
		$StartOfWeekSunSatMonthLong = Get-Date -Date $StartOfWeekSunSat -UFormat %B
		#$StartOfWeekMonthShort = Get-Date -Date (Get-MondayOfWeekInt -DoWInput $SelectedDoW) -UFormat %b
		$StartOfWeekSunSatMonthShort = Get-Date -Date $StartOfWeekSunSat -UFormat %b
		
		#$EndOfWeekMonthLong = Get-Date -Date (Get-SundayOfWeekInt -DoWInput $SelectedDoW) -UFormat %B
		$EndOfWeekSunSat = Get-SaturdayOfWeek -DoWInput $SelectedDateTime
		$EndOfWeekSunSatMonthLong = Get-Date -Date $EndOfWeekSunSat -UFormat %B
		#$EndOfWeekMonthShort = Get-Date -Date (Get-SundayOfWeekInt -DoWInput $SelectedDoW) -UFormat %b
		$EndOfWeekSunSatMonthShort = Get-Date -Date $EndOfWeekSunSat -UFormat %b
		
		If ($StartOfWeekSunSatMonthLong -ne $EndOfWeekSunSatMonthLong) {
			Write-Verbose   "Month (Sun-Sat): $StartOfWeekSunSatMonthShort-$EndOfWeekSunSatMonthShort"
		} Else {
			Write-Verbose   "Month (Sun-Sat): $StartOfWeekSunSatMonthLong"
		}
		# Month/Day (MM/DD)
		Write-Verbose   "(Sun-Sat): Sun ($(Get-Date -Date $StartOfWeekSunSat -UFormat %m/%d))"
		Write-Verbose   "(Sun-Sat): Sat ($(Get-Date -Date $EndOfWeekSunSat -UFormat %m/%d))"
		
		# Week of the Year (00-52)
		$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
		Write-Verbose "`$WeekOfYearZero (00-52) = $WeekOfYearZero"
		
		# Week of the Year (01-53)
		$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
		Write-Verbose "`$WeekOfYear (01-53) = $WeekOfYear"
		
		# Week of the Year (01-53)
		$NextWeekOfYearZero = Get-Date -Date (($SelectedDateTime).AddDays(7)) -UFormat %W
		Write-Verbose "`$NextWeekOfYearZero (00-52) = $NextWeekOfYearZero"
		
		# Week of the Year (01-53)
		$NextWeekOfYear = Get-Date -Date (($SelectedDateTime).AddDays(7)) -UFormat %V
		Write-Verbose "`$NextWeekOfYear (01-53) = $NextWeekOfYear"
		
		# Week of the Year (01-53)
		$PreviousWeekOfYearZero = Get-Date -Date (($SelectedDateTime).AddDays(-7)) -UFormat %W
		Write-Verbose "`$PreviousWeekOfYearZero (00-52) = $PreviousWeekOfYearZero"
		
		# Week of the Year (01-53)
		$PreviousWeekOfYear = Get-Date -Date (($SelectedDateTime).AddDays(-7)) -UFormat %V
		Write-Verbose "`$PreviousWeekOfYear (01-53) = $PreviousWeekOfYear"
		
		Write-HR -IsVerbose -DashedLine
		
		Do {
			
			If ($SelectedDateTime -eq $TodayDateTime) {
				$TodayLabel = " (Today)"
			} Else {
				$TodayLabel = ""
			}
			
			If ($SelectedDateTime -eq $YesterdayDateTime) {
				$YesterdayLabel = " (Yesterday)"
			} Else {
				$YesterdayLabel = ""
			}
			
			#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			
			If ($SelectedDoW -eq 7) { # Sunday
				$Sunday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Sunday    = $Sunday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
				#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
				$EndOfWeekMonSun = Get-Date -Date $SelectedDateTime
				$EndOfWeekMonSunMonthLong = Get-Date -Date $SelectedDateTime -UFormat %B
				$EndOfWeekMonSunMonthShort = Get-Date -Date $SelectedDateTime -UFormat %b
			}
			
			If ($SelectedDoW -eq 6) { # Saturday
				$Saturday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Saturday  = $Saturday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
			}
			
			If ($SelectedDoW -eq 5) { # Friday
				$Friday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Friday    = $Friday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
			}
			
			If ($SelectedDoW -eq 4) { # Thursday
				$Thursday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Thursday  = $Thursday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
			}
			
			If ($SelectedDoW -eq 3) { # Wednesday
				$Wednesday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Wednesday = $Wednesday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
			}
			
			If ($SelectedDoW -eq 2) { # Tuesday
				$Tuesday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Tuesday   = $Tuesday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
			}
			
			If ($SelectedDoW -eq 1) { # Monday
				$Monday = $SelectedDateTime
				# Week of the Year (00-52)
				$WeekOfYearZero = Get-Date -Date $SelectedDateTime -UFormat %W
				$WeekOfYearZeroLabel = " WoY=($WeekOfYearZero/52)"
				# Week of the Year (01-53)
				$WeekOfYear = Get-Date -Date $SelectedDateTime -UFormat %V
				$WeekOfYearLabel = " WoY=($WeekOfYear/53)"
				Write-Verbose "Monday    = $Monday$($WeekOfYearZeroLabel)$($WeekOfYearLabel)$($TodayLabel)$($YesterdayLabel)"
				#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
				$StartOfWeekMonSun = Get-Date -Date $SelectedDateTime
				$StartOfWeekMonSunMonthLong = Get-Date -Date $SelectedDateTime -UFormat %B
				$StartOfWeekMonSunMonthShort = Get-Date -Date $SelectedDateTime -UFormat %b
			}
			
			$SelectedDoW = $SelectedDoW - 1
			$SelectedDateTime = ($SelectedDateTime).AddDays(-1)
			
		} until ($SelectedDoW -lt 1)
		
		If ($StartOfWeekMonSunMonthLong -ne $EndOfWeekMonSunMonthLong) {
			$MonthLabel = "$StartOfWeekMonSunMonthShort-$EndOfWeekMonSunMonthShort"
			Write-Verbose   "Month (Mon-Sun): $MonthLabel"
		} Else {
			$MonthLabel = "$StartOfWeekMonSunMonthLong"
			Write-Verbose   "Month (Mon-Sun): $MonthLabel"
		}
		# Month/Day (MM/DD)
		Write-Verbose   "(Mon-Sun): Mon ($(Get-Date -Date $StartOfWeekMonSun -UFormat %m/%d))"
		Write-Verbose   "(Mon-Sun): Sun ($(Get-Date -Date $EndOfWeekMonSun -UFormat %m/%d))"
		
		#-----------------------------------------------------------------------------------------------------------------------
		# Build Choice Prompt
		#-----------------------------------------------------------------------------------------------------------------------
		
		$Info = @"
Month: $MonthLabel
Week #$WeekOfYear/53
"@

If ($SelectedWeek -eq 0) {
$Info += "`r`n`r`n$TitleName"
}

<#
Legend:

R - Tomorrow
T - Today
Y - Yesterday
C - Current Week
N - Next Week

D - Sunday
S - Saturday
F - Friday
H - Thursday
W - Wednesday
U - Tuesday
M - Monday

O - Show/Hide Saturday & Sunday
P - Previous Week
L - Last Week
Q - Quit
#>

If ($SelectedWeek -ne 0) {
$Info += "`r`n`r`n[C] - Current Week (#$TodayWeekOfYear)`r`n"
$Info += "[N] - Next Week (#$NextWeekOfYear)`r`n`r`n"
}

If ($SelectedWeek -eq 0) {
$Info += "`r`n`r`n"
If ($TomorrowOption -eq $true) {
$Info += "[R] - ($TomorrowMonthDay) $TomorrowDoWLong - Tomo[r]row`r`n"
}
$Info += "[T] - ($TodayMonthDay) $TodayDoWLong - [T]oday`r`n"
$Info += "[Y] - ($YesterdayMonthDay) $YesterdayDoWLong - [Y]esterday`r`n"
}

If ($SelectedWeek -ne 0 -And $SatSunEnabled -eq $true) {
$Info += "[D] - ($(Get-Date -Date $Sunday -UFormat %m/%d)) Sunday`r`n"
$Info += "[S] - ($(Get-Date -Date $Saturday -UFormat %m/%d)) Saturday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 6) {
$Info += "[F] - ($(Get-Date -Date $Friday -UFormat %m/%d)) Friday`r`n"
}
} Else {
$Info += "[F] - ($(Get-Date -Date $Friday -UFormat %m/%d)) Friday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 5) {
$Info += "[H] - ($(Get-Date -Date $Thursday -UFormat %m/%d)) Thursday`r`n"
}
} Else {
$Info += "[H] - ($(Get-Date -Date $Thursday -UFormat %m/%d)) Thursday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 4) {
$Info += "[W] - ($(Get-Date -Date $Wednesday -UFormat %m/%d)) Wednesday`r`n"
}
} Else {
$Info += "[W] - ($(Get-Date -Date $Wednesday -UFormat %m/%d)) Wednesday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 3) {
$Info += "[U] - ($(Get-Date -Date $Tuesday -UFormat %m/%d)) Tuesday`r`n"
}
} Else {
$Info += "[U] - ($(Get-Date -Date $Tuesday -UFormat %m/%d)) Tuesday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 2) {
$Info += "[M] - ($(Get-Date -Date $Monday -UFormat %m/%d)) Monday`r`n"
}
} Else {
$Info += "[M] - ($(Get-Date -Date $Monday -UFormat %m/%d)) Monday`r`n"
}

$Info += "`r`n[P] - Previous Week (#$PreviousWeekOfYear)"

If ($SelectedWeek -ne 0) {
$Info += "`r`n[O] - Show/Hide Saturday & Sunday"
}

$Info += "`r`n`r`n[Q] - Quit`r`n`n`n"
		
		#Write-HR
		Write-Host "$Info"
		
		#Write-HR -IsVerbose -DashedLine
		#Write-HR
		
		
		#-----------------------------------------------------------------------------------------------------------------------
		# Execute Choice Prompt
		#-----------------------------------------------------------------------------------------------------------------------
		$Answer = Read-Host -Prompt "Select a choice"
		#-----------------------------------------------------------------------------------------------------------------------
		# Interpret answer
		#-----------------------------------------------------------------------------------------------------------------------
		#help about_switch
		#https://powershellexplained.com/2018-01-12-Powershell-switch-statement/#switch-statement
		#Write-Verbose "`$Answer = $Answer"
		switch ($Answer) {
			'R' { # R - Tomorrow
				If ($SelectedWeek -eq 0) {
					$UserSelectedDateTime = $TomorrowDateTime
				}
			}
			'T' { # T - Today
				If ($SelectedWeek -eq 0) {
					$UserSelectedDateTime = $TodayDateTime
				}
			}
			'Y' { # Y - Yesterday
				If ($SelectedWeek -eq 0) {
					$UserSelectedDateTime = $YesterdayDateTime
				}
			}
			'C' { # C - Current Week
				If ($SelectedWeek -ne 0) {
					$SelectedWeek = 0
				}
			}
			'N' { # N - Next Week
				If ($SelectedWeek -ne 0) {
					$SelectedWeek += 1
				}
			}
			'D' { # D - Sunday
				If ($SatSunEnabled -ne $true -Or $SelectedWeek -ne 0) {
					$UserSelectedDateTime = $Sunday
				}
			}
			'S' { # S - Saturday
				If ($SatSunEnabled -ne $true -Or $SelectedWeek -ne 0) {
					$UserSelectedDateTime = $Saturday
				}
			}
			'F' { # F - Friday
				$UserSelectedDateTime = $Friday
			}
			'H' { # H - Thursday
				$UserSelectedDateTime = $Thursday
			}
			'W' { # W - Wednesday
				$UserSelectedDateTime = $Wednesday
			}
			'U' { # U - Tuesday
				$UserSelectedDateTime = $Tuesday
			}
			'M' { # M - Monday
				$UserSelectedDateTime = $Monday
			}
			'O' { # O - Show/Hide Saturday & Sunday
				$SatSunEnabled = -not $SatSunEnabled
			}
			'P' { # P - Previous Week
				$SelectedWeek += -1
			}
			'L' { # L - Last Week
			}
			'Q' { # Q - Quit
				$UserSelectedDateTime = 'Quit/End/Exit'
			}
			
			default { # Choice not recognized.
				Write-Host `r`n
				Write-Host "Choice `"$Answer`" not recognized. Options must be one of the above."
				#Write-HorizontalRuleAdv -HRtype DashedLine
				Write-Host `r`n
				#Break #help about_Break
				PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "
				Write-Host `r`n
				Write-HorizontalRuleAdv -HRtype DashedLine
			}
		}
		#Write-Host "Answer is:"
		#Write-Host "$UserSelectedDateTime"
		
		
	} Until (!($null -eq $UserSelectedDateTime -Or $UserSelectedDateTime -eq "" -Or $UserSelectedDateTime -eq ''))
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-HR -IsVerbose -DashedLine
	Write-HR
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	
	#-----------------------------------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	Write-HR -IsVerbose
	Write-HR -IsVerbose
	Write-HR -IsVerbose -DashedLine
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	If ($null -eq $UserSelectedDateTime -Or $UserSelectedDateTime -eq "" -Or $UserSelectedDateTime -eq '') {
		Write-Host "Is this the pause you're looking for?"
		PAUSE
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Return $UserSelectedDateTime
	Write-Output $UserSelectedDateTime
	
} # End PromptForChoice-DayDate function -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

#-----------------------------------------------------------------------------------------------------------------------
Function Test-ValidateInteger { #---------------------------------------------------------------------------------------
	<#
	.PARAMETER ValueInput
	#>

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc. See 'help about_CommonParameters') the following 2 lines must be present:
	#[CmdletBinding()]
	#Param()

	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$true,Position=0,
		ValueFromPipeline = $true)]
		$ValueInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Sub-functions:
	#=======================================================================================================================
	#=======================================================================================================================
	
	#-----------------------------------------------------------------------------------------------------------------------
	function Validate-Integer { #-------------------------------------------------------------------------------------------
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
			# This [ValidateScript({})] does the exact same thing as the [ValidatePattern("")] above, it just throws much nicer, customizable error messages that actually explain why if failed (rather than "(?<![-.])\b[0-9]+\b(?!\.[0-9])").
			[ValidateScript({
				If ($_ -match "(?<![-.])\b[0-9]+\b(?!\.[0-9])") {
					$True
				} else {
					Throw "$_ must be a positive integer (whole number, no decimals). [ValidateScript({})] error."
				}
			})]
			#-----------------------------------------------------------------------------------------------------------------------
			# Bugfix: For the [ValidatePattern("")] or [ValidateScript({})] regex validation checks to work e.g. for strict integer validation (throw an error if a non-integer value is provided) do not define the var-type e.g. [int]$var since PowerShell will automatically round the input value to an integer BEFORE performing the regex comparisons. Instead, declare parameter without [int] defining the var-type e.g. $var,
			$InputToValidate
		)
		
		Return $InputToValidate
		#Return [int]$InputToValidate
	} # End Validate-Integer function --------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#-----------------------------------------------------------------------------------------------------------------------
	function Remove-LeadingZeros { #----------------------------------------------------------------------------------------
		Param (
			#Script parameters go here
			[Parameter(Mandatory=$true,Position=0,
			ValueFromPipeline = $true)]
			$VarInput
		)
		
		$VarSimplified = $VarInput.ToString().TrimStart('0')
		
		If ($VarSimplified -eq $null) {
			Write-Verbose "$VarName is `$null after removing leading zeros."
			$VarSimplified = '0'
		}
		If ($VarSimplified -eq "") {
			Write-Verbose "$VarName is equal to `"`" after removing leading zeros."
			$VarSimplified = '0'
		}
		If ($VarSimplified -eq '') {
			Write-Verbose "$VarName is equal to `'`' after removing leading zeros."
			$VarSimplified = '0'
		}
		
		Return $VarSimplified
	} # End Remove-LeadingZeros --------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#=======================================================================================================================
	#=======================================================================================================================
	# /Sub-functions
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Check if input is null
	If ($ValueInput -eq $null -Or $ValueInput -eq "" -Or $ValueInput -eq '') {
		Throw "`$ValueInput is either Null or an empty string."
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Remove leading zeros (0)
	$VarSimplified = Remove-LeadingZeros -VarInput $ValueInput
	Write-Verbose "Remove leading zeros (0) = $VarSimplified"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Check if $ValueInput is integer using Validate-Integer function
	try { # help about_Try_Catch_Finally
		#https://stackoverflow.com/questions/6430382/powershell-detecting-errors-in-script-functions
		$VarInteger = Validate-Integer $VarSimplified -ErrorVariable ValidateIntError
		# -ErrorVariable <variable_name> - Error is assigned to the variable name you specify. Even when you use the -ErrorVariable parameter, the $error variable is still updated.
		# If you want to append an error to the variable instead of overwriting it, you can put a plus sign (+) in front of the variable name. E.g. -ErrorVariable +<variable_name>
		#https://devblogs.microsoft.com/scripting/handling-errors-the-powershell-way/
	}
	catch {
		Write-Verbose "`$ValidateIntError:" # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
		Write-Verbose "$ValidateIntError" -ErrorAction 'SilentlyContinue' # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
		Throw "`$ValueInput must be an integer. (Whole numbers only, no decimals, no negatives.)"
		Return
	}
	
	Write-Verbose "Integer validation success = $VarInteger"
	
	Write-Verbose "`"$ValueInput`" value $VarInteger validation complete."
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$VarInteger
	
} # End Test-ValidateInteger function ----------------------------------------------------------------------------------
Set-Alias -Value "Test-ValidateInteger" -Name "Read-ValidateInteger"  # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptIntegerRange { #------------------------------------------------------------------------------------
	<#
	.PARAMETER HintMinMax
	Extra hint text string you can add that displays as a warning if user enters an integer input outside of Min-Max range. 
	
	This only happens at the end, after integer validation. If user enters a non-integer, those errors & warnings will be thrown first instead.
	
	The default display text during the Min-Max validation failure is:
	WARNING: $Label input must be between $MinInt-$MaxInt.
	
	If -HintMinMax is set, that string will also be displayed as a warning to help explain what the range is for.
	#>
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,
		ValueFromPipeline = $true)]
		[Alias('VarInput')]
		$ValueInput,
		
		[Parameter(Mandatory=$true,Position=0)]
		[Alias('VarName')]
		[string]$Label,
		
		[Parameter(Mandatory=$true,Position=1)]
		[int]$MinInt,
		
		[Parameter(Mandatory=$true,Position=2)]
		[int]$MaxInt,
		
		[Parameter(Mandatory=$false)]
		[string]$HintMinMax
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Check if we have a value sent in from an external variable (parameter) first
	If ($ValueInput -eq $null -or $ValueInput -eq "") {
		$PipelineInput = $false
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $ValueInput"
		$ValueInput = [string]$ValueInput #Bugfix: convert input from an object to a string
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Initialize test verification vars
	$IntegerValidation = $false
	$RangeValidation = $false
	
	# Begin loop to validate Input, and request new input from user if it fails validation.
	while ($IntegerValidation -eq $false -Or $RangeValidation -eq $false) {
		
		# Initialize test verification vars (at the start of each loop)
		$IntegerValidation = $false
		$RangeValidation = $false
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Prompt user for $Label value input
		If ($PipelineInput -ne $true) {
			Write-Verbose "No values piped-in from external sources (parameters)"
			$ValueInput = Read-Host -Prompt "Enter $Label"
			Write-Verbose "Entered value = $ValueInput"
		} else {
			Write-Verbose "Using piped-in value from parameter = $ValueInput"
			$PipelineInput = $false
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Call Test-ValidateInteger function
		
		# Check if $ValueInput is integer using Test-ValidateInteger function
		try { # help about_Try_Catch_Finally
			#https://stackoverflow.com/questions/6430382/powershell-detecting-errors-in-script-functions
			$VarInteger = Test-ValidateInteger $ValueInput -ErrorVariable ValidateIntError
			# -ErrorVariable <variable_name> - Error is assigned to the variable name you specify. Even when you use the -ErrorVariable parameter, the $error variable is still updated.
			# If you want to append an error to the variable instead of overwriting it, you can put a plus sign (+) in front of the variable name. E.g. -ErrorVariable +<variable_name>
			#https://devblogs.microsoft.com/scripting/handling-errors-the-powershell-way/
		}
		catch {
			#Write-HorizontalRuleAdv -DashedLine -IsVerbose
			Write-Verbose "`$ValidateIntError:" # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
			Write-Verbose "$ValidateIntError" -ErrorAction 'SilentlyContinue' # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
			#Write-Verbose "$error" -ErrorAction 'SilentlyContinue' # Command's error record will be appended to the "automatic variable" named $error
			#Write-HorizontalRuleAdv -DashedLine -IsWarning
			Write-Warning "$Label input must be an integer. (Whole numbers only, no decimals, no negatives.)"
			#PAUSE
			Write-Host `r`n
			Continue #help about_Continue
		}
		
		$IntegerValidation = $true
		
		Write-Verbose "Integer validation success = $VarInteger"
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Input range validation
		
		# Check if $Label input is between $MinInt and $MaxInt
		If ([int]$VarInteger -ge [int]$MinInt -And [int]$VarInteger -le [int]$MaxInt) {
			$VarRange = [int]$VarInteger
			$RangeValidation = $true
		} else {
			#Write-HorizontalRuleAdv -DashedLine -IsWarning
			Write-Warning "$Label input must be between $MinInt-$MaxInt."
			If (!($HintMinMax -eq $null -Or $HintMinMax -eq "")) {
				Write-Warning $HintMinMax
			}
			#PAUSE
			Write-Host `r`n
			Continue #help about_Continue
		}
		
		Write-Verbose "$Label value range validation = $VarRange"
		
	}
	
	Write-Verbose "$Label value $VarRange validation complete."
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$VarRange
	
} # End Read-PromptIntegerRange function -------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptIntegerRange" -Name "ReadPrompt-ValidateIntegerRange"  # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptHour { #--------------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		$VarInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarName = "Hour"
	
	$MinInt = 0
	
	$MaxInt = 23
	
	# since 24-hour time values are valid hour values
	
	$RangeFailureHintText = "$VarName input must be between 1-12 for AM/PM time, or 0-23 for 24-hour time."
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$OutputValue = Read-PromptIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText -ValueInput $VarInput
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$OutputValue
	
} # End Read-PromptHour function ---------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptHour" -Name "ReadPrompt-Hour" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptMinute { #------------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		$VarInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarName = "Minute"
	
	$MinInt = 0
	
	$MaxInt = 59
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$OutputValue = Read-PromptIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -ValueInput $VarInput
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$OutputValue
	
} # End Read-PromptMinute function -------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptMinute" -Name "ReadPrompt-Minute" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptDayOfMonth { #--------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		$VarInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarName = "DayOfMonth"
	
	$MinInt = 1
	
	$MaxInt = 31
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$OutputValue = Read-PromptIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -ValueInput $VarInput
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$OutputValue
	
} # End Read-PromptDayOfMonth function ---------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptDayOfMonth" -Name "ReadPrompt-DayOfMonth" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptMonth { #-------------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		$VarInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarName = "Month"
	
	$MinInt = 1
	
	$MaxInt = 12
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$OutputValue = Read-PromptIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -ValueInput $VarInput
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$OutputValue
	
} # End Read-PromptMonth function --------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptMonth" -Name "ReadPrompt-Month" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptYear { #--------------------------------------------------------------------------------------------
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[cmdletbinding()]
	#Param()
	[cmdletbinding()]
	Param(
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		$VarInput
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarName = "Year"
	
	$MinInt = 0
	
	$MaxInt = 9999
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$OutputValue = Read-PromptIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -ValueInput $VarInput
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return [int]$OutputValue
	
} # End Read-PromptYear function ---------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptYear" -Name "ReadPrompt-Year" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------
