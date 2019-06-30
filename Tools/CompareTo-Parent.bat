@ECHO OFF
::SETLOCAL
SETLOCAL EnableDelayedExpansion

::Index: 
:: 1. :RunAsAdministrator
:: 2. :Header
:: 3. :Parameters
:: 4. :ExternalFunctions
:: 5. :Main
:: 6. :Footer
:: 7. :DefineFunctions

REM ECHO DEBUGGING: Begin Run-As-Administrator block.

:RunAsAdministrator
:: SS64 Run with elevated permissions script (ElevateMe.vbs)
:: Thanks to: http://ss64.com/vb/syntax-elevate.html
:-------------------------------------------------------------------------------
:: First check if we are running As Admin/Elevated
FSUTIL dirty query %SystemDrive% >nul
IF %ERRORLEVEL% EQU 0 GOTO START

GOTO START & REM <-- Leave this line in to always skip Elevation Prompt -->
::GOTO NOCHOICE & REM <-- Leave this line in to always Elevate to Administrator (skip choice) -->
ECHO:
ECHO CHOICE Loading...
ECHO:
:: https://ss64.com/nt/choice.html
CHOICE /M "Run as Administrator?"
IF ERRORLEVEL 2 GOTO START & REM No.
IF ERRORLEVEL 1 REM Yes.
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

REM -------------------------------------------------------------------------------

:Header
GOTO SkipHeader & REM Un-comment this line to skip Header
::CLS
ECHO:
ECHO Script name ^( %~nx0 ^) & REM This script's file name and extension. https://ss64.com/nt/syntax-args.html
ECHO Working directory: %~dp0 & REM The drive letter and path of this script's location.
ECHO Current directory: %CD% & REM The path of the currently selected directory.
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
ECHO Input parameters [%1] [%2] [%3] ...
ECHO:
::PAUSE
::CLS
:SkipHeader

:: End Header

REM -------------------------------------------------------------------------------

:Parameters

:: Input from 

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param1 = File A

SET "_FILE_A=%UserProfile%\Documents\SpiderOak Hive\SysAdmin\Configuring Systems\Boxstarter\Troubleshoot-BatchScript.bat"

SET "_FILE_A=%UserProfile%\Documents\SpiderOak Hive\SysAdmin\Configuring Systems\Boxstarter\initiate-boxstarter_template.bat"

SET "_FILE_A=%UserProfile%\Documents\SpiderOak Hive\SysAdmin\Flash Drive\Build-GeneralFlashDrive.bat"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param2 = File B

SET "_FILE_B=%UserProfile%\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Debug-TroubleshootBatchFile.bat"

SET "_FILE_B=%UserProfile%\Documents\SpiderOak Hive\Programming\Batch\+Function Library\initiate-boxstarter_template.bat"

SET "_FILE_B=%UserProfile%\Documents\Flash Drive updates\Build-GeneralFlashDrive.bat"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param3 = Banner options.

:: Set to QUIET for minimal amount of display text.
SET "_DISPLAY_BANNER=QUIET"

:: Set to SIMPLE for a small opening banner. 
SET "_DISPLAY_BANNER=SIMPLE"

:: Set to FANCY for a custom beginning & closing banner.
SET "_DISPLAY_BANNER=FANCY"

:: If no value for _DISPLAY_BANNER is passed, FANCY is automatically selected by default.

:: If QUIET, SIMPLE, or FANCY cannot be interpreted, behavior defaults to QUIET.

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Parameters


REM -------------------------------------------------------------------------------

REM ECHO DEBUGGING: Begin ExternalFunctions block.

:ExternalFunctions
:: Load External functions and programs:

::Index of external functions: 
:: 1. Banner.cmd "%_BANNER_FUNC%"
:: 2. kdiff3.exe "%_KDIFF_EXE%"

::Banner.cmd
:-------------------------------------------------------------------------------
::CALL "%_BANNER_FUNC%" 12345678901234
::CALL "%_BANNER_FUNC%" 123456789012345678901
::CALL "%_BANNER_FUNC%" A-Z, 0-9, . @
:: Maximum string length is 14. (For CMD)
:: Maximum string length is 21. (For PowerShell)
:: Compatible characters: 0-9 Hyphen "-" Period "." Comma "," At "@" A-Z (Caps only) Space " "
:: Requires SETLOCAL EnableDelayedExpansion
::-------------------------------------------------------------------------------
SET "_BANNER_FOUND=YARP"
::SET "_ORIG_DIR=%CD%"
SET "_ORIG_DIR=%~dp0"
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Just the command
SET "_BANNER_FUNC=Banner.cmd"
:: Same directory
IF NOT EXIST "%_BANNER_FUNC%" (
	SET "_BANNER_FUNC=%CD%\Banner.cmd"
)
:: One directory down
IF NOT EXIST "%_BANNER_FUNC%" (
	SET "_BANNER_FUNC=%CD%\Banner\Banner.cmd"
)
:: One directory up
IF NOT EXIST "%_BANNER_FUNC%" (
	CD ..
	SET "_BANNER_FUNC=!CD!\Banner.cmd"
	CD %_ORIG_DIR%
)
:: One directory up, into functions folder
IF NOT EXIST "%_BANNER_FUNC%" (
	CD ..
	SET "_BANNER_FUNC=!CD!\functions\Banner.cmd"
	CD %_ORIG_DIR%
)
:: Two directories up
IF NOT EXIST "%_BANNER_FUNC%" (
	CD ..
	CD ..
	SET "_BANNER_FUNC=!CD!\Banner.cmd"
	CD %_ORIG_DIR%
)
:: SodaLake Flash Drive relative path
IF NOT EXIST "%_BANNER_FUNC%" (
	CD ..
	SET "_BANNER_FUNC=!CD!\Banner\Banner.cmd"
	CD %_ORIG_DIR%
)
IF NOT EXIST "%_BANNER_FUNC%" (
	CD ..
	CD ..
	SET "_BANNER_FUNC=!CD!\Batch\Banner\Banner.cmd"
	CD %_ORIG_DIR%
)
:: SpiderOak Hive location
IF NOT EXIST "%_BANNER_FUNC%" (
	REM SET "_BANNER_FUNC=%USERPROFILE%\Documents\__\Banner\Banner.cmd"
	SET "_BANNER_FUNC=%USERPROFILE%\Documents\SpiderOak Hive\Programming\Batch\+Function Library\Banner\Banner.cmd"
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF NOT EXIST "%_BANNER_FUNC%" (
	SET "_BANNER_FOUND=NOPE"
	ECHO:
	ECHO EXTERNAL FUNCTION NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find Banner.cmd
	ECHO %_BANNER_FUNC%
	ECHO:
	ECHO https://ss64.com/nt/syntax-banner.html
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	REM GOTO END
	GOTO SkipBannerFunc
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Script name & extention
FOR %%G IN ("%_BANNER_FUNC%") DO SET "_BANNER_FUNC_NAME=%%~nxG"

:: Script drive & path
FOR %%G IN ("%_BANNER_FUNC%") DO SET "_BANNER_FUNC_PATH=%%~dpG"
:SkipBannerFunc
:-------------------------------------------------------------------------------

::kdiff3.exe
:-------------------------------------------------------------------------------
::"%_KDIFF_EXE%" -help
::"%_KDIFF_EXE%" "%_FILE_A%" "%_FILE_B%"
::GOTO SkipKdiffFunction
::-------------------------------------------------------------------------------
:: Just the command
SET "_KDIFF_EXE=kdiff3.exe"
:: C:\Program Files\TortoiseHg\lib\kdiff3.exe
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_KDIFF_EXE=%ProgramFiles%\TortoiseHg\lib\kdiff3.exe"
)
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_KDIFF_EXE=%ProgramFiles(x86)%\TortoiseHg\lib\kdiff3.exe"
)
:: C:\Program Files\KDiff3\kdiff3.exe
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_KDIFF_EXE=%ProgramFiles%\KDiff3\kdiff3.exe"
)
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_KDIFF_EXE=%ProgramFiles(x86)%\KDiff3\kdiff3.exe"
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF NOT EXIST "%_KDIFF_EXE%" (
	ECHO:
	ECHO EXTERNAL FUNCTION NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find kdiff3.exe
	REM ECHO %_KDIFF_EXE%
	ECHO:
	ECHO Have you installed TortoiseHg or KDiff3?
	ECHO:
	ECHO Chocolatey ^(Run As Administrator^)
	ECHO ^> choco install tortoisehg -y ^(or^)
	ECHO ^> choco install kdiff3 -y
	ECHO:
	ECHO https://chocolatey.org/packages/kdiff3
	ECHO:
	ECHO http://kdiff3.sourceforge.net/
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	GOTO END
)
:: kdiff3.exe -help
:: "%_KDIFF_EXE%" -help
:SkipKdiffFunction
:-------------------------------------------------------------------------------

::End ExternalFunctions

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ScriptMain
:Main

REM ECHO DEBUGGING: Beginning Main execution block.

::===============================================================================
:: Phase 1: Evaluate Parameters
:: Phase 2: Banner
:: Phase 3: Use Kdiff to merge both files
:: Phase 4: Banner
::===============================================================================

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 1: Evaluate Parameters
::===============================================================================

:: Activate help function
IF NOT "%~1"=="" (
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
	IF /I "%~1"=="help" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="-h" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="-help" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="--help" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="/?" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="/h" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
	IF /I "%~1"=="/help" (
		CALL :DisplayHelp
		GOTO END
		REM ENDLOCAL & EXIT /B
	)
)

REM ECHO DEBUGGING: Finished help evaluation.

REM -------------------------------------------------------------------------------

:: Always prefer parameters passed via command line over hard-coded vars.
SET "_PASSED_PARAMS=DISABLED"
IF NOT "%~1"=="" (
	SET "_FILE_A=%~1"
	SET "_PASSED_PARAMS=ACTIVE"
)

:: Check if _FILE_A exists
IF NOT EXIST "%_FILE_A%" (
	ECHO:
	ECHO PARAMETER NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find _FILE_A
	ECHO %_FILE_A%
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	GOTO END
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
)

REM -------------------------------------------------------------------------------

:: Request _FILE_B if it was not also provided
IF NOT "%~2"=="" (
	SET "_FILE_B=%~2"
) ELSE (
	REM If _FILE_A was passed via external command, check why _FILE_B was not also passed the same way.
	REM Allow user to manually re-enter path to _FILE_B if called from command line
	REM This is important if the user drags-and-drops a file onto this script.
	IF "%_PASSED_PARAMS%"=="ACTIVE" (
		SET "_DRAGNDROP_MODE=ACTIVE"
		GOTO :ManuallyEnterFileB
	)
)

GOTO SkipManuallyEnterFileB
:ManuallyEnterFileB
CLS
::ECHO -------------------------------------------------------------------------------
::ECHO ERROR: Cannot find _FILE_B
::ECHO %~nx0 requires 2 parameters: _FILE_A and _FILE_B
::ECHO _FILE_A: ^(Found^)
::ECHO "%_FILE_A%"
::ECHO:
::ECHO _FILE_B: ^(Not Found^)
::ECHO "%_FILE_B%"
::ECHO -------------------------------------------------------------------------------
::SET /P "_FILE_B=Please manually enter the full path of _FILE_B: "
IF "%_BANNER_FOUND%"=="YARP" (
	REM ECHO -------------------------------------------------------------------------------
	CALL "%_BANNER_FUNC%" "  merge files "
	REM CALL "%_BANNER_FUNC%" 12345678901234
	REM Maximum string length is 14.
) ELSE (
	ECHO  Drag-n-Drop Mode:
)
ECHO -------------------------------------------------------------------------------
IF "%_BANNER_FOUND%"=="YARP" (
	ECHO  Drag-n-Drop Mode:
)
ECHO "%~nx0 /?" for help
ECHO:
ECHO Merge differences between two text files using kdiff3.
ECHO:
ECHO  _FILE_A: ^(Already Selected^)
ECHO "%_FILE_A%"
ECHO -------------------------------------------------------------------------------
SET /P "_FILE_B=Please drag-and-drop _FILE_B onto the prompt and press ENTER: "
REM Remove any surrounding quotes.
REM ECHO DEBUGGING: _FILE_B = %_FILE_B%
FOR /F "tokens=*" %%G IN ("%_FILE_B%") DO SET "_FILE_B=%%~G"
REM ECHO DEBUGGING: _FILE_B = %_FILE_B%
ECHO:
:SkipManuallyEnterFileB

:: Check if _FILE_B exists
IF NOT EXIST "%_FILE_B%" (
	ECHO:
	ECHO PARAMETER NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find _FILE_B
	ECHO "%_FILE_B%"
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	IF "%_PASSED_PARAMS%"=="ACTIVE" (
		GOTO ManuallyEnterFileB
	) ELSE (
		ECHO:
		GOTO END
	)
)

REM -------------------------------------------------------------------------------

::Check if _FILE_A and _FILE_B are the same
IF /I "%_FILE_A%"=="%_FILE_B%" (
	ECHO:
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: _FILE_A is the same as _FILE_B
	ECHO %_FILE_A%
	ECHO:
	ECHO %_FILE_B%
	ECHO:
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	GOTO END
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
)

REM -------------------------------------------------------------------------------

:: Get _FILE_A Name & eXtention, Drive letter & Path
FOR %%G IN ("%_FILE_A%") DO SET "_FILE_A_NAME=%%~nxG"
FOR %%G IN ("%_FILE_A%") DO SET "_FILE_A_PATH=%%~dpG"

:: Get _FILE_B Name & eXtention, Drive letter & Path
FOR %%G IN ("%_FILE_B%") DO SET "_FILE_B_NAME=%%~nxG"
FOR %%G IN ("%_FILE_B%") DO SET "_FILE_B_PATH=%%~dpG"

REM -------------------------------------------------------------------------------

REM ECHO DEBUGGING: Finished evaluating parameters. Starting Phase 2: Banner 

::===============================================================================
:: Phase 2: Banner
::===============================================================================

:: kdiff banner

:: Collect passed parameters
IF "%_PASSED_PARAMS%"=="ACTIVE" (
	IF "%~3"=="" (
		SET "_DISPLAY_BANNER=FANCY"
	) ELSE (
		SET "_DISPLAY_BANNER=%~3"
	)
)

IF "%_DRAGNDROP_MODE%"=="ACTIVE" CLS
	
IF /I NOT "%_DISPLAY_BANNER%"=="QUIET" (
	IF /I "%_DISPLAY_BANNER%"=="FANCY" (
		REM CLS
		ECHO -------------------------------------------------------------------------------
		CALL :SplashLogoKdiff
		ECHO -------------------------------------------------------------------------------
	) ELSE IF /I "%_DISPLAY_BANNER%"=="SIMPLE" (
		IF /I "%_BANNER_FOUND%"=="YARP" (
			REM CLS
			REM ECHO -------------------------------------------------------------------------------
			REM CALL "%_BANNER_FUNC%" kdiff combine
			CALL "%_BANNER_FUNC%" " kdiff combine"
			REM CALL "%_BANNER_FUNC%" 12345678901234
			REM Maximum string length is 14.
			ECHO -------------------------------------------------------------------------------
		) ELSE (
			ECHO KDIFF COMBINE ^(%~nx0^)
			ECHO -------------------------------------------------------------------------------
		)
	) ELSE ( 
		ECHO KDIFF COMBINE ^(%~nx0^)
		ECHO -------------------------------------------------------------------------------
	)
) ELSE (
	ECHO KDIFF COMBINE ^(%~nx0^)
	ECHO -------------------------------------------------------------------------------
)

REM ECHO DEBUGGING: Finished showing banner. Starting Phase 3: Use Kdiff to merge ...

::===============================================================================
:: Phase 3: Use Kdiff to merge both files
::===============================================================================

:: Get Help
IF /I NOT "%_DISPLAY_BANNER%"=="FANCY" (
	GOTO SkipHelp
) ELSE IF "%_DRAGNDROP_MODE%"=="ACTIVE" (
	GOTO SkipHelp
)
ECHO Skipping KDiff3 help... & GOTO SkipHelp
ECHO:
ECHO Open KDiff3 help:
"%_KDIFF_EXE%" -h
PAUSE
::ECHO:
:SkipHelp

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Compare 2 files: kdiff3 fileA fileB
IF /I NOT "%_DISPLAY_BANNER%"=="FANCY" (
	GOTO SkipComparing
) ELSE IF "%_DRAGNDROP_MODE%"=="ACTIVE" (
	GOTO SkipComparing
)
ECHO Skip file compare... & GOTO SkipComparing
ECHO:
ECHO Comparing:
ECHO %_FILE_A%
ECHO:
ECHO %_FILE_B%
ECHO:
PAUSE
"%_KDIFF_EXE%" "%_FILE_A%" "%_FILE_B%"
PAUSE
::ECHO:
:SkipComparing

REM -------------------------------------------------------------------------------

:: Update File A: kdiff3 fileA fileB -o,--output file fileA
IF /I NOT "%_DISPLAY_BANNER%"=="QUIET" (
	ECHO:
	ECHO #-----------------------------------------------------------------------------#
	ECHO   Updating File A:
	ECHO   %_FILE_A_PATH%
	ECHO   "%_FILE_A_NAME%"
	REM ECHO   %_FILE_A%
	ECHO:
	ECHO   From File B:
	ECHO   %_FILE_B_PATH%
	ECHO   "%_FILE_B_NAME%"
	REM ECHO   %_FILE_B%
	ECHO #-----------------------------------------------------------------------------#
) ELSE (
	ECHO:
	ECHO Updating File A:
	ECHO %_FILE_A_PATH%
	ECHO "%_FILE_A_NAME%"
	REM ECHO %_FILE_A%
	ECHO:
	ECHO From File B:
	ECHO %_FILE_B_PATH%
	ECHO "%_FILE_B_NAME%"
	REM ECHO %_FILE_B%
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
)
ECHO:
ECHO Save changes ^& close when finished.
ECHO:
PAUSE
"%_KDIFF_EXE%" "%_FILE_A%" "%_FILE_B%" -o "%_FILE_A%"
ECHO:
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - *
ECHO:
ECHO Finished updating File A. ^(%_FILE_A_NAME%^)
::ECHO:
::PAUSE

:: Update File B: kdiff3 fileA fileB -o,--output file fileB
IF /I NOT "%_DISPLAY_BANNER%"=="QUIET" (
	ECHO:
	ECHO #-----------------------------------------------------------------------------#
	ECHO   Updating File B:
	ECHO   %_FILE_B_PATH%
	ECHO   "%_FILE_B_NAME%"
	REM ECHO   %_FILE_B%
	ECHO:
	ECHO   From File A:
	ECHO   %_FILE_A_PATH%
	ECHO   "%_FILE_A_NAME%"
	REM ECHO   %_FILE_A%
	ECHO #-----------------------------------------------------------------------------#
) ELSE (
	ECHO:
	ECHO Updating File B:
	ECHO %_FILE_B_PATH%
	ECHO "%_FILE_B_NAME%"
	REM ECHO %_FILE_B%
	ECHO:
	ECHO From File A:
	ECHO %_FILE_A_PATH%
	ECHO "%_FILE_A_NAME%"
	REM ECHO %_FILE_A%
	REM Debugging: cannot use :: for comments within IF statement, instead use REM
)
ECHO:
ECHO Save changes ^& close when finished.
ECHO:
PAUSE
"%_KDIFF_EXE%" "%_FILE_B%" "%_FILE_A%" -o "%_FILE_B%"
ECHO:
ECHO Finished updating File B. ^(%_FILE_B_NAME%^)
ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 4: Banner
::===============================================================================

IF /I "%_DISPLAY_BANNER%"=="FANCY" (
	CALL :SplashLogoMergeComplete
)

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

IF /I NOT "%_DISPLAY_BANNER%"=="QUIET" (
	PAUSE
)

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Main

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM ===============================================================================
REM -------------------------------------------------------------------------------

:Footer
:END
ENDLOCAL
ECHO: 
ECHO End %~nx0
ECHO: 
::PAUSE
::GOTO:EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.

:: End Footer

REM -------------------------------------------------------------------------------

REM ECHO DEBUGGING: Begin DefineFunctions block.

::Index of functions: 
:: 1. :DisplayHelp
:: 2. :GetTerminalWidth
:: 3. :StrLen
:: 4. :GenerateBlankSpace
:: 5. :FormatTextLine
:: 6. :SplashLogoKdiff
:: 7. :SplashLogoMergeComplete

GOTO SkipFunctions
:: Declare Functions
:DefineFunctions
:-------------------------------------------------------------------------------
:DisplayHelp
::CALL :DisplayHelp
:: Display help splash text.
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::C:\Users\[Username]>ipconfig /?
::
::USAGE:
::    ipconfig [/allcompartments] [/? | /all |
::                                 /renew [adapter] | /release [adapter] |
::                                 /renew6 [adapter] | /release6 [adapter] |
::                                 /flushdns | /displaydns | /registerdns |
::                                 /showclassid adapter |
::                                 /setclassid adapter [classid] |
::                                 /showclassid6 adapter |
::                                 /setclassid6 adapter [classid] ]
::
::where
::    adapter             Connection name
::                       (wildcard characters * and ? allowed, see examples)
::
::    Options:
::       /?               Display this help message
::       /all             Display full configuration information.
::       /release         Release the IPv4 address for the specified adapter.
::       /release6        Release the IPv6 address for the specified adapter.
::       /renew           Renew the IPv4 address for the specified adapter.
::       /renew6          Renew the IPv6 address for the specified adapter.
::       /flushdns        Purges the DNS Resolver cache.
::       /registerdns     Refreshes all DHCP leases and re-registers DNS names
::       /displaydns      Display the contents of the DNS Resolver Cache.
::       /showclassid     Displays all the dhcp class IDs allowed for adapter.
::       /setclassid      Modifies the dhcp class id.
::       /showclassid6    Displays all the IPv6 DHCP class IDs allowed for adapter.
::       /setclassid6     Modifies the IPv6 DHCP class id.
::
::
::The default is to display only the IP address, subnet mask and
::default gateway for each adapter bound to TCP/IP.
::
::For Release and Renew, if no adapter name is specified, then the IP address
::leases for all adapters bound to TCP/IP will be released or renewed.
::
::For Setclassid and Setclassid6, if no ClassId is specified, then the ClassId is removed.
::
::Examples:
::    > ipconfig                       ... Show information
::    > ipconfig /all                  ... Show detailed information
::    > ipconfig /renew                ... renew all adapters
::    > ipconfig /renew EL*            ... renew any connection that has its
::                                         name starting with EL
::    > ipconfig /release *Con*        ... release all matching connections,
::                                         eg. "Wired Ethernet Connection 1" or
::                                             "Wired Ethernet Connection 2"
::    > ipconfig /allcompartments      ... Show information about all
::                                         compartments
::    > ipconfig /allcompartments /all ... Show detailed information about all
::                                         compartments
::
::C:\Users\[Username]>_
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::C:\Users\[Username]>tracert /?
::
::Usage: tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout]
::               [-R] [-S srcaddr] [-4] [-6] target_name
::
::Options:
::    -d                 Do not resolve addresses to hostnames.
::    -h maximum_hops    Maximum number of hops to search for target.
::    -j host-list       Loose source route along host-list (IPv4-only).
::    -w timeout         Wait timeout milliseconds for each reply.
::    -R                 Trace round-trip path (IPv6-only).
::    -S srcaddr         Source address to use (IPv6-only).
::    -4                 Force using IPv4.
::    -6                 Force using IPv6.
::
::C:\Users\[Username]>_
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO:
::ECHO ===============================================================================
::ECHO %~nx0 Help.
::ECHO:
::ECHO Called from: "%~dp0"
::ECHO:
::ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
ECHO USAGE: .\%~nx0 "path_to_file_a" "path_to_file_b" [banner]
ECHO:
ECHO where
ECHO     banner      =       QUIET - for minimal output
ECHO                         SIMPLE - for a small banner during start.
ECHO                         FANCY - for a custom banner during start ^& end.
ECHO                        (If no option is selected, the default is FANCY.)
ECHO:
::ECHO OPTIONS:
::ECHO:
ECHO Uses kdiff3 to merge changes between two different files or folders.
ECHO Paramters can be passed via command line or hard-coded into this script.
ECHO If no parameters are provided, default is to use hard-coded variables.
ECHO:
ECHO You may also drag-and-drop files on this script one at a time.
ECHO:
ECHO EXAMPLES:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Documents\file_1.txt" "^%USERPROFILE^%\Dropbox\file_1.txt"
ECHO:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Documents\Folder1" "^%USERPROFILE^%\Dropbox\Folder1" fancy
ECHO:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Desktop\file_2.json" "^%USERPROFILE^%\Dropbox\file_2.json" quiet
ECHO:
::ECHO     > ipconfig                       ... Show information
::ECHO     > ipconfig /all                  ... Show detailed information
::ECHO     > ipconfig /renew                ... renew all adapters
::ECHO     > ipconfig /renew EL*            ... renew any connection that has its
::ECHO                                          name starting with EL
::ECHO     > ipconfig /release *Con*        ... release all matching connections,
::ECHO                                          eg. "Wired Ethernet Connection 1" or
::ECHO                                              "Wired Ethernet Connection 2"
::ECHO     > ipconfig /allcompartments      ... Show information about all
::ECHO                                          compartments
::ECHO     > ipconfig /allcompartments /all ... Show detailed information about all
::ECHO                                          compartments
::ECHO 
::ECHO EXAMPLE:
::ECHO .\%~nx0 "path_to_file_a" "path_to_file_b" [BANNER]
::ECHO:
::ECHO PARAMETERS:
::ECHO    "path_to_file_a"   - Full file path pointing to the first file.
::ECHO    "path_to_file_b"   - Full file path pointing to the second file.
::ECHO    [BANNER]           - If no option is selected, the default is FANCY.
::ECHO                           + QUIET - for minimal output
::ECHO                           + SIMPLE - for a small banner during start.
::ECHO                           + FANCY - for a custom banner during start ^& end.
::ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL
EXIT /B
:-------------------------------------------------------------------------------
:GetTerminalWidth
::CALL :GetTerminalWidth
:: Get width in characters the current terminal (Command Prompt) is.
:: Thanks to:
:: https://ss64.com/nt/syntax-banner.html
:: Outputs:
:: "%_MAX_WINDOW_WIDTH%" Maximum length for a string e.g. "79" (CMD.EXE) or "119" (PowerShell)
:: "%_TRUE_WINDOW_WIDTH%" Actual terminal window width e.g. "80" (CMD.EXE) or "120" (PowerShell)
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FOR /F "tokens=2" %%G IN ('mode ^|find "Columns"') DO SET /A _WINDOW_WIDTH=%%G
SET /A "_WINDOW_WIDTH_NO_NEWLINE=%_WINDOW_WIDTH%-1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_MAX_WINDOW_WIDTH=%_WINDOW_WIDTH_NO_NEWLINE%" & SET "_TRUE_WINDOW_WIDTH=%_WINDOW_WIDTH%"
EXIT /B
:-------------------------------------------------------------------------------
:StrLen  StrVar  [RtnVar]
::CALL :StrLen "%_INPUT_STRING%" _STR_LEN_RTN
::ECHO %_STR_LEN_RTN%
:: Thanks to dbenham from StackOverflow:
::https://stackoverflow.com/questions/5837418/how-do-you-get-the-string-length-in-a-batch-file#5841587
::
:: Computes the length of string in variable StrVar
:: and stores the result in variable RtnVar.
:: If RtnVar is is not specified, then prints the length to stdout.
::
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(
  SETLOCAL EnableDelayedExpansion
  SET "s=A!%~1!"
  SET "len=0"
  FOR %%P IN (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
    IF "!s:~%%P,1!" NEQ "" (
      SET /A "len+=%%P"
      SET "s=!s:~%%P!"
    )
  )
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(
  ENDLOCAL
  IF "%~2" EQU "" (ECHO %len%) ELSE SET "%~2=%len%"
  EXIT /B
)
:-------------------------------------------------------------------------------
:GenerateBlankSpace NumberOfBlankSpaces
::CALL :GenerateBlankSpace "%_NUM_BLANK_LEN%"
::ECHO %_BLANK_SPACE%#
::ECHO 1234567890123456789012345678901234567890123456789012345678901234567890123456789
::ECHO 0        1         2         3         4         5         6         7         
::ECHO -------------------------------------------------------------------------------
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
SET "_INPUT_INT=%~1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Check if input parameter exists.
IF [%_INPUT_INT%]==[] ECHO Function :GenerateBlankSpace requires an integer input paramter. & ENDLOCAL & EXIT /B
:: Check if input parameter is a number.
SET "_INT_TEST="&FOR /F "delims=0123456789" %%G IN ("%_INPUT_INT%") DO SET "_INT_TEST=%%G"
IF DEFINED _INT_TEST (
	REM ECHO %_INPUT_INT% is NOT numeric
	ECHO Function :GenerateBlankSpace requires an integer input paramter. & ENDLOCAL & EXIT /B
) ELSE (
	REM sECHO %_INPUT_INT% is numeric
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET "_OUTPUT_STRING="
::https://ss64.com/nt/for_l.html
FOR /L %%G IN (1,1,%_INPUT_INT%) DO SET "_OUTPUT_STRING=%_OUTPUT_STRING% "
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_BLANK_SPACE=%_OUTPUT_STRING%"
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:FormatTextLine InputText [PrefixBlankSpaces] [PrefixBorderCharacter] [SuffixBorderCharacter]
::CALL :FormatTextLine "%_TEXT_IN_BOX%" 2 ^( ^)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
SET "_TEXTBODY=%~1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF /I [%~2]==[] (
	REM Default to 1 blank prefix space if none defined`
	SET "_PREFIX_BLANK=1"
) ELSE (
	SET "_PREFIX_BLANK=%~2"
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Check if border character input parameter(s) were supplied
IF /I [%~3]==[] (
	REM No parameter 3 or 4, so set | as the default border character
	SET "_PREFIX_CHAR=^|"
	SET "_SUFFIX_CHAR=^|"
) ELSE (
	IF /I [%~4]==[] (
		REM Parameter 3 is present, but parameter 4 is not.
		REM Set both characters to the same.
		SET "_PREFIX_CHAR=%~3"
		SET "_SUFFIX_CHAR=%~3"
	) ELSE ( 
		REM Both paramter 3 and 4 are present, use what is provided.
		SET "_PREFIX_CHAR=%~3"
		SET "_SUFFIX_CHAR=%~4"
	)
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_BLANK_SPACE=%_OUTPUT_STRING%"
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:SplashLogoKdiff
::CALL :SplashLogoKdiff
:: For source see "kdiff-ascii-text.bat"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
::SETLOCAL
::patorjk.com
::ECHO Font Name: Big Money-nw
::ECHO -------------------------------------------------------------------------------
::ECHO $$\             $$\ $$\  $$$$$$\   $$$$$$\    
::ECHO $$ |            $$ |\__|$$  __$$\ $$  __$$\   
::ECHO $$ |  $$\  $$$$$$$ |$$\ $$ /  \__|$$ /  \__|  
::ECHO $$ | $$  |$$  __$$ |$$ |$$$$\     $$$$\       
::ECHO $$$$$$  / $$ /  $$ |$$ |$$  _|    $$  _|      
::ECHO $$  _$$<  $$ |  $$ |$$ |$$ |      $$ |        
::ECHO $$ | \$$\ \$$$$$$$ |$$ |$$ |      $$ |        
::ECHO \__|  \__| \_______|\__|\__|      \__|        
::ECHO -------------------------------------------------------------------------------
:: Replace:
:: 		|	with	^|
:: 		<	with	^<
::ECHO -------------------------------------------------------------------------------
ECHO $$\             $$\ $$\  $$$$$$\   $$$$$$\    
ECHO $$ ^|            $$ ^|\__^|$$  __$$\ $$  __$$\   
ECHO $$ ^|  $$\  $$$$$$$ ^|$$\ $$ /  \__^|$$ /  \__^|  
ECHO $$ ^| $$  ^|$$  __$$ ^|$$ ^|$$$$\     $$$$\       
ECHO $$$$$$  / $$ /  $$ ^|$$ ^|$$  _^|    $$  _^|      
ECHO $$  _$$^<  $$ ^|  $$ ^|$$ ^|$$ ^|      $$ ^|        
ECHO $$ ^| \$$\ \$$$$$$$ ^|$$ ^|$$ ^|      $$ ^|        
ECHO \__^|  \__^| \_______^|\__^|\__^|      \__^|        
::ECHO -------------------------------------------------------------------------------
::PAUSE
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ENDLOCAL
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:SplashLogoMergeComplete
::CALL :SplashLogoMergeComplete
:: For source see "merge-ascii-test.bat" and "merge-ascii-test.txt"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
::SETLOCAL
::patorjk.com
::Font Name: Crazy
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     |  |/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     |   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     |  |  |  |  |  |/     /________\   \|  .-. || |  | |/     /________\   \  #
::ECHO     |  |  |  |  |  ||                  || |  | | \`-' / |                  |  #
::ECHO     |  |  |  |  |  |\    .-------------'| |  | | /("'`  \    .-------------'  #
::ECHO     |  |  |  |  |  | \    '-.____...---.| |  '-  \ '---. \    '-.____...---.  #
::ECHO     |__|  |__|  |__|  `.             .' | |       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   | |      ||     ||  `''-...... -'     #
::ECHO                                         |_|      \'. __//                     #
::ECHO                                                   `'---'                      #
:: Original artwork:
::ECHO         *                                      ,                              #
::ECHO       (  `                                    (                          )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)         (      (        ) /  __  /       #
::ECHO      |_|  |_|\___| |_|  \__, | \___|          \o,----.  o  _,'( ,.^. \        #
::ECHO                         |___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'|     : -hrr- #
::ECHO                                         \   `.  \   `.          |      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO                                       /      / ,'   /                \        #
::Font Name: Big
::ECHO              _____ ____  __  __ _____  _      ______ _______ ______           #
::ECHO             / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|          #
::ECHO            | |   | |  | | \  / | |__) | |    | |__     | |  | |__             #
::ECHO            | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __|            #
::ECHO            | |___| |__| | |  | | |    | |____| |____   | |  | |____           #
::ECHO             \_____\____/|_|  |_|_|    |______|______|  |_|  |______|          #

::Font Name: Fire Font-k
::ECHO         *                             #
::ECHO       (  `                            #
::ECHO       )\))(     (   (    (  (     (   #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\  #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_) #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))   #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)  #
::ECHO      |_|  |_|\___| |_|  \__, | \___|  #
::ECHO                         |___/         #
::ECHO:
::ECHO         *                             #
::ECHO       (  `                            #
::ECHO       )\))(     (   (    (  (     (   #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\  #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_) #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))   #
::ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)  #
::ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|  #
::ECHO                         ^|___/         #
::ECHO:
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     ^|  ^|/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     ^|   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|/     /________\   \^|  .-. ^|^| ^|  ^| ^|/     /________\   \  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|^|                  ^|^| ^|  ^| ^| \`-' / ^|                  ^|  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|\    .-------------'^| ^|  ^| ^| /("'`  \    .-------------'  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^| \    '-.____...---.^| ^|  '-  \ '---. \    '-.____...---.  #
::ECHO     ^|__^|  ^|__^|  ^|__^|  `.             .' ^| ^|       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   ^| ^|      ^|^|     ^|^|  `''-...... -'     #
::ECHO                                         ^|_^|      \'. __//                     #
::ECHO                                                   `'---'                      #
ECHO         *                                      ,                              #
ECHO       (  `                                    (                          )    #
ECHO       )\))(     (   (    (  (     (            \                        /     #
ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^^-.,-''"""\' \       )      #
ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)         (      (        ) /  __  /       #
ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|          \o,----.  o  _,'( ,.^^. \        #
ECHO                         ^|___/                 ,'`.__  `---'    `\ \ \ \_      #
ECHO                                        ,.,. ,'                   \    ' )     #
ECHO                                        \ \ \\__  ,------------.  /     /      #
ECHO                                       ( \ \ \( `---.-`-^^--,-,--\:     :       #
ECHO                                        \       (   (""""""`----'^|     : -hrr- #
ECHO                                         \   `.  \   `.          ^|      \      #
ECHO                                          \   ;  ;     )      __ _\      \     #
ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
ECHO                                        /      ;  ,'  /              \        `#
ECHO                                       /      / ,'   /                \        #
ECHO              _____ ____  __  __ _____  _      ______ _______ ______           #
ECHO             / ____/ __ \^|  \/  ^|  __ \^| ^|    ^|  ____^|__   __^|  ____^|          #
ECHO            ^| ^|   ^| ^|  ^| ^| \  / ^| ^|__) ^| ^|    ^| ^|__     ^| ^|  ^| ^|__             #
ECHO            ^| ^|   ^| ^|  ^| ^| ^|\/^| ^|  ___/^| ^|    ^|  __^|    ^| ^|  ^|  __^|            #
ECHO            ^| ^|___^| ^|__^| ^| ^|  ^| ^| ^|    ^| ^|____^| ^|____   ^| ^|  ^| ^|____           #
ECHO             \_____\____/^|_^|  ^|_^|_^|    ^|______^|______^|  ^|_^|  ^|______^|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     |  |/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     |   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     |  |  |  |  |  |/     /________\   \|  .-. || |  | |/     /________\   \  #
::ECHO     |  |  |  |  |  ||                  || |  | | \`-' / |                  |  #
::ECHO     |  |  |  |  |  |\    .-------------'| |  | | /("'`  \    .-------------'  #
::ECHO     |  |  |  |  |  | \    '-.____...---.| |  '-  \ '---. \    '-.____...---.  #
::ECHO     |__|  |__|  |__|  `.             .' | |       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   | |      ||     ||  `''-...... -'     #
::ECHO         *                               |_|    , \'. __//                     #
::ECHO       (  `                                    (   `'---'                 )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)         (      (        ) /  __  /       #
::ECHO      |_|  |_|\___| |_|  \__, | \___|          \o,----.  o  _,'( ,.^. \        #
::ECHO                         |___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'|     : -hrr- #
::ECHO                                         \   `.  \   `.          |      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO              _____ ____  __  __ _____ /_     /__'___/_______ ______  \        #
::ECHO             / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|          #
::ECHO            | |   | |  | | \  / | |__) | |    | |__     | |  | |__             #
::ECHO            | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __|            #
::ECHO            | |___| |__| | |  | | |    | |____| |____   | |  | |____           #
::ECHO             \_____\____/|_|  |_|_|    |______|______|  |_|  |______|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     ^|  ^|/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     ^|   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|/     /________\   \^|  .-. ^|^| ^|  ^| ^|/     /________\   \  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|^|                  ^|^| ^|  ^| ^| \`-' / ^|                  ^|  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|\    .-------------'^| ^|  ^| ^| /("'`  \    .-------------'  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^| \    '-.____...---.^| ^|  '-  \ '---. \    '-.____...---.  #
::ECHO     ^|__^|  ^|__^|  ^|__^|  `.             .' ^| ^|       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   ^| ^|      ^|^|     ^|^|  `''-...... -'     #
::ECHO         *                               ^|_^|    , \'. __//                     #
::ECHO       (  `                                    (   `'---'                 )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^^-.,-''"""\' \       )      #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)         (      (        ) /  __  /       #
::ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|          \o,----.  o  _,'( ,.^^. \        #
::ECHO                         ^|___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'^|     : -hrr- #
::ECHO                                         \   `.  \   `.          ^|      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO              _____ ____  __  __ _____ /_     /__'___/_______ ______  \        #
::ECHO             / ____/ __ \^|  \/  ^|  __ \^| ^|    ^|  ____^|__   __^|  ____^|          #
::ECHO            ^| ^|   ^| ^|  ^| ^| \  / ^| ^|__) ^| ^|    ^| ^|__     ^| ^|  ^| ^|__             #
::ECHO            ^| ^|   ^| ^|  ^| ^| ^|\/^| ^|  ___/^| ^|    ^|  __^|    ^| ^|  ^|  __^|            #
::ECHO            ^| ^|___^| ^|__^| ^| ^|  ^| ^| ^|    ^| ^|____^| ^|____   ^| ^|  ^| ^|____           #
::ECHO             \_____\____/^|_^|  ^|_^|_^|    ^|______^|______^|  ^|_^|  ^|______^|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ENDLOCAL
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions

::GOTO:EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
