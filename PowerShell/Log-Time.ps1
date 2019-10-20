
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\PromptForChoice-DayDate.ps1"

#

#=======================================================================================================================

#

#-----------------------------------------------------------------------------------------------------------------------
Function Log-Time { #---------------------------------------------------------------------------------------------------
	<#
		.SYNOPSIS
		Logs a timestamp to a .csv log file.

		.DESCRIPTION
		Logs a UTC/GMT (Coordinated Universal Time, Greenwich Mean Time) timestamp 'type' tag

		.PARAMETER TimeLogFile
		TimeLogFile

		.PARAMETER TimeStampTag
		TimeStampTag

		.PARAMETER Interactive
		Interactive

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
        


	#>
    
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
		[Parameter(Mandatory=$true,Position=0)]
		[string]$TimeLogFile = '.\TimeLog.csv', 
		
		[Parameter(Mandatory=$false)]
		[Alias('i','PickTime','Add')]
		[switch]$Interactive = $false,
		
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
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Evaluate input parameters
	#-----------------------------------------------------------------------------------------------------------------------
	
	If (!(Test-Path $TimeLogFile)) {
		Write-Warning "Time-Log file does not exist: '$TimeLogFile'"
        Do {
            $UserInput = Read-Hose "Would you like to create it? [Y/N]"
        } until ($UserInput -eq 'y' -Or $UserInput -eq 'n')
        If ($UserInput -eq 'y') {
            New-Item $UserInput #| Out-Null
        } else {
            Return
        }
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
    
    $TodayDay = Get-Date
    Write-Verbose "`rToday: $TodayDay`r"
    
    $Yesterday = (Get-Date).AddDays(-1)
    Write-Verbose "Yesterday: $Yesterday"
    
    $Tomorrow = (Get-Date).AddDays(1)
    Write-Verbose "Tomorrow: $Tomorrow"
    
    #
    #=======================================================================================================================

    #
    If (!$Interactive) {
        $DateTimeToLog = Get-Date
        Write-Host "Writing current TimeStamp '(Get-Date)' to log ($TimeLogFile) . . ."
        $DateTimeToLog >> $TimeLogFile
    }
    #
    
    #=======================================================================================================================
	
} # End Log-Time function ----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#

#=======================================================================================================================
#-----------------------------------------------------------------------------------------------------------------------

#

$TodayDay = Get-Date

Write-Verbose "`rToday: $TodayDay`r"

$Yesterday = (Get-Date).AddDays(-1)

Write-Verbose "Yesterday: $Yesterday"

$Tomorrow = (Get-Date).AddDays(1)

Write-Verbose "Tomorrow: $Tomorrow"

#

#=======================================================================================================================

# Select Day:

#=======================================================================================================================

# Get Date to enter time for
$PickedDate = PromptForChoice-DayDate -TitleName "Select day to enter times for:"

# Collect time (display header)
Clear-Host
Start-Sleep -Milliseconds 100 #Bugfix: Clear-Host acts so quickly, sometimes it won't actually wipe the terminal properly. If you force it to wait, then after PowerShell will display any specially-formatted text properly.
Write-Host "`r`nSelected date: $($PickedDate.ToLongDateString())`n"
Write-Host "`r`n# Start Time #`n`r`n" -ForegroundColor Yellow

#Get Start time hour value
$StartHour = ReadPrompt-Hour

#Get Start time minute value
$StartMin = ReadPrompt-Minute

# Check if we even need to prompt the user for AM/PM time
If ($StartHour -gt 12 -Or $StartHour -eq 0) {
	$StartAMPM = 24
} else {
	$StartAMPM = ReadPrompt-AMPM24 # -Verbose
}

#Write-HorizontalRuleAdv -SingleLine

If ($StartAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -AM
    #$24hour = Convert-AMPMhourTo24hour $StartHour -AM -Verbose
} elseif ($StartAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -PM
    #$24hour = Convert-AMPMhourTo24hour $StartHour -PM -Verbose
} elseif ($StartAMPM -eq 24) {
    $24hour = $StartHour
} else {
	Write-Error "AM/PM/24-hour time mode not recognized."
}

$Timestamp = Get-Date -Date $PickedDate -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

Write-Host "Timestamp = $Timestamp"

#https://ss64.com/ps/syntax-dateformats.html
$Timestamp = Get-Date -Date $Timestamp -Format F

Write-Host "Timestamp = $Timestamp"

$StartTime = Get-Date -Date $PickedDate -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

Write-Host "Start time = $StartTime"

#https://ss64.com/ps/syntax-dateformats.html
#$StartTime = Get-Date -Date $StartTime -Format F

#Write-Host "Start time = $StartTime"

#

#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "`r`n# End Time #`n`r`n" -ForegroundColor Yellow

#$EndHour = Read-Host -Prompt "Enter End hour"
#$EndHour = ReadPrompt-Hour -Verbose
$EndHour = ReadPrompt-Hour

#$EndMin = Read-Host -Prompt "Enter End minute"
#$EndMin = ReadPrompt-Minute -Verbose
$EndMin = ReadPrompt-Minute

If ($EndHour -gt 12 -Or $EndHour -eq 0) {
	$EndAMPM = 24
} else {
	#$EndAMPM = ReadPrompt-AMPM24 -Verbose
    $EndAMPM = ReadPrompt-AMPM24
}

#Write-HorizontalRuleAdv -SingleLine

If ($EndAMPM -eq "AM") {
    #$24hour = Convert-AMPMhourTo24hour $EndHour -AM -Verbose
    $24hour = Convert-AMPMhourTo24hour $EndHour -AM
} elseif ($EndAMPM -eq "PM") {
    #$24hour = Convert-AMPMhourTo24hour $EndHour -PM -Verbose
    $24hour = Convert-AMPMhourTo24hour $EndHour -PM
} elseif ($EndAMPM -eq 24) {
    $24hour = $EndHour
} else {
	Write-Error "AM/PM/24-hour time mode not recognized."
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

Write-Host "Timestamp = $Timestamp"

#https://ss64.com/ps/syntax-dateformats.html
$Timestamp = Get-Date -Date $Timestamp -Format F

Write-Host "Timestamp = $Timestamp"

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

Write-Host "End time = $EndTime"

#https://ss64.com/ps/syntax-dateformats.html
#$EndTime = Get-Date -Date $EndTime -Format F

#Write-Host "End time = $EndTime"

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

$TimeGoal = (Get-Date -Hour 33 -Minute 0 -Second 0 -Millisecond 0).TimeOfDay

$TimeRemaining = $TimeGoal - $AccumulatedTime
$TimeRemaining = 33 - $AccumulatedTime.TotalHours

$AccumulatedTimeToday = (Get-Date -Hour 12 -Minute 25 -Second 0 -Millisecond 0).TimeOfDay - (Get-Date -Hour 8 -Minute 45 -Second 0 -Millisecond 0).TimeOfDay

$HourFormatted = ReadPrompt-Hour


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



