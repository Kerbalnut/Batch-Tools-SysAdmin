@ECHO OFF

:: RUNAS /noprofile /user:[DOMAIN]\[USERNAME] CMD.EXE

:: RUNAS /noprofile /user:[DOMAIN]\[USERNAME] "CMD.EXE /C ".\Uninstall-Chocolatey.bat""

::Index: 
:: 1. :RunAsAdministrator
:: 2. :Header
:: 3. :Parameters
:: 4. :ExternalFunctions
:: 5. :Main
:: 6. :DefineFunctions
:: 7. :Footer

REM Bugfix: Use "REM ECHO DEBUG*ING: " instead of "::ECHO DEBUG*ING: " to comment-out debugging lines, in case any are within IF statements.
REM ECHO DEBUGGING: Begin RunAsAdministrator block.

:RunAsAdministrator
:: BatchGotAdmin International-Fix Code
:: https://sites.google.com/site/eneerge/home/BatchGotAdmin
:-------------------------------------------------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
IF '%ERRORLEVEL%' NEQ '0' (
    ECHO Requesting administrative privileges... ^(waiting 2 seconds^)
	PING -n 3 127.0.0.1>nul
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
:-------------------------------------------------------------------------------

REM -------------------------------------------------------------------------------

:Parameters

:: Input from 

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Param1 = Backup location

::SET "_BACKUP_FOLDER=%UserProfile%\Documents\Chocolatey Backup"
SET "_BACKUP_FOLDER=C:\ProgramData\chocolatey-backup"

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Parameters

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

::https://chocolatey.org/docs/uninstallation

ECHO Uninstalling Chocolatey

:: Should you decide you don't like Chocolatey, you can uninstall it simply by removing the folder (and the environment variable(s) that it creates). Since it is not actually installed in Programs and Features, you don't have to worry that it cluttered up your registry (however that's a different story for the applications that you installed with Chocolatey or manually).

:: Most of Chocolatey is contained in C:\ProgramData\chocolatey or whatever $env:ChocolateyInstall evaluates to. You can simply delete that folder.

:: NOTE You might first back up the sub-folders lib and bin just in case you find undesirable results in removing Chocolatey. Bear in mind not every Chocolatey package is an installer package, there may be some non-installed applications contained in these subfolders that could potentially go missing. Having a backup will allow you to test that aspect out.

:: Environment Variables

:: There are some environment variables that need to be adjusted or removed.

::     ChocolateyInstall
::     ChocolateyToolsLocation
::     ChocolateyLastPathUpdate
::     PATH (will need updated to remove)

REM ===============================================================================

ECHO:

:: Check if chocolatey is installed
IF NOT EXIST "%ChocolateyInstall%" (
	ECHO ^%ChocolateyInstall^% directory not detected.
	GOTO END
)

IF NOT EXIST "C:\ProgramData\chocolatey" (
	ECHO C:\ProgramData\chocolatey directory not detected.
	ECHO:
	REM GOTO END
)

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Backup the sub-folders lib and bin
COPY "%ChocolateyInstall%\lib" "%_BACKUP_FOLDER%\lib"
COPY "%ChocolateyInstall%\bin" "%_BACKUP_FOLDER%\bin"

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Remove ChocolateyInstall directory

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: Remove choco from PATH

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -






:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:END
ECHO:
ECHO ===============================================================================
ECHO: 
ECHO End %~nx0
ECHO: 
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.


