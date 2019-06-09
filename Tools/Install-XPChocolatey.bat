@ECHO OFF

:: BatchGotAdmin International-Fix Code
:: https://sites.google.com/site/eneerge/home/BatchGotAdmin
:-------------------------------------------------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
IF '%ERRORLEVEL%' NEQ '0' (
    ECHO Requesting administrative privileges...
    GOTO UACPrompt
) ELSE ( GOTO gotAdmin )

:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%Temp%\getadmin.vbs"
    ECHO UAC.ShellExecute "%~s0", "", "", "RUNAS", 1 >> "%Temp%\getadmin.vbs"

    "%Temp%\getadmin.vbs"
    EXIT /B

:gotAdmin
    IF EXIST "%Temp%\getadmin.vbs" ( DEL "%Temp%\getadmin.vbs" )
    PUSHD "%CD%"
    CD /D "%~dp0"
	ECHO BatchGotAdmin Permissions set.
:-------------------------------------------------------------------------------
ECHO.
ECHO -------------------------------------------------------------------------------
SETLOCAL

ECHO.
ECHO This script requires an internet connection to properly run.
ECHO.

ECHO Step #1. Is PowerShell installed?
ECHO (launching ".\Get-InstalledPowerShell.bat"...)
CALL .\Get-InstalledPowerShell.bat
CLS
ECHO.
ECHO Step #1. Is PowerShell installed?
IF [%_PSversion%]==[0] (
    ECHO PowerShell is not installed.
 ) ELSE ( 
    ECHO PowerShell is installed:
	ECHO v%_PSversion%
	IF [%_PSversion%]==[2] (
		GOTO PSver2END
	 )
 )
ECHO.


ECHO -------------------------------------------------------------------------------
ECHO.


ECHO Step #2. Install PowerShell v1.0
ECHO.
ECHO Step #2.1 Uninstall PowerShell v1.0 (if necessary)
IF [%_PSversion%]==[1] (
	ECHO -------------------------------------------------------------------------------
	ECHO.
	ECHO Click to select the ^*Show updates^* check box.
	ECHO.
	ECHO In the ^*Currently installed programs^* list, click ^*Windows PowerShell^(TM^) 1.0^*, and then click ^*Remove^*.
	ECHO.
	ECHO Follow the instructions to remove the following entry: 
	ECHO ^*Windows PowerShell^(TM^) 1.0^*
	ECHO ^*Windows Server 2003 - Software Updates ^> Hotfix for Windows Server 2003 ^(KB926139-v2^)^*
	ECHO.
	ECHO (launching Add/Remove Programs)
	appwiz.cpl
	PAUSE
 )
ECHO.


ECHO Step #2.2.1 Prerequisites - OS compatibility
ECHO.
ECHO Is OS one of the following?:
ECHO 		- Windows XP with Service Pack 2
ECHO 		- Windows Server 2003 R2
ECHO 		- Windows Server 2003 with Service Pack 2
ECHO 		- Windows Server 2003 with Service Pack 1
ECHO.
ECHO	If so, continue. Otherwise abort program.
ECHO.
::msinfo32
ECHO (launching Windows Version info)
winver
::sysdm.cpl
::winmsd.exe
PAUSE
ECHO OS accepted by User.
ECHO.

ECHO Step #2.2.2 Prerequisites - Windows Updates
ECHO.
ECHO Are all latest Windows updates installed?
ECHO.
ECHO (launching IE: Microsoft Update "windowsupdate.microsoft.com")
"%ProgramFiles%\Internet Explorer\iexplore.exe" windowsupdate.microsoft.com
REM "%ProgramFiles(x86)%\Internet Explorer\iexplore.exe" 
CHOICE /M "Reboot now?"
IF ERRORLEVEL 2 GOTO NotYet1
IF ERRORLEVEL 1 SHUTDOWN /R /T 0
GOTO End
:NotYet1
ECHO Windows Updates accepted by User.
ECHO.

ECHO Step #2.3.1 Prerequisites - .NET Framework 2.0 dependencies
ECHO.
ECHO Search installed programs for "Windows Internet Explorer"
ECHO 		v5.01 or v6.0 SP1 installed at least?
ECHO (launching Add/Remove Programs)
appwiz.cpl
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?linkid=63042")
"%ProgramFiles%\Internet Explorer\iexplore.exe" http://go.microsoft.com/fwlink/?linkid=63042
PAUSE
ECHO 		IE accepted by User.
ECHO.
ECHO Windows Installer
ECHO 		3.0 or 3.1 at least installed?
ECHO.
ECHO (launching Unattended install of "Windows Installer 3.1 x86 (v2)"...)
ECHO .\WindowsInstaller-KB893803-v2-x86.exe
:: .\WindowsInstaller-KB893803-v2-x86.exe /help /quiet
.\WindowsInstaller-KB893803-v2-x86.exe /passive
:: "%ProgramFiles%\Internet Explorer\iexplore.exe" https://www.microsoft.com/en-us/download/details.aspx?id=25
:: appwiz.cpl
CHOICE /M "Reboot now?"
IF ERRORLEVEL 2 GOTO NotYet2
IF ERRORLEVEL 1 SHUTDOWN /R /T 0
GOTO End
:NotYet2
ECHO.

ECHO Step #2.3.2 Prerequisites - .NET Framework 2.0 Redistributable Package
ECHO.
ECHO "DotNetFx.exe"
ECHO Download from Microsoft Windows Update:
ECHO.
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?linkid=63039")
"%ProgramFiles%\Internet Explorer\iexplore.exe" http://go.microsoft.com/fwlink/?linkid=63039
ECHO.

ECHO Step #2.3.3 Prerequisites - .NET Framework 2.0 Service Pack 1
ECHO.
ECHO (launching Unattended install of ".NET Framework 2.0 SP1 x86"...)
ECHO .\DotNET20\NetFx20SP1_x86.exe
:: .\DotNET20\NetFx20SP1_x86.exe /? /quiet /norestart
.\DotNET20\NetFx20SP1_x86.exe /passive
ECHO.

ECHO Step #2.3.4 Prerequisites - .NET Framework 2.0 Service Pack 2
ECHO.
ECHO (launching Unattended install of ".NET Framework 2.0 SP2 x86"...)
ECHO .\DotNET20\NetFx20SP2_x86.exe
:: .\DotNET20\NetFx20SP2_x64.exe /? /quiet /norestart
.\DotNET20\NetFx20SP2_x86.exe /passive
CHOICE /M "Reboot now?"
IF ERRORLEVEL 2 GOTO NotYet5
IF ERRORLEVEL 1 SHUTDOWN /R /T 0
GOTO End
:NotYet5
ECHO.


ECHO Step #2.4 Install PowerShell v1.0:
ECHO.
ECHO Windows XP, 32-bit (x86):
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?LinkID=75788&clcid=0x09")
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://go.microsoft.com/fwlink/?LinkID=75788&clcid=0x09"
ECHO.
ECHO Windows XP, 64-bit (x64):
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?LinkID=75789&clcid=0x09")
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://go.microsoft.com/fwlink/?LinkID=75789&clcid=0x09"
ECHO.
ECHO Windows Server 2003, 32-bit (x86): "WindowsServer2003-KB926139-v2-x86-ENU.exe"
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?LinkID=75790&clcid=0x09")
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://go.microsoft.com/fwlink/?LinkID=75790&clcid=0x09"
:: .\PowerShellv1\WindowsServer2003-KB926139-v2-x86-ENU.exe
ECHO.
ECHO Windows Server 2003, 64-bit (x64):
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?LinkID=75791&clcid=0x09")
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://go.microsoft.com/fwlink/?LinkID=75791&clcid=0x09"
ECHO.
ECHO Windows Server 2003, Itanium (ia64):
ECHO (launching IE: Microsoft Update "http://go.microsoft.com/fwlink/?LinkID=75792&clcid=0x09")
"%ProgramFiles%\Internet Explorer\iexplore.exe" "http://go.microsoft.com/fwlink/?LinkID=75792&clcid=0x09"
CHOICE /M "Reboot now?"
IF ERRORLEVEL 2 GOTO NotYet6
IF ERRORLEVEL 1 SHUTDOWN /R /T 0
GOTO End
:NotYet6
ECHO.

:PSver2
ECHO -------------------------------------------------------------------------------
ECHO.

ECHO Step #3. Install PowerShell v2.0 for XP (Windows Management Framework Core)
ECHO. 
ECHO Core Includes:
ECHO 	- Windows Remote Management (WinRM) 2.0
ECHO 	- Windows PowerShell 2.0
ECHO.
ECHO (launching Unattended install of "Windows Management Framework"...)
ECHO Windows XP, 32-bit (x86): "WindowsXP-KB968930-x86-ENG.exe"
:: .\PowerShellv2\WindowsXP-KB968930-x86-ENG.exe /help
:: .\PowerShellv2\WindowsXP-KB968930-x86-ENG.exe /passive /promptrestart
ECHO.
ECHO Windows Server 2003, 32-bit (x86): "WindowsServer2003-KB968930-x86-ENG.exe"
:: .\PowerShellv2\WindowsServer2003-KB968930-x86-ENG.exe /help
.\PowerShellv2\WindowsServer2003-KB968930-x86-ENG.exe /passive /promptrestart
ECHO.


:PSver2END
ECHO -------------------------------------------------------------------------------
ECHO.

ECHO Step #4. Install PowerShell v3.0 on XP (skip)
ECHO. 
ECHO (skip) There are no plans for making WMF 3.0 available on Windows XP or Windows Vista.
ECHO. 

ECHO -------------------------------------------------------------------------------
ECHO.

ECHO Step #5. Install Chocolatey
ECHO. 
PAUSE
ECHO (launching ".\Install-Chocolatey.bat"...)
CALL .\Install-Chocolatey.bat
PAUSE


ECHO -------------------------------------------------------------------------------
ECHO.

ECHO Step #6. Run Chocolatey app package
ECHO. 
PAUSE
ECHO (launching ".\Chocopckg_MarTekTech-v1.ps1"...)

powershell.exe -NoProfile -ExecutionPolicy Unrestricted -Command ". .\Chocopckg_MarTekTech-v1.ps1"





:End
ECHO.
ECHO End program.
ENDLOCAL
ECHO.
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
