
#Requires -RunAsAdministrator

#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\PromptForChoice-DayDate.ps1"

#

<#
if (test-path "$env:USERPROFILE\Documents\TimeLog.csv") {
    del "$env:USERPROFILE\Documents\TimeLog.csv"
    Write-Host "deleted." -ForegroundColor green
    pause
}


if (test-path "$env:USERPROFILE\Documents\test.csv") {
    del "$env:USERPROFILE\Documents\test.csv"
    Write-Host "deleted." -ForegroundColor green
    pause
}

function test-thisfunc {
    new-item "$env:USERPROFILE\Documents\test.csv"
    Write-Host "Func accessed." -ForegroundColor Yellow
}

test-thisfunc
pause

if (test-path "$env:USERPROFILE\Documents\test.csv") {
    del "$env:USERPROFILE\Documents\test.csv"
    Write-Host "deleted." -ForegroundColor green
    #pause
}

pause
#>

#=======================================================================================================================

#

#-----------------------------------------------------------------------------------------------------------------------
Function Pick-TimeStampTag { #---------------------------------------------------------------------------------------------------
	<#
    #>
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[CmdletBinding()]
	#Param()
    
    Param(
        
		[Parameter(Mandatory=$false)]
		[Alias('i','PickTime','Add')]
		[switch]$BeginEndOutput = $false
		
    )
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$TimeLogTag = $TimeStampTag
	$BeginEnd = "[TimeStamp]"
	    
    $TimeLogTag = "Clock-In"
	$BeginEnd = "[Begin]"
	
	$TimeLogTag = "Clock-Out"
	$BeginEnd = "[End]"
	
	$TimeLogTag = "TimeStamp"
	$BeginEnd = "[TimeStamp]"
	
	$TimeLogTag = "Task-Start='$TaskStart'"
	$BeginEnd = "[Begin]"
	
	$TimeLogTag = "Task-Stop"
	$BeginEnd = "[End]"
	
	$TimeLogTag = "Break-Start"
	$BeginEnd = "[Begin]"
	
	$TimeLogTag = "Break-Stop"
	$BeginEnd = "[End]"
	
	$TimeLogTag = "Pause-Start='$PauseStart'"
	$BeginEnd = "[Begin]"
	
	$TimeLogTag = "Pause-Stop"
	$BeginEnd = "[End]"
	
	$TimeLogTag = "Distraction"
	$BeginEnd = "[TimeStamp]"
	
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
    If ($BeginEndOutput -eq $false) {
        Return $TimeLogTag
    } ElseIf ($BeginEndOutput -eq $true) {
        Return $BeginEnd
    }
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End 
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Log-Time { #---------------------------------------------------------------------------------------------------
	<#
		.SYNOPSIS
		Logs a timestamp to a .csv log file.

		.DESCRIPTION
		Logs a UTC/GMT (Coordinated Universal Time, Greenwich Mean Time) date & time value, the local timezone from where the entry was logged (ID and Name), a timestamp idenfitication 'type' tag, and a [Begin]/[End] tag for filtering purposes.

		.PARAMETER TimeLogFile
		TimeLogFile

		.PARAMETER Interactive
		Interactive

		.PARAMETER Date
		Date

		.PARAMETER PickTimeOnly
		PickTimeOnly

		.PARAMETER TimeStampTag
		TimeStampTag

		.PARAMETER ClockIn
		ClockIn

		.PARAMETER ClockOut
		ClockOut

		.PARAMETER TimeStamp
		TimeStamp

		.PARAMETER TaskStart
		TaskStart

		.PARAMETER TaskStop
		TaskStop
		
		.PARAMETER BreakStart
		BreakStart
		
		.PARAMETER BreakStop
		BreakStop
		
		.PARAMETER PauseStart
		PauseStart
		
		.PARAMETER PauseStop
		PauseStop
		
		.PARAMETER Distraction
		Distraction
		
		.EXAMPLE
		C:\PS> Test-Param -A "Anne" -D "Dave" -F "Freddy"
        
        .NOTES
        CSV file format headers:

        TimeStampUT,TimeZoneID,TimeZoneName,[Begin/End/TimeStamp],Tag

	#>
    
#Requires -RunAsAdministrator

	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
	#[CmdletBinding()]
	#Param()
	
	[CmdletBinding(DefaultParameterSetName='TimeStampTag')]
	
	Param (
		#[CmdletBinding(DefaultParameterSetName="ByUserName")]
		# Script parameters go here
		#https://ss64.com/ps/syntax-args.html
		#http://wahlnetwork.com/2017/07/10/powershell-aliases/
		#https://www.jonathanmedd.net/2013/01/add-a-parameter-to-multiple-parameter-sets-in-powershell.html
		[Parameter(Mandatory=$false,Position=0)]
		[string]$TimeLogFile = "$env:USERPROFILE\Documents\TimeLog.csv", 
		
		[Parameter(Mandatory=$false)]
		[Alias('i','PickTime','Add')]
		[switch]$Interactive = $false,

		[Parameter(Mandatory=$false)]
        [DateTime]$Date,

		[Parameter(Mandatory=$false)]
        [switch]$PickTimeOnly,
		
		[Parameter(Mandatory=$false,
		Position=1,
		ParameterSetName='CustomTag')]
		[string]$TimeStampTag,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='ClockInTag')]
		[switch]$ClockIn,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='ClockOutTag')]
		[switch]$ClockOut,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='TimeStampTag')]
		[switch]$TimeStamp,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='TaskStartTag')]
		[string]$TaskStart,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='TaskStopTag')]
		[switch]$TaskStop,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='BreakStartTag')]
		[switch]$BreakStart,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='BreakStopTag')]
		[switch]$BreakStop,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='PauseStartTag')]
		[string]$PauseStart,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='PauseStopTag')]
		[switch]$PauseStop,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='DistractionTag')]
		[switch]$Distraction
		
	)
	
	# Function name:
	# https://stackoverflow.com/questions/3689543/is-there-a-way-to-retrieve-a-powershell-function-name-from-within-a-function#3690830
	#$FunctionName = (Get-PSCallStack | Select-Object FunctionName -Skip 1 -First 1).FunctionName
	#$FunctionName = (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
	$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-Verbose "Running function: $FunctionName"
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Evaluate input parameters
	#-----------------------------------------------------------------------------------------------------------------------
    
    #Bugfix: Old outputs were coming out of the function as well as the new ones.
    
    Clear-Variable -Name DateTimeToLog -ErrorAction SilentlyContinue | Out-Null
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    Write-Verbose "`$TimeLogFile = $TimeLogFile"	

	If (!(Test-Path $TimeLogFile)) {
		Write-Warning "Time-Log file does not exist: '$TimeLogFile'"
        Do {
            $UserInput = Read-Host "Would you like to create it? [Y/N]"
        } until ($UserInput -eq 'y' -Or $UserInput -eq 'n')
        If ($UserInput -eq 'y') {
            #New-Item -Path $TimeLogFile -Credential (Get-Credential -Credential "$env:USERNAME") -ItemType "file" -Force #| Out-Null
            #Write-host "TROUBLESHOOTING 1"
            New-Item -Path $TimeLogFile -ItemType "file" -Force
            #Write-host "TROUBLESHOOTING 2"
            $CSVheaders = "TimeStampUT,TimeStampUT_Readable,TimeZoneID,TimeZoneName,[Begin/End/TimeStamp],Tag"
            $CSVheaders > $TimeLogFile
            $TimeLogPath = Split-Path -Path $TimeLogFile -Parent
            #dir $TimeLogPath
        } else {
            Return
        }
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
    If ($Date) {
        #$DateInput = Get-Date -Date ((Get-Date -Date $Date).ToUniversalTime()) -Format FileDateUniversal
        #$DateInput = Get-Date -Date $DateInput
        $DateInput = Get-Date -Date $Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0
        Write-Verbose "Date input given = $DateInput"
    }
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	If ($TimeStampTag) {
		$TimeLogTag = $TimeStampTag
		$BeginEnd = "[TimeStamp]"
	}
	
	If ($ClockIn) {
		$TimeLogTag = "Clock-In"
		$BeginEnd = "[Begin]"
	}
	
	If ($ClockOut) {
		$TimeLogTag = "Clock-Out"
		$BeginEnd = "[End]"
	}
	
	If ($TimeStamp) {
		$TimeLogTag = "TimeStamp"
		$BeginEnd = "[TimeStamp]"
	}
	
	If ($TaskStart) {
		$TimeLogTag = "Task-Start='$TaskStart'"
		$BeginEnd = "[Begin]"
	}
	
	If ($TaskStop) {
		$TimeLogTag = "Task-Stop"
		$BeginEnd = "[End]"
	}
	
	If ($BreakStart) {
		$TimeLogTag = "Break-Start"
		$BeginEnd = "[Begin]"
	}
	
	If ($BreakStop) {
		$TimeLogTag = "Break-Stop"
		$BeginEnd = "[End]"
	}
	
	If ($PauseStart) {
		$TimeLogTag = "Pause-Start='$PauseStart'"
		$BeginEnd = "[Begin]"
	}
	
	If ($PauseStop) {
		$TimeLogTag = "Pause-Stop"
		$BeginEnd = "[End]"
	}
	
	If ($Distraction) {
		$TimeLogTag = "Distraction"
		$BeginEnd = "[TimeStamp]"
	}
    
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	If (($TimeLogTag -eq $null -Or $TimeLogTag -eq "") -And ($TimeLogTag -eq $null -Or $TimeLogTag -eq "")) {
		$TimeLogTag = "TimeStamp"
		$BeginEnd = "[TimeStamp]"
        Write-Warning "No type of timestamp tag selected. Default is `"TimeStamp`""
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Build Time-Log Entry
	#-----------------------------------------------------------------------------------------------------------------------
    
    #=======================================================================================================================
    #
    
    $TodayDateTime = Get-Date
    Write-Verbose "`rToday: $TodayDateTime`r"
	$TodayDoWLong = Get-Date -UFormat %A
	# Month/Day (MM/DD)
	$TodayMonthDay = Get-Date -UFormat %m/%d
	# Day/Month (DD/MM)
	$TodayDayMonth = Get-Date -UFormat %d/%m
    
    $YesterdayDateTime = (Get-Date).AddDays(-1)
    Write-Verbose "Yesterday: $YesterdayDateTime"
	$YesterdayDoWLong = Get-Date -Date $YesterdayDateTime -UFormat %A
	# Month/Day (MM/DD)
	$YesterdayMonthDay = Get-Date -Date $YesterdayDateTime -UFormat %m/%d
	# Day/Month (DD/MM)
	$YesterdayDayMonth = Get-Date -Date $YesterdayDateTime -UFormat %d/%m
    
    $TomorrowDateTime = (Get-Date).AddDays(1)
    Write-Verbose "Tomorrow: $TomorrowDateTime"
	$TomorrowDoWLong = Get-Date -Date $TomorrowDateTime -UFormat %A
    # Month/Day (MM/DD)
	$TomorrowMonthDay = Get-Date -Date $TomorrowDateTime -UFormat %m/%d
	# Day/Month (DD/MM)
	$TomorrowDayMonth = Get-Date -Date $TomorrowDateTime -UFormat %d/%m
	
    #
    #=======================================================================================================================

    #
    If (!$Interactive) {
        Write-Host "Writing current TimeStamp '(Get-Date)' to log ($TimeLogFile) . . ."
        $DateTimeToLog = Get-Date
    } Else {
        
        #
        # Choose Date:
$DatePickerSimple = @"
Choose date:
        
[T] - ($TodayMonthDay) $TodayDoWLong - [T]oday
[Y] - ($YesterdayMonthDay) $YesterdayDoWLong - [Y]esterday

[P] - Pick a different date
"@
        If (!$PickTimeOnly) {
        
            PAUSE

            Do {
                #Clear-Host
                Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
                Write-Host $DatePickerSimple
                $UserResponse = Read-Host "`nEnter selection"
            } until ($UserResponse -eq 't' -Or $UserResponse -eq 'y' -Or $UserResponse -eq 'p')
            If ($UserResponse -eq 't') {
                $DateToLog = Get-Date
            } ElseIf ($UserResponse -eq 'y') {
                $DateToLog = (Get-Date).AddDays(-1)
            } ElseIf ($UserResponse -eq 'p') {
                $DateToLog = PromptForChoice-DayDate # -Verbose
            }

        } Else {
            $DateToLog = Get-Date -Date $DateInput
        }


        #
        # Choose Time:
        
        # Collect time (display header)
        #Clear-Host
        Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
        Write-Host "`r`nSelected date: $($DateToLog.ToLongDateString())`n"
        Write-Host "`r`n# Select Time #`n`r`n" -ForegroundColor Yellow

        #Get Selected time hour value
        $SelectedHour = ReadPrompt-Hour
        
        #Get Selected time minute value
        $SelectedMin = ReadPrompt-Minute
        
        # Check if we even need to prompt the user for AM/PM time
        If ($SelectedHour -gt 12 -Or $SelectedHour -eq 0) {
	        $SelectedAMPM = 24
        } else {
	        $SelectedAMPM = ReadPrompt-AMPM24 # -Verbose
        }
        
        #Write-HorizontalRuleAdv -SingleLine
        
        If ($SelectedAMPM -eq "AM") {
            $24hour = Convert-AMPMhourTo24hour $SelectedHour -AM
            #$24hour = Convert-AMPMhourTo24hour $SelectedHour -AM -Verbose
        } elseif ($SelectedAMPM -eq "PM") {
            $24hour = Convert-AMPMhourTo24hour $SelectedHour -PM
            #$24hour = Convert-AMPMhourTo24hour $SelectedHour -PM -Verbose
        } elseif ($SelectedAMPM -eq 24) {
            $24hour = $SelectedHour
        } else {
	        Write-Error "AM/PM/24-hour time mode not recognized."
        }
        
        $DateTimeObj = Get-Date -Date $DateToLog -Hour $24hour -Minute $SelectedMin -Second 0 -Millisecond 0
        
        Write-Verbose "DateTimeObj = $DateTimeObj"
        
        #https://ss64.com/ps/syntax-dateformats.html
        #$DateTimeToLog = Get-Date -Date $DateTimeToLog -Format F

        #Write-Host "DateTimeToLog = $DateTimeToLog"
        
        [DateTime]$DateTimeToLog = $DateTimeObj

    }
    #
    
    $UTCToLog = $DateTimeToLog.ToUniversalTime()
    # UniversalSortableDateTimePattern using the format for universal time display E.g. 2019-10-22 20:33:56Z
    $UTCToLog_Readable = Get-Date -Date $UTCToLog -Format u
    # FileDateTimeUniversal date and time in universal time (UTC), in 24-hour format. The format is yyyyMMddTHHmmssffffZ (case-sensitive, using a 4-digit year, 2-digit month, 2-digit day, the letter T as a time separator, 2-digit hour, 2-digit minute, 2-digit second, 4-digit millisecond, and the letter Z as the UTC indicator). For example: 20190627T1540500718Z.
    $UTCToLog = Get-Date -Date $UTCToLog -Format FileDateTimeUniversal
    $LocalTimeZoneID = (Get-TimeZone).Id
    $LocalTimeZoneName = (Get-TimeZone).DisplayName
    $NewRecord = "$UTCToLog,$UTCToLog_Readable,$LocalTimeZoneID,$LocalTimeZoneName,$BeginEnd,$TimeLogTag"
    $NewRecord >> $TimeLogFile | Out-Null

    #=======================================================================================================================

	Write-Host "DateTimeToLog = $DateTimeToLog"
    $DateTimeToLog = Get-Date -Date $DateTimeToLog
    
	Write-Host "DateTimeToLog = $DateTimeToLog"
    $DateTimeToLog = ($DateTimeToLog).DateTime

	Write-Host "DateTimeToLog = $DateTimeToLog"
    #$DateTimeToLog = [DateTime]$DateTimeToLog

	#Write-Host "DateTimeToLog = $DateTimeToLog"

    #Return $DateTimeToLog
    Write-Output -InputObject $DateTimeToLog -NoEnumerate

} # End Log-Time function ----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#

#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------

#

$TodayDateTime = Get-Date

Write-Verbose "`rToday: $TodayDateTime`r"

$Yesterday = (Get-Date).AddDays(-1)

Write-Verbose "Yesterday: $Yesterday"

$Tomorrow = (Get-Date).AddDays(1)

Write-Verbose "Tomorrow: $Tomorrow"

#

#=======================================================================================================================

# Select Day:

#=======================================================================================================================

# Collect time (display header)
Clear-Host
Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
Write-Host "`r`n# Start Time #`n`r`n" -ForegroundColor Yellow

PAUSE

$StartTime = Log-Time -Interactive -ClockIn -Verbose

Write-Host "Start time = $StartTime"

$StartTime | Get-Member | Out-Host

#https://ss64.com/ps/syntax-dateformats.html
#$StartTime = Get-Date -Date $StartTime -Format F

#Write-Host "Start time = $StartTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n# End Time #`n`r`n" -ForegroundColor Yellow

PAUSE

#$EndTime = Log-Time -Interactive -ClockOut -Verbose
$EndTime = ($StartTime).DateTime
$EndTime = Log-Time -Date $EndTime -PickTimeOnly -Interactive -ClockOut -Verbose

Write-Host "End time = $EndTime"

#https://ss64.com/ps/syntax-dateformats.html
#$EndTime = Get-Date -Date $EndTime -Format F

#Write-Host "End time = $EndTime"

PAUSE

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n"

Write-HR

Write-Host "`r`n`r`n"

#

$StartTimeStr = Get-Date $StartTime -Format F

$EndTimeStr = Get-Date $EndTime -Format F

Write-Host "Start time = $(Get-Date $StartTime -Format F)"

Write-Host "End time = $(Get-Date $EndTime -Format F)"

#$StartTime | Get-Member

$StartTimeOnly = ($StartTime).TimeOfDay

$EndTimeOnly = ($EndTime).TimeOfDay

Write-Host "Start time = $StartTimeOnly"

Write-Host "End time = $EndTimeOnly"

#$StartTimeOnly | Get-Member

$StartTime = Get-Date $StartTime

$EndTime = Get-Date $EndTime

Write-Host "Start time = $StartTime"

Write-Host "End time = $EndTime"

#

$TimeDifference = $EndTime - $StartTime

Write-Host "Time Duration = $TimeDifference (hours:minutes)"

#$TimeDifference | Get-Member

#$TimeDifferenceHours = $TimeDifference.Hours

#Write-Host "Time Duration (hours) = $TimeDifferenceHours"

$TimeDifferenceHours = $TimeDifference.TotalHours

Write-Host "Time Duration = $TimeDifferenceHours (hours)"

#

#$TimeGoal = Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0

#Write-Host "Time goal = $TimeGoal"

#$TimeGoalStr = $TimeGoal.ToShortTimeString()

#Write-Host "Time goal = $TimeGoalStr"

#$TimeGoalStr = $TimeGoal.ToLongTimeString()

#Write-Host "Time goal = $TimeGoalStr"

#$TimeGoalStr = Get-Date -Date $TimeGoal -Format t

#Write-Host "Time goal = $TimeGoalStr"

$TimeGoal = (Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0) - (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
$TimeGoal = (Get-Date -Hour 8 -Minute 0 -Second 0 -Millisecond 0).TimeOfDay

Write-Host "Time goal = $TimeGoal (hours:minutes)"

#$TimeGoal | Get-Member

#$TimeGoalHours = $TimeGoal.Hours

#Write-Host "Time goal (hours) = $TimeGoalHours"

$TimeGoalHours = $TimeGoal.TotalHours

Write-Host "Time goal = $TimeGoalHours (hours)"

#

$TimeRemaining = $TimeGoal - ($EndTime - $StartTime)

Write-Host "Time left = $TimeRemaining (hours:minutes)"

#$TimeRemaining = Get-Date -Date $TimeRemaining -Format t

#Write-Host "Time left = $TimeRemaining"

#$TimeRemaining | Get-Member

#$TimeRemainingHours = $TimeRemaining.Hours

#Write-Host "Time left (hours) = $TimeRemainingHours"

$TimeRemainingHours = $TimeRemaining.TotalHours

Write-Host "Time left = $TimeRemainingHours (hours)"

#

$AccumulatedTime = (Get-Date -Hour 8 -Minute 10 -Second 0 -Millisecond 0).TimeOfDay
$AccumulatedTime += (Get-Date -Hour 8 -Minute 15 -Second 0 -Millisecond 0).TimeOfDay
$AccumulatedTime += (Get-Date -Hour 8 -Minute 45 -Second 0 -Millisecond 0).TimeOfDay

$TimeGoal = New-TimeSpan -Hour 33

$TimeRemaining = $TimeGoal - $AccumulatedTime
$TimeRemaining = 33 - $AccumulatedTime.TotalHours

$AccumulatedTimeToday = (Get-Date -Hour 12 -Minute 25 -Second 0 -Millisecond 0).TimeOfDay - (Get-Date -Hour 8 -Minute 45 -Second 0 -Millisecond 0).TimeOfDay

$TimeRemainingToday = 33 - ($AccumulatedTime.TotalHours + $AccumulatedTimeToday.TotalHours)
$TimeRemainingToday = $TimeRemainingToday

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n"

Write-HR

Write-Host "`r`n"

#


#

#=======================================================================================================================

#



