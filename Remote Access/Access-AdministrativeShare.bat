@ECHO OFF

REM Bugfix: Use "REM ECHO DEBUG*ING: " instead of "::ECHO DEBUG*ING: " to comment-out debugging lines, in case any are within IF statements.
REM ECHO DEBUGGING: Begin Parameters block.

::-------------------------------------------------------------------------------

:Parameters

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param1

SET "_REMOTE_HOST="

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param2 

SET "_DRIVE_LETTER="

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::End Parameters

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

REM ECHO DEBUGGING: Beginning Main execution block.

::Index of Main:

::===============================================================================
:: Phase 1: Get Parameters: Remote Host
:: Phase 2: Evaluate Parameters: Drive Letter
:: Phase 3: Open windows explorer to remote administrative share
::===============================================================================

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 1: Get Parameters: Remote Host
::===============================================================================

ECHO %~nx0
ECHO:
ECHO Access Administrative shares on a remote system.

:: -------------------------------------------------------------------------------

:GetRemoteHost
ECHO:
IF "%_REMOTE_HOST%"=="" (
	SET /P "_REMOTE_HOST=Enter Name or IP of remote host (e.g. server.local, 192.168.0.11): "
)

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Check DNS for name resolution

SET "_ERROR_OUTPUT_FILE=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.txt"

NSLOOKUP "%_REMOTE_HOST%" >nul 2>"%_ERROR_OUTPUT_FILE%"

FOR %%G IN ("%_ERROR_OUTPUT_FILE%") DO SET "_ERROR_OUTPUT_FILE_SIZE=%%~zG"
SET /A "_ERROR_OUTPUT_FILE_SIZE_KB=%_ERROR_OUTPUT_FILE_SIZE%/1024"

IF %_ERROR_OUTPUT_FILE_SIZE% GTR 0 (
	ECHO:
	ECHO Error: "%_REMOTE_HOST%" could not be looked up by DNS.
	ECHO:
	TYPE "%_ERROR_OUTPUT_FILE%"
	ECHO:
	PAUSE
	REM CLS
	REM GOTO GetRemoteHost
)

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Ping IP address

::CALL :CheckLink "%_REMOTE_HOST%" silent

IF "%_LinkState%"=="down" (
	ECHO:
	ECHO Error: "%_REMOTE_HOST%" not responding to ICMP pings.
	ECHO:
	PAUSE
	REM CLS
	REM GOTO GetRemoteHost
)

::===============================================================================
:: Phase 2: Evaluate Parameters: Drive Letter
::===============================================================================

:GetDriveLetter
ECHO:
IF "%_DRIVE_LETTER%"=="" (
	SET /P "_DRIVE_LETTER=Enter Drive letter to connect to (e.g. C, D): "
)

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Check if string is longer than 1 character

IF "%_DRIVE_LETTER%"=="" (
	ECHO:
	ECHO Error: Drive letter empty.
	ECHO:
	ECHO "%%_DRIVE_LETTER%%" = "%_DRIVE_LETTER%"
	ECHO:
	PAUSE
	CLS
	GOTO GetDriveLetter
)

CALL :StrLen "%_DRIVE_LETTER%" _DRIVE_LETTER_LENGTH

REM ECHO DEBUGGING: "%%_DRIVE_LETTER%%" string length: %_DRIVE_LETTER_LENGTH%

IF %_DRIVE_LETTER_LENGTH% GTR 1 (
	ECHO:
	ECHO Error: Drive letter too long.
	ECHO:
	PAUSE
	CLS
	GOTO GetDriveLetter
)

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Convert string to uppercase

CALL :UpCase "%_DRIVE_LETTER%"

SET "_DRIVE_LETTER=%_UPCASE_STRING%"

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 3: Open windows explorer to remote administrative share
::===============================================================================

ECHO:
ECHO Loading . . . 
ECHO:
	
EXPLORER \\%_REMOTE_HOST%\%_DRIVE_LETTER%$\

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Main

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM ===============================================================================
REM -------------------------------------------------------------------------------

:Footer
:END
::ENDLOCAL
ECHO: 
ECHO End %~nx0
ECHO: 
::PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.

:: End Footer

REM -------------------------------------------------------------------------------

REM ECHO DEBUGGING: Begin DefineFunctions block.

:DefineFunctions
:: Declare Functions

::Index of functions: 
:: 1. :StrLen
:: 2. :UpCase
:: 3. :CheckLink

GOTO SkipFunctions
:-------------------------------------------------------------------------------
:StrLen  StrVar  [RtnVar]
::CALL :StrLen "%_INPUT_STRING%" _DRIVE_LETTER_LENGTH
::ECHO %_DRIVE_LETTER_LENGTH%
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
:UpCase InputString
::CALL :UpCase "%_INPUT_STRING%"
:: Thanks to:
::https://www.robvanderwoude.com/battech_convertcase.php
:: Outputs:
:: "%_UPCASE_STRING%"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
SET "_INPUT_STRING=%~1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Subroutine to convert a variable VALUE to all UPPER CASE.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "_INPUT_STRING=%%_INPUT_STRING:%%~i%%"
SET "_OUTPUT_STRING=%_INPUT_STRING%"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_UPCASE_STRING=%_OUTPUT_STRING%"
::EXIT /B
GOTO:EOF
:-------------------------------------------------------------------------------
:CheckLink IPorDNSaddress [QuietMode]
::CALL :CheckLink "%_IP_ADDR_OR_DNS%"
::CALL :CheckLink "%_IP_ADDR_OR_DNS%" quiet
:: Check address for ICMP ping response packets
:: http://stackoverflow.com/questions/3050898/how-to-check-if-ping-responded-or-not-in-a-batch-file
:: thanks to paxdiablo for checklink.cmd
:: Outputs:
:: "%_LinkState%" Either "down" or "up"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@SETLOCAL EnableExtensions EnableDelayedExpansion
@ECHO OFF
SET "ipaddr=%~1"
SET "_QUIET=%~2"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET "_SILENT_MODE=OFF"
IF /I "%_QUIET%"=="quiet" SET "_SILENT_MODE=ON"
IF /I "%_QUIET%"=="silent" SET "_SILENT_MODE=ON"
SET "_loopcount=0"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF /I "%_SILENT_MODE%"=="OFF" ECHO Testing address: %ipaddr%
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:loop
SET "state=down"
FOR /F "tokens=5,7" %%a IN ('PING -n 1 !ipaddr!') DO (
    IF "x%%a"=="xReceived" IF "x%%b"=="x1," SET "state=up"
)
IF /I "%_SILENT_MODE%"=="OFF" ECHO Link is !state!
REM --> test networking hardware capability
PING -n 6 127.0.0.1 >nul: 2>nul:
IF "!state!"=="down" (
	IF /I "%_SILENT_MODE%"=="ON" (
		ENDLOCAL & SET "_LinkState=%state%" & EXIT /B
	)
	IF !_loopcount! LSS 3 (
		SET /A "_loopcount+=1"
		GOTO :loop
	) ELSE (
		ENDLOCAL & SET "_LinkState=%state%" & EXIT /B
	)	
) ELSE (
	IF "!state!"=="up" (
		ENDLOCAL & SET "_LinkState=%state%" & EXIT /B
	)
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_LinkState=%state%"
EXIT /B
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions

