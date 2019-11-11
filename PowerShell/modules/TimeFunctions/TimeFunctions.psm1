

#-----------------------------------------------------------------------------------------------------------------------
Function DateToIso($Zeit) { #-------------------------------------------------------------------------------------------
  <#
  .NOTES
  Source Dr J R Stockton 
  .LINK
  https://ss64.com/ps/syntax-dateformats.htmls
  #>
  "Returns an array containing the ISO Year, Week and DayofWeek"
  $DayofWeek = +$Zeit.DayofWeek
  if ($DayofWeek -eq 0) { $DayofWeek = 7 }           # Mon=1..Sun=7
  $Thursday = $Zeit.AddDays(4 - $DayofWeek)          # Go to nearest Thursday
  $Week = 1+[Math]::Floor(($Thursday.DayOfYear-1)/7) # Adjusted seventh
  $Year = $Thursday.Year         # Needed
  $Year, $Week, $DayofWeek
} # End DateToIso function ---------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function PromptForChoice-DayDate { #------------------------------------------------------------------------------------
	
	<#
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
	
	# Sub-functions:
	#=======================================================================================================================
	
	#-----------------------------------------------------------------------------------------------------------------------
	function Convert-DoWNumberToMonSun { #----------------------------------------------------------------------------------
		<#
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

	#-----------------------------------------------------------------------------------------------------------------------
	function Get-SundayOfWeek { #-------------------------------------------------------------------------------------------
		<#	
		.SYNOPSIS
		Get Sunday of current week (Sun-Mon)
	
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

	#-----------------------------------------------------------------------------------------------------------------------
	function Get-SaturdayOfWeek { #-----------------------------------------------------------------------------------------
		<#
		.SYNOPSIS
		Get Sunday of current week (Sun-Sat)
	
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
	
	#=======================================================================================================================
	# /Sub-functions

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
	$PresentWeekSelected = $true
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
	

	} Until (!($UserSelectedDateTime -eq $null -Or $UserSelectedDateTime -eq "" -Or $UserSelectedDateTime -eq ''))

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
	
	If ($UserSelectedDateTime -eq $null -Or $UserSelectedDateTime -eq "" -Or $UserSelectedDateTime -eq '') {
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
Function ReadPrompt-Hour { #--------------------------------------------------------------------------------------------
	
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
	
	# Make function more customizable by condensing hard-coded values to the top
	
	$VarName = "Hour"
	
	$MinInt = 0
	
	$MaxInt = 23
	
	# since 24-hour time values are valid hour values
	
	$RangeFailureHintText = "$VarName input must be between 1-12 for AM/PM time, or 0-23 for 24-hour time."
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
		$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-Hour function ---------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-ValidateIntegerRange { #----------------------------------------------------------------------------
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
		$ValueInput,
		
		[Parameter(Mandatory=$true,Position=0)]
		[string]$Label,
		
		[Parameter(Mandatory=$true,Position=1)]
		[int]$MinInt,
		
		[Parameter(Mandatory=$true,Position=2)]
		[int]$MaxInt,
		
		[Parameter(Mandatory=$false)]
		[string]$HintMinMax
	)
	
	# Sub-functions:
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
		$VarSimplified = $VarInput.TrimStart('0')
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
	# /Sub-functions
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VarInput = $ValueInput
	
	$VarName = $Label
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
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
		
		# Prompt user for $VarName value input
		If ($PipelineInput -ne $true) {
			Write-Verbose "No values piped-in from external sources (parameters)"
			$VarInput = Read-Host -Prompt "Enter $VarName"
			Write-Verbose "Entered value = $VarInput"
		} else {
			Write-Verbose "Using piped-in value from parameter = $VarInput"
			$PipelineInput = $false
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Check if input is null
		If ($VarInput -eq $null -or $VarInput -eq "") {
			Write-HorizontalRuleAdv -DashedLine -IsWarning
			Write-Warning "$VarName input is null."
			#PAUSE
			Write-Host `r`n
			Continue #help about_Continue
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Remove leading zeros (0)
		$VarSimplified = Remove-LeadingZeros $VarInput
		Write-Verbose "Remove leading zeros (0) = $VarSimplified"
		
		# Remove leading zeros (0)
		<#
		$VarSimplified = $VarInput.TrimStart('0')
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
		Write-Verbose "Remove leading zeros (0) = $VarSimplified"
		#>
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Check if $VarName input is integer using Validate-Integer function
		try { # help about_Try_Catch_Finally
			#https://stackoverflow.com/questions/6430382/powershell-detecting-errors-in-script-functions
			$VarInteger = Validate-Integer $VarSimplified -ErrorVariable ValidateIntError
			# -ErrorVariable <variable_name> - Error is assigned to the variable name you specify. Even when you use the -ErrorVariable parameter, the $error variable is still updated.
			# If you want to append an error to the variable instead of overwriting it, you can put a plus sign (+) in front of the variable name. E.g. -ErrorVariable +<variable_name>
			#https://devblogs.microsoft.com/scripting/handling-errors-the-powershell-way/
		}
		catch {
			Write-HorizontalRuleAdv -DashedLine -IsVerbose
			Write-Verbose "`$ValidateIntError:" # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
			Write-Verbose "$ValidateIntError" -ErrorAction 'SilentlyContinue' # Error variable set using the -ErrorVariable "common parameter": Get-Help -Name about_CommonParameters
			#Write-HorizontalRuleAdv -SingleLine -IsVerbose
			#Write-Verbose "`$error:" # Command's error record will be appended to the "automatic variable" named $error
			#Write-HorizontalRuleAdv -DashedLine -IsVerbose
			#Write-Verbose "$error" -ErrorAction 'SilentlyContinue' # Command's error record will be appended to the "automatic variable" named $error
			Write-HorizontalRuleAdv -DashedLine -IsWarning
			Write-Warning "$VarName input must be an integer. (Whole numbers only, no decimals, no negatives.)"
			#PAUSE
			Write-Host `r`n
			Continue #help about_Continue
		}
		
		$IntegerValidation = $true
		
		Write-Verbose "Integer validation success = $VarInteger"
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Check if $VarName input is between $MinInt and $MaxInt
		If ([int]$VarInteger -ge [int]$MinInt -And [int]$VarInteger -le [int]$MaxInt) {
			$VarRange = [int]$VarInteger
			$RangeValidation = $true
		} else {
			Write-HorizontalRuleAdv -DashedLine -IsWarning
			Write-Warning "$VarName input must be between $MinInt-$MaxInt."
			If (!($HintMinMax -eq $null -Or $HintMinMax -eq "")) {
				Write-Warning $HintMinMax
			}
			#PAUSE
			Write-Host `r`n
			Continue #help about_Continue
		}
		
		Write-Verbose "$VarName value range validation = $VarRange"
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $VarRange validation complete."
	
	Return [int]$VarRange
	
} # End ReadPrompt-ValidateIntegerRange function -----------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-Minute { #------------------------------------------------------------------------------------------
	
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
	
	# Make function more customizable by condensing hard-coded values to the top
	
	$VarName = "Minute"
	
	$MinInt = 0
	
	$MaxInt = 59
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
		$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-Minute function -------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-DayOfMonth { #--------------------------------------------------------------------------------------
	
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
	
	# Make function more customizable by condensing hard-coded values to the top
	
	$VarName = "DayOfMonth"
	
	$MinInt = 1
	
	$MaxInt = 31
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
		$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-DayOfMonth function ---------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-Month { #-------------------------------------------------------------------------------------------
	
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
	
	# Make function more customizable by condensing hard-coded values to the top
	
	$VarName = "Month"
	
	$MinInt = 1
	
	$MaxInt = 12
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
		$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-Month function --------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function ReadPrompt-Year { #--------------------------------------------------------------------------------------------
	
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
	
	# Make function more customizable by condensing hard-coded values to the top
	
	$VarName = "Year"
	
	$MinInt = 1900
	
	$MaxInt = 2050
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Check if we have a value sent in from an external variable (parameter) first
	If ($VarInput -eq $null -or $VarInput -eq "") {
		$PipelineInput = $false
		$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-Year function ---------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------------------------------
Function Total-TimestampArray { #---------------------------------------------------------------------------------------
	
	Param (
		#Script parameters go here
		# https://ss64.com/ps/syntax-args.html
		[Parameter(Mandatory=$false,Position=0)]
		[string]$HRtype = 'SingleLine', 
		
		[Parameter(Mandatory=$false)]
		[switch]$Endcaps = $false,

		[Parameter(Mandatory=$false)]
		[string]$EndcapCharacter = '#',
		
		[Parameter(Mandatory=$false)]
		[switch]$IsWarning = $false,

		[Parameter(Mandatory=$false)]
		[switch]$IsVerbose = $false,

		[Parameter(Mandatory=$false)]
		[switch]$MaxLineLength = $false
	)
	
	# Function name:
	# https://stackoverflow.com/questions/3689543/is-there-a-way-to-retrieve-a-powershell-function-name-from-within-a-function#3690830
	#$FunctionName = (Get-PSCallStack | Select-Object FunctionName -Skip 1 -First 1).FunctionName
	#$FunctionName = (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
	$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-Verbose "Running function: $FunctionName"
	
	
} # End Total-TimestampArray function ---------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



