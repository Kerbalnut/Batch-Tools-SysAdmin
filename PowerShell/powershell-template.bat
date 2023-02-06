@ECHO OFF
::SETLOCAL EnableDelayedExpansion

::Index: 
:: 1. :RunAsAdministrator
:: 2. :Header
:: 3. :Parameters
:: 5. :Main
:: 6. :Footer
:: 7. :DefineFunctions

REM Bugfix: Use "REM ECHO DEBUG*ING: " instead of "::ECHO DEBUG*ING: " to comment-out debugging lines, in case any are within IF statements.
REM ECHO DEBUGGING: Begin RunAsAdministrator block.

:RunAsAdministrator
:: SS64 Run with elevated permissions script (ElevateMe.vbs)
:: Thanks to: http://ss64.com/vb/syntax-elevate.html
:-------------------------------------------------------------------------------
:: First check if we are running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 GOTO START

::GOTO START & REM <-- Leave this line in to always skip Elevation Prompt -->
::GOTO NOCHOICE & REM <-- Leave this line in to always Run As Administrator (skip choice) -->
:: <-- Remove this block to always RunAs Administrator -->
ECHO:
ECHO CHOICE Loading...
ECHO:
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator? (CMD.EXE/VBScript elevation)"
IF ERRORLEVEL 2 GOTO START & REM No.
IF ERRORLEVEL 1 REM Yes.
:: <-- Remove this block to always RunAs Administrator -->
:NOCHOICE

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
:: End Run-As-Administrator function

:Header
::GOTO SkipHeader & REM Un-comment this line to skip Header
CLS
ECHO:

:: To run from PowerShell command line:
:: https://ss64.com/ps/syntax-run.html
:: https://ss64.com/ps/call.html
:: & "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Sort-FilesByDate.ps1"
:: & "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Sort-FilesByDate.ps1" -Verbose -Debug
:: & "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Templates\powershell-template.ps1" -Verbose -Debug -LaunchedInCmd
:: https://ss64.com/ps/source.html
:: . "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Templates\powershell-template.ps1"
:: . "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Templates\powershell-template.ps1" -Verbose -Debug
:: . "C:\Users\G\Documents\SpiderOak Hive\Programming\Powershell\Templates\powershell-template.ps1" -Verbose -Debug -LaunchedInCmd

:: Execution Policy:
:: $oldExecutionPolicy = Get-ExecutionPolicy
:: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
:: Set-ExecutionPolicy -ExecutionPolicy Bypass
:: Set-ExecutionPolicy $oldExecutionPolicy

:: End Header

REM -------------------------------------------------------------------------------

:Parameters

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param1 = Full path to PowerShell file to run

SET "_PowerShellFile=%~dpn0.ps1" & REM %~dpn0.ps1 This script's Drive letter, Path, and Name, but with a .ps1 extension.
::SET "_PowerShellFile=%~dp0Test-AdministratorPermissions.ps1" & REM This script's Drive letter and Path, but pointing to the Test-AdministratorPermissions.ps1

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param2 = Run-as-administrator, Override user-prompt with default choice: 

:: Set as either "RunNonElevated" or "RunAsAdministrator"
:: Set as Blank String to always prompt user
SET "_ADMIN_OPTION=RunNonElevated"
::SET "_ADMIN_OPTION=RunAsAdministrator"
::SET "_ADMIN_OPTION="

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param3 = Verbose and Debug Run options, Override user-prompt with default choice: 

:: Set as Blank String to always prompt user
SET "_RUN_OPTIONS=Run" & REM Run the script regularly, with no options.
SET "_RUN_OPTIONS=Verbose" & REM Run the script with the "-Verbose" switch.
SET "_RUN_OPTIONS=Debug" & REM Run the script with the "-Debug" switch.
SET "_RUN_OPTIONS=VerboseDebug" & REM Run this script with "-Verbose -Debug" switches.
SET "_RUN_OPTIONS=" & REM Leaving this blank will always prompt user.

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param4 = PowerShell Script Parameters

:: Include any extra switches or parameters you want passed to the PowerShell script to be invoked, besides -Verbose or -Debug (obviously).
SET "_POSH_PARAMS=-LaunchedInCmd"
SET "_POSH_PARAMS=-InformationAction Continue"
::SET "_POSH_PARAMS="

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param5 = Set PowerShell ExecutionPolicy

:: For more information, in a PowerShell prompt, type "\> help about_Execution_Policies"
::https://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/
SET "_batExecutionPolicy=Unrestricted" & REM Unsigned scripts can run. Warns the user before running scripts and configuration files that are downloaded from the Internet.
SET "_batExecutionPolicy=Bypass" & REM Nothing is blocked and there are no warnings or prompts. (This execution policy is designed for configurations in which a Windows PowerShell script is built in to a larger application or for configurations in which Windows PowerShell is the foundation for a program that has its own security model.)
SET "_batExecutionPolicy=AllSigned" & REM Requires that all scripts and configuration files be signed by a trusted publisher, including scripts that you write on the local computer. Prompts you before running scripts from publishers that you have not yet classified as trusted or untrusted.
SET "_batExecutionPolicy=Restricted" & REM Permits individual commands (cmdline), but prevents scripts, including: formatting and configuration files (.ps1xml), module script files (.psm1), and Windows PowerShell profiles (.ps1)
SET "_batExecutionPolicy=RemoteSigned" & REM Only scripts downloaded from the internet require signing by trusted publisher. Does not require digital signatures on scripts that you have written on the local computer.
::SET "_batExecutionPolicy=Default"
::SET "_batExecutionPolicy=Undefined" & REM There is no execution policy set in the current scope. If the execution policy in all scopes is Undefined, the effective execution policy is Restricted, which is the default execution policy.

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param6 = Skip Help commands

SET "_SHOW_HELP=No"
::SET "_SHOW_HELP=Yes"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param7 = Example Help Command

SET "_SHOW_EXAMPLE_HELP=No"
::SET "_SHOW_EXAMPLE_HELP=Yes"

SET "_EXAMPLE_HELP_COMMAND=Get-ChildItem"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Parameters

REM -------------------------------------------------------------------------------

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

REM ECHO DEBUGGING: Beginning Main execution block.

::Index of Main:

::===============================================================================
:: Phase 1: Evaluate Parameters
:: Phase 2: Example PowerShell help command
:: Phase 3: PowerShell script help command
:: Phase 4: Main Menu
:: Phase 5: Run PowerShell script as Administrator (Examples)
::===============================================================================

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 1: Evaluate Parameters
::===============================================================================

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: If no input file is given, default to a .ps1 file of the same name.
IF /I "%_PowerShellFile%"=="" SET "_PowerShellFile=%~dpn0.ps1"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Check if out target file exists
IF NOT EXIST "%_PowerShellFile%" (
	ECHO:
	ECHO -------------------------------------------------------------------------------
	ECHO WARNING:
	ECHO -------------------------------------------------------------------------------
	ECHO:
	ECHO "%_PowerShellFile%" not found.
	ECHO:
	GOTO Footer
)

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Get _PowerShellFile Name & eXtention, Drive letter & Path, siZe
FOR %%G IN ("%_PowerShellFile%") DO SET "_PowerShellFile_NAME=%%~nxG"
FOR %%G IN ("%_PowerShellFile%") DO SET "_PowerShellFile_PATH=%%~dpG"
FOR %%G IN ("%_PowerShellFile%") DO SET "_PowerShellFile_SIZE=%%~zG"
SET /A "_PowerShellFile_SIZE_KB=%_PowerShellFile_SIZE%/1024"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Get/Set execution policy
SET "_ExecutionPolicy=Default"
IF /I "%_batExecutionPolicy%"=="Unrestricted" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="Bypass" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="AllSigned" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="Restricted" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="RemoteSigned" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="Default" SET "_ExecutionPolicy=%_batExecutionPolicy%"
IF /I "%_batExecutionPolicy%"=="Undefined" SET "_ExecutionPolicy=%_batExecutionPolicy%"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 2: Example PowerShell help command
::===============================================================================

:ExampleHelp
:: Skip Example Help lookup
IF /I "%_SHOW_EXAMPLE_HELP%"=="No" (
	ECHO Skipping %_EXAMPLE_HELP_COMMAND% example help command 
	GOTO ScriptHelp & REM Comment out this line to display help before loading script
)
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO Example help:
ECHO:
ECHO Get-Help %_EXAMPLE_HELP_COMMAND%
ECHO:
:: https://ss64.com/nt/syntax-args.html
PowerShell.exe -NoProfile -Command Get-Help %_EXAMPLE_HELP_COMMAND%
ECHO:
ECHO -------------------------------------------------------------------------------

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 3: PowerShell script help command
::===============================================================================

:ScriptHelp
:: Skip Help lookup
IF /I "%_SHOW_HELP%"=="No" (
	ECHO Skipping %_PowerShellFile_NAME% help command 
	GOTO MainMenu & REM Comment out this line to display help before loading script
)
ECHO -------------------------------------------------------------------------------
ECHO:
ECHO Full script help:
ECHO:
ECHO %_PowerShellFile%
ECHO Get-Help .\%_PowerShellFile_NAME%
ECHO:
:: https://ss64.com/nt/syntax-args.html
::PowerShell.exe -NoProfile -Command Get-Help %_PowerShellFile% -Full
PowerShell.exe -NoProfile -Command Get-Help .\%_PowerShellFile_NAME% -Full
ECHO:
ECHO -------------------------------------------------------------------------------

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

REM ===============================================================================

::===============================================================================
:: Phase 4: Main Menu
::===============================================================================

::GOTO AdminVerboseRun
::GOTO AdminRunScript

:MainMenu
ECHO:
ECHO %_PowerShellFile_NAME%
ECHO:
ECHO Detecting Windows OS version compatibility . . . 
ECHO:
CALL :GetWindowsVersion
ECHO:

:ChooseAdminOptions
IF /I "%_ADMIN_OPTION%"=="RunNonElevated" GOTO ChooseRunOptions
IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" GOTO ChooseRunOptions
CALL :GetIfAdmin NoEcho
IF /I "%_IS_ADMIN%"=="Yes" (
	SET "_ADMIN_OPTION=RunAsAdministrator"
	GOTO ChooseRunOptions
)
ECHO CHOICE Loading...
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator? (PowerShell elevation)"
IF ERRORLEVEL 2 SET "_ADMIN_OPTION=RunNonElevated" & GOTO ChooseRunOptions & REM No.
IF ERRORLEVEL 1 SET "_ADMIN_OPTION=RunAsAdministrator" & REM Yes.

:ChooseRunOptions
IF /I "%_RUN_OPTIONS%"=="Run" GOTO RunScript
IF /I "%_RUN_OPTIONS%"=="Verbose" GOTO VerboseRun
IF /I "%_RUN_OPTIONS%"=="Debug" GOTO DebugScript
IF /I "%_RUN_OPTIONS%"=="VerboseDebug" GOTO DebugAndVerbose
:: https://ss64.com/nt/choice.html
ECHO CHOICE Loading...
::CHOICE /C LDWE /N /M "|  L - Log Times  |  D - Stats by Day  |  W - by Week  |  -----  |  E - Exit  |"
CHOICE /C RVDG /N /M "|  R - Run Script  |  V - Verbose  |  D - Debug  |  G - Debug & Verbose  |    |"
IF ERRORLEVEL 4 GOTO DebugAndVerbose
IF ERRORLEVEL 3 GOTO DebugScript
IF ERRORLEVEL 2 GOTO VerboseRun
IF ERRORLEVEL 1 GOTO RunScript
ECHO:
ECHO ERROR: Invalid choice / Choice not recognized.
ECHO:
GOTO MainMenu

:: Alternate ExecutionPolicy = Bypass
::https://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/

:: The dot sourcing feature lets you run a script in the current scope instead of in the script scope.
:: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-6&viewFallbackFrom=powershell-Microsoft.PowerShell.Core

:: Call operator (&) allows you to execute a command, script or functiActive 
:: https://ss64.com/ps/call.html

:RunScript
:: First check if we are running As Admin/Elevated
CALL :GetIfAdmin
::CALL :GetIfAdmin NoEcho
::ECHO Got Admin permissions: %_IS_ADMIN%
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command . '%_PowerShellFile%' -LaunchedInCmd
IF %_WindowsVersion% EQU 10 (
	REM Windows 10 has PowerShell width CMD.exe windows.
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		REM PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%""' -Verb RunAs}"
		REM PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File ""%_PowerShellFile%""' -Verb RunAs}"
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" %_POSH_PARAMS%'}"
	)
) ELSE (
	REM Windows versions earlier than 10 are standard width.
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		REM PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%""' -LaunchedInCmd -Verb RunAs}"
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "%_PowerShellFile%" -LaunchedInCmd %_POSH_PARAMS%'}"
	)
)
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command "& '%_PowerShellFile%'"
GOTO Footer

:VerboseRun
:: First check if we are running As Admin/Elevated
CALL :GetIfAdmin
::CALL :GetIfAdmin NoEcho
::ECHO Got Admin permissions: %_IS_ADMIN%
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command . '%_PowerShellFile%' -LaunchedInCmd -Verbose
IF %_WindowsVersion% EQU 10 (
	REM Windows 10 has PowerShell width CMD.exe windows.
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Verbose %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		REM PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%""' -Verbose -Verb RunAs}"
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Verbose %_POSH_PARAMS%'}"
	)
) ELSE (
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Verbose %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		REM PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%"" -LaunchedInCmd' -Verbose -Verb RunAs}"
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Verbose %_POSH_PARAMS%'}"
	)
)
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command "& '%_PowerShellFile%' -LaunchedInCmd -Verbose"
GOTO Footer

:DebugScript
:: First check if we are running As Admin/Elevated
CALL :GetIfAdmin
::CALL :GetIfAdmin NoEcho
::ECHO Got Admin permissions: %_IS_ADMIN%
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command . '%_PowerShellFile%' -LaunchedInCmd -Debug
IF %_WindowsVersion% EQU 10 (
	REM Windows 10 has PowerShell width CMD.exe windows.
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Debug %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Debug %_POSH_PARAMS%'}"
		
	)
) ELSE (
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Debug %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Debug %_POSH_PARAMS%'}"
		
	)
)
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command & '%_PowerShellFile%' -LaunchedInCmd -Debug
GOTO Footer

:DebugAndVerbose
:: First check if we are running As Admin/Elevated
CALL :GetIfAdmin
::CALL :GetIfAdmin NoEcho
::ECHO Got Admin permissions: %_IS_ADMIN%
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command . '%_PowerShellFile%' -LaunchedInCmd -Verbose -Debug
IF %_WindowsVersion% EQU 10 (
	REM Windows 10 has PowerShell width CMD.exe windows.
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Verbose -Debug %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -Verbose -Debug %_POSH_PARAMS%'}"
	)
) ELSE (
	IF /I "%_ADMIN_OPTION%"=="RunNonElevated" (
		PowerShell.exe -NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Verbose -Debug %_POSH_PARAMS%
	)
	IF /I "%_ADMIN_OPTION%"=="RunAsAdministrator" (
		PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy %_ExecutionPolicy% -File "%_PowerShellFile%" -LaunchedInCmd -Verbose -Debug %_POSH_PARAMS%'}"
	)
)
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command & '%_PowerShellFile%' -LaunchedInCmd -Verbose -Debug
GOTO Footer

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 5: Run PowerShell script as Administrator (Examples)
::===============================================================================

:AdminRunScript
PowerShell.exe -NoProfile -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%""' -Verb RunAs}"
GOTO Footer

:AdminVerboseRun
::PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%_PowerShellFile%"" -Verbose' -Verb RunAs}"
PowerShell.exe -NoProfile -ExecutionPolicy RemoteSigned -Command "& {Start-Process PowerShell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """"%_PowerShellFile%"""" -Verbose' -Verb RunAs}"
GOTO Footer


::http://blog.danskingdom.com/allow-others-to-run-your-powershell-scripts-from-a-batch-file-they-will-love-you-for-it/

::Here is how to pass in ordered parameters:

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%' 'First Param Value' 'Second Param Value'";

::And here is how to pass in named parameters:

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%' -Param1Name 'Param 1 Value' -Param2Name 'Param 2 Value'"

::And if you are running the admin version of the script, here is how to pass in ordered parameters:

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """"%PowerShellScriptPath%"""" """"First Param Value"""" """"Second Param Value"""" ' -Verb RunAs}"

::And here is how to pass in named parameters:

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File """"%PowerShellScriptPath%"""" -Param1Name """"Param 1 Value"""" -Param2Name """"Param 2 value"""" ' -Verb RunAs}";

::And yes, the PowerShell script name and parameters need to be wrapped in 4 double quotes in order to properly handle paths/values with spaces.




ECHO:
ECHO -------------------------------------------------------------------------------

:: End Main

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:Footer
:END
::ENDLOCAL
ECHO: 
ECHO End %~nx0
ECHO: 
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.

:: End Footer

REM -------------------------------------------------------------------------------

REM ECHO DEBUGGING: Begin DefineFunctions block.

:DefineFunctions
:: Declare Functions

::Index of functions: 
:: 1. :GetIfAdmin
:: 2. :GetWindowsVersion

GOTO SkipFunctions
:-------------------------------------------------------------------------------
:GetIfAdmin [NoEcho]
::CALL :GetIfAdmin [NoEcho]
:: Check if we have elevated/Administrator permissions in this session.
:: Outputs:
:: "%_IS_ADMIN%" will be either "Yes" or "No"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET "_NO_OUTPUT=%1"
SET "_NO_ECHO=Inactive"
IF /I "%_NO_OUTPUT%"=="NoEcho" SET "_NO_ECHO=Active"
IF /I "%_NO_OUTPUT%"=="NoOutput" SET "_NO_ECHO=Active"
IF /I "%_NO_OUTPUT%"=="No" SET "_NO_ECHO=Active"
IF /I "%_NO_OUTPUT%"=="N" SET "_NO_ECHO=Active"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Check if we are running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 (
	REM Yes, we have admin.
	SET "_IS_ADMIN=Yes"
	IF /I "%_NO_ECHO%"=="Inactive" (
		ECHO This batch file "%~nx0" is running with Administrator permissions
	)
) ELSE (
	REM No, we do not have admin.
	SET "_IS_ADMIN=No"
	IF /I "%_NO_ECHO%"=="Inactive" (
		ECHO This batch file "%~nx0" is running non-Elevated.
	)
)	
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_IS_ADMIN=%_IS_ADMIN%"
EXIT /B
:-------------------------------------------------------------------------------
:GetWindowsVersion
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FOR /F "tokens=4-7 delims=[.] " %%i IN ('ver') DO (
	IF %%i == Version SET "_winversion=%%j.%%k"
	IF %%i neq Version SET "_winversion=%%i.%%j"
)	
IF "%_winversion%" == "10.0" (
	SET "_winversion=10"
	SET "_winvername=10"
	SET "_easyname=Windows 10"
	ECHO Windows 10
) ELSE (
	IF "%_winversion%" == "6.3" (
		SET "_winvername=8.1"
		SET "_easyname=Windows 8.1"
		ECHO Windows 8.1
	) ELSE (
		IF "%_winversion%" == "6.2" (
			SET "_winvername=8"
			SET "_easyname=Windows 8"
			ECHO Windows 8
		) ELSE (
			IF "%_winversion%" == "6.1" (
				SET "_winvername=7"
				SET "_easyname=Windows 7"
				ECHO Windows 7
			) ELSE (
				IF "%_winversion%" == "6.0" (
					SET "_winvername=Vista"
					SET "_easyname=Windows Vista"
					ECHO Windows Vista
				) ELSE (
					IF "%_winversion%" == "5.2" (
						SET "_winvername=Server 2003 / R2 / XP 64-bit"
						SET "_easyname=Windows Server 2003 / R2 / Windows XP 64-bit Edition"
						ECHO Windows Server 2003 / R2 / Windows XP 64-bit Edition
					) ELSE (
						IF "%_winversion%" == "5.1" (
							SET "_winvername=XP"
							SET "_easyname=Windows XP"
							ECHO Windows XP
						) ELSE (
							IF "%_winversion%" == "5.0" (
								SET "_winvername=2000"
								SET "_easyname=Windows 2000"
								ECHO Windows 2000
							) ELSE (
								REM SET "_winversion=0.0"
								SET "_winvername=Unknown"
								SET "_easyname=Unable to determine OS version automatically: %_winversion%"
								ECHO %_easyname%
							)
						)
					)
				)
			)
		)
	)
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_WindowsVersion=%_winversion%" & SET "_WindowsName=%_winvername%" & SET "_WindowsEasyName=%_easyname%"
EXIT /B
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions
