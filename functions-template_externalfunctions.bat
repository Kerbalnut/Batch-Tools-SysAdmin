
REM -------------------------------------------------------------------------------

::ECHO DEBUGGING: Begin ExternalFunctions block.

:ExternalFunctions
:: Load External functions and programs:

::Index of external functions: 
:: 1. Banner.cmd "%_BANNER_FUNC%"
:: 2. CompareTo-Parent.bat "%_COMPARE_FUNC%"
:: 3. kdiff3.exe "%_KDIFF_EXE%"
:: 4. fossil.exe "%_FOSSIL_EXE%"

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

::CompareTo-Parent.bat
:-------------------------------------------------------------------------------
::CALL "%_COMPARE_FUNC%" "%_FILE_A%" "%_FILE_B%"
:: Requires SETLOCAL EnableDelayedExpansion
GOTO SkipCompareToParentFunc
::-------------------------------------------------------------------------------
SET "_COMPAREFUNC_FOUND=YARP"
::SET "_ORIG_DIR=%CD%"
SET "_ORIG_DIR=%~dp0"
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Just the command
SET "_COMPARE_FUNC=CompareTo-Parent.bat"
:: Same directory
IF NOT EXIST "%_COMPARE_FUNC%" (
	SET "_COMPARE_FUNC=%CD%\CompareTo-Parent.bat"
)
:: One directory down
IF NOT EXIST "%_COMPARE_FUNC%" (
	SET "_COMPARE_FUNC=%CD%\Compare To\CompareTo-Parent.bat"
)
:: Two directories down
IF NOT EXIST "%_COMPARE_FUNC%" (
	SET "_COMPARE_FUNC=%CD%\Tools\Compare To\CompareTo-Parent.bat"
)
:: SodaLake Flash Drive relative path
IF NOT EXIST "%_COMPARE_FUNC%" (
	CD ..
	CD ..
	SET "_COMPARE_FUNC=!CD!\Tools\Compare To\CompareTo-Parent.bat"
	CD %_ORIG_DIR%
)
:: Flash Drive Updates relative path
IF NOT EXIST "%_COMPARE_FUNC%" (
	CD ..
	SET "_COMPARE_FUNC=!CD!\SodaLake\Tools\Compare To\CompareTo-Parent.bat"
	CD %_ORIG_DIR%
)
:: SpiderOak Hive location
IF NOT EXIST "%_COMPARE_FUNC%" (
	REM SET "_COMPARE_FUNC=%USERPROFILE%\Documents\__\SodaLake\Tools\Compare To\CompareTo-Parent.bat"
	SET "_COMPARE_FUNC=%USERPROFILE%\Documents\...\Tools\Compare To\CompareTo-Parent.bat"
)
:: Work Laptop location
IF NOT EXIST "%_COMPARE_FUNC%" (
	REM SET "_COMPARE_FUNC=%USERPROFILE%\Documents\__\Tools\Compare To\CompareTo-Parent.bat"
	SET "_COMPARE_FUNC=%USERPROFILE%\Documents\SodaLake\Tools\Compare To\CompareTo-Parent.bat"
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF NOT EXIST "%_COMPARE_FUNC%" (
	SET "_COMPAREFUNC_FOUND=NOPE"
	ECHO:
	ECHO EXTERNAL FUNCTION NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find CompareTo-Parent.bat
	ECHO %_COMPARE_FUNC%
	ECHO:
	ECHO %UserProfile%\Documents\SpiderOak Hive\SysAdmin\Tools\Compare To\CompareTo-Parent.bat
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	REM GOTO END
	GOTO SkipCompareToParentFunc
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Script name & extention
FOR %%G IN ("%_COMPARE_FUNC%") DO SET "_COMPARE_FUNC_NAME=%%~nxG"

:: Script drive & path
FOR %%G IN ("%_COMPARE_FUNC%") DO SET "_COMPARE_FUNC_PATH=%%~dpG"
:SkipCompareToParentFunc
:-------------------------------------------------------------------------------

::kdiff3.exe
:-------------------------------------------------------------------------------
::"%_KDIFF_EXE%" -help
::"%_KDIFF_EXE%" "%_FILE_A%" "%_FILE_B%"
GOTO SkipKdiffFunction
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

::fossil.exe
:-------------------------------------------------------------------------------
::"%_FOSSIL_EXE%" help
::"%_FOSSIL_EXE%" help ui
::"%_FOSSIL_EXE%" ui "%_FOSSIL_FILE%"
GOTO SkipFossilFunction
::-------------------------------------------------------------------------------
:: Just the command
SET "_FOSSIL_EXE=fossil"
:: Just the command + extension
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_FOSSIL_EXE=fossil.exe"
)
:: C:\ProgramData\chocolatey\lib\fossil.portable\tools\fossil.exe
IF NOT EXIST "%_KDIFF_EXE%" (
	SET "_FOSSIL_EXE=%ChocolateyInstall%\lib\fossil.portable\tools\fossil.exe"
)
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF NOT EXIST "%_FOSSIL_EXE%" (
	ECHO:
	ECHO EXTERNAL FUNCTION NOT FOUND
	ECHO -------------------------------------------------------------------------------
	ECHO ERROR: Cannot find fossil.exe
	ECHO %_FOSSIL_EXE%
	ECHO:
	ECHO Have you installed Fossil?
	ECHO:
	ECHO Chocolatey ^(Run As Administrator^)
	ECHO ^> choco install fossil -y
	ECHO:
	ECHO https://chocolatey.org/packages/fossil
	ECHO:
	ECHO https://www.fossil-scm.org/
	ECHO -------------------------------------------------------------------------------
	ECHO:
	PAUSE
	ECHO:
	GOTO END
)
:: fossil.exe help
:: "%_FOSSIL_EXE%" help
:SkipFossilFunction
:-------------------------------------------------------------------------------

::End ExternalFunctions

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ScriptMain
:Main
