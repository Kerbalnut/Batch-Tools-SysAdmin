<#
.LINK
https://www.jonathanmedd.net/2014/01/testing-for-admin-privileges-in-powershell.html
#>

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#-----------------------------------------------------------------------------------------------------------------------
function Start-PSAdmin {Start-Process PowerShell -Verb RunAs}
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
function Test-IsAdmin { #-----------------------------------------------------------------------------------------------
	([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
} #---------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------

#=======================================================================================================================

If ((Test-IsAdmin)) {
	Write-Host "Script is running with Administrator permissions!" -ForegroundColor "White" -BackgroundColor "Red"
} Else {
	Write-Host "Script running with non-elevated permissions." -ForegroundColor "White" -BackgroundColor "Black"
}

PAUSE

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Return
