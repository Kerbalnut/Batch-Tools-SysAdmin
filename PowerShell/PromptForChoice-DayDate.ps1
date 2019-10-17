﻿
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
		[string]$TitleName,
		
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
	#-----------------------------------------------------------------------------------------------------------------------
    function Convert-DoWNumberToMonSun { #----------------------------------------------------------------------------------
	    <#
        .NOTES
        Day-of-Week in number format, (Mon-Sun = 1-7):
        
	    1 = Monday
	    2 = Tuesday
	    3 = Wednesday
	    4 = Thursday
	    5 = Friday
  	    6 = Saturday
	    7 = Sunday
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
	
    $TodayDoWNumberOneThruSeven = Convert-DoWNumberToMonSun $TodayDateTime

	[int]$DaysIntoTheWeek = [int]$TodayDoWNumberOneThruSeven
	[int]$SelectedDoW = [int]$TodayDoWNumberOneThruSeven
	[int]$TodayDoW = [int]$TodayDoWNumberOneThruSeven

	[DateTime]$SelectedDateTime = [DateTime]$TodayDateTime
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	PAUSE
	
    Do {
		Clear-Host
		
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
$Info += "`r`n`r`nSelect day:"
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
$Info += "`r`n`r`nC - Current Week (#$TodayWeekOfYear)`r`n"
$Info += "N - Next Week`r`n`r`n"
}

If ($SelectedWeek -eq 0) {
$Info += "`r`n`r`n"
If ($TomorrowOption -eq $true) {
$Info += "R - ($TomorrowMonthDay) $TomorrowDoWLong - Tomorrow`r`n"
}
$Info += "T - ($TodayMonthDay) $TodayDoWLong - Today`r`n"
$Info += "Y - ($YesterdayMonthDay) $YesterdayDoWLong - Yesterday`r`n"
}

If ($SelectedWeek -ne 0 -And $SatSunEnabled -eq $true) {
$Info += "D - ($(Get-Date -Date $Sunday -UFormat %m/%d)) Sunday`r`n"
$Info += "S - ($(Get-Date -Date $Saturday -UFormat %m/%d)) Saturday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 6) {
$Info += "F - ($(Get-Date -Date $Friday -UFormat %m/%d)) Friday`r`n"
}
} Else {
$Info += "F - ($(Get-Date -Date $Friday -UFormat %m/%d)) Friday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -eq 5) {
$Info += "H - ($(Get-Date -Date $Thursday -UFormat %m/%d)) Thursday`r`n"
}
} Else {
$Info += "H - ($(Get-Date -Date $Thursday -UFormat %m/%d)) Thursday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 4) {
333$Info += "W - ($(Get-Date -Date $Wednesday -UFormat %m/%d)) Wednesday`r`n"
}
} Else {
$Info += "W - ($(Get-Date -Date $Wednesday -UFormat %m/%d)) Wednesday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 3) {
$Info += "U - ($(Get-Date -Date $Tuesday -UFormat %m/%d)) Tuesday`r`n"
}
} Else {
$Info += "U - ($(Get-Date -Date $Tuesday -UFormat %m/%d)) Tuesday`r`n"
}

If ($SelectedWeek -eq 0) {
If ($TodayDoW -gt 2) {
$Info += "M - ($(Get-Date -Date $Monday -UFormat %m/%d)) Monday`r`n"
}
} Else {
$Info += "M - ($(Get-Date -Date $Monday -UFormat %m/%d)) Monday`r`n"
}

$Info += "`r`nP - Previous Week"

If ($SelectedWeek -ne 0) {
$Info += "`r`nO - Show/Hide Saturday & Sunday"
}

$Info += "`r`n`r`nQ - Quit`r`n`n`n"
    	
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
			}
			'T' { # T - Today
			}
			'Y' { # Y - Yesterday
			}
			'C' { # C - Current Week
				$SelectedWeek = 0
			}
			'N' { # N - Next Week
				$SelectedWeek += 1
			}
			'D' { # D - Sunday
			}
			'S' { # S - Saturday
			}
			'F' { # F - Friday
			}
			'H' { # H - Thursday
			}
			'W' { # W - Wednesday
			}
			'U' { # U - Tuesday
			}
			'M' { # M - Monday
			}
			'O' { # O - Show/Hide Saturday & Sunday
			}
			'P' { # P - Previous Week
				$SelectedWeek += -1
			}
			'L' { # L - Last Week
			}
			'Q' { # Q - Quit
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
	

        
    
    } Until ($Answer -eq 'R' -Or $Answer -eq 'T' -Or $Answer -eq 'Y' -Or $Answer -eq 'D' -Or $Answer -eq 'S' -Or $Answer -eq 'F' -Or $Answer -eq 'H' -Or $Answer -eq 'W' -Or $Answer -eq 'U' -Or $Answer -eq 'M' -Or $Answer -eq 'Q')

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
	
	PAUSE
	
	#-----------------------------------------------------------------------------------------------------------------------
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Return $ChoiceResultVar

} # End PromptForChoice-DayDate function -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

PromptForChoice-DayDate # -Verbose
