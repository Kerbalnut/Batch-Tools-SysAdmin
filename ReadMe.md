# Batch Functions, Templates, Tools, and Scripts

Common tasks that can be accomplished by *.bat files on Windows systems.

These features a lot of structure, organization, and emphasis on functions, or calling other scripts to do the rest.

All code or functions gained from other sources are referenced in place where used with links.

---

## Contents:

#### BoxstarterInstall-NetworkingUtilities.bat

Use Boxstarter and Chocolatey to automatically install a suite of software packages, in this case networking utilities for a technician's laptop. 

#### BoxstarterInstall-template.bat

Use Boxstarter and Chocolatey to automatically install a suite of software packages. Define software packages using [Boxstarter script](https://boxstarter.org/UsingBoxstarter) and Chocolatey commands, or simply a comma-separated list of [chocolatey packages](https://chocolatey.org/packages). Boxstarter scripts can be either a .txt file (preferably with the same name as the script), or uploaded to [gist.github.com](https://gist.github.com/) and referenced via Raw URL.

#### functions-template.bat

A framework for creating organized batch scripts. Also serves as a repository for all internal and external functions, and examples of using them.

Index of external functions: 

1. Banner.cmd "%_BANNER_FUNC%"
2. CompareTo-Parent.bat "%_COMPARE_FUNC%"
3. kdiff3.exe "%_KDIFF_EXE%"
4. fossil.exe "%_FOSSIL_EXE%"

Index of Main:

1. Phase 1: Evaluate Parameters
2. Phase 2: Test :GetIfPathIsDriveRoot
3. Phase 3: Test :GetWindowsVersion
4. Phase 4: Test Banner.cmd (external function)
5. Phase 5: Test :GetTerminalWidth
6. Phase 6: Test :CheckLink
7. Phase 7: Test :GetDate, :ConvertTimeToSeconds, and :ConvertSecondsToTime
8. Phase 8: Test :InitLog and :InitLogOriginal
9. Phase 9: Test :CreateShortcut, :CreateSymbolicLink, and :CreateSymbolicDirLink

Index of functions: 

1. :SampleFunction
2. :DisplayHelp
3. :GetTerminalWidth
4. :StrLen
5. :GenerateBlankSpace
6. :FormatTextLine
7. :CheckLink
8. :GetWindowsVersion
9. :GetIfPathIsDriveRoot
10. :CreateShortcut
11. :CreateSymbolicLink
12. :CreateSymbolicDirLink
13. :GetDate
14. :ConvertTimeToSeconds
15. :ConvertSecondsToTime
16. :InitLogOriginal
17. :InitLog
18. :SplashLogoKdiff
19. :SplashLogoMerge
20. :SplashLogoMergeComplete

#### Install-AllWindowsUpdates.bat

#### Update-Java.bat

### Tools >

#### Tools >CompareTo-Parent.bat

Use [Kdiff3](https://chocolatey.org/packages/kdiff3) to merge the changes between 2 (text) files or folders. Supports drag-and-drop of files one-at-a-time.

#### Tools >Debug-TroubleshootBatchFile.bat

Used to troubleshoot batch files that close immediately on error, by keeping last errors open in command prompt for review. Supports drag-and-drop.

### functions >

#### functions >Banner.cmd

Displays a text banner across command prompt. Up to 14 characters for Windows 8 and below command prompt width, or up to 21 characters for Windows 10 command prompt width, or PowerShell prompt width on any Windows version.

Compatible characters:

- 0-9
- Hyphen "-"
- Period "."
- Comma ","
- At "@"
- A-Z (Caps only)
- Space " "

#### functions > matrix-timer.bat

---

## Run As Administrator functions

There are 2 different Run-As-Administrator functions in use. **#1** uses a `cacls.exe` method to check for permissions. **#2** uses a `FSUTIL` method to check.  Both use `UAC.ShellExecute` command called from a .vbs script to elevate.

**#1** [BatchGotAdmin International-Fix Code](https://sites.google.com/site/eneerge/home/BatchGotAdmin) does not forward any parameters to the elevated script. Always elevates a script when the **:RunAsAdministrator** block is the first code execution added to the top. 

- Tools > Get-Chocolatey.bat
- Tools > Install-Chocolatey.bat
- Tools > Install-XPChocolatey.bat
- BoxstarterInstall-NetworkingUtilities.bat
- BoxstarterInstall-template.bat
- Install-AllWindowsUpdates.bat
- Update-Java.bat

**#2** [SS64 Run with elevated permissions script (ElevateMe.vbs)](http://ss64.com/vb/syntax-elevate.html) can accept parameters and pass them along to the elevated script. Includes structure to prompt user for elevation, automatically elevate always, or skip elevation always. 

- Tools > CompareTo-Parent.bat
- Tools > Debug-TroubleshootBatchFile.bat
- functions-template.bat

---

