
#Requires -RunAsAdministrator

# Update-Help requires -RunAsAdministrator privileges in order to run properly. 

Update-Help

# Set Execution Policy

Write-Host "Current Execution Policy = $(Get-ExecutionPolicy)"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# Install Modules

# ...

