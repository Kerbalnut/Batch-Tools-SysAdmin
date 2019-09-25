
#

. "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\powershell-template.ps1" -LoadFunctions

#

Function Convert-TimeZone {

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


#------------------------------------------------------------------------------------------------------------------------------

param(
  [Parameter(Mandatory=$false)]
  $Time,
  [Parameter(Mandatory=$false)]
  $FromTimeZone,
  [Parameter(Mandatory=$false)]
  $ToTimeZone
)

function ConvertTime
{
  param($time, $fromTimeZone, $toTimeZone)

  $oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($fromTimeZone)
  $oToTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($toTimeZone)
  $utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
  $newTime = [System.TimeZoneInfo]::ConvertTime($utc, $oToTimeZone)

  return $newTime
}

function ConvertUTC
{
  param($time, $fromTimeZone)

  $oFromTimeZone = [System.TimeZoneInfo]::FindSystemTimeZoneById($fromTimeZone)
  $utc = [System.TimeZoneInfo]::ConvertTimeToUtc($time, $oFromTimeZone)
  return $utc
}

if ($toTimeZone)
{
  
  [datetime]$time = $time
  $toUTC = ConvertUTC -time $time -fromTimeZone $fromTimeZone
  $toNewTimeZone = ConvertTime -time $time -fromTimeZone $fromTimeZone -toTimeZone $toTimeZone
  Write-Host ("Original Time ({0}): {1}" -f $fromTimeZone, $time)
  Write-Host ("UTC Time: {0}" -f $toUTC)
  Write-Host ("{0}: {1}" -f $toTimeZone, $toNewTimeZone)
}
else
{
  if (!($time)) 
  {
    $fromTimeZone = (([System.TimeZoneInfo]::Local).Id).ToString()
    $time = [DateTime]::SpecifyKind((Get-Date), [DateTimeKind]::Unspecified)
  }
  else { [datetime]$time = $time }
  Write-Host ("Original Time - {0}: {1}" -f $fromTimeZone, $time)
  $toUTC = ConvertUTC -time $time -fromTimeZone $fromTimeZone
  $times = @()
  foreach ($timeZone in ([system.timezoneinfo]::GetSystemTimeZones()))
  {
   $times += (New-Object psobject -Property @{'Name' = $timeZone.DisplayName; 'ID' = $timeZone.id; 'Time' = (ConvertTime -time $time -fromTimeZone $fromTimeZone -toTimeZone $timeZone.id); 'DST' = $timeZone.SupportsDaylightSavingTime})
  }
  $times | Sort-Object Time | Format-Table -Property * -AutoSize
}

#------------------------------------------------------------------------------------------------------------------------------





}

#

$TodayDay = Get-Date -UFormat %d

$TodayDay = Get-Date

$TodayDay

$Yesterday = (Get-Date).AddDays(-1)

$Yesterday

#

$Midnight = Get-Date -Hour 23 -Minute 52 -Second 0 -Millisecond 0

$Midnight

$PastMidnight = Get-Date -Hour 0 -Minute 15 -Second 0 -Millisecond 0

$PastMidnight

PAUSE

#

$StartHour = Read-Host -Prompt "Enter Start hour"

$StartMin = Read-Host -Prompt "Enter Start minute"

$StartAMPM = ReadPrompt-AMPM24

If ($StartAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -AM -Verbose
}

If ($StartAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $StartHour -PM -Verbose
}

If ($StartAMPM -eq 24) {
    $24hour = $StartHour
}

$Timestamp = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

$StartTime = Get-Date -Hour $24hour -Minute $StartMin -Second 0 -Millisecond 0

$StartTime

#

$EndHour = Read-Host -Prompt "Enter End hour"

$EndMin = Read-Host -Prompt "Enter End minute"

$EndAMPM = ReadPrompt-AMPM24

If ($EndAMPM -eq "AM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -AM -Verbose
}

If ($EndAMPM -eq "PM") {
    $24hour = Convert-AMPMhourTo24hour $EndHour -PM -Verbose
}

If ($EndAMPM -eq 24) {
    $24hour = $EndHour
}

$Timestamp = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime = Get-Date -Hour $24hour -Minute $EndMin -Second 0 -Millisecond 0

$EndTime

