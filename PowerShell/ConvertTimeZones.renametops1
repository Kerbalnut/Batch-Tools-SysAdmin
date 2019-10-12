param(
  [Parameter(Mandatory=$false)]
  $time,
  [Parameter(Mandatory=$false)]
  $fromTimeZone,
  [Parameter(Mandatory=$false)]
  $toTimeZone
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