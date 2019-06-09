@ECHO OFF
::COLOR 0A
COLOR 2
SET "_TARGET=%~1"
IF "%~1"=="" SET "_TARGET=1000" & REM Time in milliseconds, defaults to 1000
SET "_TIMER=0"
CALL :GetWindowsVersion
:START
IF "%_WindowsVersion%"=="10" (
	ECHO %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM%
) ELSE ( 
	ECHO %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM% %RANDOM%
)
SET /A "_TIMER+=1"
IF %_TIMER% GTR %_TARGET% GOTO :EOF
GOTO START
:END
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
:DefineFunctions
:-------------------------------------------------------------------------------
:GetWindowsVersion
@ECHO OFF
SETLOCAL
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
ENDLOCAL & SET "_WindowsVersion=%_winversion%" & SET "_WindowsName=%_winvername%" & SET "_WindowsEasyName=%_easyname%"
EXIT /B
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions