<#
.SYNOPSIS
Enable Administrative share on local computer.
.DESCRIPTION
Turns on the admin share e.g. \\hostname\C$\ for access from a remote computer.
.NOTES
.LINK
https://www.wintips.org/how-to-enable-admin-shares-windows-7/
#>

# PartOfDomain (boolean Property)
$PartOfDomain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

If ($PartOfDomain) {
	$Domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Name, Domain
	Write-Host "DOMAIN:"
	$Domain | Format-Table | Out-Host
} Else {
	# Workgroup (string Property)
	$Workgroup = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup
	Write-Host "WORKGROUP: $Workgroup"
}




