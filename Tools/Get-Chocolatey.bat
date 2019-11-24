@ECHO OFF

:: RUNAS /noprofile /user:[DOMAIN]\[USERNAME] CMD.EXE

:: RUNAS /noprofile /user:[DOMAIN]\[USERNAME] "CMD.EXE /C ".\Get-Chocolatey.bat""

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
	ECHO BatchGotAdmin Permissions set.
:-------------------------------------------------------------------------------
:: End Run-As-Administrator function


::@powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%SYSTEMDRIVE%\chocolatey\bin;%ALLUSERSPROFILE%\chocolatey\bin

::@powershell -NoProfile -ExecutionPolicy unrestricted -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH="%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

@powershell -NoProfile -ExecutionPolicy Unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%SYSTEMDRIVE%\chocolatey\bin;%ALLUSERSPROFILE%\chocolatey\bin
:: @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

ECHO:
ECHO ===============================================================================
ECHO: 
ECHO End %~nx0
ECHO: 
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
