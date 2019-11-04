
#Requires -RunAsAdministrator

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Update-Help requires -RunAsAdministrator privileges in order to run properly. 

Update-Help

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set Execution Policy

Write-Host "Current Execution Policy = $(Get-ExecutionPolicy)"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#=======================================================================================================================

# Install Modules
#-----------------------------------------------------------------------------------------------------------------------

## Pester
#https://bitsofknowledge.net/2018/03/24/powershell-must-have-tools-for-development/
#https://devblogs.microsoft.com/scripting/what-is-pester-and-why-should-i-care/

# Pester comes pre-installed with Windows 10, but we recommend updating, by running this PowerShell command as administrator:

Install-Module -Name Pester -Force

# Facing problems?
#https://github.com/pester/Pester/wiki/Installation-and-Update

<#
Installing the module may result in this message:

WARNING: Module 'Pester' version '3.4.0' published by
'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US'
will be superceded by version '4.4.3' published by 'CN=Jakub Jareš, O=Jakub Jareš,
L=Praha, C=CZ'. If you do not trust the new publisher, uninstall the module.

This is because the module is signed by a different certificate than the version that Microsoft shipped with Windows.

In Windows 10 v1809 and higher, you first need to cleanup the default Pester module and only then you can proceed with the installation of higher version of Pester module
#>

$module = "C:\Program Files\WindowsPowerShell\Modules\Pester"
takeown /F $module /A /R
icacls $module /reset
icacls $module /grant Administrators:'F' /inheritance:d /T
Remove-Item -Path $Module -Recurse -Force -Confirm:$false

Install-Module -Name Pester -Force

# For any subsequent update it is enough to run:

Update-Module -Name Pester

#-----------------------------------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------------------------------
# /Install Modules

#=======================================================================================================================
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ...

