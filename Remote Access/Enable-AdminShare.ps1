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
	Single-line summary.
	.DESCRIPTION
	Multiple paragraphs describing in more detail what the function is, what it does, how it works, inputs it expects, and outputs it creates.
	.NOTES
	Some extra info about this function, like it's origins, what module (if any) it's apart of, and where it's from.
	
	Maybe some original author credits as well.
	
	Function New-TaskTrackingInitiative is where this template is based from.
	
	.PARAMETER WhatIf
	.PARAMETER Confirm
	.EXAMPLE
	Enable-PingResponse -WhatIf -Confirm
	#>
	[Alias("New-ProjectInitTEST")]
	#Requires -Version 3
	#[CmdletBinding()]
	[CmdletBinding(DefaultParameterSetName = 'None')]
	Param(
		[Alias('PingV6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS
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
	
	$PingFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	
	$Profiles = @('Domain','Private')
	
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
					If ($_.Name -like "4") {
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
	
	$PingFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	
	$PingV6FirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	
	
	
	
	<#
Name                  : CoreNet-Diag-ICMP4-EchoRequest-In
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv4-In)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP4-EchoRequest-Out
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv4-Out)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP6-EchoRequest-In
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv6-In)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP6-EchoRequest-Out
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv6-Out)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP4-EchoRequest-In-NoScope
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv4-In)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP4-EchoRequest-Out-NoScope
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv4-Out)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP6-EchoRequest-In-NoScope
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv6-In)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : CoreNet-Diag-ICMP6-EchoRequest-Out-NoScope
DisplayName           : Core Networking Diagnostics - ICMP Echo Request (ICMPv6-Out)
Description           : ICMP Echo Request messages are sent as ping requests to other nodes.
DisplayGroup          : Core Networking Diagnostics
Group                 : @FirewallAPI.dll,-27000
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

#>
	
	
	
	
	
	
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
	
	$Profiles = @('Domain','Private')
	
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
	
	$NetBiosFirewallRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
	
	
	
	<#
Name                  : NETDIS-NB_Name-In-UDP-NoScope
DisplayName           : Network Discovery (NB-Name-In)
Description           : Inbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : NETDIS-NB_Name-Out-UDP-NoScope
DisplayName           : Network Discovery (NB-Name-Out)
Description           : Outbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

	
	
	
Name                  : NETDIS-NB_Name-In-UDP-Active
DisplayName           : Network Discovery (NB-Name-In)
Description           : Inbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : True
Profile               : Private
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : NETDIS-NB_Name-Out-UDP-Active
DisplayName           : Network Discovery (NB-Name-Out)
Description           : Outbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : True
Profile               : Private
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local
	
	
Name                  : NETDIS-NB_Name-In-UDP
DisplayName           : Network Discovery (NB-Name-In)
Description           : Inbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : False
Profile               : Public
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : NETDIS-NB_Name-Out-UDP
DisplayName           : Network Discovery (NB-Name-Out)
Description           : Outbound rule for Network Discovery to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : Network Discovery
Group                 : @FirewallAPI.dll,-32752
Enabled               : False
Profile               : Public
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

	
Name                  : FPS-NB_Name-In-UDP-NoScope
DisplayName           : File and Printer Sharing (NB-Name-In)
Description           : Inbound rule for File and Printer Sharing to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : File and Printer Sharing
Group                 : @FirewallAPI.dll,-28502
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : FPS-NB_Name-Out-UDP-NoScope
DisplayName           : File and Printer Sharing (NB-Name-Out)
Description           : Outbound rule for File and Printer Sharing to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : File and Printer Sharing
Group                 : @FirewallAPI.dll,-28502
Enabled               : False
Profile               : Domain
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local
	
	
Name                  : FPS-NB_Name-In-UDP
DisplayName           : File and Printer Sharing (NB-Name-In)
Description           : Inbound rule for File and Printer Sharing to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : File and Printer Sharing
Group                 : @FirewallAPI.dll,-28502
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Inbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local

Name                  : FPS-NB_Name-Out-UDP
DisplayName           : File and Printer Sharing (NB-Name-Out)
Description           : Outbound rule for File and Printer Sharing to allow NetBIOS Name Resolution. [UDP 137]
DisplayGroup          : File and Printer Sharing
Group                 : @FirewallAPI.dll,-28502
Enabled               : False
Profile               : Private, Public
Platform              : {}
Direction             : Outbound
Action                : Allow
EdgeTraversalPolicy   : Block
LooseSourceMapping    : False
LocalOnlyMapping      : False
Owner                 :
PrimaryStatus         : OK
Status                : The rule was parsed successfully from the store. (65536)
EnforcementStatus     : NotApplicable
PolicyStoreSource     : PersistentStore
PolicyStoreSourceType : Local
	
	#>
	
	
	
	
	
	If (!($ICMPv6)) {
		$PingFirewallRule += $PingV6FirewallRule
	}
	If (!($NetBIOS)) {
		$PingFirewallRule += $NetBiosFirewallRule
	}
	
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Enable-PingResponse function.
Set-Alias -Name 'New-ProjectInitTEST' -Value 'Enable-PingResponse'
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


