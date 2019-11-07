
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
		$VarInput,

		[Parameter(Mandatory=$false)]
		[switch]$DoNotPromptUser
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
		If ($DoNotPromptUser) {
			$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText -DoNotPromptUser
		} Else {
			$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText
		}
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		If ($DoNotPromptUser) {
			$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText -DoNotPromptUser
		} Else {
			$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -HintMinMax $RangeFailureHintText
		}
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
		[string]$HintMinMax,

		[Parameter(Mandatory=$false)]
		[switch]$DoNotPromptUser
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
		$VarInput,

		[Parameter(Mandatory=$false)]
		[switch]$DoNotPromptUser
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
		If ($DoNotPromptUser) {
			$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -DoNotPromptUser
		} Else {
			$OutputValue = ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
		}
	} else {
		$PipelineInput = $true
		Write-Verbose "Piped-in content = $VarInput"
		$VarInput = [string]$VarInput #Bugfix: convert input from an object to a string
		If ($DoNotPromptUser) {
			$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt -DoNotPromptUser
		} Else {
			$OutputValue = $VarInput | ReadPrompt-ValidateIntegerRange -Label $VarName -MinInt $MinInt -MaxInt $MaxInt
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "$VarName value $OutputValue validation complete."
	
	Return $OutputValue
	
} # End ReadPrompt-Minute function -------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------












#-----------------------------------------------------------------------------------------------------------------------
Function Read-ValidateInteger { #----------------------------------------------------------------------------
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
	# /Sub-functions
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Check if input is null
		If ($ValueInput -eq $null -Or $ValueInput -eq "" -Or $ValueInput -eq '') {
			Throw "`$ValueInput is either Null or an empty string."
		}
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		# Remove leading zeros (0)
		$VarSimplified = Remove-LeadingZeros -VarInput $ValueInput
		Write-Verbose "Remove leading zeros (0) = $VarSimplified"
		
		# Remove leading zeros (0)
		<#
		$VarSimplified = $ValueInput.TrimStart('0')
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
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "`"$ValueInput`" value $VarInteger validation complete."
	
	Return [int]$VarInteger
	
} # End ReadPrompt-ValidateIntegerRange function -----------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------



