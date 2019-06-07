# Batch Functions, Templates, Tools, and Scripts

Common tasks that can be accomplished by *.bat files on Windows systems.

These features a lot of structure, organization, and emphasis on functions, or calling other scripts to do the rest.

## Contents:

#### BoxstarterInstall-NetworkingUtilities.bat

Use Boxstarter and Chocolatey to automatically install a suite of software packages, in this case networking utilities for a technician's laptop.

#### functions-template.bat

A template for creating new batch scripts. Also serves as a repository for all internal and external functions, and tests for them.

### Tools >

#### CompareTo-Parent.bat

Use Kdiff3 to merge the changes between 2 (text) files or folders. Supports drag-and-drop of files one-at-a-time.

#### Debug-TroubleshootBatchFile.bat

Used to troubleshoot batch files that close immediately on error, by keeping last errors open in command prompt for review. Supports drag-and-drop.

### functions >

#### Banner.cmd

Displays a text banner across command prompt. Up to 14 characters for Windows 8 and below command prompt width, or up to 21 characters for Windows 10 command prompt width, or PowerShell prompt width on any Windows version.

Compatible characters:

- 0-9
- Hyphen "-"
- Period "."
- Comma ","
- At "@"
- A-Z (Caps only)
- Space " "


