
Function Convert-AMPMhourTo24hour {
	<#
		.SYNOPSIS
		Convert an hour value in AM/PM format to a 24-hour value.
		
		.DESCRIPTION
		Enter a 12-hour format value plus its AM/PM value, and this cmdlet will return the equivalent 24-hour format hour value from 0-23. Must specify either -AM or -PM switch.
		
		.PARAMETER Hours
		The AM/PM hour value, from 1-12
		
		.PARAMETER AM
		Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>
		
		.PARAMETER PM
		Add a character to each end of the horizontal rule. Default is '#'. Set a different endcap character using -EndcapCharacter <single character>
	#>
	
	Param (
		#Script parameters go here
		# https://ss64.com/ps/syntax-args.html
		[Parameter(Mandatory=$true,Position=0)]
		#[ValidateRange(1,12)]
		#[ValidateRange([int]::1,[int]::12)]
		[ValidateRange(1,12)]
        [int]$Hours,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='AMtag')]
		[switch]$AM,
		
		[Parameter(Mandatory=$true,
		ParameterSetName='PMtag')]
		[switch]$PM
	)
	
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


