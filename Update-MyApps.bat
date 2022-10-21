@ECHO OFF
::SETLOCAL EnableDelayedExpansion

REM Bugfix: Use "REM ECHO DEBUG*ING: " instead of "::ECHO DEBUG*ING: " to comment-out debugging lines, in case any are within IF statements.
REM ECHO DEBUGGING: Begin RunAsAdministrator block.

:RunAsAdministrator
:: SS64 Run with elevated permissions script (ElevateMe.vbs)
:: Thanks to: http://ss64.com/vb/syntax-elevate.html
:-------------------------------------------------------------------------------
:: First check if we are already running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 SET "_ADMIN=TRUE" & GOTO START

:: Check input parameters
REM ECHO DEBUGGING: Parameter %%1: "%1"
IF "%1"=="RunAsAdmin" GOTO RUNASADMIN
IF "%1"=="NoAdmin" GOTO SKIPADMIN

::GOTO SKIPADMIN & REM <-- Leave this line in to always skip Elevation Prompt -->
::GOTO RUNASADMIN & REM <-- Leave this line in to always Run As Administrator (skip choice) -->
:: Comment out both GOTO statements to prompt user to elevate.
ECHO:
ECHO CHOICE Loading...
ECHO:
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator? (CMD.EXE/VBScript elevation)"
IF ERRORLEVEL 2 GOTO SKIPADMIN & REM No.
IF ERRORLEVEL 1 REM Yes.
:RUNASADMIN

:: wait 2 seconds, in case this user is not in Administrators group. (To prevent an infinite loop of UAC admin requests on a restricted user account.)
ECHO Requesting administrative privileges... ^(waiting 2 seconds^)
PING -n 3 127.0.0.1 > nul

::Create and run a temporary VBScript to elevate this batch file
	:: https://ss64.com/nt/syntax-args.html
	SET _batchFile=%~s0
	SET _batchFile=%~f0
	SET _Args=%*
	IF NOT [%_Args%]==[] (
		REM double up any quotes
		REM https://ss64.com/nt/syntax-replace.html
		SET "_Args=%_Args:"=""%"
		REM Bugfix: cannot use :: for comments within IF statement, instead use REM
	)
	:: https://ss64.com/nt/if.html
	IF ["%_Args%"] EQU [""] ( 
		SET "_CMD_RUN=%_batchFile%"
	) ELSE ( 
		SET "_CMD_RUN=""%_batchFile%"" %_Args%"
	)
	:: https://ss64.com/vb/shellexecute.html
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%Temp%\~ElevateMe.vbs"
	ECHO UAC.ShellExecute "CMD", "/C ""%_CMD_RUN%""", "", "RUNAS", 1 >> "%Temp%\~ElevateMe.vbs"
	:: ECHO UAC.ShellExecute "CMD", "/K ""%_batchFile% %_Args%""", "", "RUNAS", 1 >> "%temp%\~ElevateMe.vbs"
	
	cscript "%Temp%\~ElevateMe.vbs" 
	EXIT /B

GOTO START
:SKIPADMIN
SET "_ADMIN=FALSE"
:START
:: set the current directory to the batch file location
::CD /D %~dp0
:-------------------------------------------------------------------------------
:: End Run-As-Administrator function

choco upgrade notepadplusplus GoogleChrome Firefox vscode vscodium keepass nextcloud-client dropbox signal putty vlc wireshark nmap filezilla thunderbird paint.net discord steam epicgameslauncher -y
::choco upgrade telegram -y
::choco upgrade libreoffice -7
::choco upgrade libreoffice-fresh -7
choco upgrade hg git tortoisegit tortoisehg github-desktop -y
::choco upgrade javaruntime jre8 -y

ECHO End of script.
PAUSE

::ENDLOCAL
EXIT /B

