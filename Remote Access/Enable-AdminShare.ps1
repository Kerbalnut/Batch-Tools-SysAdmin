<#
.SYNOPSIS
Enable Administrative share on the local computer.
.DESCRIPTION
Turns on the admin share e.g. \\hostname\C$\ on this computer, so it can be accessed from a remote computer. Runs a series of steps to ensure this computer's Admin shares will be accessible, but not all the steps are related or necessary. It may only actually require one of these steps to enable the Admin shares on this PC. Likewise, not every step is required to disable Admin shares, but when -Disable switch is used the user will prompted to run them all in reverse anyways.
.PARAMETER Disable
Runs the same series of steps that this script would normally run, but makes the opposite actions. User will still be prompted whether to run each step or not just like when run normally.
.PARAMETER LoadFunctions
Only loads the functions this script contains into whatever scope it was called from. None of the other logic in this script will be loaded.
.PARAMETER LoadAllFunctions
Even loads functions with context-specific text that wouldn't make much sense in other situations.
.NOTES
Keep in mind this script isn't guaranteed to always enable access to Admin shares on 100% of networks either. There's countless other things in networking that can prevent this, from client isolation tactics, different VLANs, down to individual port blocking for something like NetBIOS on the network, that can prevent Admin shares from working.

Disclaimer: It should be obvious, but just like every other form of remote access, most of these steps will lower the security of your system in some way. Some are negligible, some can be serious security risks. Improper registry edits can cause system instability.
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
[CmdletBinding(DefaultParameterSetName = "LoadFuncs")]
Param(
	[switch]$Disable,
	
	[Parameter(ParameterSetName = "LoadFuncs")]
	[switch]$LoadFunctions,
	[Parameter(ParameterSetName = "LoadAllFuncs")]
	[switch]$LoadAllFunctions
	
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
	
	Write-Verbose "Starting $($MyInvocation.MyCommand)"
	
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
		Write-Verbose "Ending $($MyInvocation.MyCommand)"
		Return
	} Else {
		Write-Verbose "Ending $($MyInvocation.MyCommand)"
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
	
	If ($VerbosePreference -ne 'SilentlyContinue') {
		Write-Host "Firewall rules before change:"
		Get-PingResponseRules @FunctionParams -Table | Out-Host
	}
	
	ForEach ($Rule in $PingFirewallRule) {
		If ($Enable) {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Enabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				Write-Verbose "Enabling Firewall rule: $($Rule.Name)"
				$Rule | Set-NetFirewallRule -Enabled 1
			}
		} Else {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Disabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				Write-Verbose "Disabling Firewall rule: $($Rule.Name)"
				$Rule | Set-NetFirewallRule -Enabled 2
			}
		}
	}
	
	If ($VerbosePreference -ne 'SilentlyContinue') {
		Write-Host "Firewall rules after change:"
		Get-PingResponseRules @FunctionParams -Table | Out-Host
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

#-----------------------------------------------------------------------------------------------------------------------
Function Backup-RegistryPath {
	[CmdletBinding()]
	Param(
		$KeyPath,
		$KeyName,
		$BackupFolderName = 'RegistryBackups'
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Write-Verbose "Starting function: $($MyInvocation.MyCommand)"
	
	#-----------------------------------------------------------------------------------------------------------------------
	Function Add-NewRegFileName($NewFileName) {
		#$NewFileName = Read-Host "New file name"
		#If (!$NewFileName -Or $NewFileName -eq "") {Continue}
		$NewFileName = $NewFileName.Trim()
		If ($NewFileName -match '^.*\.\w+$') {
			If ($NewFileName -notmatch '^.*\.reg$') {
				$FileExtension = [System.IO.Path]::GetExtension($NewFileName)
				$FilePathWithoutExention = $NewFileName -replace "\$FileExtension$",""
				$RecommendedPath = $FilePathWithoutExention + ".reg"
				$RecommendedFile = Split-Path $RecommendedPath -Leaf
				Write-Warning "Registry backup files that do not use a .reg file extension cannot be restored automatically by double-clicking."
				Do {
					$NewExtRec = Read-Host "Change file extension to use `"$RecommendedFile`" .reg extension instead? (RECOMMENDED) [Y\N]"
					$NewExtRec = $NewExtRec.Trim()
				} Until ($NewExtRec -eq "Y" -Or $NewExtRec -eq "N")
				If ($NewExtRec -eq "Y") {
					$NewFileName = $RecommendedPath
				}
			}
		} Else {
			If ($NewFileName -match '.*\.$') {
				# E.g. "C:\foo bar\test file."
				Write-Warning "Not a proper file extension, cannot end with period."
				$NewFileName = $NewFileName -replace '\.$',''
			}
			Write-Warning "No file extension detected, auto-choosing '.reg'."
			$NewFileName = $NewFileName + ".reg"
		}
		Return $NewFileName
	} # End Function Add-NewRegFileName
	#-----------------------------------------------------------------------------------------------------------------------
	
	#-----------------------------------------------------------------------------------------------------------------------
	Function Export-RegPath {
		[CmdletBinding()]
		Param(
			$BackupFileName,
			$BackupRegPath,
			$BackupFilePath
		)
		$FileWithExt = Split-Path -Path $BackupFilePath -Leaf
		$FileWithExt = $BackupFileName
		$RegOutputFile = Join-Path -Path $env:TEMP -ChildPath "reg_export_output.txt"
		$ParentFolder = Split-Path -Path $BackupFilePath -Parent
		If (!(Test-Path -Path $ParentFolder)) {
			Try {
				mkdir $ParentFolder
			} Catch {
				Write-Warning "Could not create folder for registry backup: `"$ParentFolder`""
				#Write-Error "Could not create folder for registry backup: `"$ParentFolder`""
				#Throw "Could not create folder for registry backup: `"$ParentFolder`""
			}
		}
		Try {
			#(Reg export "$BackupRegPath" "$BackupFilePath" /y) | Tee-Object | Set-Variable -Name RegCmdResult
			(Reg export "$BackupRegPath" "$BackupFilePath" /y) *> "$RegOutputFile"
		} Catch {
			$RegCmdResult = Get-Content -Path $RegOutputFile
			Write-Host "'Reg' export command had an error:`n$RegCmdResult" -ForegroundColor Red -BackgroundColor Black
			Write-Error "Registry backup file export failed. ($FileWithExt) `"$RegOutputFile`""
			Pause
			Throw "Registry backup file export failed. ($FileWithExt)`"$RegOutputFile`""
		}
		$RegCmdResult = Get-Content -Path $RegOutputFile
		If ($RegCmdResult -like "*ERROR*") {
			Write-Host "'Reg' export command had an error:`n$RegCmdResult" -ForegroundColor Red -BackgroundColor Black
			Write-Error "Registry backup file export failed. ($FileWithExt) `"$RegOutputFile`""
			Pause
			Throw "Registry backup file export failed. ($FileWithExt)`"$RegOutputFile`""
		}
	} # End Function Export-RegPath
	#-----------------------------------------------------------------------------------------------------------------------
	
	# Setup vars:
	$BackupRegPath = $KeyPath
	#$BackupRegPath = Split-Path -Path $BackupRegPath -Parent
	$BackupRegPath = $BackupRegPath -replace 'Registry::',''
	$BackupRegPath = $BackupRegPath -replace 'HKEY_LOCAL_MACHINE','HKLM'
	$BackupRegPath = $BackupRegPath -replace ':',''
	$DateString = Get-Date -UFormat "%Y-%m-%d_%H-%M-%S"
	$BackupFileName = "$($DateString)_$($KeyName)_backup.reg"
	#$BackupFileName = "test_backup.reg"
	#$BackupFilePath = Join-Path -Path (Get-Location) -ChildPath $BackupFileName
	$BackupFilePath = Join-Path -Path (Get-Location) -ChildPath $BackupFolderName
	$BackupFilePath = Join-Path -Path $BackupFilePath -ChildPath $BackupFileName
	
	$Alt1 = Join-Path -Path $env:USERPROFILE -ChildPath 'Desktop'
	$Alt1 = Join-Path -Path $Alt1 -ChildPath $BackupFolderName
	#$Alt1 = (Join-Path -Path $Alt1 -ChildPath $BackupFileName)
	$Alt2 = Join-Path -Path $env:USERPROFILE -ChildPath 'Documents'
	$Alt2 = Join-Path -Path $Alt2 -ChildPath $BackupFolderName
	#$Alt2 = (Join-Path -Path $Alt2 -ChildPath $BackupFileName)
	$Alt3 = Join-Path -Path $env:TEMP -ChildPath $BackupFolderName
	#$Alt3 = (Join-Path -Path $env:TEMP -ChildPath $BackupFileName)
	
	$AltPaths = @(
		$BackupFilePath,
		(Join-Path -Path $Alt1 -ChildPath $BackupFileName),
		(Join-Path -Path $Alt2 -ChildPath $BackupFileName),
		(Join-Path -Path $Alt3 -ChildPath $BackupFileName)
	)
	
	If ((Get-Location) -notlike "C:\WINDOWS*") {
		$BackupFilePath = ($AltPaths | Select-Object -First 1)
	} Else {
		$BackupFilePath = ($AltPaths | Select-Object -First 2)
		$BackupFilePath = ($BackupFilePath | Select-Object -Last 1)
	}
	
	# Ask user to backup registry key path:
	Write-Host "`n`nBackup resgistry location:`n$BackupRegPath`n`nTo path:`n$BackupFilePath`n"
	$Title = "Backup registry location?"
	$Info = "Backup the target registry location before making changes? (RECOMMENDED) This is only a backup, you will be asked to make the actual changes later."
	# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
	$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes, backup the target registry path. No other changes will be made. (RECOMMENDED) `"$BackupRegPath`""
	$Change = New-Object System.Management.Automation.Host.ChoiceDescription "&Change Backup Path", "Change backup path (RECOMMENDED): `"$BackupFilePath`""
	$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No, do not make any registry backups. (NOT RECOMMENDED)"
	$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $Change, $No)
	[int]$DefaultChoice = 0 # First choice starts at zero
	$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
	switch ($Result) {
		0 {
			Write-Verbose "Backing up registry to: $BackupFilePath"
			#Reg export "$BackupRegPath" "$BackupFilePath" /y\
			Export-RegPath -BackupFileName $BackupFileName -BackupRegPath $BackupRegPath -BackupFilePath $BackupFilePath
		}
		1 {
			Write-Verbose "Choose alternate path:"
			$DisplayTable = @()
			$i = 0
			$AltPaths | ForEach-Object {
				$i++
				$DisplayTable += [PSCustomObject]@{
					ID = $i
					Path = $_
				}
			}
			$i++
			$DisplayTable += [PSCustomObject]@{
				ID = $i
				Path = "<Enter new path>"
			}
			
			Do {
				Write-Host "Choose alternate path:"
				$DisplayTable | Format-Table | Out-Host
				[int]$Choice = Read-Host "Enter choice ID"
			} Until ([int]$Choice -ge 1 -And [int]$Choice -le $DisplayTable.Count)
			If ([int]$Choice -eq $DisplayTable.Count) {
				# User made last choice in list: enter their own path
				$Accepted = $False
				Do {
					$UserPath = Read-Host "Enter new path"
					$UserPath = $UserPath.Trim()
					If (!$UserPath -Or $UserPath -eq "" -Or $null -eq $UserPath) {Continue}
					$UserPath = $UserPath -replace '\\$',''
					If (!(Test-Path -Path $UserPath)) {
						Write-Verbose "Path does not exist."
						If ($UserPath -match '.*\.$') {
							# E.g. "C:\foo bar\test file."
							Write-Warning "Not a proper file extension, cannot end with period."
							Continue
						}
						If ($UserPath -match '^.*\.\w+$') {
							# E.g. "C:\foo bar\test file.ext"
							$HasFileExtension = $True
						} Else {
							# E.g. "C:\foo bar\test file"
							$HasFileExtension = $False
						}
						If ($HasFileExtension) {
							# Path has file extension
							If ($UserPath -notmatch '^.*\.reg$') {
								$FileExtension = [System.IO.Path]::GetExtension($UserPath)
								$FilePathWithoutExention = $UserPath -replace "\$FileExtension$",""
								$RecommendedPath = $FilePathWithoutExention + ".reg"
								$RecommendedFile = Split-Path $RecommendedPath -Leaf
								Write-Warning "Registry backup files that do not use a .reg file extension cannot be restored automatically by double-clicking."
								Do {
									$NewExtRec = Read-Host "Change file extension to use `"$RecommendedFile`" .reg extension instead? (RECOMMENDED) [Y\N]"
									$NewExtRec = $NewExtRec.Trim()
								} Until ($NewExtRec -eq "Y" -Or $NewExtRec -eq "N")
								If ($NewExtRec -eq "Y") {
									$UserPath = $RecommendedPath
								}
							}
							$ParentFolder = Split-Path -Path $UserPath -Parent
							# E.g. "C:\foo bar\"
							If (!(Test-Path -Path $ParentFolder)) {
								Write-Warning "Folder path does not exist: $ParentFolder"
								Do {
									$MakeDirs = Read-Host "Create it? [Y\N]"
									$MakeDirs = $MakeDirs.Trim()
								} Until ($MakeDirs -eq "Y" -Or $MakeDirs -eq "N")
								If ($MakeDirs -eq "Y") {
									mkdir $ParentFolder
								} Else {
									Continue
								}
							}
							$FileWithExt = Split-Path -Path $UserPath -Leaf
							# E.g. "test file.ext"
							Try {
								Write-Verbose "Creating: $UserPath"
								#Reg export "$BackupRegPath" "$UserPath" /y
								Export-RegPath -BackupFileName $BackupFileName -BackupRegPath $BackupRegPath -BackupFilePath $UserPath
							} Catch {
								Write-Warning "Registry backup file export failed. ($FileWithExt)"
								Continue
							}
							$Accepted = $True
						} Else {
							# Path doesn't have file extension
							# E.g. "C:\foo bar\test file"
							$NewFileName = Read-Host "New file name"
							If (!$NewFileName -Or $NewFileName -eq "" -Or $null -eq $NewFileName) {Continue}
							$NewFileName = $NewFileName.Trim()
							$NewFileName = Add-NewRegFileName -NewFileName $NewFileName
							# E.g. "C:\foo bar\test file"
							Write-Warning "Folder path does not exist: $UserPath"
							Do {
								$MakeDirs = Read-Host "Create it? [Y\N]"
								$MakeDirs = $MakeDirs.Trim()
							} Until ($MakeDirs -eq "Y" -Or $MakeDirs -eq "N")
							If ($MakeDirs -eq "Y") {
								mkdir $UserPath
							} Else {
								Continue
							}
							$UserPath = Join-Path -Path $UserPath -ChildPath $NewFileName
							Try {
								Write-Verbose "Creating: $UserPath"
								#Reg export "$BackupRegPath" "$UserPath" /y
								Export-RegPath -BackupFileName $BackupFileName -BackupRegPath $BackupRegPath -BackupFilePath $UserPath
							} Catch {
								Write-Warning "Registry backup file export failed. ($NewFileName)"
								Continue
							}
							$Accepted = $True
						} # End If ($HasFileExtension)
					} Else {
						Write-Verbose "Path exists."
						#$IsFolder = (Get-Item $UserPath) -is [System.IO.DirectoryInfo]
						$IsFolder = (Get-Item $UserPath).PSIsContainer
						If ($IsFolder) {
							$NewFileName = Read-Host "New file name"
							If (!$NewFileName -Or $NewFileName -eq "") {Continue}
							$NewFileName = $NewFileName.Trim()
							$NewFileName = Add-NewRegFileName -NewFileName $NewFileName
							$UserPath = Join-Path -Path $UserPath -ChildPath $NewFileName
						}
						Try {
							Write-Verbose "Creating: $UserPath"
							#Reg export "$BackupRegPath" "$UserPath" /y
							Export-RegPath -BackupFileName $BackupFileName -BackupRegPath $BackupRegPath -BackupFilePath $UserPath
						} Catch {
							Write-Warning "Registry backup file export failed. ($NewFileName)"
							Continue
						}
						$Accepted = $True
					} # End If (!(Test-Path -Path $UserPath))
				} Until ($Accepted)
			} Else {
				# User Made a pre-generated backup path choice:
				$DisplayTable | ForEach-Object {
					If ($_.ID -eq $Choice) {
						$AltBackupFilePath = $_.Path
					}
				}
				
				Export-RegPath -BackupFileName $BackupFileName -BackupRegPath $BackupRegPath -BackupFilePath $AltBackupFilePath
				
			} # End If ([int]$Choice -eq $DisplayTable.Count)
			#Reg export "$BackupRegPath" "$AltBackupFilePath" /y
		}
		2 {
			Write-Warning "No registry backups were made."
		}
		Default {
			Write-Error "Registry backup choice error."
			Throw "Registry backup choice error."
		}
	}
	# End Backup registry path
	Write-Verbose "Ending function: $($MyInvocation.MyCommand)"
} # End Function Backup-RegistryPath
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function New-RegistryKey {
	[CmdletBinding()]
	Param(
		[string]$KeyPath,
		[string]$KeyName,
		$NewValue
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Write-Verbose "Starting function: $($MyInvocation.MyCommand)"
	# First check if registry key exists:
	If ($NewFuncKeyValue) {Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
	Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	Write-Verbose "NewFuncKeyValue = '$NewFuncKeyValue'"
	Try {
		$NewFuncKeyValue = Get-ItemProperty -Path $KeyPath -Name $KeyName -Force -ErrorAction 'Stop' @CommonParameters
	} Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Verbose "Registry key '$KeyName' does not exist. 1"
		If ($NewFuncKeyValue) {Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
		Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	} Catch {
		Write-Verbose "Registry key '$KeyName' does not exist. 2"
		If ($NewFuncKeyValue) {Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
		Remove-Variable -Name NewFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	}
	Write-Verbose "NewFuncKeyValue = '$NewFuncKeyValue'"
	# Ask user to create it if it doesn't:
	If (!($NewFuncKeyValue)) {
		Write-Verbose "Key '$KeyName' does not exist."
		# Ask user to either disable or delete registry key
		$Title = "Create new registry key?"
		$Info = "Create the '$KeyName' registry key?"
		# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
		$Create = New-Object System.Management.Automation.Host.ChoiceDescription "&Create Key", "Create new '$KeyName' registry key with the DWORD value = $NewValue"
		$Skip = New-Object System.Management.Automation.Host.ChoiceDescription "&Skip", "Keep everything as-is, do not make any changes to the registry."
		$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Create, $Skip)
		[int]$DefaultChoice = 0 # First choice starts at zero
		$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
		switch ($Result) {
			0 {
				Write-Verbose "Creating '$KeyName' reg key with the DWORD value = $NewValue"
				
				$null = New-ItemProperty -Path $KeyPath -Name $KeyName -Type DWORD -Value $NewValue @CommonParameters
				
			}
			1 {
				Write-Verbose "No changes made, keeping registry as-is"
			}
			Default {
				Write-Error "Create new registry key choice error."
				Throw "Create new registry key choice error."
			}
		}
	}
	Write-Verbose "Ending function: $($MyInvocation.MyCommand)"
} # End Function New-RegistryKey
#-----------------------------------------------------------------------------------------------------------------------

If ($LoadFunctions -And !$LoadAllFunctions) {
	Write-Verbose "Finished loading '$($MyInvocation.MyCommand)' functions."
	Return
}

#-----------------------------------------------------------------------------------------------------------------------
Function Remove-RegistryKey {
	[CmdletBinding()]
	Param(
		[string]$KeyPath,
		[string]$KeyName,
		[switch]$ServerOS,
		[string]$OSName,
		[switch]$OptionalRemoval
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Write-Verbose "Starting function: $($MyInvocation.MyCommand)"
	# First check if registry key exists:
	If ($DelFuncKeyValue) {Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
	Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	Write-Verbose "DelFuncKeyValue = '$DelFuncKeyValue'"
	Try {
		$DelFuncKeyValue = Get-ItemProperty -Path $KeyPath -Name $KeyName -ErrorAction 'Stop'
	} Catch [System.Management.Automation.ItemNotFoundException] {
		Write-Verbose "Registry key '$KeyName' does not exist. 1"
		If ($DelFuncKeyValue) {Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
		Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	} Catch {
		Write-Verbose "Registry key '$KeyName' does not exist. 2"
		If ($DelFuncKeyValue) {Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'}
		Remove-Variable -Name DelFuncKeyValue -Force -ErrorAction 'SilentlyContinue'
	}
	Write-Verbose "DelFuncKeyValue = '$DelFuncKeyValue'"
	# Ask user to delete it if it does:
	If ($DelFuncKeyValue -And $DelFuncKeyValue -ne '' -And $null -ne $DelFuncKeyValue) {
		If ($DelFuncKeyValue.$KeyName -eq 0) {
			$ValueLabel = "(disabled)"
		} ElseIf ($DelFuncKeyValue.$KeyName -eq 1) {
			$ValueLabel = "(enabled)"
		}
		If (!$OptionalRemoval) {
			Write-Warning "Key '$KeyName' exists. Value = '$($DelFuncKeyValue.$KeyName)'"
			Write-Host "In order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n"
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($DelFuncKeyValue.$KeyName) $ValueLabel"
			}
			Write-Host "`nRegistry path:`n$KeyPath\`n`nKey:`n$KeyName"
			$DisplayTable | Format-Table | Out-Host
			If ($ServerOS) {
				$OSLabel = "server"
				$OppositeLabel = "non-server"
			} Else {
				$OSLabel = "non-server"
				$OppositeLabel = "server"
			}
			Write-Warning "Incorrect/incompatible registry key detected. This computer has been detected as a $OSLabel OS ('$OSName'), yet a key only meant for a $OppositeLabel OS was detected ('$KeyName'). Recommended to delete this registry key."
			$SuggestedAction = "RECOMMENDED"
		} Else {
			$SuggestedAction = "OPTIONAL"
		}
		# Ask user to either disable or delete registry key
		$Title = "Delete registry key?"
		$Info = "Remove the '$KeyName' registry key?"
		# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
		$Delete = New-Object System.Management.Automation.Host.ChoiceDescription "&Delete", "Delete the '$KeyName' registry key. ($SuggestedAction)"
		$Keep = New-Object System.Management.Automation.Host.ChoiceDescription "&Keep", "Keep as-is, do not make any changes to the registry: '$KeyName' ($($DelFuncKeyValue.$KeyName))"
		$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Delete, $Keep)
		If (!$OptionalRemoval) {
			[int]$DefaultChoice = 0 # First choice starts at zero
		} Else {
			[int]$DefaultChoice = 1 # First choice starts at zero
		}
		$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
		switch ($Result) {
			0 {
				Write-Verbose "Deleting '$KeyName' reg key."
				Remove-ItemProperty -Path $KeyPath -Name $KeyName @CommonParameters
			}
			1 {
				Write-Verbose "Keeping registry key the same: '$KeyName' ($($DelFuncKeyValue.$KeyName))"
			}
			Default {
				Write-Error "Delete registry key choice error."
				Throw "Delete registry key choice error."
			}
		}
	} Else {
		Write-Verbose "Key '$KeyName' already doesn't exist. Nothing to delete."
	}
	Write-Verbose "Ending function: $($MyInvocation.MyCommand)"
} # End Function Remove-RegistryKey
#-----------------------------------------------------------------------------------------------------------------------

If ($LoadAllFunctions) {
	Write-Verbose "Finished loading ALL '$($MyInvocation.MyCommand)' functions."
	Return
}

$HR = "-----------------------------------------------------------------------------------------------------------------------"
Write-Host $HR -BackgroundColor Black -ForegroundColor White
Write-Host "Starting script: $($MyInvocation.MyCommand)" -BackgroundColor Black -ForegroundColor White
If ($Disable) {$Verb1 = "Disabling"} Else {$Verb1 = "Enabling"}
Write-Host "$Verb1 Admin shares (e.g. \\$env:COMPUTERNAME\C$) on this machine: `n" -BackgroundColor Black -ForegroundColor White

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
Write-Host "Current network shares:" -BackgroundColor Black -ForegroundColor White
Write-Host "C:\> net share"
net share

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$Step1 = "Step 1: Check that connected network(s) are not set to 'Public' profile type."
#Write-Host "Step 1: Check that connected network(s) are not set to 'Public' profile type.`n" -BackgroundColor Black -ForegroundColor White
Write-Host $Step1 -BackgroundColor Black -ForegroundColor White
Write-Host ""

$NetProfiles = Get-NetConnectionProfile

$NetProfiles | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table

$PublicProfiles = $False
$NetProfiles | ForEach-Object {
	If ($_.NetworkCategory -eq "Public") {
		$PublicProfiles = $True
		If (!($Disable)) {
			Write-Warning "The network '$($_.Name)' on interface '($($_.InterfaceIndex)) $($_.InterfaceAlias)' is set to '$($_.NetworkCategory)'."
		}
	}
}

If (!($Disable)) {
	If (($PublicProfiles -And !$Disable) -Or (!$PublicProfiles -And $Disable)) {
		ForEach ($interface in $NetProfiles) {
			If ($interface.NetworkCategory -eq "Public") {
				# Ask user to change network interface profile to Private
				$Title = "Change '$($interface.Name)' network on '($($interface.InterfaceIndex)) $($interface.InterfaceAlias)' to 'Private' profile?"
				$Info = "The '$($interface.Name)' $($interface.InterfaceAlias) network is set to '$($interface.NetworkCategory)' profile type, which changes the class of firewall rules being applied to a very restrictive set, designed for untrusted networks. If this is a trusted network, changing it to 'Private' will make this device discoverable by other devices on this network."
				# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
				$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Change '$($interface.Name)' $($interface.InterfaceIndex) - $($interface.InterfaceAlias) network profile to 'Private', making it discoverable by other devices."
				$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not make changes to '$($interface.Name)' $($interface.InterfaceAlias) network profile, it will remain as '$($interface.NetworkCategory)'."
				$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
				[int]$DefaultChoice = 0 # First choice starts at zero
				$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
				switch ($Result) {
					0 {
						Write-Verbose "Changing '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Private'."
						
						#Set-NetConnectionProfile -InterfaceIndex $interface.InterfaceIndex -NetworkCategory 'Private' @CommonParameters
						$interface | Set-NetConnectionProfile -NetworkCategory 'Private' @CommonParameters
						
						Get-NetConnectionProfile | Where-Object {$_.InterfaceIndex -eq $interface.InterfaceIndex} | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table | Out-Host
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
} Else {
	Write-Host "Disabling Admin shares, no need to mess with network profiles.`nSKIPPING...`n"
	
	Write-Host "`n"
	Write-Warning "TODO - Give user the option to change network profile(s) back to Public. But keep the default option as No."
	Write-Host "`n"
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
If ($Disable) {$Verb2 = "Disable"} Else {$Verb2 = "Enable"}
$Step2 = "Step 2: $Verb2 ping response and `"File and print sharing`" through Windows Firewall."
#Write-Host "Step 2: Enable ping response and `"File and print sharing`" through Windows Firewall.`n" -BackgroundColor Black -ForegroundColor White
Write-Host $Step2 -BackgroundColor Black -ForegroundColor White
Write-Host ""

$PingParamsHash = @{
	ICMPv6 = $False
	NetBIOS = $True
}

#Get-PingResponseRules -ICMPv6 -NetBIOS -Table @CommonParameters
Get-PingResponseRules @PingParamsHash -Table @CommonParameters

Write-Verbose "Checking if ping/NetBIOS firewall rules are already allowed."
$FwRules = Get-PingResponseRules @PingParamsHash @CommonParameters
$RulesDisabled = $False
ForEach ($rule in $FwRules) {
	If ($rule.Enabled -eq 'False') {
		$RulesDisabled = $True
		# Default: No
	}
}

If (($RulesDisabled -And !$Disable) -Or (!$RulesDisabled -And $Disable)) {
	# Ask user to change ping response firewall rules.
	$Title = "$Verb2 ping response?"
	$Info = "$Verb2 firewall rules that Allow ping response (ICMPv4) and NetBIOS discovery on this machine: $env:COMPUTERNAME?"
	# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
	If ($PingParamsHash.ICMPv6 -And $PingParamsHash.NetBIOS) {
		$Targets = "IPv6 & NetBIOS"
	} ElseIf ($PingParamsHash.ICMPv6) {
		$Targets = "IPv6"
	} ElseIf ($PingParamsHash.NetBIOS) {
		$Targets = "NetBIOS"
	}
	$AdditionalParams = "IPv4"
	If ($Targets) {$AdditionalParams = "$AdditionalParams (as well as $Targets)"}
	$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "$Verb2 firewall rules that would Allow a $AdditionalParams ping response from this device: $env:COMPUTERNAME"
	$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not make any firewall rule changes."
	$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
	If ($Disable) {
		# Default: No
		[int]$DefaultChoice = 1 # First choice starts at zero
	} Else {
		# Default: Yes
		[int]$DefaultChoice = 0 # First choice starts at zero
	}
	$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
	switch ($Result) {
		0 {
			If ($Disable) {
				Write-Verbose "Disabling ping response:"
				Disable-PingResponse @PingParamsHash @CommonParameters
			} Else {
				Write-Verbose "Enabling ping response:"
				Enable-PingResponse @PingParamsHash @CommonParameters
			}
			
			Get-PingResponseRules @PingParamsHash -Table
		}
		1 {
			Write-Verbose "Declined firewall rules change for ping."
		}
		Default {
			Write-Error "Ping response choice error."
			Throw "Ping response choice error."
		}
	}
} Else {
	If (!$RulesDisabled -And !$Disable) {
		Write-Host "All ping firewall rules already enabled.`nSKIPPING...`n"
	} ElseIf ($RulesDisabled -And $Disable) {
		Write-Host "All ping firewall rules already disabled.`nSKIPPING...`n"
	}
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$Step3 = "Step 3: Ensure that both computers belong to the same Workgroup or Domain."
#Write-Host "Step 3: Ensure that both computers belong to the same Workgroup or Domain." -BackgroundColor Black -ForegroundColor White
Write-Host $Step3 -BackgroundColor Black -ForegroundColor White
Write-Host ""

# PartOfDomain (boolean Property)
$PartOfDomain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

If ($PartOfDomain) {
	Write-Host "This PC's domain/workgroup status:"
	Write-Host "DOMAIN:"
	$Domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Name, Domain
	$Domain | Format-Table | Out-Host
} Else {
	Write-Host "Note: Non-domain PC's should have the same Workgroup name set in order to network together.`n"
	Write-Host "This PC's domain/workgroup status:"
	# Workgroup (string Property)
	$Workgroup = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup
	Write-Host "WORKGROUP: `"$Workgroup`""
	Write-Host "`nTo check another PC's Workgroup name:"
	Write-Host " - Run (Win+R): sysdm.cpl"
	Write-Host " - Run (Win+R): SystemPropertiesComputerName"
	Write-Host " - ......  C:\> net config workstation | find `"Workstation domain`"`n"
}

If (!($Disable)) {
	# Ask user to change Workgroup
	$Title = "Change this PC's Workgroup?"
	$Info = "Change the current Workgroup name '$Workgroup' of this PC '$env:COMPUTERNAME' to something different (REQUIRES RESTART), or keep it as-is?"
	# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
	$Change = New-Object System.Management.Automation.Host.ChoiceDescription "&Change", "Change the current Workgroup name '$Workgroup' of this PC '$env:COMPUTERNAME' to something new. (REQUIRES RESTART)"
	$Keep = New-Object System.Management.Automation.Host.ChoiceDescription "&Keep The Same", "Keep the current Workgroup name '$Workgroup' the same. (Default)"
	$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Change, $Keep)
	[int]$DefaultChoice = 1 # First choice starts at zero
	$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
	switch ($Result) {
		0 {
			Write-Verbose "Changing Workgroup name."
			Write-Host "Ctrl+C to cancel."
			$NewWgName = Read-Host "New Workgroup name"
			Add-Computer -WorkGroupName $NewWgName @CommonParameters
			
			$Title = "Reboot PC now?"
			$Info = "Restart this PC '$env:COMPUTERNAME' now to update Workgroup name change '$NewWgName'?"
			# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
			$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes, reboot this machine now to apply Workgroup name change '$NewWgName'"
			$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No, reboot later."
			$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
			[int]$DefaultChoice = 1 # First choice starts at zero
			$Restart = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
			switch ($Restart) {
				0 {
					Write-Host "Rebooting in 10 seconds" -BackgroundColor Black -ForegroundColor White
					Write-Host "Ctrl+C to Cancel" -BackgroundColor Black -ForegroundColor White
					Start-Sleep -Seconds 10
					Restart-Computer @CommonParameters
				}
				1 {
					Write-Verbose "Reboot deferred."
					Write-Warning "If the Workgroup name was changed, this PC must be restarted for the changes to take effect."
				}
				Default {
					Write-Error "Reboot choice error."
					Throw "Workgroup choice error."
				}
			}
		}
		1 {
			Write-Verbose "Keeping Workgroup name: $Workgroup"
		}
		Default {
			Write-Error "Workgroup choice error."
			Throw "Workgroup choice error."
		}
	}
} Else {
	Write-Host "Disabling Admin shares, no need to change Workgroup.`nSKIPPING...`n"
}

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$Step4 = "Step 4: Update registry values"
#Write-Host "Step 4: Update registry values" -BackgroundColor Black -ForegroundColor White
Write-Host $Step4 -BackgroundColor Black -ForegroundColor White
Write-Host ""

Write-Verbose "Reg key 1: LanmanServer and AutoShareWks/AutoShareServer (auto-generate & publish Admin shares on reboot)"
# Check if Server OS:
$ServerOS = $False
$OSName = ((Get-CimInstance -ClassName CIM_OperatingSystem).Caption)
If ($OSName -like "*Server*") {
	$ServerOS = $True
}
Write-Verbose "Server OS detected: $ServerOS ('$OSName')"

# Set registry key path & name
#$KeyPath = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$KeyNameServer = "AutoShareServer"
$KeyNameDesktop = "AutoShareWks"
If ($ServerOS) {
	$KeyName = $KeyNameServer
	$WrongKeyName = $KeyNameDesktop
} Else {
	$KeyName = $KeyNameDesktop
	$WrongKeyName = $KeyNameServer
}
$BackupFolderName = "RegistryBackups"

# Check if registry key(s) exists:
Try {
	$KeyValue = Get-ItemProperty -Path $KeyPath -Name $KeyName -ErrorAction 'Stop'
} Catch {
	Write-Verbose "Registry key '$KeyName' does not exist."
	If ($KeyValue) {Remove-Variable -Name KeyValue -Force -ErrorAction 'SilentlyContinue'}
}
Try {
	$WrongKeyValue = Get-ItemProperty -Path $KeyPath -Name $WrongKeyName -ErrorAction 'Stop'
} Catch {
	Write-Verbose "Registry key '$WrongKeyName' does not exist."
	If ($WrongKeyValue) {Remove-Variable -Name WrongKeyValue -Force -ErrorAction 'SilentlyContinue'}
}

# Backup registry key path.
# First determine if any backups are necessary:
$BackupRegistry = $False

If ($ServerOS -And ($KeyValue.$KeyName -eq $KeyNameDesktop)) {$BackupRegistry = $True}
If (!$ServerOS -And ($KeyValue.$KeyName -eq $KeyNameServer)) {$BackupRegistry = $True}
# A registry key with value 0 is required to disable admin share creation on reboot.
# Either no key or a key with value 1 will enable it.
If ($Disable) {
	# A registry key with value 0 is required to disable admin share creation on reboot.
	If ($KeyValue) {
		Write-Verbose "Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'"
		If ($KeyValue.$KeyName -eq 1) {
			Write-Verbose "'$KeyName' is enabled."
			# Ask user to disable key
			$BackupRegistry = $True
		} Else {
			Write-Verbose "'$KeyName' is already disabled."
		}
	} Else {
		Write-Verbose "'$KeyName' doesn't exist, Admin shares are enabled."
		# Ask user to create it as disabled
		$BackupRegistry = $True
	}
} Else {
	# Either no key or a key with value 1 will enable it.
	If ($KeyValue) {
		Write-Verbose "Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'"
		If ($KeyValue.$KeyName -eq 0) {
			Write-Verbose "'$KeyName' is disabled."
			# Ask user to enable it or delete it.
			$BackupRegistry = $True
		} Else {
			Write-Verbose "'$KeyName' is already enabled."
			# Ask if user wants to delete it anyway.
			$BackupRegistry = $True
		}
	} Else {
		Write-Verbose "'$KeyName' doesn't exist, Admin shares are already enabled."
		# Ask if user wants to explicitly set it to enabled anyway.
		$BackupRegistry = $True
	}
}
If ($BackupRegistry) {
	# Backup registry key path.
	Backup-RegistryPath -KeyPath $KeyPath -KeyName $KeyName -BackupFolderName $BackupFolderName @CommonParameters
}

# Detect & delete non-necessary registry keys:
Write-Verbose "KeyValue = '$KeyValue'"
$RemoveKeyParams = @{
	KeyPath = $KeyPath
	ServerOS = $ServerOS
	OSName = $OSName
}
If ($ServerOS) {
	#Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyNameDesktop -Verbose
	Remove-RegistryKey -KeyName $KeyNameDesktop @RemoveKeyParams @CommonParameters
} Else {
	#Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyNameServer -Verbose
	Remove-RegistryKey -KeyName $KeyNameServer @RemoveKeyParams @CommonParameters
}
Write-Verbose "KeyValue = '$KeyValue'"

# Create/Enable/Disable/Delete registry key:

# A registry key with value 0 is required to disable admin share creation on reboot.
# Either no key or a key with value 1 will enable it.
If ($Disable) {
	# A registry key with value 0 is required to disable admin share creation on reboot.
	If ($KeyValue) {
		Write-Verbose "Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'"
		If ($KeyValue.$KeyName -eq 1) {
			Write-Verbose "'$KeyName' is enabled."
			# Ask user to disable key
			
			# Ask user to disable registry key.
			Write-Warning "'$KeyName' is enabled."
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($KeyValue.$KeyName) (True)"
			}
			Write-Host "`nRegistry path:`n$KeyPath\`nKey:$KeyName"
			$DisplayTable | Format-Table | Out-Host
			Write-Host "`nIn order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n"
			Write-Warning "After a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.`n"
			# Ask user to either disable or delete registry key
			$Title = "Disable registry key?"
			$Info = "Change the value of '$KeyName' to 0 to disable Admin shares?"
			# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
			$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes, disable the '$KeyName' registry key by changing it to 0 (currently is $($KeyValue.$KeyName)), which will disable Windows Admin share generation on boot."
			$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No, do not make any changes to the registry."
			$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
			[int]$DefaultChoice = 0 # First choice starts at zero
			$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
			switch ($Result) {
				0 {
					Write-Verbose "Changing '$KeyName' reg key to 0 (disabled)."
					
					#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 0
					Set-ItemProperty -Path $KeyPath -Name $KeyName -Value 0
				}
				1 {
					Write-Verbose "Keeping registry key the same: '$KeyName' ($($KeyValue.$KeyName))"
				}
				Default {
					Write-Error "Disable registry key choice error."
					Throw "Disable registry key choice error."
				}
			}
			
		} Else {
			Write-Verbose "'$KeyName' is already disabled."
			
			Write-Verbose "Registry key '$KeyName' is already set to $($KeyValue.$KeyName) (disabled).`nSKIPPING...`n"
		}
	} Else {
		Write-Verbose "'$KeyName' doesn't exist, Admin shares are enabled."
		# Ask user to create it as disabled
		
		# Ask user to create registry key as disabled.
		Write-Warning "Key '$KeyName' does not exist."
		Write-Host "`nIn order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n"
		Write-Warning "After a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.`n"
		
		#$null = New-ItemProperty -Path $KeyPath -Name $KeyName -Type DWORD -Value 1
		New-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -NewValue 0
	}
} Else {
	# Either no key or a key with value 1 will enable it.
	
	If ($KeyValue) {
		Write-Verbose "Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'"
		If ($KeyValue.$KeyName -eq 0) {
			Write-Verbose "'$KeyName' is disabled."
			# Ask user to enable it or delete it.
			
			# Ask user to enable or delete registry key.
			Write-Warning "'$KeyName' is disabled."
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($KeyValue.$KeyName) (False)"
			}
			Write-Host "`nRegistry path:`n$KeyPath\`nKey:$KeyName"
			$DisplayTable | Format-Table | Out-Host
			Write-Host "`nFor Windows 10 to automatically create & publish administrative shares after a reboot, the registry key '$KeyPath' needs a Dword parameter either named '$KeyName' with the value 1 (enabled), or for that parameter to be deleted completely. Currently '$KeyName' is set as $($KeyValue.$KeyName) (disabled).`n"
			# Ask user to either disable or delete registry key
			$Title = "Enable or delete the registry key?"
			$Info = "Change the value of '$KeyName' to 1 (enabled) or delete it completely to enable Admin shares?"
			# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
			$Enable = New-Object System.Management.Automation.Host.ChoiceDescription "&Enable", "Enable, change the '$KeyName' registry key to value 1 (enabled). This enables Admin share creation after reboots."
			$Delete = New-Object System.Management.Automation.Host.ChoiceDescription "&Delete", "Delete the '$KeyName' registry key. This enables Admin share creation after reboots."
			$Cancel = New-Object System.Management.Automation.Host.ChoiceDescription "&Cancel", "Cancel, do not make any changes to the registry."
			$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Enable, $Delete, $Cancel)
			[int]$DefaultChoice = 0 # First choice starts at zero
			$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
			switch ($Result) {
				0 {
					Write-Verbose "Changing '$KeyName' reg key from $($KeyValue.$KeyName) (disabled) to 1 (enabled)."
					
					#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1
					Set-ItemProperty -Path $KeyPath -Name $KeyName -Value 1
				}
				1 {
					Write-Verbose "Deleting registry key: '$KeyName'"
					
					#Remove-ItemProperty -Path $KeyPath -Name $KeyName -Verbose
					Remove-ItemProperty -Path $KeyPath -Name $KeyName @CommonParameters
					#Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -ServerOS $ServerOS -OSName $OSName @CommonParameters
				}
				2 {
					Write-Verbose "Keeping registry key the same: '$KeyName' ($($KeyValue.$KeyName))"
				}
				Default {
					Write-Error "Disable registry key choice error."
					Throw "Disable registry key choice error."
				}
			}
			
		} Else {
			Write-Verbose "'$KeyName' is already enabled."
			# Ask if user wants to delete it anyway.
			
			# Either deleting or enabling (1) this registry key will turn the Admin shares feature back on. User wants it on and it's already on (1), so we can leave the reg key as-is. But deleting it would also work.
			Write-Host "Registry key '$KeyName' is already enabled ($($KeyValue.$KeyName)). Windows will already automatically publish Administrative shares when this key is set to 1, or is deleted. No registry changes are necessary, but it can also be deleted for the same effect."
			
			#Remove-ItemProperty -Path $KeyPath -Name $KeyName -Verbose
			#Remove-ItemProperty -Path $KeyPath -Name $KeyName @CommonParameters
			Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyNameDesktop -OptionalRemoval @CommonParameters
		}
	} Else {
		Write-Verbose "'$KeyName' doesn't exist, Admin shares are already enabled."
		# Ask if user wants to explicitly set it to enabled anyway.
		
		# Ask user to create registry key as enabled.
		Write-Host "Registry key '$KeyName' already doesn't exist. Windows will automatically publish Administrative shares. No registry changes are necessary, but this key can still be created as enabled if desired.`n"
		
		#$null = New-ItemProperty -Path $KeyPath -Name $KeyName -Type DWORD -Value 1
		New-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -NewValue 1
	}
}

#- -- - - - - - - - - -- - - - - - - - - - - - - - -- 

Write-Host "Tests completed."
Pause
Return

Write-Verbose "Reg key 2: LocalAccountTokenFilterPolicy (disable Remote UAC)"

<#
http://woshub.com/enable-remote-access-to-admin-shares-in-workgroup/
Enable Remote Access to Admin Shares on Windows 10 using LocalAccountTokenFilterPolicy

There is one important issue when working with Windows admin shared folders on a computer that is not joined to an Active Directory domain (part of a workgroup). Windows 10, by default, restricts remote access to administrative shares to a user who is a member of the local Administrators group. The remote access available only under the built-in local Administrator account (it is disabled by default).

Here is what the problem looks like in detail. I’m trying to remotely access the built-in admin shares on a computer running Windows 10 that is a member of a workgroup (with the firewall turned off) as follows:

    \\w10_pc\C$
    \\w10_pc\D$
    \\w10_pc\IPC$
    \\w10_pc\Admin$

In the authorization window, I specify the credentials of an account that is a member of the local Administrators group on Windows 10, and get an “Access is denied” error. At the same time, I can access all network shares and shared printers on Windows 10 (the computer is not hidden in Network Neighborhood). Also, I can access administrative shares under the built-in Administrator account. If this computer is joined to an Active Directory domain, the access to the admin shares from domain accounts with administrative privileges is not blocked.

Can't access ADMIN$ share remotely under admin accounts

The point is in another aspect of security policy that appeared in the UAC – so called Remote UAC (User Account Control for remote connections) that filters the tokens of local and Microsoft accounts and blocks remote access to admin shares under such accounts. When accessing under the domain accounts, this restriction is not applied.

You can disable Remote UAC by creating the LocalAccountTokenFilterPolicy parameter in the registry

Tip. It will slightly reduce the Windows security level.
#>












Write-Verbose "Restarting LanmanServer service..."
Get-Service LanmanServer @CommonParameters | Restart-Service @CommonParameters

#- -- - - - - - - - - -- - - - - - - - - - - - - - -- 

Write-Host "Tests completed."
Pause
Return

Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$Step5 = "Step 5: Specify which user(s) can access the Admin Shares (Disk Volumes)."
#Write-Host "Step 5: Specify which user(s) can access the Admin Shares (Disk Volumes)." -BackgroundColor Black -ForegroundColor White
Write-Host $Step5 -BackgroundColor Black -ForegroundColor White
Write-Host ""

Write-Host "Users in Administrators group:"
$AdminGroupMembers = Get-LocalGroupMember -Group "Administrators" @CommonParameters
$AdminGroupMembers | Select-Object -Property Name, ObjectClass, PrincipalSource | Format-Table | Out-Host

Write-Host "`n"
Write-Warning "TODO - Check if current user name is in the Admin group of the local machine."
Write-Host "`n"



#New-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Type DWORD -Value 0
#You can deploy this registry parameter to all domain computers through a GPO.

# Now, after a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.

# If you want to enable admin shares on Windows, you need to change the parameter value to 1 or delete it:

#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1 @CommonParameters

# To have Windows recreate the hidden admin shares, simply restart the Server service with the command:

#Get-Service LanmanServer @CommonParameters | Restart-Service -Verbose @CommonParameters



Write-Host "-----------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$EndOfSteps = "End of Steps: Admin shares on this PC ($env:COMPUTERNAME) should now be active."
#Write-Host "End of Steps: Admin shares on this PC ($env:COMPUTERNAME) should now be active." -BackgroundColor Black -ForegroundColor White
Write-Host $EndOfSteps -BackgroundColor Black -ForegroundColor White
Write-Host ""

Write-Host "Current network shares:" -BackgroundColor Black -ForegroundColor White
Write-Host "C:\> net share"
net share

If ($Disable) {
	Write-Host "Admin shares should be disabled on this machine now." -BackgroundColor Black -ForegroundColor Yellow
} Else {
	Write-Host "`nTry accessing a share from another PC, e.g.:" -BackgroundColor Black -ForegroundColor Yellow
	Write-Host " - \\$env:COMPUTERNAME\C$" -BackgroundColor Black -ForegroundColor Yellow
	
	$NetProfiles = Get-NetConnectionProfile
	$IpAddresses = Get-NetIPAddress
	$ValidIPs = @()
	
	ForEach ($IP in $IpAddresses) {
		ForEach ($InterfId in $NetProfiles) {
			If ($IP.InterfaceIndex -eq $InterfId.InterfaceIndex) {
				$ValidIPs += $IP
			}
		}
	}
	
	ForEach ($IP in $ValidIPs) {
		If ($IP.IPAddress -like "169.254.*") {
			Write-Host " - \\$($IP.IPAddress)\C$ - (DHCP error: Unassigned APIPA network address in use.)" -BackgroundColor Black -ForegroundColor Red
		} Else {
			Write-Host " - \\$($IP.IPAddress)\C$" -BackgroundColor Black -ForegroundColor Yellow
		}
	}
}

Write-Host "`n`n`n"

Pause


