
#-----------------------------------------------------------------------------------------------------------------------
Function Convert-TimeZone { #-------------------------------------------------------------------------------------------

	<#
	.SYNOPSIS
	Convert-TimeZone function converts times from one time zone to the same time in another time zone.

	.DESCRIPTION
	Thanks to:
	https://blogs.msdn.microsoft.com/rslaten/2014/08/04/converting-times-from-one-time-zone-to-another-time-zone-in-powershell/

	.PARAMETER Time
	Horizontal Rule types. Accepted types are 'SingleLine', 'DoubleLine', 'DashedLine', and 'BlankLine'. Defaults to 'SingleLine'.
	
	.PARAMETER FromTimeZone
	From
	
	.PARAMETER ToTimeZone
	To
	
	.LINK
	https://blogs.msdn.microsoft.com/rslaten/2014/08/04/converting-times-from-one-time-zone-to-another-time-zone-in-powershell/
	
	.LINK
	Get-TimeZone
	
	#>
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	param(
		[Parameter(Mandatory=$false)]
		$Time,
		[Parameter(Mandatory=$false)]
		$FromTimeZone,
		[Parameter(Mandatory=$false)]
		$ToTimeZone
	)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#-----------------------------------------------------------------------------------------------------------------------
	function ConvertTime { #------------------------------------------------------------------------------------------------
		param($time, $FromTimeZone, $ToTimeZone)
		
		$oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($FromTimeZone)
		$oToTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($ToTimeZone)
		$utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
		$newTime = [System.TimeZoneInfo]::ConvertTime($utc, $oToTimeZone)
	
		return $newTime
	} # End ConvertTime function -------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#-----------------------------------------------------------------------------------------------------------------------
	function ConvertUTC { #-------------------------------------------------------------------------------------------------
		param($time, $FromTimeZone)
		
		$oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($FromTimeZone)
		$utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
		return $utc
	} # End ConvertUTC function -------------------------------------------------------------------------------------------
	#-----------------------------------------------------------------------------------------------------------------------
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	if ($ToTimeZone)
	{
	
		[datetime]$time = $time
		$toUTC = ConvertUTC -time $time -FromTimeZone $FromTimeZone
		$toNewTimeZone = ConvertTime -time $time -FromTimeZone $FromTimeZone -ToTimeZone $ToTimeZone
		Write-Host ("Original Time ({0}): {1}" -f $FromTimeZone, $time)
		Write-Host ("UTC Time: {0}" -f $toUTC)
		Write-Host ("{0}: {1}" -f $ToTimeZone, $toNewTimeZone)
	}
	else
	{
		if (!($time)) 
		{
			$FromTimeZone = (([System.TimeZoneInfo]::Local).Id).ToString()
			$time = [DateTime]::SpecifyKind((Get-Date), [DateTimeKind]::Unspecified)
		}
		else { [datetime]$time = $time }
		
		Write-Host ("Original Time - {0}: {1}" -f $FromTimeZone, $time)
		$toUTC = ConvertUTC -time $time -FromTimeZone $FromTimeZone
		$times = @()
		foreach ($timeZone in ([system.timezoneinfo]::GetSystemTimeZones()))
		{
			$times += (New-Object psobject -Property @{'Name' = $timeZone.DisplayName; 'ID' = $timeZone.id; 'Time' = (ConvertTime -time $time -FromTimeZone $FromTimeZone -ToTimeZone $timeZone.id); 'DST' = $timeZone.SupportsDaylightSavingTime})
		}
		$times | Sort-Object Time | Format-Table -Property * -AutoSize
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
} # End Convert-TimeZone function --------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------
