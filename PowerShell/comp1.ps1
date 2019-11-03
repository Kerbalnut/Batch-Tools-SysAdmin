
#-----------------------------------------------------------------------------------------------------------------------
Function Log-Time { #---------------------------------------------------------------------------------------------------
	<#
		.SYNOPSIS
		Logs a timestamp to a .csv log file.
		
		.DESCRIPTION
		Logs a UTC/GMT (Coordinated Universal Time, Greenwich Mean Time) date & time value, the local timezone from where the entry was logged (ID and Name), a timestamp idenfitication 'type' tag, and a [Begin]/[End] tag for filtering purposes.
		
		.PARAMETER TimeLogFile
		TimeLogFile = "$env:USERPROFILE\Documents\TimeLog.csv"
		
		.PARAMETER Interactive
		Interactive
		
		.PARAMETER DateTimeInput
		DateTimeInput <date_time_object>
		
		.PARAMETER Description
		Description <string>
		
		.PARAMETER TimeStampTag
		TimeStampTag <custom_tag>
		
		.PARAMETER ClockIn
		ClockIn
		
		.PARAMETER ClockOut
		ClockOut
		
		.PARAMETER TimeStamp
		TimeStamp <timestamp_message>
		
		.PARAMETER TaskStart
		TaskStart <task_name>
		
		.PARAMETER TaskStop
		TaskStop
		
		.PARAMETER BreakStart
		BreakStart
		
		.PARAMETER BreakStop
		BreakStop
		
		.PARAMETER PauseStart
		PauseStart <pause_reason>
		
		.PARAMETER PauseStop
		PauseStop
		
		.PARAMETER ProjectStart
		ProjectStart <project_name>
		
		.PARAMETER ProjectStop
		ProjectStop <project_name>
		
		.PARAMETER Distraction
		Distraction
		
		.EXAMPLE
		Test-Param -A "Anne" -D "Dave" -F "Freddy"
		C:\PS>
		
		.NOTES
		CSV file format headers:

		TimeStampUT,TimeZoneID,TimeZoneName,[Begin/End/TimeStamp],Tag

	#>
	
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
		[Parameter(Mandatory=$true,Position=0)]
		[Alias('File','Path','FilePath')]
		[string]$TimeLogFile = "$env:USERPROFILE\Documents\TimeLog.csv", 
		
		[Parameter(Mandatory=$false)]
		[Alias('i','PickTime','Add')]
		[switch]$Interactive = $false,
		
		[Parameter(Mandatory=$false,
		ValueFromPipeline = $true)]
		[Alias('Date','Time')]
		[DateTime]$DateTimeInput,
		
		[Parameter(Mandatory=$false)]
		[Alias('d')]
		[string]$Description,
		
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
		[string]$TimeStamp,
		
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
		ParameterSetName='ProjectStartTag')]
		[string]$ProjectStart,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='ProjectStopTag')]
		[string]$ProjectStop,
		
		[Parameter(Mandatory=$false,
		ParameterSetName='DistractionTag')]
		[switch]$Distraction
		
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Function name:
	# https://stackoverflow.com/questions/3689543/is-there-a-way-to-retrieve-a-powershell-function-name-from-within-a-function#3690830
	#$FunctionName = (Get-PSCallStack | Select-Object FunctionName -Skip 1 -First 1).FunctionName
	#$FunctionName = (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
	$FunctionName = $PSCmdlet.MyInvocation.MyCommand.Name
	Write-Verbose "Running function: $FunctionName"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$TimeLogColumns = "DateTime"
	$TimeLogColumns += ",BeginEnd"
	$TimeLogColumns += ",TimeLogTag"
	$TimeLogColumns += ",Description"
	
	Write-Verbose "Log columns:`r`n'$TimeLogColumns'"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Evaluate input parameters
	#-----------------------------------------------------------------------------------------------------------------------
	
	#Bugfix: Old outputs were coming out of the function as well as the new ones.
	
	Clear-Variable -Name DateTimeToLog -ErrorAction SilentlyContinue | Out-Null
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Evaluate log file input parameter
	
	Write-Verbose "`$TimeLogFile = $TimeLogFile"
	
	If (!(Test-Path $TimeLogFile)) {
		Write-HR -IsWarning
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
			# No, do not create new file
			Return
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Evaluate -Interactive/-DateTimeInput parameters
	
	If ($DateTimeInput) {
		Write-Verbose "DateTimeInput = $DateTimeInput"
		Write-Host "DateTimeInput = $DateTimeInput"
		$DateTimeMode = 'InputProvided'
		$DateTimeValue = $DateTimeInput
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		#$DateInput = Get-Date -Date ((Get-Date -Date $DateTimeInput).ToUniversalTime()) -Format FileDateUniversal
		#$DateInput = Get-Date -Date $DateInput
		If ($PickTimeOnly -eq $true) {
			$DateInput = Get-Date -Date $DateTimeInput -Hour 0 -Minute 0 -Second 0 -Millisecond 0
		} Else {
			$DateInput = Get-Date -Date $DateTimeInput
		}
		Write-Verbose "Date input given = $DateInput"
	} elseif ($Interactive) {
		Write-Verbose "Interactive mode selected"
		Write-Host "Interactive mode selected"
		$DateTimeMode = 'Interactive'
	} else {
		Write-HR -IsWarning
		Write-Warning "No -DateTimeInput or -Interactive mode selected. Defaulting to -Interactive"
		$DateTimeMode = 'Interactive'
	}
	Write-Verbose "Date/Time mode selected = $DateTimeMode"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Set Timestamp Tag and Begin/End tag.
	
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
		$TimeLogTag = "TimeStamp='$TimeStamp'"
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
	
	If ($ProjectStart) {
		$TimeLogTag = "Project-Start='$ProjectStart'"
		$BeginEnd = "[TimeStamp]"
	}
	
	If ($ProjectStop) {
		$TimeLogTag = "Project-Stop='$ProjectStop'"
		$BeginEnd = "[TimeStamp]"
	}
	
	If ($Distraction) {
		$TimeLogTag = "Distraction"
		$BeginEnd = "[TimeStamp]"
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Default to [TimeStamp] tag if nothing else is selected.
	
	#If ($TimeLogTag -eq $null -Or $TimeLogTag -eq "") {
	If (($TimeLogTag -eq $null -Or $TimeLogTag -eq "") -And ($TimeLogTag -eq $null -Or $TimeLogTag -eq "")) {
		Write-HR -IsWarning
		Write-Warning "No TimeStampTag seleceted. Defaulting to [TimeStamp]"
		Write-Warning "No type of timestamp tag selected. Default is `"TimeStamp`""
		$TimeLogTag = "TimeStamp='defaultNoTagSelected'"
		$BeginEnd = "[TimeStamp]"
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Collect Date/Time value if interactive mode is set
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($DateTimeMode -eq 'Interactive') {
		Write-Host "Choose Day and Time . . . "
	}
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Write Time-Log Entry
	#-----------------------------------------------------------------------------------------------------------------------
	
	<#
	$TimeLogColumns = "DateTime"
	$TimeLogColumns += ",BeginEnd"
	$TimeLogColumns += ",TimeLogTag"
	$TimeLogColumns += ",Description"
	Write-Verbose "Log columns:`r`n'$TimeLogColumns'"
	#>
	
	$TimeLogEntry = $DateTimeValue
	$TimeLogEntry += ",$BeginEnd"
	$TimeLogEntry += ",$TimeLogTag"
	$TimeLogEntry += ",$Description"
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End Log-Time function ----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
