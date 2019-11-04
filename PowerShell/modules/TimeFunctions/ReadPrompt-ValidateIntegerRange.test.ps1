
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dot source our function(s) to test.

. "$env:USERPROFILE\Documents\GitHub\Batch-Tools-SysAdmin\PowerShell\modules\TimeFunctions\ReadPrompt-ValidateIntegerRange.ps1"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#=======================================================================================================================
#4. Testing ReadPrompt-Hour
#=======================================================================================================================

$SectionName = "#4. Testing ReadPrompt-Hour"

$ChoiceSkip = PromptForChoice-YesNoSectionSkip $SectionName

If ($ChoiceSkip -eq 'N') {
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

Write-Host `r`n
Write-Host `r`n

#

Write-Host "# Start Time #`n`r`n"

Write-Host `r`n

Write-HorizontalRuleAdv -SingleLine

#$StartHour = Read-Host -Prompt "Enter Start hour"
#$StartHour = ReadPrompt-Hour -Verbose
$StartHour = ReadPrompt-Hour -Verbose

#

Write-HorizontalRuleAdv

#

#-----------------------------------------------------------------------------------------------------------------------

Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = (0000004 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = ('0000004' | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Success:" -ForegroundColor Green
$StartHour = ("0000000" | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (24 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (2.4 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (-2 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (0.01 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

Write-Host "Failure:"
$StartHour = (-0000.0010 | ReadPrompt-Hour -Verbose)

Write-HorizontalRuleAdv -DashedLine

#-----------------------------------------------------------------------------------------------------------------------

#

Write-HorizontalRuleAdv

#

Write-Host `r`n

#

Write-Host "--------------------------------------------------------------------------------------------------"

#

PAUSE # PAUSE (alias for Read-Host) Prints "Press Enter to continue...: "

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

