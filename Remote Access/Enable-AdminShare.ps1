<#
.SYNOPSIS
Enable Administrative share on local computer.
.DESCRIPTION
Turns on the admin share e.g. \\hostname\C$\ for access from a remote computer.
.NOTES
.EXAMPLE
. "$Home\Documents\GitHub\Batch-Tools-SysAdmin\Remote Access\Enable-AdminShare.ps1" -LoadFunctions -Verbose

Run this line to only load the functions stored in this script. Dot-sourcing is required to import the functions and variables of this script into the current scope, unlike calling it with & ampersand which does not. Parameters can still be passed to the script.

Older versions of PowerShell do not allow variables in the path when dot-sourcing a script. The text <enter user name> must be replaced:

. "C:\Users\<enter user name>\Documents\GitHub\Batch-Tools-SysAdmin\Remote Access\Enable-AdminShare.ps1" -LoadFunctions -Verbose
.LINK
https://www.wintips.org/how-to-enable-admin-shares-windows-7/
.LINK
http://woshub.com/enable-remote-access-to-admin-shares-in-workgroup/
#>
[CmdletBinding()]
Param(
	[switch]$LoadFunctions
)
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$CommonParameters = @{
	Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
	Debug = [System.Management.Automation.ActionPreference]$DebugPreference
}
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#-----------------------------------------------------------------------------------------------------------------------
Function Get-PingResponseRules {
	<#
	.SYNOPSIS
	Returns a list of firewall rules for the IPv4 ICMP ping respone on the current machine.
	.DESCRIPTION
	Can also get IPv6 and NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules.
	.PARAMETER ICMPv6
	Also gets IPv6 ICMP ping firewall rules, in addition to the IPv4 ICMP ping firewall rules.
	.PARAMETER NetBIOS
	Also gets NetBIOS-based Network Discovery and File and Printer Sharing firewall rules, in addition to the IPv4 ICMP ping firewall rules.
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
	.PARAMETER Table
	Formats output as a table instead for easy viewing.
	.NOTES
	.LINK
	Get-PingResponseRules
	Set-PingResponse
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Get-PingResponseRules -IPv6 -NetBIOS -Table
	#>
	[CmdletBinding()]
	Param(
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[Alias('FormatTable')]
		[switch]$Table
		
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
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
	
	If ($Table) {
		$PingFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	} Else {
		Return $PingFirewallRule
	}
} # End of Get-PingResponseRules function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Set-PingResponse {
	<#
	.SYNOPSIS
	Sets firewall rules for the IPv4 ICMP ping respone on the current machine.
	.DESCRIPTION
	Can also enable/disable IPv6 and NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules.
	
	Either -Enable or -Disable switch is required.
	.PARAMETER Enable
	Turns on the rules that Allow ping packets through the firewall.
	.PARAMETER Disable
	Turns off the rules that Allow ping packets through the firewall.
	.PARAMETER ICMPv6
	Also enables/disables IPv6 ICMP ping firewall rules, in addition to the IPv4 ICMP ping firewall rules.
	.PARAMETER NetBIOS
	Also enables/disables NetBIOS-based Network Discovery and File and Printer Sharing firewall rules, in addition to the IPv4 ICMP ping firewall rules.
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
	Get-PingResponseRules
	Set-PingResponse
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Set-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV6','IPv6')]
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
	
	$FunctionParams = @{
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		Profiles = $Profiles
	}
	
	$PingFirewallRule = Get-PingResponseRules @FunctionParams @CommonParameters
	
	If ($VerbosePreference -eq 'SilentlyContinue') {
		Write-Host "Firewall rules before change:"
		Get-PingResponseRules @FunctionParams -Table @CommonParameters
	}
	
	ForEach ($Rule in $PingFirewallRule) {
		If ($Enable) {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Enabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				$Rule | Set-NetFirewallRule -Enabled 1
			}
		} Else {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Disabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				$Rule | Set-NetFirewallRule -Enabled 2
			}
		}
	}
	
	If ($VerbosePreference -eq 'SilentlyContinue') {
		Write-Host "Firewall rules after change:"
		Get-PingResponseRules @FunctionParams -Table @CommonParameters
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
} # End of Set-PingResponse function.
#-----------------------------------------------------------------------------------------------------------------------

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
	Get-PingResponseRules
	Set-PingResponse
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Enable-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[switch]$WhatIf
		
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$ParamsHash = @{
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		Profiles = $Profiles
		Enable = $True
		#Disable = $True
		WhatIf = $WhatIf
	}
	
	Set-PingResponse @ParamsHash @CommonParameters
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Enable-PingResponse function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Disable-PingResponse {
	<#
	.SYNOPSIS
	Disable the IPv4 ICMP ping respone on the current machine.
	.DESCRIPTION
	Can also disable IPv6 and NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules
	.PARAMETER ICMPv6
	Also disables IPv6 ICMP ping firewall rules, in addition to the IPv4 ICMP ping firewall rules.
	.PARAMETER NetBIOS
	Also disables NetBIOS-based Network Discovery and File and Printer Sharing firewall rules, in addition to the IPv4 ICMP ping firewall rules.
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
	Get-PingResponseRules
	Set-PingResponse
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Disable-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[switch]$WhatIf
		
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$ParamsHash = @{
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		Profiles = $Profiles
		#Enable = $True
		Disable = $True
		WhatIf = $WhatIf
	}
	
	Set-PingResponse @ParamsHash @CommonParameters
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Disable-PingResponse function.
#-----------------------------------------------------------------------------------------------------------------------

If ($LoadFunctions) {
	Write-Host "Finished loading functions."
	Write-Verbose "Finished loading functions."
	Return
}

Return

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Starting script: $($MyInvocation.MyCommand)"
Write-Verbose "Verbose switch on."
If ($VerbosePreference -eq 'SilentlyContinue') {
	Pause
	Clear-Host
}

Write-Host "Enabling Admin shares (\\hostname\C$) on this machine: $env:COMPUTERNAME`n"

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Current network shares:"
net share

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 1: Enable ping response and `"File and print sharing`" through Windows Firewall.`n"

$ParamsHash = @{
	ICMPv6 = $True
	NetBIOS = $True
}

#Get-PingResponseRules -ICMPv6 -NetBIOS -Table @CommonParameters
Get-PingResponseRules @ParamsHash -Table @CommonParameters

# Ask user to change ping response firewall rules.
$Title = "Enable ping response?"
$Info = "Enable firewall rules to Allow ping response (ICMPv4) and NetBIOS discovery on this machine: $env:COMPUTERNAME?"
# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Enable firewall rules that would Allow a ping response from this device: $env:COMPUTERNAME"
$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not make any firewall rule changes."
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
[int]$DefaultChoice = 0 # First choice starts at zero
$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
switch ($Result) {
	0 {
		Write-Verbose "Enabling ping response:"
		Get-PingResponseRules @ParamsHash -Table @CommonParameters
	}
	1 {
		Write-Verbose "Declined firewall rules change for ping."
	}
	Default {
		Write-Error "Ping response choice error."
		Throw "Ping response choice error."
	}
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 2: Check that connected network(s) are not set to 'Public' profile type.`n"

$NetProfiles = Get-NetConnectionProfile

$NetProfiles | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table

$PublicProfiles = $False
$NetProfiles | ForEach-Object {
	If ($_.NetworkCategory -eq "Public") {
		$PublicProfiles = $True
		Write-Warning "A network interface is set to 'Public': $($_.InterfaceAlias)"
	}
}

If ($PublicProfiles) {
	ForEach ($interface in $NetProfiles) {
		If ($interface.NetworkCategory -eq "Public") {
			# Ask user to change network interface profile to Private
			$Title = "Change '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Private'?"
			$Info = "The $($interface.InterfaceAlias) network is set to '$($interface.NetworkCategory)' profile type, which changes the class of firewall rules being applied to a very restrictive set, designed for untrusted networks. If this is a trusted network, changing it to 'Private' will make this device discoverable by other devices on this network."
			# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
			$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Change '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Private'."
			$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No changes to '$($interface.InterfaceAlias)' network profile, it will remain as '$($interface.NetworkCategory)'."
			$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
			[int]$DefaultChoice = 0 # First choice starts at zero
			$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
			switch ($Result) {
				0 {
					Write-Verbose "Changing '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Private'."
					
					#Set-NetConnectionProfile -InterfaceIndex $interface.InterfaceIndex -NetworkCategory 'Private' @CommonParameters
					$interface | Set-NetConnectionProfile -NetworkCategory 'Private' @CommonParameters
					
					Get-NetConnectionProfile | Where-Object {$_.InterfaceIndex -eq $interface.InterfaceIndex} | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table
				}
				1 {
					Write-Verbose "No changes made to '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile. ($($interface.NetworkCategory))"
				}
				Default {
					Write-Error "Network profile choice error."
					Throw "Network profile choice error."
				}
			} # End switch
		} # End If ($interface.NetworkCategory -eq "Public")
	} # End ForEach
} Else {
	Write-Host "No network profiles set to Public.`nSKIPPING...`n"
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------"
Write-Host "Step 3: Ensure that both computers belong to the same Workgroup or Domain.`n"

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
$Info = "Change Workgroup name $Workgroup to something else (REQUIRES RESTART), or keep it as-is?"
# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
$Change = New-Object System.Management.Automation.Host.ChoiceDescription "&Change", "Change Workgroup name $Workgroup to something new (REQUIRES RESTART)"
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
Write-Host "Step 4: Specify which user(s) can access the Admin Shares (Disk Volumes).`n"

Write-Host "Users in Administrators group:"
$AdminGroupMembers = Get-LocalGroupMember -Group "Administrators" @CommonParameters
$AdminGroupMembers | Out-Host







#New-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Type DWORD -Value 0
#You can deploy this registry parameter to all domain computers through a GPO.

# Now, after a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.

# If you want to enable admin shares on Windows, you need to change the parameter value to 1 or delete it:

Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1 @CommonParameters

# To have Windows recreate the hidden admin shares, simply restart the Server service with the command:

Get-Service LanmanServer @CommonParameters | Restart-Service -Verbose @CommonParameters

Pause


