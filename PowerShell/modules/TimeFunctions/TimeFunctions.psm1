

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
	#http://techgenix.com/powershell-functions-common-parameters/
	# To enable common parameters in functions (-Verbose, -Debug, etc. See 'help about_CommonParameters') the following 2 lines must be present:
	#[CdmdletBinding()]
	#Param()
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$true,Position=0,
		ValueFromPipeline = $true)]
		$ValueInput
	)
	
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
Function Read-PromptDayOfMonth { #------------------------------------------------------------------------------------------
	
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
	
} # End Read-PromptDayOfMonth function -------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptDayOfMonth" -Name "ReadPrompt-DayOfMonth" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptMonth { #------------------------------------------------------------------------------------------
	
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
	
} # End Read-PromptMonth function -------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptMonth" -Name "ReadPrompt-Month" # -Scope Global
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Read-PromptYear { #------------------------------------------------------------------------------------------
	
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
	
} # End Read-PromptYear function -------------------------------------------------------------------------------------
Set-Alias -Value "Read-PromptYear" -Name "ReadPrompt-Year" # -Scope Global
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



