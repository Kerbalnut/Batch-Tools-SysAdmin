@ECHO OFF
::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:Parameters

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param1

SET "_REMOTE_HOST="

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param2 

SET "_DRIVE_LETTER="

::-------------------------------------------------------------------------------
:Main

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

EXPLORER \\%_REMOTE_HOST%\%_DRIVE_LETTER%$\

::- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
EXIT /B
