@ECHO OFF

SET "_PREV_COMMITS_TO_GET=8"

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::Thanks to:
::https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
ECHO:
ECHO Last %_PREV_COMMITS_TO_GET% commits in the local repository:
ECHO:

:: Natural command:
::git log -6 --pretty=format:"%h - %an, %ar : %s"
:: This will work from the command line, but in batch script percentage signs % must be doubled-up to be literal %%

git log -%_PREV_COMMITS_TO_GET% --pretty=format:"%%h - %%an, %%ar : %%s"

ECHO:
PAUSE

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:

ECHO:
PAUSE

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
