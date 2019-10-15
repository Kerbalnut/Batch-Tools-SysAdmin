
#-----------------------------------------------------------------------------------------------------------------------
Function PromptForChoice-DayDate { #------------------------------------------------------------------------------------
	
	<#
	.LINK
	https://ss64.com/ps/syntax-dateformats.html
	#>
	
	Param (
		#Script parameters go here
		[Parameter(Mandatory=$false,Position=0,
		ValueFromPipeline = $true)]
		[string]$TitleName,
		
		[Parameter(Mandatory=$false)]
		[string]$InfoDescription,
		
		[Parameter(Mandatory=$false)]
		[string]$HintPhrase
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$VerbosePreferenceOrig = $VerbosePreference
	#$VerbosePreference = "SilentlyContinue" # Will suppress Write-Verbose messages. This is the default value.
	$VerbosePreference = "Continue" # Will print out Write-Verbose messages. Gets set when -Verbose switch is used to run the script. (Or when you set the variable manually.)
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	# Collect date variables
	
	#https://ss64.com/ps/syntax-dateformats.html
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Today:
	
	$TodayDoWLong = Get-Date -UFormat %A
	Write-Verbose "`$TodayDoWLong = $TodayDoWLong"
	
	# Month/Day (MM/DD)
	$TodayMonthDay = Get-Date -Format 'm, M'
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
	
	$TodayDateTime = Get-Date
	
	$YesterdayDateTime = $TodayDateTime.AddDays(-1)
	Write-Verbose "`$YesterdayDateTime = $YesterdayDateTime"
	
	$YesterdayDateTime = (Get-Date).AddDays(-1)
	Write-Verbose "`$YesterdayDateTime = $YesterdayDateTime"
	
	$YesterdayDoW = Get-Date -Date $YesterdayDateTime -UFormat %A
	Write-Verbose "`$YesterdayDoW = $YesterdayDoW"
	
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -UFormat %m/%d
	Write-Verbose "`$YesterdayMonthDay = $YesterdayMonthDay"
	
	$YesterdayDayMonth = Get-Date -Date $YesterdayDateTime -UFormat %d/%m
	Write-Verbose "`$YesterdayDayMonth = $YesterdayDayMonth"
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Get earlier Days of Week
	
	Write-Verbose "Today:"
	
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
	
	# Day-of-Week in number format, (Sun-Sat = 0-6):
	<#
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	#>
	$TodayDoWNumber = Get-Date -UFormat %u
	Write-Verbose "`$TodayDoWNumber = $TodayDoWNumber"
	
	# Day-of-Week in number format, (Mon-Sun = 1-7):
	<#
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	7 = Sunday
	#>
	$TodayDoWNumberOneThruSeven = Get-Date -UFormat %u
	If ([int]$TodayDoWNumberOneThruSeven -eq 0) {$TodayDoWNumberOneThruSeven = 7}
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Test all Day-of-Week output
	
	Write-Verbose "Start of Loop."
	
	Write-HR -IsVerbose
	
	$CurrentDateTime = Get-Date
	
	For ($i=1; $i -le 7; $i++) {
	
	$DoWLong = Get-Date -Date $CurrentDateTime -UFormat %A
	Write-Verbose "`$DoWLong = $DoWLong"
	
	# Day-of-Week in 3 characters::
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
	$DoWShort = Get-Date -Date $CurrentDateTime -UFormat %a
	Write-Verbose "`$DoWShort = $DoWShort"
	
	# Day-of-Week in number format, (Sun-Sat = 0-6):
	<#
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	#>
	$DoWNumber = Get-Date -Date $CurrentDateTime -UFormat %u
	Write-Verbose "`$DoWNumber = $DoWNumber"
	
	# Day-of-Week in number format, (Mon-Sun = 1-7):
	<#
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	7 = Sunday
	#>
	$DoWNumberOneThruSeven = Get-Date -Date $CurrentDateTime -UFormat %u
	If ([int]$DoWNumberOneThruSeven -eq 0) {$DoWNumberOneThruSeven = 7}
	Write-Verbose "`$DoWNumberOneThruSeven = $DoWNumberOneThruSeven"
	
	$CurrentDateTime = $CurrentDateTime.AddDays(-1)
	
	Write-HR -IsVerbose
	
	}
	Write-Verbose "End of Loop."
	
	Write-HR -IsVerbose -DashedLine
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Fill in earlier days of the week.
	
	# 'Today' and 'Yesterday' will be constant. But we'll fill in every day earlier as an option, up to Monday. So starting at Wednesday and later, we'll calculate those values. And to do that we'll need the Day-of-Week as an integer value for Monday through Sunday.
	
	# Day-of-Week in number format, (Mon-Sun = 1-7):
	<#
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	7 = Sunday
	#>
	$TodayDoWNumberOneThruSeven = Get-Date -UFormat %u
	If ([int]$TodayDoWNumberOneThruSeven -eq 0) {$TodayDoWNumberOneThruSeven = 7}
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	
	
	$TodayDateTime = Get-Date
	
	$YesterdayDateTime = $TodayDateTime.AddDays(-1)
	
	
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	If ([int]$TodayDoWNumberOneThruSeven -ge 3) {
		
		$RollingInt = [int]$TodayDoWNumberOneThruSeven - 2
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = -2
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFive = (Get-Date).AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		$DayOptionFive = $TodayDateTime.AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFour = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionFour = $DayOptionFour"
		Write-Verbose "`$DayOptionFour = $(Get-Date -Date $DayOptionFour -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionThree = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionThree = $DayOptionThree"
		Write-Verbose "`$DayOptionThree = $(Get-Date -Date $DayOptionThree -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionTwo = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionTwo = $DayOptionTwo"
		Write-Verbose "`$DayOptionTwo = $(Get-Date -Date $DayOptionTwo -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionOne = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionOne = $DayOptionOne"
		Write-Verbose "`$DayOptionOne = $(Get-Date -Date $DayOptionOne -UFormat %A)"
		
		
		
		
		
	}
	
	
	
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	If ([int]$TodayDoWNumberOneThruSeven -ge 3) {
		
		$RollingInt = [int]$TodayDoWNumberOneThruSeven - 2
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = -2
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFive = (Get-Date).AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		$DayOptionFive = $TodayDateTime.AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive -UFormat %A)"
		$DayOptionFiveDate = $DayOptionFive.Date
		Write-Verbose "`$DayOptionFive = $($DayOptionFive.Date)"
		Write-Verbose "`$DayOptionFive = $DayOptionFiveDate"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive)"
		
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFour = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionFour = $DayOptionFour"
		Write-Verbose "`$DayOptionFour = $(Get-Date -Date $DayOptionFour -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionThree = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionThree = $DayOptionThree"
		Write-Verbose "`$DayOptionThree = $(Get-Date -Date $DayOptionThree -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionTwo = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionTwo = $DayOptionTwo"
		Write-Verbose "`$DayOptionTwo = $(Get-Date -Date $DayOptionTwo -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionOne = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionOne = $DayOptionOne"
		Write-Verbose "`$DayOptionOne = $(Get-Date -Date $DayOptionOne -UFormat %A)"
		
		
		
		
		
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Test past dates
	
	Write-HR -DashedLine
	
	Write-Host "`Test past dates"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "Start of Loop."
	
	$VerbosePreferenceOrig = $VerbosePreference
	$VerbosePreference = 'SilentlyContinue'
	
	Write-HR -IsVerbose
	
	$CurrentDateTime = Get-Date
	$LastWeekOfYear = ""
	#$LastMonthFull = ""
	$LastMonthFull = $TodayMonthFull
	
	# Week of the Year (00-52)
	$TodayWeekOfYearZero = Get-Date -UFormat %W
	Write-Verbose "`$TodayWeekOfYearZero (00-52) = $TodayWeekOfYearZero"
    
	# Week of the Year (01-53)
	$TodayWeekOfYear = Get-Date -UFormat %V
	Write-Verbose "`$TodayWeekOfYear (01-53) = $TodayWeekOfYear"
	
	$CountLoop = 45
	Write-Verbose "Days to count backwards: $CountLoop"
	
	#-----------------------------------------------------------------------------------------------------------------------
	For ($i=1; $i -le $CountLoop; $i++) {
	    
	    $DoWLong = Get-Date -Date $CurrentDateTime -UFormat %A
	    Write-Verbose "`$DoWLong = $DoWLong"
	    
	    # Day-of-Week in 3 characters::
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
	    $DoWShort = Get-Date -Date $CurrentDateTime -UFormat %a
	    Write-Verbose "`$DoWShort = $DoWShort"
    	
	    # Day-of-Week in number format, (Sun-Sat = 0-6):
	    <#
	    0 = Sunday
	    1 = Monday
	    2 = Tuesday
	    3 = Wednesday
	    4 = Thursday
	    5 = Friday
	    6 = Saturday
	    #>
	    $DoWNumber = Get-Date -Date $CurrentDateTime -UFormat %u
	    Write-Verbose "`$DoWNumber = $DoWNumber"
    	
	    # Day-of-Week in number format, (Mon-Sun = 1-7):
	    <#
	    1 = Monday
	    2 = Tuesday
	    3 = Wednesday
	    4 = Thursday
	    5 = Friday
	    6 = Saturday
	    7 = Sunday
	    #>
	    $DoWNumberOneThruSeven = Get-Date -Date $CurrentDateTime -UFormat %u
	    If ([int]$DoWNumberOneThruSeven -eq 0) {$DoWNumberOneThruSeven = 7}
	    Write-Verbose "`$DoWNumberOneThruSeven = $DoWNumberOneThruSeven"
    	
	    # Month/Day (MM/DD)
	    $MonthDay = Get-Date -Date $CurrentDateTime -UFormat %m/%d
	    Write-Verbose "`$MonthDay = $MonthDay"
    	
    	# Day/Month (DD/MM)
	    $DayMonth = Get-Date -Date $CurrentDateTime -UFormat %d/%m
	    Write-Verbose "`$DayMonth = $DayMonth"
    	
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
        $MonthShort = Get-Date -Date $CurrentDateTime -UFormat %b
	    Write-Verbose "`$MonthShort - $MonthShort"
    	    
        # Month name - full (January)
	    $MonthFull = Get-Date -Date $CurrentDateTime -UFormat %B
	    Write-Verbose "`$MonthFull = $MonthFull"
    	
	    # Week of the Year (00-52)
	    $WeekOfYearZero = Get-Date -Date $CurrentDateTime -UFormat %W
	    Write-Verbose "`$WeekOfYearZero (00-52) = $WeekOfYearZero"
        
	    # Week of the Year (01-53)
	    $WeekOfYear = Get-Date -Date $CurrentDateTime -UFormat %V
	    Write-Verbose "`$WeekOfYear (01-53) = $WeekOfYear"
    	
	    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    	
	    #Test case:
	    If ($i -eq 3) {
		    #$MonthFull = "December"
		    #$MonthShort = "Dec"
	    }
	    
    	
	    If ($WeekOfYear -eq $TodayWeekOfYear) {
		    Write-Verbose "Current week selected"
    		$WeekOfYearDisplayLabel = " - Current week."
	    } Else {
		    $WeekOfYearDisplayLabel = ""
    	}
    	
	    if ($MonthFull -ne $LastMonthFull) {
		    Write-Verbose "Month change detected."
    		$LastMonthFull = $MonthFull
	    	$MonthChangeDisplayLabel = " - Month change."
    	}  Else {
    		$MonthChangeDisplayLabel = ""
	    }
	    
    	if ($WeekOfYear -ne $LastWeekOfYear) {
    		Write-Verbose "New week detected."
	    	Write-Host "New week detected."
    		$LastWeekOfYear = $WeekOfYear
	    }
	    
	    
    	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    	
	    #Write-Host "$MonthDay - $DoWShort - $MonthShort - Week #($WeekOfYear/52)($WeekOfYearDisplayLabel)$($MonthChangeDisplayLabel)"
	    Write-Host "$MonthDay - $DoWShort - ($WeekOfYear/52) - $MonthShort$($WeekOfYearDisplayLabel)$($MonthChangeDisplayLabel)"
	    
    	$CurrentDateTime = $CurrentDateTime.AddDays(-1)
    	
	    Write-HR -IsVerbose
	}
	
	$VerbosePreference = 'Continue'
	$VerbosePreference = $VerbosePreferenceOrig
	Write-Verbose "End of Loop."
	
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
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# Build out currently selected week, out until Monday (Mon-Sun week display)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Get how many days we are away from Monday. 
	
	# Since the default output of PowerShell DoW is Sun-Sat = 0-6, we must convert it to our choice of a Monday through Sunday week format, Mon-Sun = 1-7.
	
	# Day-of-Week in number format, (Sun-Sat = 0-6):
	<#
	0 = Sunday
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	#>
	$TodayDoWNumber = Get-Date -Date $TodayDateTime -UFormat %u
	Write-Verbose "`$TodayDoWNumber = $TodayDoWNumber"
	
	# Day-of-Week in number format, (Mon-Sun = 1-7):
	<#
	1 = Monday
	2 = Tuesday
	3 = Wednesday
	4 = Thursday
	5 = Friday
	6 = Saturday
	7 = Sunday
	#>
	[int]$TodayDoWNumberOneThruSeven = Get-Date -Date $TodayDateTime -UFormat %u
	If ([int]$TodayDoWNumberOneThruSeven -eq 0) {$TodayDoWNumberOneThruSeven = 7}
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	

    function Convert-DoWNumberToMonSun {
    param(
        [parameter(Position=0)]
        [DateTime]$InputVal
    )
	$DoWNumberOneThruSeven = (Get-Date -Date $InputVal -UFormat %u)
	If ([int]$DoWNumberOneThruSeven -eq 0) {$DoWNumberOneThruSeven = 7}
	Write-Verbose "`$DoWNumberOneThruSeven = $DoWNumberOneThruSeven"
    Return [int]$DoWNumberOneThruSeven
	}

    function Convert-DoWNumberToSunSat {
    param(
        [parameter(Position=0)]
        [DateTime]$InputVal
    )
	$DoWNumberZeroThruSix = Get-Date -Date $InputVal -UFormat %u
	If ([int]$DoWNumberZeroThruSix -eq 7) {$DoWNumberZeroThruSix = 0}
	Write-Verbose "`$DoWNumberZeroThruSix = $DoWNumberZeroThruSix"
    Return [int]$DoWNumberZeroThruSix
	}

	[int]$DaysIntoTheWeek = [int]$TodayDoWNumberOneThruSeven
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	[int]$SelectedDoW = [int]$TodayDoWNumberOneThruSeven
	
	[DateTime]$SelectedDateTime = [DateTime]$TodayDateTime
    
    # Get Monday of current week

    function Get-MondayOfWeekInt {
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
    }


    function Get-SundayOfWeek {
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
    }
    
    # Get Sunday of current week

    function Get-SundayOfWeekInt {
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
    }

    function Get-SaturdayOfWeek {
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
    }
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
    Do {

        Write-HR -IsVerbose -DoubleLine

	    If ($SelectedWeek -eq 0) {
            $ConvertedDoWMonSun = (Convert-DoWNumberToMonSun -Input $TodayDateTime)
		    [int]$SelectedDoW = (Get-SundayOfWeekInt -DoWInput $ConvertedDoWMonSun)
		    $SelectedDateTime = (Get-SaturdayOfWeek -DoWInput $TodayDateTime)
            $SelectedDateTime = $SelectedDateTime.AddDays(1) # Shift foward 1 day since we want (Mon-Sun) week instead of (Sun-Sat)
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
            Write-Host "Month (Sun-Sat): $StartOfWeekSunSatMonthShort-$EndOfWeekSunSatMonthShort"
	    } Else {
            Write-Host "Month (Sun-Sat): $StartOfWeekSunSatMonthLong"
        }
    	# Month/Day (MM/DD)
        Write-Host "(Sun-Sat): Sun ($(Get-Date -Date $StartOfWeekSunSat -UFormat %m/%d))"
        Write-Host "(Sun-Sat): Sat ($(Get-Date -Date $EndOfWeekSunSat -UFormat %m/%d))"
        
    	# Week of the Year (00-52)
    	$WeekOfYearZero = Get-Date -Date $CurrentDateTime -UFormat %W
    	Write-Verbose "`$WeekOfYearZero (00-52) = $WeekOfYearZero"
           
    	# Week of the Year (01-53)
    	$WeekOfYear = Get-Date -Date $CurrentDateTime -UFormat %V
    	Write-Verbose "`$WeekOfYear (01-53) = $WeekOfYear"
        
        Write-HR -IsVerbose -DashedLine
    
    	Do {
		
	    	If ($SelectedDateTime -eq $TodayDateTime) {
		    #If ($SelectedDoW -eq $DaysIntoTheWeek) {
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
                $StartOfWeekMonSun = Get-Date -Date $SelectedDateTime
                $StartOfWeekMonSunMonthLong = Get-Date -Date $SelectedDateTime -UFormat %B
                $StartOfWeekMonSunMonthShort = Get-Date -Date $SelectedDateTime -UFormat %b
		    }
		    
		    $SelectedDoW = $SelectedDoW - 1
		    $SelectedDateTime = ($SelectedDateTime).AddDays(-1)
		
	    } until ($SelectedDoW -lt 1)
    
        If ($StartOfWeekMonSunMonthLong -ne $EndOfWeekMonSunMonthLong) {
            Write-Host "Month (Mon-Sun): $StartOfWeekMonSunMonthShort-$EndOfWeekMonSunMonthShort"
        } Else {
            Write-Host "Month (Mon-Sun): $StartOfWeekMonSunMonthLong"
        }
        # Month/Day (MM/DD)
        Write-Host "(Mon-Sun): Mon ($(Get-Date -Date $StartOfWeekMonSun -UFormat %m/%d))"
        Write-Host "(Mon-Sun): Sun ($(Get-Date -Date $EndOfWeekMonSun -UFormat %m/%d))"
        
    	Write-HR -IsVerbose -DashedLine
    	Write-HR
    	
        $SelectedWeek += -1
    
    } Until ($SelectedWeek -lt -3)

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-HR -IsVerbose -DashedLine
	Write-HR
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$YesterdayDateTime = $TodayDateTime.AddDays(-1)
	
	<#
	1 = Monday		
	2 = Tuesday		
	3 = Wednesday	-2 = 1 Monday
	4 = Thursday	-3 = 1 Monday, -2 = Tuesday
	5 = Friday		-4 = 1 Monday, -3 = Tuesday, -2 = Wednesday
	6 = Saturday	-5 = 1 Monday, -4 = Tuesday, -3 = Wednesday, -2 = Thursday
	7 = Sunday		-6 = 1 Monday, -5 = Tuesday, -4 = Wednesday, -3 = Thursday, -2 = Friday
	#>
	
	<#
	1 = Monday		
	2 = Tuesday		
	3 = Wednesday	DayOptionOne = -2 = 1 Monday
	4 = Thursday	DayOptionTwo = -3 = 1 Monday, -2 = Tuesday
	5 = Friday		DayOptionThree = -4 = 1 Monday, -3 = Tuesday, -2 = Wednesday
	6 = Saturday	DayOptionFour = -5 = 1 Monday, -4 = Tuesday, -3 = Wednesday, -2 = Thursday
	7 = Sunday		DayOptionFive = -6 = 1 Monday, -5 = Tuesday, -4 = Wednesday, -3 = Thursday, -2 = Friday
	#>
	
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	If ([int]$TodayDoWNumberOneThruSeven -ge 3) {
		
		$RollingInt = [int]$TodayDoWNumberOneThruSeven - 2
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = -2
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFive = (Get-Date).AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		$DayOptionFive = $TodayDateTime.AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFour = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionFour = $DayOptionFour"
		Write-Verbose "`$DayOptionFour = $(Get-Date -Date $DayOptionFour -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionThree = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionThree = $DayOptionThree"
		Write-Verbose "`$DayOptionThree = $(Get-Date -Date $DayOptionThree -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionTwo = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionTwo = $DayOptionTwo"
		Write-Verbose "`$DayOptionTwo = $(Get-Date -Date $DayOptionTwo -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionOne = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionOne = $DayOptionOne"
		Write-Verbose "`$DayOptionOne = $(Get-Date -Date $DayOptionOne -UFormat %A)"
		
		
		
		
		
	}
	
	Write-Verbose "`$TodayDoWNumberOneThruSeven = $TodayDoWNumberOneThruSeven"
	
	If ([int]$TodayDoWNumberOneThruSeven -ge 3) {
		
		$RollingInt = [int]$TodayDoWNumberOneThruSeven - 2
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = -2
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFive = (Get-Date).AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		$DayOptionFive = $TodayDateTime.AddDays($DaysBefore) # Two days before
		Write-Verbose "`$DayOptionFive = $DayOptionFive"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive -UFormat %A)"
		$DayOptionFiveDate = $DayOptionFive.Date
		Write-Verbose "`$DayOptionFive = $($DayOptionFive.Date)"
		Write-Verbose "`$DayOptionFive = $DayOptionFiveDate"
		Write-Verbose "`$DayOptionFive = $(Get-Date -Date $DayOptionFive)"
		
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionFour = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionFour = $DayOptionFour"
		Write-Verbose "`$DayOptionFour = $(Get-Date -Date $DayOptionFour -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionThree = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionThree = $DayOptionThree"
		Write-Verbose "`$DayOptionThree = $(Get-Date -Date $DayOptionThree -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionTwo = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionTwo = $DayOptionTwo"
		Write-Verbose "`$DayOptionTwo = $(Get-Date -Date $DayOptionTwo -UFormat %A)"
		
		$RollingInt = $RollingInt - 1
		Write-Verbose "`$RollingInt = $RollingInt"
		$DaysBefore = $DaysBefore - 1
		Write-Verbose "`$DaysBefore = $DaysBefore"
		$DayOptionOne = $TodayDateTime.AddDays($DaysBefore)
		Write-Verbose "`$DayOptionOne = $DayOptionOne"
		Write-Verbose "`$DayOptionOne = $(Get-Date -Date $DayOptionOne -UFormat %A)"
		
		
		
		
		
	}
	
	
	
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
	
	PAUSE
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Build Choice Prompt
	#-----------------------------------------------------------------------------------------------------------------------
	$Title = "$TitleName?"
	$Info = "$InfoDescription"
	$Info = @"
Month: $TodayMonth
Week #$TodayWeekOfYear/53

Select day:

T - Today - $TodayDoWLong ($TodayMonthDay)
Y - Yesterday - $YesterdayDoW ($YesterdayMonthDay)
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

Select a choice:
"@
	Write-Host "$Info"
	
	$Info = @"
Choose day:

T - Today
Y - Yesterday
"@
	
	$Info += @"
Choose day:

T - Today
Y - Yesterday

F - Friday
H - Thursday
W - Wednesday
U - Tuesday
M - Monday

L - Last Week
Q - Quit

Select a choice:
"@
	
	
	$ChoiceYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "[Y]es, $HintPhrase."
	$ChoiceNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "[N]o, do not $HintPhrase."
	$Options = [System.Management.Automation.Host.ChoiceDescription[]]($ChoiceYes, $ChoiceNo)
	# default choice: 0 = first Option, 1 = second option, etc.
	[int]$defaultchoice = 0
	#-----------------------------------------------------------------------------------------------------------------------
	# Execute Choice Prompt
	#-----------------------------------------------------------------------------------------------------------------------
	# PromptForChoice() output will always be integer: https://powershell.org/forums/topic/question-regarding-result-host-ui-promptforchoice/
	If ($InfoDescription) {
		$answer = $host.UI.PromptForChoice($Title, $Info, $Options, $defaultchoice)
	} else {
		$answer = $host.UI.PromptForChoice($Title, "", $Options, $defaultchoice)
	}
	#-----------------------------------------------------------------------------------------------------------------------
	# Interpret answer
	#-----------------------------------------------------------------------------------------------------------------------
	#help about_switch
	#https://powershellexplained.com/2018-01-12-Powershell-switch-statement/#switch-statement
	#Write-Verbose "Answer = $answer"
	switch ($answer) {
		0 { # Y - Yes
			Write-Verbose "Yes ('$answer') option selected."
			$ChoiceResultVar = 'Y'
		}
		1 { # N - No
			Write-Verbose "No ('$answer') option selected."
			$ChoiceResultVar = 'N'
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return $ChoiceResultVar

} # End PromptForChoice-DayDate function -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

PromptForChoice-DayDate
