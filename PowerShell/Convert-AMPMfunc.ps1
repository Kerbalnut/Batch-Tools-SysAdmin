
Function Convert-AMPMhourTo24hour {
	<#
		.SYNOPSIS
		Convert an hour value in AM/PM format to the equivalent 24-hour value.
		
		.DESCRIPTION
		Enter a 12-hour format value plus its AM/PM value, and this cmdlet will return the equivalent 24-hour format hour value from 0-23. Must specify either -AM or -PM switch.
		
		.PARAMETER Hours
		The AM/PM hour value, from 1-12
		
		.PARAMETER AM
		Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>
		
		.PARAMETER PM
		Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>
	#>
	[cmdletbinding()]
	Param (
        
		
        
		#Script parameters go here
		[Parameter(Mandatory=$true,Position=0)]
		# Validate a positive integer (whole number) using Regular Expressions:
		#https://stackoverflow.com/questions/16774064/regular-expression-for-whole-numbers-and-integers
		#	(?<![-.])		# Assert that the previous character isn't a minus sign or a dot.
		#	\b				# Anchor the match to the start of a number.
		#	[0-9]+			# Match a number.
		#	\b				# Anchor the match to the end of the number.
		#	(?!\.[0-9])		# Assert that no decimal part follows.
		#$RegEx = "(?<![-.])\b[0-9]+\b(?!\.[0-9])"
		#[ValidatePattern("(?<![-.])\b[0-9]+\b(?!\.[0-9])")]
		# This [ValidateScript({))] does the exact same thing as the [ValidatePattern("")] above, it just throws much nicer, customizable error messages.
        
		[ValidateScript({
            If ($_ -match "(?<![-.])\b[0-9]+\b(?!\.[0-9])") {
                $True
            } else {
                Throw "$_ must be a positive integer (whole number, no decimals)."
            }
        })]
		
		[ValidateRange(1,12)]
		# Bugfix: To properly validate regex for integer ranges, and throw an error if a decimal value is provided, do not use [int]$var since PowerShell will automatically round the input value before performing the [ValidatePattern("")] regex comparison. Instead, declare parameter without [int] e.g. $var,
		$Hours,
		
		
		
		
		[Parameter(Mandatory=$true,
		ParameterSetName='AMtag')]
		[switch]$AM,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='PMtag')]
		[switch]$PM
	)
	
    Write-Host "'`$Hours' = '$Hours'"
    Write-Verbose "'`$Hours' = '$Hours'"
    
	<#
	------------------------------------------------------------------------------------------------
	12:00 AM = 00:00	*** exception: if AM hours = 12, subtract 12 for 24-hours	\
	1:00 AM = 01:00		\															 |
	2:00 AM = 02:00		 |															 |
	3:00 AM = 03:00		 |															 |
	4:00 AM = 04:00		 |															 |
	5:00 AM = 05:00		 |															 |
	6:00 AM = 06:00		 |------- AM time = 24-hour time							 |-------  AM
	7:00 AM = 07:00		 |															 |
	8:00 AM = 08:00		 |															 |
	9:00 AM = 09:00		 |															 |
	10:00 AM = 10:00	 |															 |
	11:00 AM = 11:00____/___________________________________________________________/_______________
	12:00 PM = 12:00	*** exception: if PM hours = 12, 24-hours = 12				\
	1:00 PM = 13:00		\															 |
	2:00 PM = 14:00		 |															 |
	3:00 PM = 15:00		 |															 |
	4:00 PM = 16:00		 |															 |
	5:00 PM = 17:00		 |															 |
	6:00 PM = 18:00		 |------- PM hours + 12 = 24-hours							 |-------  PM
	7:00 PM = 19:00		 |															 |
	8:00 PM = 20:00		 |															 |
	9:00 PM = 21:00		 |															 |
	10:00 PM = 22:00	 |															 |
	11:00 PM = 23:00	/															/
	------------------------------------------------------------------------------------------------
	#>
	
	#-----------------------------------------------------------------------------------------------------------------------
	# Convert AM hours
	#-----------------------------------------------------------------------------------------------------------------------
	
	If ($AM) {
		
		
		
		
	}
	
	
} # End Convert-AMPMhourTo24hour function -------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#

Write-Host "--------------------------------------------------------------------------------------------------"
Write-Host "--------------------------------------------------------------------------------------------------"

<#
11.6
11.4
11
011
9.6
9.4
09
9
-9

#>

#help Convert-AMPMhourTo24hour -full


Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 0 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 1 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 12 -AM


Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 09.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 09.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 11.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 11.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 11 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 011 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 9.6 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour 9.4 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 009 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 09 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Success:" -ForegroundColor Green
Convert-AMPMhourTo24hour 9 -AM

Write-Host "--------------------------------------------------------------------------------------------------"

Write-Host "Failure:"
Convert-AMPMhourTo24hour -9 -AM

#





