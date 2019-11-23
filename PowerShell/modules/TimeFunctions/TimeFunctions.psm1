

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
	
	
} # End Total-TimestampArray function ----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



