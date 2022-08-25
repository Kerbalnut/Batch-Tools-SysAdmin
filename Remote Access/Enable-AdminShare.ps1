<#
.SYNOPSIS
Enable Administrative share on local computer.
.DESCRIPTION
Turns on the admin share e.g. \\hostname\C$\ for access from a remote computer.
.NOTES
.LINK
https://www.wintips.org/how-to-enable-admin-shares-windows-7/
.LINK
http://woshub.com/enable-remote-access-to-admin-shares-in-workgroup/
#>
[CmdletBinding()]
Param()
$CommonParameters = @{
	Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
	Debug = [System.Management.Automation.ActionPreference]$DebugPreference
}

#-----------------------------------------------------------------------------------------------------------------------
Function Enable-PingResponse {
	<#
	.SYNOPSIS
	Enable the IPv4 ICMP ping respone on the current machine.
	.DESCRIPTION
	Can also enable IPv6 and NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules
	.PARAMETER ICMPv6
	Also enables IPv6 ICMP ping firewall rules, in addition to the IPv4 ICMP ping firewall rules.
	.PARAMETER NetBIOS
	Also enables NetBIOS-based Network Discovery and File and Printer Sharing firewall rules, in addition to the IPv4 ICMP ping firewall rules.
	.PARAMETER Profiles
	Must be an array of strings, even if only one Profile is selected. Acceptable values are: Public, Private, Domain. Default is @('Domain','Private').
	
	Profiles designate which firewall rules are active based what type of network you are connected to. Use the `Get-NetConnectionProfile` command to see what your currently connected network is set as. To chenge it, run PowerShell as an Administrator and use a command like:
	
	Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private
	Set-NetConnectionProfile -InterfaceAlias "Wi-Fi" -NetworkCategory Public
	Get-NetAdapter | Set-NetConnectionProfile -NetworkCategory Private
	
	Note: It's not possible to change the network adapter category to Domain when there is no domain available. It can only be changed from Private to Public and vice-versa.
	
	For more info, see the commands like: 
	
	Get-NetAdapter
	Get-NetAdapterStatistics
	netsh wlan show networks
	netsh wlan show network mode=ssid
	netsh wlan show network mode=bssid
	explorer.exe ms-availablenetworks
	netsh.exe wlan show profiles name="SSID name" key=clear
	
	https://4sysops.com/archives/manage-wifi-connection-in-windows-10-with-powershell/#show-and-export-profiles-read-password
	Install wifi¬profile¬management is via PowerShellGet run the following command as Administrator: 
	`Install-Module -Name wifiprofilemanagement`
	.PARAMETER WhatIf
	Does not make any changes to the system. Instead a message will be displayed for every change that would've happened.
	.NOTES
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Enable-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[Parameter(Mandatory = $True, ParameterSetName = 'Enabled')]
		[Switch]$Enable,
		
		[Parameter(Mandatory = $True, ParameterSetName = 'Disable')]
		[Switch]$Disable,
		
		[switch]$WhatIf
		
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Get-NetFirewallRule -DisplayName "File and Printer Sharing*" @CommonParameters
	
	#Get-NetFirewallRule -Description "*NetBIOS*" @CommonParameters
	
	$PingFirewallNames = @(
		"CoreNet-Diag-ICMP4-EchoRequest-In",
		"CoreNet-Diag-ICMP4-EchoRequest-Out",
		"CoreNet-Diag-ICMP6-EchoRequest-In",
		"CoreNet-Diag-ICMP6-EchoRequest-Out",
		"CoreNet-Diag-ICMP4-EchoRequest-In-NoScope",
		"CoreNet-Diag-ICMP4-EchoRequest-Out-NoScope",
		"CoreNet-Diag-ICMP6-EchoRequest-In-NoScope",
		"CoreNet-Diag-ICMP6-EchoRequest-Out-NoScope"
	)
	
	$PingFirewallRule = @()
	
	Get-NetFirewallRule -Description "*ICMP*" | ForEach-Object {
		ForEach ($Name in $PingFirewallNames) {
			If ($_.Name -eq $Name) {
				$PingFirewallRule += $_
			}
		}
	}
	
	$Orig = $PingFirewallRule
	$PingFirewallRule = @()
	$PingV6FirewallRule = @()
	$Orig | ForEach-Object {
		$AddV4 = $False
		$AddV6 = $False
		#Write-Host "$($_.Name)"
		ForEach ($P in $_.Profile) {
			#Write-Host "$P"
			ForEach ($Filter in $Profiles) {
				#Write-Host "$Filter"
				If ($P -like "*$Filter*" -And $_.Action -eq "Allow") {
					If ($_.Name -like "*4*") {
						$AddV4 = $True
					} Else {
						$AddV6 = $True
					}
					
				}
			}
		}
		If ($AddV4) {
			$PingFirewallRule += $_
		}
		If ($AddV6) {
			$PingV6FirewallRule += $_
		}
	}
	
	If ($VerbosePreference -ne 'SilentlyContinue') {
		Write-Host "IPv4 ICMP ping firewall rules:"
		$PingFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		If ($ICMPv6) {
			Write-Host "IPv6 ICMP ping firewall rules:"
			$PingV6FirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		}
	}
	
	
	
	
	
	
	
	
	$NetBiosFirewallNames = @(
		"NETDIS-NB_Name-In-UDP-NoScope",
		"NETDIS-NB_Name-Out-UDP-NoScope",
		"NETDIS-NB_Name-In-UDP-Active",
		"NETDIS-NB_Name-Out-UDP-Active",
		"NETDIS-NB_Name-In-UDP",
		"NETDIS-NB_Name-Out-UDP",
		"FPS-NB_Name-In-UDP-NoScope",
		"FPS-NB_Name-Out-UDP-NoScope",
		"FPS-NB_Name-In-UDP",
		"FPS-NB_Name-Out-UDP"
	)
	
	$NetBiosFirewallRule = @()
	
	Get-NetFirewallRule -Description "*NetBIOS*" | ForEach-Object {
		ForEach ($Name in $NetBiosFirewallNames) {
			If ($_.Name -eq $Name) {
				$NetBiosFirewallRule += $_
			}
		}
	}
	
	# $NetBiosFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	
	$Orig = $NetBiosFirewallRule
	$NetBiosFirewallRule = @()
	$Orig | ForEach-Object {
		$Add = $False
		#Write-Host "$($_.Name)"
		ForEach ($P in $_.Profile) {
			#Write-Host "$P"
			ForEach ($Filter in $Profiles) {
				#Write-Host "$Filter"
				If ($P -like "*$Filter*" -And $_.Action -eq "Allow") {
					$Add = $True
				}
			}
		}
		If ($Add) {
			$NetBiosFirewallRule += $_
		}
	}
	
	If ($VerbosePreference -ne 'SilentlyContinue' -And $NetBIOS) {
		Write-Host "NetBIOS-based Network Discovery and File and Printer Sharing firewall rules:"
		$NetBiosFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	}
	
	
	
	
	
	If ($ICMPv6) {
		$PingFirewallRule += $PingV6FirewallRule
	}
	If ($NetBIOS) {
		$PingFirewallRule += $NetBiosFirewallRule
	}
	
	If ($WhatIf) {
		ForEach ($Rule in $PingFirewallRule) {
			
			If ($Enable) {
				Write-Host "What If: Setting rule to Enabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				Write-Host "What If: Setting rule to Disabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			}
			
		}
	} Else {
		
		ForEach ($Rule in $PingFirewallRule) {
			If ($Enable) {
				$Rule | Set-NetFirewallRule -Enabled 1
			} Else {
				$Rule | Set-NetFirewallRule -Enabled 2
			}
		}
		
	}
	
	
	
	<#
	Set-NetFirewallRule [-Action <Action>] [-AsJob] [-Authentication <Authentication>] [-CimSession <CimSession[]>]
	[-Description <String>] [-Direction <Direction>] [-DynamicTarget <DynamicTransport>] [-EdgeTraversalPolicy
	<EdgeTraversal>] [-Enabled <Enabled>] [-Encryption <Encryption>] [-GPOSession <String>] [-IcmpType <String[]>]
	[-InterfaceAlias <WildcardPattern[]>] [-InterfaceType <InterfaceType>] [-LocalAddress <String[]>]
	[-LocalOnlyMapping <Boolean>] [-LocalPort <String[]>] [-LocalUser <String>] [-LooseSourceMapping <Boolean>]
	[-NewDisplayName <String>] [-OverrideBlockRules <Boolean>] [-Owner <String>] [-Package <String>] [-PassThru]
	[-Platform <String[]>] [-PolicyStore <String>] [-Profile <Profile>] [-Program <String>] [-Protocol <String>]
	[-RemoteAddress <String[]>] [-RemoteMachine <String>] [-RemotePort <String[]>] [-RemoteUser <String>] [-Service
	<String>] [-ThrottleLimit <Int32>] -DisplayName <String[]> [-Confirm] [-WhatIf] [<CommonParameters>]
	#>
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Enable-PingResponse function.
#-----------------------------------------------------------------------------------------------------------------------

Write-Host "Starting script: $($MyInvocation.MyCommand)"
Write-Verbose "Verbose switch on."
If ($VerbosePreference -eq 'SilentlyContinue') {
	Pause
	Clear-Host
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Current network shares:"
net share

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 1: Ensure that both computers belong to the same Workgroup.`n"

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

# Ask user to change Workgroup
$Title = "Change Workgroup?"
$Info = "Change Workgroup name $Workgroup to something else (requires restart), or keep it as-is?"
# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
$Change = New-Object System.Management.Automation.Host.ChoiceDescription "&Change", "Change Workgroup name $Workgroup to something new (requires restart)"
$Keep = New-Object System.Management.Automation.Host.ChoiceDescription "&Keep", "Keep Workgroup name $Workgroup the same. (Default)"
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Change, $Keep)
[int]$DefaultChoice = 1 # First choice starts at zero
$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
switch ($Result) {
	0 {
		Write-Verbose "Changing Workgroup name."
		
	}
	1 {
		Write-Verbose "Keeping Workgroup name: $Workgroup"
	}
	Default {
		Write-Error "Workgroup choice error."
		Throw "Workgroup choice error."
	}
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 2: Specify which user(s) can access the Admin Shares (Disk Volumes).`n"

Write-Host "Users in Administrators group:"
$AdminGroupMembers = Get-LocalGroupMember -Group "Administrators" @CommonParameters
$AdminGroupMembers | Out-Host


Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 3: Enable `"File and print sharing`" through Windows Firewall.`n"

Get-NetFirewallPortFilter

Get-NetFirewallPortFilter | ?{$_.LocalPort -eq 80} | Get-NetFirewallRule | ?{ $_.Direction –eq “Inbound” -and $_.Action –eq “Allow”} | Set-NetFirewallRule -RemoteAddress 192.168.0.2

Get-NetFirewallApplicationFilter -Program "*svchost*" | Get-NetFirewallRule

Get-NetFirewallRule -DisplayName "File and Printer Sharing*" @CommonParameters


#New-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Type DWORD -Value 0
#You can deploy this registry parameter to all domain computers through a GPO.

# Now, after a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.

# If you want to enable admin shares on Windows, you need to change the parameter value to 1 or delete it:

Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1 @CommonParameters

# To have Windows recreate the hidden admin shares, simply restart the Server service with the command:

Get-Service LanmanServer @CommonParameters | Restart-Service -Verbose @CommonParameters

Pause


