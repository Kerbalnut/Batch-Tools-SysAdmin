@ECHO OFF

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

git pull

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
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
