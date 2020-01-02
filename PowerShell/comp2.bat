
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
