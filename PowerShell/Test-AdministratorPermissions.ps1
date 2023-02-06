<#
.LINK
https://www.jonathanmedd.net/2014/01/testing-for-admin-privileges-in-powershell.html

.LINK
https://devblogs.microsoft.com/scripting/weekend-scripter-welcome-to-the-powershell-information-stream/
#>

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#http://techgenix.com/powershell-functions-common-parameters/
# To enable common parameters in functions (-Verbose, -Debug, etc.) the following 2 lines must be present:
#[cmdletbinding()]
#Param()

[cmdletbinding()]
Param(
	$InformationPreference = 'Continue'
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#-----------------------------------------------------------------------------------------------------------------------
function Test-IsAdmin { #-----------------------------------------------------------------------------------------------
	([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
} #---------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#=======================================================================================================================

Write-Verbose "Begining of Main Execution block."

Write-Information "Execution policy : '$(Get-ExecutionPolicy)'" #-InformationAction 'Continue'

Write-Debug 'About to run "Test-IsAdmin" function and check output.'

# Write-Host has parameters that change its display, for example, ForegroundColor and BackgroundColor. Write-Information does not.
If ((Test-IsAdmin)) {
	Write-Host "Script is running with Administrator permissions!" -ForegroundColor "White" -BackgroundColor "Red"
} Else {
	Write-Host "Script running with non-elevated permissions." -ForegroundColor "White" -BackgroundColor "Black"
}

Write-Verbose "End of Main Execution block."

PAUSE

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Return
