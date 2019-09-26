@ECHO OFF

::https://stackoverflow.com/questions/9983048/where-does-notepad-store-style-configurator-settings

SET "_FOLDER_LOCATION=%APPDATA%\Notepad++"

EXPLORER "%_FOLDER_LOCATION%"

EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
