@ECHO OFF
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
:: Phase 1: Evaluate Parameters
:: Phase 2: Check DNS for name resolution
:: Phase 3: Ping IP address
:: Phase 4: Open windows explorer to remote administrative share
::===============================================================================

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::===============================================================================
:: Phase 1: Evaluate Parameters
::===============================================================================

ECHO %~nx0
ECHO:
ECHO Access Administrative shares on a remote system.

ECHO:
IF "%_REMOTE_HOST%"=="" (
	SET /P "_REMOTE_HOST=Enter Name or IP of remote host (e.g. server.local, 192.168.0.11): "
)

ECHO:
IF "%_DRIVE_LETTER%"=="" (
	SET /P "_DRIVE_LETTER=Enter Drive letter to connect to (e.g. C, D): "
)

::===============================================================================
:: Phase 2: Check DNS for name resolution
::===============================================================================

::===============================================================================
:: Phase 3: Ping IP address
::===============================================================================

::===============================================================================
:: Phase 4: Open windows explorer to remote administrative share
::===============================================================================

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
:: 1. :CheckLink

GOTO SkipFunctions
:-------------------------------------------------------------------------------
:CheckLink IPorDNSaddress
:: Check address for ICMP ping response packets
:: http://stackoverflow.com/questions/3050898/how-to-check-if-ping-responded-or-not-in-a-batch-file
:: thanks to paxdiablo for checklink.cmd
@SETLOCAL EnableExtensions EnableDelayedExpansion
@ECHO OFF
SET "ipaddr=%1"
ECHO Testing address: %ipaddr%
SET "_loopcount=0"
:loop
SET "state=down"
FOR /F "tokens=5,7" %%a IN ('PING -n 1 !ipaddr!') DO (
    IF "x%%a"=="xReceived" IF "x%%b"=="x1," SET "state=up"
)
ECHO Link is !state!
REM --> test networking hardware capability
PING -n 6 127.0.0.1 >nul: 2>nul:
IF "!state!"=="down" (
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
ENDLOCAL & SET "_LinkState=%state%"
EXIT /B
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions

