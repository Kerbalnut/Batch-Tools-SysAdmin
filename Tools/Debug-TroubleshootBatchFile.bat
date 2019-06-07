@ECHO OFF
SETLOCAL
:: CMD /K Debug-TroubleshootBatchFile.bat
:: CMD /K Debug-TroubleshootBatchFile.bat "C:\Users\G\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Functions list\functions-template.bat"
:: CMD /K Debug-TroubleshootBatchFile.bat "C:\Users\G\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Functions list\functions-template.bat" "twenty two years" "twente eight seasons"

ECHO:
ECHO Input parameters [%1] [%2] [%3]
ECHO:
::PAUSE
CLS

:: SS64 Run with elevated permissions script (ElevateMe.vbs)
:: Thanks to: http://ss64.com/vb/syntax-elevate.html
:-------------------------------------------------------------------------------
:: First check if we are running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 GOTO START

ECHO:
ECHO CHOICE Loading...
ECHO:
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator?"
IF ERRORLEVEL 2 GOTO START & REM No.
IF ERRORLEVEL 1 REM Yes.

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
		REM Debugging: cannot use :: for comments within IF statement, instead use REM
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

:START
:: set the current directory to the batch file location
::CD /D %~dp0
:-------------------------------------------------------------------------------
CLS
ECHO Script name ^( %~nx0 ^) & REM This script's file name and extension. https://ss64.com/nt/syntax-args.html
ECHO Working directory: %~dp0 & REM The drive letter and path of this script's location.
REM Debugging: cannot use :: for comments within IF statement, instead use REM
ECHO:

:: Check if we are running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 (
	ECHO Elevated Permissions: YES
) ELSE ( 
	ECHO Elevated Permissions: NO
)

ECHO:
ECHO -------------------------------------------------------------------------------
REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:
ECHO Input parameters [%1] [%2] [%3]

::-------------------------------------------------------------------------------

SET "_BatchPath=.\Install-AllWindowsUpdates.bat"

SET "InputTestScript=%~1" & REM %~1   Expand %1 removing any surrounding quotes (")

ECHO(
IF "%InputTestScript%"=="" (
	REM No input parameters were given.
	REM Use hard-coded script location
	REM e.g. "%USERPROFILE%\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Functions list\functions-template.bat"
	SET "DebugScript=%USERPROFILE%\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Functions list\functions-template.bat"
	REM SET "DebugScript=%USERPROFILE%\Documents\SpiderOak Hive\SysAdmin\Flash Drive\General Flash Drive\Launch-AD_ElevatedCMD.bat"
	REM SET "DebugScript=%_BatchPath%"
	ECHO Script-coded locaation selected.
	ECHO:
) ELSE (
	REM Use input parameters.
	SET "DebugScript=%InputTestScript%"
	ECHO Commandline parameter input selected.
	ECHO:
	
	REM -------------------------------------------------------------------------------
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
	REM Debugging: cannot use ECHO( for newlines within IF statement, instead use ECHO. or ECHO: 
)

ECHO Launching script in DEBUG mode: 
ECHO(
ECHO %DebugScript%
ECHO(

ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO(
PAUSE
ECHO(
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO(

CMD /K "%DebugScript%"

ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO End %DebugScript%
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------
ECHO -------------------------------------------------------------------------------

::-------------------------------------------------------------------------------

ENDLOCAL
ECHO: 
ECHO End %~nx0
ECHO: 
PAUSE
EXIT
