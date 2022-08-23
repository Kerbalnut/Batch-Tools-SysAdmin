# How to use

Paste one of these code blocks as far near the top of your script as possible, preferably right after `@ECHO OFF` and `SETLOCAL` lines.

These snippets will restart your script from the beginning, and the more logic you try to add above the admin block tends to create more weird errors more often, so as close to the top as possible.

For example:

```bat
@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: Description, Index, etc.

:: <-- Paste a RunAsAdmin code block here -->

ECHO Main script code.
ECHO ...
ECHO ...
ECHO ...

ENDLOCAL
EXIT /B
```
- **BatchGotAdmin International-Fix Code.bat** - Short and compact, always runs the script as admin.
- **SS64 Run with elevated permissions (ElevateMe.vbs).bat** - Has built-in options for disabling itself, prompting user whether to run as Admin or not, and input parameter logic so other scripts can call it as strictly Admin or non-Admin.
