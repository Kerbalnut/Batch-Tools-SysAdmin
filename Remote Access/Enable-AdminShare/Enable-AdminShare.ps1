<#
.SYNOPSIS
Enable Administrative share on the local computer.
.DESCRIPTION
Turns on the default admin share(s) e.g. \\hostname\C$\ on this computer, so the filesystem can be accessed from a remote computer. Runs a series of steps that collectively ensure this computer's Admin shares will be accessible, but not every step is related or necessary. This script is interactive, the user will be prompted to run each step or not. 

Only one of these steps may actually be required to get Admin shares on this PC accessible. And vice versa, not every step is required to disable Admin shares, however when the -Disable switch is used the user will still be prompted to reverse every change this script can make.

Warning: This script can make changes to the Registry and Windows Firewall rules. You will be prompted to make backups first when appropriate.
.PARAMETER Disable
Runs the same series of actions that this script would normally run, but in reverse. User will still be prompted whether to run each step or not. Usually default choices are appropriate.
.PARAMETER LoadFunctions
Only loads the functions this script contains into whatever scope it was called from. None of the other actions in this script will be performed.
.PARAMETER LoadAllFunctions
Even loads functions with context-specific text that wouldn't make much sense in other situations.
.NOTES
Disclaimers:
Keep in mind this script isn't guaranteed to always enable access to Admin shares on 100% of networks either. There's countless other things in networking that can prevent this, from client isolation tactics, different VLANs, down to individual port blocking for something like NetBIOS/SMB etc. on the network, that can prevent Admin shares from working.

Another thing that could prevent Admin shares from working is any custom Windows Firewall rules. This script will check & modify firewall rules based on a built-in, static list of fw rule names. So if a custom Block firewall rule somehow got created, this script will not detect it, and will not change it. This could be added in the future if there's interest, please see the github link below for contribution options, like creating a new issue or pull request!

Warning: Most of these steps will lower the security of your system in some way. Some have negligible effect (like enabling IPv4 ping response), and some can be serious security risks (like opening firewall rules that can also apply to Public networks). Improper registry edits can also cause system instability etc. The user will be warned and prompted to make backups in most of these situations, but even still use this script at your own risk.

Check out the source code for updates to this script:
https://github.com/Kerbalnut/Batch-Tools-SysAdmin

TODO:
X Finish adding redirection to Write-LogFile for all messages.
- Add option to backup firewall rules before change.
- Add option to change relevant firewall rules that apply to both "Private, Public" profiles, to only apply to "Private" network profiles for better security.
- Add check for custom block firewall rules.
- Further testing all the way through the script after these changes have been made.
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
	[switch]$LoadAllFunctions,
	
	[string]$LogFilePath,
	
	[switch]$CsvLog = $True
	#[switch]$CsvLog
	
)
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
$CommonParameters = @{
	Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
	Debug = [System.Management.Automation.ActionPreference]$DebugPreference
}
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#-----------------------------------------------------------------------------------------------------------------------
Function Write-LogFile {
	<#
	.SYNOPSIS
	Adds a time-stamped message to a log file, and passes the message text on down the pipeline to be output using other methods.
	.DESCRIPTION
	For example, to make a message both get written to the log file and be output to the terminal using Write-Host on one line:
	
	"Hello World" | Write-LogFile | Write-Host
	
	Or, using other output options:
	
	"Hello World" | Write-LogFile | Write-Verbose
	"Hello World" | Write-LogFile | Write-Debug
	"Hello World" | Write-LogFile | Write-Warning
	"Hello World" | Write-LogFile | Write-Error
	
	Caution: This function will always return the text string input down the pipeline, meaning even if Write-Host is omitted the text will still be printed to the terminal. These 2 commands are essentially the same: 
	
	"Hello World" | Write-LogFile
	"Hello World" | Write-LogFile | Write-Host
	
	To silence the terminal output and only write the message to the log file, pipe output into Out-Null:
	
	"Hello World" | Write-LogFile | Out-Null
	
	Log messages can also be tagged the same ways as the different PowerShell output streams:
	
	"Hello World" | Write-LogFile -VerboseMsg | Write-Verbose
	"Hello World" | Write-LogFile -DebugMsg | Write-Debug
	"Hello World" | Write-LogFile -WarningMsg | Write-Warning
	"Hello World" | Write-LogFile -ErrorMsg | Write-Error
	
	Caution: The -Path parameter is required, but if the $Global:WriteLogFilePath global var is used it can be omitted. See Path param for more info.
	.PARAMETER Path
	Path of log file to update. This is a required parameter.
	
	E.g. "C:\foo bar\file.log"
	
	For example, using a code block like below will set-up a $LogFilePath var with the same name as the executing script, and in the current path:
	
	$ScriptName = $MyInvocation.MyCommand
	$FileExtension = [System.IO.Path]::GetExtension($ScriptName)
	$FileNameWithoutExention = $ScriptName -replace "\$FileExtension$",""
	$LogFilePath = Join-Path -Path (Get-Location) -ChildPath "$FileNameWithoutExention.log"

	Then, log messages can be written like below:
	
	"Hello World" | Write-LogFile -Path $LogFilePath | Write-Host
	
	To omit having to type out the -Path $LogFilePath parameter, a global var can be set that this function will use automatically, for example:
	
	$Global:WriteLogFilePath = "C:\foo bar\file.log"
	- or
	$Global:WriteLogFilePath = $LogFilePath
	- or
	Write-LogFile -SetGlobalLogPath $LogFilePath
	
	Then, logging can be simplified to: 
	
	"Hello World" | Write-LogFile | Write-Host
	- or
	"Hello World" | Write-LogFile
	
	To remove the global var after you're done:
	Remove-Variable -Name WriteLogFilePath -Scope Global
	
	Note: If the -Path parameter is explicitly set, it will take preference over the $Global:WriteLogFilePath var. To target the log file path store in $Global:WriteLogFilePath, leave -Path parameter blank.
	
	See also:
	-SetGlobalLogPath
	-GetGlobalLogPath
	-RemoveGlobalLogPath
	.PARAMETER VerboseMsg
	Adds a prefix of 'VERBOSE:' to the log message. Only one prefix tag should be used at a time.
	.PARAMETER DebugMsg
	Adds a prefix of 'DEBUG:' to the log message. Only one prefix tag should be used at a time.
	.PARAMETER WarningMsg
	Adds a prefix of 'WARNING:' to the log message. Only one prefix tag should be used at a time.
	.PARAMETER ErrorMsg
	Adds a prefix of 'ERROR:' to the log message. Only one prefix tag should be used at a time.
	.PARAMETER Csv
	Creates a .csv log instead, for easier filtering.
	.PARAMETER SetGlobalLogPath
	Sets the $Global:WriteLogFilePath var. This must be a valid path to a log file.
	
	When the $Global:WriteLogFilePath var is set, this function will use it as a value for the -Path param, allowing you omit that parameter and still target the same log file.
	.PARAMETER GetGlobalLogPath
	If the $Global:WriteLogFilePath var is set, will print it's value.
	.PARAMETER RemoveGlobalLogPath
	Removes the $Global:WriteLogFilePath var.
	
	Remove-Variable -Name WriteLogFilePath -Scope Global -Force
	.NOTES
	This function is very similar to Tee-Object. However this function is much more focused on log file generation, with automatic timestamping and PowerShell-themed tagging. Use Tee-Object for more general output splitting to a file.
	.LINK
	Tee-Object
	.EXAMPLE
	Write-LogFile
	#>
	[CmdletBinding(DefaultParameterSetName = '12hour')]
	Param(
		[Parameter(Position = 0, ValueFromPipelineByPropertyName = $True, ParameterSetName = '12hour')]
		[Parameter(Position = 0, ValueFromPipelineByPropertyName = $True, ParameterSetName = '24hour')]
		[String]$Path,
		
		[Parameter(
			Mandatory = $True, 
			Position = 1, 
			ValueFromPipeline = $True, 
			ValueFromPipelineByPropertyName = $True,
			ParameterSetName = '12hour'
		)]
		[Parameter(
			Mandatory = $True, 
			Position = 1, 
			ValueFromPipeline = $True, 
			ValueFromPipelineByPropertyName = $True,
			ParameterSetName = '24hour'
		)]
		[String]$Message,
		
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$VerboseMsg,
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$DebugMsg,
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$WarningMsg,
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$ErrorMsg,
		
		[Parameter(ParameterSetName = '12hour')]
		[Switch]$12hour,
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$24hour,
		
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[Switch]$Csv,
		
		[Parameter(ParameterSetName = '12hour')]
		[Parameter(ParameterSetName = '24hour')]
		[ValidateSet('','SilentlyContinue','Continue','Stop')]
		[String]$ErrorActionStr = 'Stop',
		
		[Parameter(Mandatory = $True, ParameterSetName = 'SetGlobal')]
		[String]$SetGlobalLogPath,
		
		[Parameter(Mandatory = $True, ParameterSetName = 'GetGlobal')]
		[Switch]$GetGlobalLogPath,
		
		[Parameter(Mandatory = $True, ParameterSetName = 'RemoveGlobal')]
		[Switch]$RemoveGlobalLogPath
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	#Write-Verbose "Starting $($MyInvocation.MyCommand)"
	
	# Set default behavior:
	
	If (!$12hour -And !$24hour) {
		$12hour = $True
		#$24hour = $True
	}
	
	#$Csv = $True
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Set/Get/Delete global var:
	
	If ($SetGlobalLogPath) {
		If ($Global:WriteLogFilePath) {
			Remove-Variable -Name WriteLogFilePath -Scope Global
		}
		$Global:WriteLogFilePath = $SetGlobalLogPath
		Return
	}
	
	If ($GetGlobalLogPath) {
		If ($Global:WriteLogFilePath) {
			Write-Host "`$Global:WriteLogFilePath = '$Global:WriteLogFilePath'"
		}
		Return
	}
	
	If ($RemoveGlobalLogPath) {
		If ($Global:WriteLogFilePath) {
			Try {
				Remove-Variable -Name WriteLogFilePath -Scope Global
			} Catch {
				Start-Sleep -Milliseconds 20
				Remove-Variable -Name WriteLogFilePath -Scope Global -Force
			}
		}
		Start-Sleep -Milliseconds 20
		If ($Global:WriteLogFilePath) {
			Remove-Variable -Name WriteLogFilePath -Scope Global -Force
		}
		Return
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Check if a global var exists:
	
	If ($Global:WriteLogFilePath) {
		If ($Global:WriteLogFilePath -eq '' -Or $null -eq $Global:WriteLogFilePath) {
			Write-Warning "Global var exists, but is blank or null!"
			Write-Host "The var is not usable in this state. Clean it up now?"
			Do {
				$UserInput = Read-Host "Delete empty var? [Y/N]"
			} Until ($UserInput -eq 'Y' -Or $UserInput -eq 'N')
			If ($UserInput -eq 'Y') {
				Remove-Variable -Name WriteLogFilePath -Scope Global
			}
		} Else {
			#Write-Host "Global var is: $Global:WriteLogFilePath"
			If (!$Path) {
				$Path = $Global:WriteLogFilePath
			}
		}
	}
	
	If (!$Path -Or $Path -eq '' -Or $null -eq $Path) {
		Write-Error "Invalid path. Path is blank/null/empty."
		Throw "Invalid path. Path is blank/null/empty."
	}
	
	# Force Csv mode if swtich/file extension is used:
	
	$FileExtension = [System.IO.Path]::GetExtension($Path)
	If ($Csv) {
		$FileExtension = [System.IO.Path]::GetExtension($Path)
		If ($FileExtension) {
			$FilePathWithoutExention = $Path -replace "\$FileExtension$",""
		} Else {
			$FilePathWithoutExention = $Path
		}
		$Path = "$FilePathWithoutExention.csv"
	} Else {
		If ($FileExtension -eq '.csv') {
			$Csv = $True
		}
	}
	
	# Check that path to log file exists:
	
	$ParentFolder = Split-Path -Path $Path -Parent
	If (!(Test-Path -Path $ParentFolder)) {
		Write-Verbose "Log file folder path does not exist, creating folder"
		Try {
			mkdir $ParentFolder
		} Catch {
			If ($ErrorActionStr -eq 'SilentlyContiue' -Or $ErrorActionStr -eq '') {
				Write-Warning "Could not create folder for log file: `"$ParentFolder`""
			} ElseIf ($ErrorActionStr -eq 'Continue' -Or $ErrorActionStr -eq 'Stop') {
				Write-Error "Could not create folder for log file: `"$ParentFolder`""
				If ($ErrorActionStr -eq 'Stop') {
					Throw "Could not create folder for log file: `"$ParentFolder`""
				}
			}
		}
	}
	
	# Create log file if it does not already exist.
	
	If (!(Test-Path -Path $Path)) {
		Write-Verbose "Log file does not exist, creating log file"
		Try {
			New-Item -Path $Path -ItemType File
		} Catch {
			If ($ErrorActionStr -eq 'SilentlyContiue' -Or $ErrorActionStr -eq '') {
				Write-Warning "Could not create log file: `"$Path`""
			} ElseIf ($ErrorActionStr -eq 'Continue' -Or $ErrorActionStr -eq 'Stop') {
				Write-Error "Could not create log file: `"$Path`""
				If ($ErrorActionStr -eq 'Stop') {
					Throw "Could not create log file: `"$Path`""
				}
			}
		}
	}
	
	# Get date string
	
	If ($12hour) {
		$DateStr = Get-Date -UFormat '%Y/%m/%d %r'
	} ElseIf ($24hour) {
		$DateStr = Get-Date -UFormat '%Y/%m/%d %T'
	}
	If (!$DateStr) {
		$DateStr = Get-Date -UFormat '%Y/%m/%d %T'
	}
	
	# Add message tags
	
	If ($VerboseMsg) {
		$PrefixStr = 'VERBOSE: '
	} ElseIf ($DebugMsg) {
		$PrefixStr = 'DEBUG: '
	} ElseIf ($WarningMsg) {
		$PrefixStr = 'WARNING: '
	} ElseIf ($ErrorMsg) {
		$PrefixStr = 'ERROR: '
	}
	
	# Append line to file
	
	If ($Csv) {
		$LogMessage = "$DateStr,$PrefixStr,`"$Message`""
	} Else {
		$LogMessage = $DateStr + " " + $PrefixStr + $Message
	}
	Add-Content -Path $Path -Value $LogMessage
	
	# Return input back down the pipeline
	
	Return $Message
	
} # End of Write-LogFile function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Get-SmbFwRules {
	<#
	.SYNOPSIS
	Returns a list of firewall rules relevant to Admin share (SMB) remote access.
	.DESCRIPTION
	Can also get ping (IPv4/IPv6), NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules, SMB, and all additional File and Printer Sharing rules meeting a certain search criteria. Which rule sets depend on which switches are used. 
	
	At least one switch is required to produce output.
	
	Use the -ShowTable switch for formatted output.
	.PARAMETER ICMPv4
	Include IPv4 ICMP ping firewall rules in results.
	.PARAMETER ICMPv6
	Include IPv6 ICMP ping firewall rules in results.
	.PARAMETER NetBIOS
	Include NetBIOS-based Network Discovery & File and Printer Sharing firewall rules in results.
	.PARAMETER SMB
	Include SMB-based (Server Message Block) File and Printer Sharing firewall rules in results.
	.PARAMETER FpsRules
	Include a specific list of File & Printer Sharing firewall rules used for enabling access to Admin shares.
	.PARAMETER AllFilePrinterSharingRules
	Includes every firewall rule in the Display Group "File And Printer Sharing" that are set to Allow traffic, in either In/Out dierection.
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
	.PARAMETER ShowTable
	Formats output as a table instead of passing it down the pipeline, for easy viewing.
	.NOTES
	Thanks to StackOverflow user for the set of firewall rules that finally fixed a tricky one for me:
	https://serverfault.com/questions/516920/enable-file-and-print-sharing-command-line-how-to-enable-it-just-for-profile-p
	https://serverfault.com/a/968310
	.LINK
	Get-SmbFwRules
	Set-SmbFwRules
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Get-SmbFwRules -IPv4 -IPv6 -NetBIOS -ShowTable
	#>
	[CmdletBinding()]
	Param(
		[Alias('PingV4','IPv4','v4')]
		[switch]$ICMPv4,
		
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[switch]$SMB,
		
		[switch]$FpsRules,
		
		[switch]$AllFilePrinterSharingRules,
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[Alias('FormatTable','Table')]
		[switch]$ShowTable
		
	)
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	$CommonParameters = @{
		Verbose = [System.Management.Automation.ActionPreference]$VerbosePreference
		Debug = [System.Management.Automation.ActionPreference]$DebugPreference
	}
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	Write-Verbose "Starting $($MyInvocation.MyCommand)"
	
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
	
	If ($ICMPv4 -Or $ICMPv6) {
		
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
		
	} # End If ($ICMPv4 -Or $ICMPv6)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
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
	
	If ($NetBIOS) {
		
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
		
	} # End If ($NetBIOS)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$SmbFirewallRuleNames = @(
		"FPS-SMB-In-TCP-NoScope",
		"FPS-SMB-Out-TCP-NoScope",
		"FPS-SMB-In-TCP",
		"FPS-SMB-Out-TCP"
	)
	
	If ($SMB) {
		
		$SmbFwRule = @()
		
		Get-NetFirewallRule -DisplayGroup "File And Printer Sharing" | ForEach-Object {
			ForEach ($Name in $SmbFirewallRuleNames) {
				If ($_.Name -eq $Name) {
				#If ($_.Name -like "*SMB*") {
					$SmbFwRule += $_
				}
			}
		}
		
		# $SmbFwRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		
		$Orig = $SmbFwRule
		$SmbFwRule = @()
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
				$SmbFwRule += $_
			}
		}
		
		If ($VerbosePreference -ne 'SilentlyContinue' -And $SMB) {
			Write-Host "SMB File and Printer Sharing firewall rules:"
			$SmbFwRule | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		}
		
	} # End If ($SMB)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	$FpsFirewallNames = @(
		"File and Printer Sharing (Echo Request - ICMPv4-In)",
		"File and Printer Sharing (Echo Request - ICMPv6-In)",
		"File and Printer Sharing (LLMNR-UDP-In)",
		"File and Printer Sharing (NB-Datagram-In)",
		"File and Printer Sharing (NB-Name-In)",
		"File and Printer Sharing (SMB-In)",
		"File and Printer Sharing (Spooler Service - RPC)",
		"File and Printer Sharing (Spooler Service - RPC-EPMAP)",
		"File and Printer Sharing (NB-Session-In)"
	)
	
	If ($FpsRules) {
		
		$FpsFwRules = @()
		
		Get-NetFirewallRule -DisplayGroup "File And Printer Sharing" | ForEach-Object {
			ForEach ($Name in $FpsFirewallNames) {
				If ($_.DisplayName -eq $Name) {
					$FpsFwRules += $_
				}
			}
		}
		
		# $FpsFwRules | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		
		$Orig = $FpsFwRules
		$FpsFwRules = @()
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
				$FpsFwRules += $_
			}
		}
		
		If ($VerbosePreference -ne 'SilentlyContinue' -And $FpsRules) {
			Write-Host "File and Printer Sharing firewall rules:"
			$FpsFwRules | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		}
		
	} # End If ($FpsRules)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	If ($AllFilePrinterSharingRules) {
		
		$AllFilePrinterSharingFwRules = @()
		
		Get-NetFirewallRule -DisplayGroup "File And Printer Sharing" | ForEach-Object {
			$AllFilePrinterSharingFwRules += $_
		}
		
		# $AllFilePrinterSharingFwRules | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		
		$Orig = $AllFilePrinterSharingFwRules
		$AllFilePrinterSharingFwRules = @()
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
				$AllFilePrinterSharingFwRules += $_
			}
		}
		
		If ($VerbosePreference -ne 'SilentlyContinue' -And $AllFilePrinterSharingRules) {
			Write-Host "SMB File and Printer Sharing firewall rules:"
			$AllFilePrinterSharingFwRules | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		}
		
	} # End If ($AllFilePrinterSharingRules)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	# Combine selected sets of firewall rules into one output:
	
	$OutputRules = @()
	
	If ($ICMPv4) {
		$OutputRules += $PingFirewallRule
	}
	
	If ($ICMPv6) {
		$OutputRules += $PingV6FirewallRule
	}
	
	If ($NetBIOS) {
		If ($OutputRules) {
			ForEach ($CheckRule in $NetBiosFirewallRule) {
				$AddRule = $True
				ForEach ($SetRule in $OutputRules) {
					If (
						#$SetRule.Name -eq $CheckRule.Name -And `
						$SetRule.CommonName -eq $CheckRule.CommonName -And `
						#$SetRule.DisplayName -eq $CheckRule.DisplayName -And `
						$SetRule.Description -eq $CheckRule.Description -And `
						$SetRule.DisplayGroup -eq $CheckRule.DisplayGroup -And `
						$SetRule.InstanceID -eq $CheckRule.InstanceID -And `
						$SetRule.PolicyRuleName -eq $CheckRule.PolicyRuleName -And `
						$SetRule.RuleGroup -eq $CheckRule.RuleGroup -And `
						$SetRule.Direction -eq $CheckRule.Direction -And `
						$SetRule.Action -eq $CheckRule.Action
					) {
					#If ($SetRule.Name -eq $CheckRule.Name) {
						$AddRule = $False
					}
				} # End ForEach ($SetRule in $OutputRules)
				If ($AddRule) {
					#Write-Host "Added rule to output list: $($CheckRule.Name)"
					$OutputRules += $CheckRule
				}
			} # End ForEach ($CheckRule in $NetBiosFirewallRule)
		} Else {
			$OutputRules = $NetBiosFirewallRule
		} # End If ($OutputRules)
	} # End If ($NetBIOS)
	
	If ($SMB) {
		If ($OutputRules) {
			ForEach ($CheckRule in $SmbFwRule) {
				$AddRule = $True
				ForEach ($SetRule in $OutputRules) {
					If (
						#$SetRule.Name -eq $CheckRule.Name -And `
						$SetRule.CommonName -eq $CheckRule.CommonName -And `
						#$SetRule.DisplayName -eq $CheckRule.DisplayName -And `
						$SetRule.Description -eq $CheckRule.Description -And `
						$SetRule.DisplayGroup -eq $CheckRule.DisplayGroup -And `
						$SetRule.InstanceID -eq $CheckRule.InstanceID -And `
						$SetRule.PolicyRuleName -eq $CheckRule.PolicyRuleName -And `
						$SetRule.RuleGroup -eq $CheckRule.RuleGroup -And `
						$SetRule.Direction -eq $CheckRule.Direction -And `
						$SetRule.Action -eq $CheckRule.Action
					) {
					#If ($SetRule.Name -eq $CheckRule.Name) {
						$AddRule = $False
					}
				} # End ForEach ($SetRule in $OutputRules)
				If ($AddRule) {
					#Write-Host "Added rule to output list: $($CheckRule.Name)"
					$OutputRules += $CheckRule
				}
			} # End ForEach ($CheckRule in $SmbFwRule)
		} Else {
			$OutputRules = $SmbFwRule
		} # End If ($OutputRules)
	} # End If ($SMB)
	
	If ($FpsRules) {
		If ($OutputRules) {
			ForEach ($CheckRule in $FpsFwRules) {
				$AddRule = $True
				ForEach ($SetRule in $OutputRules) {
					If (
						#$SetRule.Name -eq $CheckRule.Name -And `
						$SetRule.CommonName -eq $CheckRule.CommonName -And `
						#$SetRule.DisplayName -eq $CheckRule.DisplayName -And `
						$SetRule.Description -eq $CheckRule.Description -And `
						$SetRule.DisplayGroup -eq $CheckRule.DisplayGroup -And `
						$SetRule.InstanceID -eq $CheckRule.InstanceID -And `
						$SetRule.PolicyRuleName -eq $CheckRule.PolicyRuleName -And `
						$SetRule.RuleGroup -eq $CheckRule.RuleGroup -And `
						$SetRule.Direction -eq $CheckRule.Direction -And `
						$SetRule.Action -eq $CheckRule.Action
					) {
					#If ($SetRule.Name -eq $CheckRule.Name) {
						$AddRule = $False
					}
				} # End ForEach ($SetRule in $OutputRules)
				If ($AddRule) {
					#Write-Host "Added rule to output list: $($CheckRule.Name)"
					$OutputRules += $CheckRule
				}
			} # End ForEach ($CheckRule in $FpsFwRules)
		} Else {
			$OutputRules = $FpsFwRules
		} # End If ($OutputRules)
	} # End If ($FpsRules)
	
	If ($AllFilePrinterSharingRules) {
		If ($OutputRules) {
			ForEach ($CheckRule in $AllFilePrinterSharingFwRules) {
				$AddRule = $True
				ForEach ($SetRule in $OutputRules) {
					If (
						#$SetRule.Name -eq $CheckRule.Name -And `
						$SetRule.CommonName -eq $CheckRule.CommonName -And `
						#$SetRule.DisplayName -eq $CheckRule.DisplayName -And `
						$SetRule.Description -eq $CheckRule.Description -And `
						$SetRule.DisplayGroup -eq $CheckRule.DisplayGroup -And `
						$SetRule.InstanceID -eq $CheckRule.InstanceID -And `
						$SetRule.PolicyRuleName -eq $CheckRule.PolicyRuleName -And `
						$SetRule.RuleGroup -eq $CheckRule.RuleGroup -And `
						$SetRule.Direction -eq $CheckRule.Direction -And `
						$SetRule.Action -eq $CheckRule.Action
					) {
					#If ($SetRule.Name -eq $CheckRule.Name) {
						$AddRule = $False
					}
				} # End ForEach ($SetRule in $OutputRules)
				If ($AddRule) {
					#Write-Host "Added rule to output list: $($CheckRule.Name)"
					$OutputRules += $CheckRule
				}
			} # End ForEach ($CheckRule in $AllFilePrinterSharingFwRules)
		} Else {
			$OutputRules = $AllFilePrinterSharingFwRules
		} # End If ($OutputRules)
	} # End If ($AllFilePrinterSharingRules)
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	
	If ($ShowTable) {
		$OutputRules | Select-Object -Property Name, DisplayGroup, Enabled, Profile, Direction, Action, DisplayName | Format-Table | Out-Host
		Write-Verbose "Ending $($MyInvocation.MyCommand)"
		Return
	} Else {
		Write-Verbose "Ending $($MyInvocation.MyCommand)"
		Return $OutputRules
	}
} # End of Get-SmbFwRules function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Set-SmbFwRules {
	<#
	.SYNOPSIS
	Changes certain sets of firewall rules relevant to Admin share remote access to on or off.
	.DESCRIPTION
	Can also enable/disable ping (IPv4/IPv6), NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules, SMB, and all additional File and Printer Sharing rules meeting a certain search criteria.
	
	Either -Enable or -Disable switch is required.
	.PARAMETER Enable
	Turns on the rules that Allow ping packets through the firewall. (Required)
	.PARAMETER Disable
	Turns off the rules that Allow ping packets through the firewall. (Required)
	.PARAMETER ICMPv4
	Include IPv4 ICMP ping firewall rules in results.
	.PARAMETER ICMPv6
	Include IPv6 ICMP ping firewall rules in results.
	.PARAMETER NetBIOS
	Include NetBIOS-based Network Discovery & File and Printer Sharing firewall rules in results.
	.PARAMETER SMB
	Include SMB-based (Server Message Block) File and Printer Sharing firewall rules in results.
	.PARAMETER FpsRules
	Include a specific list of File & Printer Sharing firewall rules used for enabling access to Admin shares.
	.PARAMETER AllFilePrinterSharingRules
	Includes every firewall rule in the Display Group "File And Printer Sharing" that are set to Allow traffic, in either In/Out dierection.
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
	.PARAMETER ResetPublicProfiles
	Some firewall rules apply to multiple profiles, e.g. Public & Private. This can be an additional security risk to enable these rules if you only intend to have Admin shares accessible from a Private network.
	
	Using this switch will change these rules to remove their Public profile references. This alters these rules from their defaults to make them more secure.
	.PARAMETER WhatIf
	Does not make any changes to the system. Instead a message will be displayed for every change that would've happened.
	.NOTES
	.LINK
	Get-SmbFwRules
	Set-SmbFwRules
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Set-SmbFwRules -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV4','IPv4','v4')]
		[switch]$ICMPv4,
		
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[switch]$SMB,
		
		[switch]$FpsRules,
		
		[switch]$AllFilePrinterSharingRules,
		
		[Object[]]$Profiles = @('Domain','Private'),
		
		[switch]$ResetPublicProfiles,
		
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
		ICMPv4 = $ICMPv4
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		SMB = $SMB
		FpsRules = $FpsRules
		AllFilePrinterSharingRules = $AllFilePrinterSharingRules
		Profiles = $Profiles
	}
	
	$PingFirewallRule = Get-SmbFwRules @FunctionParams @CommonParameters
	
	If ($VerbosePreference -ne 'SilentlyContinue') {
		Write-Host "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
		Write-Host "Firewall rules before change:"
		Get-SmbFwRules @FunctionParams -ShowTable | Out-Host
	}
	
	ForEach ($Rule in $PingFirewallRule) {
		If ($Enable) {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Enabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				Write-Verbose "Enabling Firewall rule: $($Rule.Name)"
				$Rule | Set-NetFirewallRule -Enabled 1
			}
		} ElseIf ($Disable) {
			If ($WhatIf) {
				Write-Host "What If: Setting rule to Disabled: $Rule" -ForegroundColor Yellow -BackgroundColor Black
			} Else {
				Write-Verbose "Disabling Firewall rule: $($Rule.Name)"
				$Rule | Set-NetFirewallRule -Enabled 2
			}
		}
	}
	
	If ($VerbosePreference -ne 'SilentlyContinue') {
		Write-Host "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
		Write-Host "Firewall rules after change:"
		Get-SmbFwRules @FunctionParams -ShowTable | Out-Host
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
	
	If ($ResetPublicProfiles) {
		Write-Host "TODO - Allow user to change FW rules that include Public/Private profiles to be Private only. (better security, but might want to back up original rules first)"
		
		# The default rules have the non-Domain rule apply for both Public and Private. This updates the rule to be Private only
		#$rules | Set-NetFirewallRule -Profile Private
		
		ForEach ($Rule in $PingFirewallRule) {
			
		}
	}
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Set-SmbFwRules function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Enable-PingResponse {
	<#
	.SYNOPSIS
	Enable the IPv4 ICMP ping respone on the current machine.
	.DESCRIPTION
	Can also enable IPv6 and NetBIOS-based Network Discovery and 'File and Printer Sharing' firewall rules.
	
	By default will always include IPv4 firewall rules. To turn off the -IPv4 switch, -IPv4:$False is required.
	.PARAMETER ICMPv4
	Includes IPv4 ICMP ping firewall rules to enable. By default, this switch is always on. To disable it, use -ICMPv4:$False
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
	Get-SmbFwRules
	Set-SmbFwRules
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Enable-PingResponse -ICMPv4:$False -ICMPv6
	
	This explicitly sets the ICMPv4 switch to False/Off, so that only ICMPv6 rules are targeted to be enabled.
	.EXAMPLE
	Enable-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV4','IPv4','v4')]
		[switch]$ICMPv4 = $True,
		
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[switch]$SMB,
		
		[switch]$FpsRules,
		
		[switch]$AllFilePrinterSharingRules,
		
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
		ICMPv4 = $ICMPv4
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		SMB = $SMB
		FpsRules = $FpsRules
		AllFilePrinterSharingRules = $AllFilePrinterSharingRules
		Profiles = $Profiles
		Enable = $True
		#Disable = $True
		WhatIf = $WhatIf
	}
	
	Set-SmbFwRules @ParamsHash @CommonParameters
	
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
	
	By default will always include IPv4 firewall rules. To turn off the -IPv4 switch, -IPv4:$False is required.
	.PARAMETER ICMPv4
	Includes IPv4 ICMP ping firewall rules to disable. By default, this switch is always on. To disable it, use -ICMPv4:$False
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
	Get-SmbFwRules
	Set-SmbFwRules
	Enable-PingResponse
	Disable-PingResponse
	.LINK
	Get-NetConnectionProfile
	Set-NetConnectionProfile
	.EXAMPLE
	Enable-PingResponse -ICMPv4:$False -ICMPv6
	
	This explicitly sets the ICMPv4 switch to False/Off, so that only ICMPv6 rules are targeted to be disabled.
	.EXAMPLE
	Disable-PingResponse -WhatIf -Confirm
	#>
	#Requires -RunAsAdministrator
	[CmdletBinding()]
	Param(
		[Alias('PingV4','IPv4','v4')]
		[switch]$ICMPv4 = $True,
		
		[Alias('PingV6','IPv6')]
		[switch]$ICMPv6,
		
		[switch]$NetBIOS,
		
		[switch]$SMB,
		
		[switch]$FpsRules,
		
		[switch]$AllFilePrinterSharingRules,
		
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
		ICMPv4 = $ICMPv4
		ICMPv6 = $ICMPv6
		NetBIOS = $NetBIOS
		SMB = $SMB
		FpsRules = $FpsRules
		AllFilePrinterSharingRules = $AllFilePrinterSharingRules
		Profiles = $Profiles
		#Enable = $True
		Disable = $True
		WhatIf = $WhatIf
	}
	
	Set-SmbFwRules @ParamsHash @CommonParameters
	
	#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	Return
} # End of Disable-PingResponse function.
#-----------------------------------------------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------------------------------------------
Function Backup-RegistryPath {
	<#
	.SYNOPSIS
	Interactively backup a given registry key path, prompting the user for backup location.
	.DESCRIPTION
	.NOTES
	#>
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
		<#
		.SYNOPSIS
		Given a file name string, this function checks & makes sure it has a .reg extension.
		#>
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
		<#
		.SYNOPSIS
		Backs up the given Registry key path to the given File Path and File Name.
		.PARAMETER BackupFileName
		.PARAMETER BackupRegPath
		.PARAMETER BackupFilePath
		#>
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
		[switch]$OptionalRemoval,
		[switch]$Quiet
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
			If (!$Quiet) {
				Write-Host "In order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n"
			}
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
			If (!$Quiet) {
				Write-Warning "Incorrect/incompatible registry key detected. This computer has been detected as a $OSLabel OS ('$OSName'), yet a key only meant for a $OppositeLabel OS was detected ('$KeyName'). Recommended to delete this registry key."
			}
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

If ($LogFilePath) {
	$FileExtension = [System.IO.Path]::GetExtension($LogFilePath)
	$FilePathWithoutExention = $LogFilePath -replace "\$FileExtension$",""
	$TeeFilePath = Join-Path -Path (Get-Location) -ChildPath "$($FileNameWithoutExention)_tee-obj.txt"
	If ($CsvLog) {
		If ($FileExtension -ne '.csv') {
			$FilePathWithoutExention = $LogFilePath -replace "\$FileExtension$",""
			$LogFilePath = "$FilePathWithoutExention.csv"
		}
	} Else {
		If ($FileExtension -eq '.csv') {
			$CsvLog = $True
		}
	}
} Else {
	$ScriptName = $MyInvocation.MyCommand
	$FileExtension = [System.IO.Path]::GetExtension($ScriptName)
	$FileNameWithoutExention = $ScriptName -replace "\$FileExtension$",""
	If ($CsvLog) {
		$LogFilePath = Join-Path -Path (Get-Location) -ChildPath "$FileNameWithoutExention.csv"
	} Else {
		$LogFilePath = Join-Path -Path (Get-Location) -ChildPath "$FileNameWithoutExention.log"
	}
	$TeeFilePath = Join-Path -Path (Get-Location) -ChildPath "$($FileNameWithoutExention)_tee-obj.txt"
}
$Global:WriteLogFilePath = $LogFilePath
"Log file: '$LogFilePath'" | Write-LogFile -VerboseMsg | Write-Verbose
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}

$HR = "-----------------------------------------------------------------------------------------------------------------------"
$HR | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
"Starting script: $($MyInvocation.MyCommand)" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
If ($Disable) {$Verb1 = "Disabling"} Else {$Verb1 = "Enabling"}
"$Verb1 Admininistrative shares (e.g. \\$env:COMPUTERNAME\C$) on this machine: `n" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White

$HR | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
"Current network shares:" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
"C:\> net share" | Write-LogFile | Write-Host
net share | Tee-Object -FilePath $TeeFilePath
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}

"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$Step1 = "Step 1: Check that connected network(s) are not set to 'Public' profile type."
#Write-Host "Step 1: Check that connected network(s) are not set to 'Public' profile type.`n" -BackgroundColor Black -ForegroundColor White
$Step1 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

$NetProfiles = Get-NetConnectionProfile

#$NetProfiles | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Tee-Object -FilePath $TeeFilePath | Format-Table | Out-Host
$NetProfiles | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}

$PublicProfiles = $False
$NetProfiles | ForEach-Object {
	If ($_.NetworkCategory -eq "Public") {
		$PublicProfiles = $True
		If (!($Disable)) {
			"The network '$($_.Name)' on interface '($($_.InterfaceIndex)) $($_.InterfaceAlias)' is set to '$($_.NetworkCategory)'." | Write-LogFile -WarningMsg | Write-Warning
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
						"Changing '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Private'." | Write-LogFile -VerboseMsg | Write-Verbose
						
						#Set-NetConnectionProfile -InterfaceIndex $interface.InterfaceIndex -NetworkCategory 'Private' @CommonParameters
						$interface | Set-NetConnectionProfile -NetworkCategory 'Private' @CommonParameters
						
						Start-Sleep -Milliseconds 500
						
						"Restarting '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network adapter" | Write-LogFile -VerboseMsg | Write-Verbose
						Get-NetAdapter -InterfaceIndex $interface.InterfaceIndex | Restart-NetAdapter
						
						Start-Sleep -Milliseconds 500
						
						Get-NetConnectionProfile | Where-Object {$_.InterfaceIndex -eq $interface.InterfaceIndex} | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
					}
					1 {
						"No changes made to '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile. ($($interface.NetworkCategory))" | Write-LogFile -VerboseMsg | Write-Verbose
					}
					Default {
						"Network profile choice error." | Write-LogFile -ErrorMsg | Write-Error
						Throw "Network profile choice error."
					}
				} # End switch
			} # End If ($interface.NetworkCategory -eq "Public")
		} # End ForEach
	} Else {
		"No network profiles set to Public.`nSKIPPING...`n" | Write-LogFile | Write-Host
	}
} Else {
	#Write-Host "Disabling Admin shares, no need to mess with network profiles.`nSKIPPING...`n"
	
	If (!($PublicProfiles)) {
		ForEach ($interface in $NetProfiles) {
			If ($interface.NetworkCategory -eq "Private") {
				# Ask user to change network interface profile to Public
				$Title = "Change '$($interface.Name)' network on '($($interface.InterfaceIndex)) $($interface.InterfaceAlias)' to 'Public' profile?"
				$Info = "The '$($interface.Name)' $($interface.InterfaceAlias) network is set to '$($interface.NetworkCategory)' profile type, which changes the class of firewall rules being applied to a very restrictive set, designed for untrusted networks. If this is an un-trusted network, changing it to 'Public' will increase security."
				# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
				$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Change '$($interface.Name)' $($interface.InterfaceIndex) - $($interface.InterfaceAlias) network profile to 'Public', making it more secure for this device to use the network."
				$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not make changes to '$($interface.Name)' $($interface.InterfaceAlias) network profile, it will remain as '$($interface.NetworkCategory)'."
				$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
				[int]$DefaultChoice = 1 # First choice starts at zero
				$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
				switch ($Result) {
					0 {
						"Changing '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile to 'Public'." | Write-LogFile -VerboseMsg | Write-Verbose
						
						#Set-NetConnectionProfile -InterfaceIndex $interface.InterfaceIndex -NetworkCategory 'Public' @CommonParameters
						$interface | Set-NetConnectionProfile -NetworkCategory 'Public' @CommonParameters
						
						Start-Sleep -Milliseconds 500
						
						"Restarting '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network adapter" | Write-LogFile -VerboseMsg | Write-Verbose
						Get-NetAdapter -InterfaceIndex $interface.InterfaceIndex | Restart-NetAdapter
						
						Start-Sleep -Milliseconds 500
						
						Get-NetConnectionProfile | Where-Object {$_.InterfaceIndex -eq $interface.InterfaceIndex} | Select-Object -Property InterfaceIndex, InterfaceAlias, NetworkCategory, IPv4Connectivity, IPv6Connectivity | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
					}
					1 {
						"No changes made to '$($interface.InterfaceIndex) $($interface.InterfaceAlias)' network profile. ($($interface.NetworkCategory))" | Write-LogFile -VerboseMsg | Write-Verbose
					}
					Default {
						"Network profile choice error." | Write-LogFile -ErrorMsg | Write-Error
						Throw "Network profile choice error."
					}
				} # End switch
			} # End If ($interface.NetworkCategory -eq "Public")
		} # End ForEach
	} Else {
		"No network profiles set to Private or Domain.`nSKIPPING...`n" | Write-LogFile | Write-Host
	}
}

"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
If ($Disable) {$Verb2 = "Disable"} Else {$Verb2 = "Enable"}
$Step2 = "Step 2: $Verb2 ping response and `"File and print sharing`" through Windows Firewall."
#Write-Host "Step 2: Enable ping response and `"File and print sharing`" through Windows Firewall.`n" -BackgroundColor Black -ForegroundColor White
#Write-Host $Step2 -BackgroundColor Black -ForegroundColor White
$Step2 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

$PingParamsHash = @{
	ICMPv6 = $True
	NetBIOS = $True
	SMB = $True
	FpsRules = $True
	#AllFilePrinterSharingRules = $True
}

#Get-SmbFwRules -ICMPv6 -NetBIOS -Table @CommonParameters
Get-SmbFwRules @PingParamsHash -Table @CommonParameters

"Checking if ping/NetBIOS firewall rules are already allowed." | Write-LogFile -VerboseMsg | Write-Verbose
$FwRules = Get-SmbFwRules @PingParamsHash @CommonParameters
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
				"Disabling ping response:" | Write-LogFile -VerboseMsg | Write-Verbose
				Disable-PingResponse @PingParamsHash @CommonParameters
			} Else {
				"Enabling ping response:" | Write-LogFile -VerboseMsg | Write-Verbose
				Enable-PingResponse @PingParamsHash @CommonParameters
			}
			
			Get-SmbFwRules @PingParamsHash -Table
		}
		1 {
			"Declined firewall rules change for ping." | Write-LogFile -VerboseMsg | Write-Verbose
		}
		Default {
			"Ping response choice error." | Write-LogFile -ErrorMsg | Write-Error
			Throw "Ping response choice error."
		}
	}
} Else {
	If (!$RulesDisabled) {
		"All ping firewall rules already enabled.`nSKIPPING...`n" | Write-LogFile | Write-Host
	}
}

#Enable-NetAdapterBinding -Name "Network Adapter Name" -DisplayName "File and Printer Sharing for Microsoft Networks"

#Disable-NetAdapterBinding -Name "Network Adapter Name" -DisplayName "File and Printer Sharing for Microsoft Networks"


"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$Step3 = "Step 3: Ensure that both computers belong to the same Workgroup or Domain."
#Write-Host "Step 3: Ensure that both computers belong to the same Workgroup or Domain." -BackgroundColor Black -ForegroundColor White
#Write-Host $Step3 -BackgroundColor Black -ForegroundColor White
$Step3 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

# PartOfDomain (boolean Property)
$PartOfDomain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

If ($PartOfDomain) {
	"This PC's domain/workgroup status:" | Write-LogFile | Write-Host
	"DOMAIN:" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	$Domain = Get-WmiObject -Namespace root\cimv2 -Class Win32_ComputerSystem | Select-Object Name, Domain
	$Domain | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
} Else {
	"Note: Non-domain PC's should have the same Workgroup name set in order to network together.`n" | Write-LogFile | Write-Host
	"This PC's domain/workgroup status:" | Write-LogFile | Write-Host
	# Workgroup (string Property)
	$Workgroup = (Get-WmiObject -Class Win32_ComputerSystem).Workgroup
	"WORKGROUP: `"$Workgroup`"" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	"`nTo check another PC's Workgroup name:" | Write-LogFile | Write-Host
	" - Run (Win+R): sysdm.cpl" | Write-LogFile | Write-Host
	" - Run (Win+R): SystemPropertiesComputerName" | Write-LogFile | Write-Host
	" - ......  C:\> net config workstation | find `"Workstation domain`"`n" | Write-LogFile | Write-Host
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
			"Changing Workgroup name." | Write-LogFile -VerboseMsg | Write-Verbose
			"Ctrl+C to cancel." | Write-LogFile | Write-Host
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
					"Rebooting in 10 seconds" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
					"Ctrl+C to Cancel" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
					Start-Sleep -Seconds 10
					Restart-Computer @CommonParameters
				}
				1 {
					"Reboot deferred." | Write-LogFile -VerboseMsg | Write-Verbose
					"If the Workgroup name was changed, this PC must be restarted for the changes to take effect." | Write-LogFile -WarningMsg | Write-Warning
				}
				Default {
					"Reboot choice error." | Write-LogFile -ErrorMsg | Write-Error
					Throw "Workgroup choice error."
				}
			}
		}
		1 {
			"Keeping Workgroup name: $Workgroup" | Write-LogFile -VerboseMsg | Write-Verbose
		}
		Default {
			"Workgroup choice error." | Write-LogFile -ErrorMsg | Write-Error
			Throw "Workgroup choice error."
		}
	}
} Else {
	"Disabling Admin shares, no need to change Workgroup.`nSKIPPING...`n" | Write-LogFile | Write-Host
}

"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$Step4 = "Step 4: Update registry values"
#Write-Host "Step 4: Update registry values" -BackgroundColor Black -ForegroundColor White
#Write-Host $Step4 -BackgroundColor Black -ForegroundColor White
$Step4 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

$RegKey1 = "Reg key 1: LanmanServer and AutoShareWks/AutoShareServer (auto-generate & publish Admin shares on reboot)"
$RegKey1 | Write-LogFile | Write-Host
# Check if Server OS:
$ServerOS = $False
$OSName = ((Get-CimInstance -ClassName CIM_OperatingSystem).Caption)
If ($OSName -like "*Server*") {
	$ServerOS = $True
}
"Server OS detected: $ServerOS ('$OSName')" | Write-LogFile -VerboseMsg | Write-Verbose

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
Remove-Variable -Name KeyValue -Force -ErrorAction 'SilentlyContinue'
Try {
	$KeyValue = Get-ItemProperty -Path $KeyPath -Name $KeyName -ErrorAction 'Stop'
} Catch {
	"Registry key '$KeyName' does not exist." | Write-LogFile -VerboseMsg | Write-Verbose
	If ($KeyValue) {Remove-Variable -Name KeyValue -Force -ErrorAction 'SilentlyContinue'}
}
Try {
	$WrongKeyValue = Get-ItemProperty -Path $KeyPath -Name $WrongKeyName -ErrorAction 'Stop'
} Catch {
	"Registry key '$WrongKeyName' does not exist." | Write-LogFile -VerboseMsg | Write-Verbose
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
		"Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -VerboseMsg | Write-Verbose
		If ($KeyValue.$KeyName -eq 1) {
			"'$KeyName' is enabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask user to disable key
			$BackupRegistry = $True
		} Else {
			"'$KeyName' is already disabled." | Write-LogFile -VerboseMsg | Write-Verbose
		}
	} Else {
		"'$KeyName' doesn't exist, Admin shares are enabled." | Write-LogFile -VerboseMsg | Write-Verbose
		# Ask user to create it as disabled
		$BackupRegistry = $True
	}
} Else {
	# Either no key or a key with value 1 will enable it.
	If ($KeyValue) {
		"Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -VerboseMsg | Write-Verbose
		If ($KeyValue.$KeyName -eq 0) {
			"'$KeyName' is disabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask user to enable it or delete it.
			$BackupRegistry = $True
		} Else {
			"'$KeyName' is already enabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask if user wants to delete it anyway.
			$BackupRegistry = $True
		}
	} Else {
		"'$KeyName' doesn't exist, Admin shares are already enabled." | Write-LogFile -VerboseMsg | Write-Verbose
		# Ask if user wants to explicitly set it to enabled anyway.
		$BackupRegistry = $True
	}
}
If ($BackupRegistry) {
	# Backup registry key path.
	Backup-RegistryPath -KeyPath $KeyPath -KeyName $KeyName -BackupFolderName $BackupFolderName @CommonParameters
}

# Detect & delete non-necessary registry keys:
"KeyValue = '$KeyValue'" | Write-LogFile -VerboseMsg | Write-Verbose
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
"KeyValue = '$KeyValue'" | Write-LogFile -VerboseMsg | Write-Verbose

# Create/Enable/Disable/Delete registry key:

# A registry key with value 0 is required to disable admin share creation on reboot.
# Either no key or a key with value 1 will enable it.
If ($Disable) {
	# A registry key with value 0 is required to disable admin share creation on reboot.
	If ($KeyValue) {
		"Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -VerboseMsg | Write-Verbose
		If ($KeyValue.$KeyName -eq 1) {
			"'$KeyName' is enabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask user to disable key
			
			# Ask user to disable registry key.
			"'$KeyName' is enabled." | Write-LogFile -WarningMsg | Write-Warning
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($KeyValue.$KeyName) (True)"
			}
			"`nRegistry path:`n$KeyPath\`nKey:$KeyName" | Write-LogFile | Write-Host
			$DisplayTable | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
			"`nIn order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n" | Write-LogFile | Write-Host
			"After a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.`n" | Write-LogFile -WarningMsg | Write-Warning
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
					"Changing '$KeyName' reg key to 0 (disabled)." | Write-LogFile -VerboseMsg | Write-Verbose
					
					#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 0
					Set-ItemProperty -Path $KeyPath -Name $KeyName -Value 0 @CommonParameters
				}
				1 {
					"Keeping registry key the same: '$KeyName' ($($KeyValue.$KeyName))" | Write-LogFile -VerboseMsg | Write-Verbose
				}
				Default {
					"Disable registry key choice error." | Write-LogFile -ErrorMsg | Write-Error
					Throw "Disable registry key choice error."
				}
			}
			
		} Else {
			"'$KeyName' is already disabled." | Write-LogFile -VerboseMsg | Write-Verbose
			
			"Registry key '$KeyName' is already set to $($KeyValue.$KeyName) (disabled).`nSKIPPING...`n" | Write-LogFile -VerboseMsg | Write-Verbose
		}
	} Else {
		"'$KeyName' doesn't exist, Admin shares are enabled." | Write-LogFile -VerboseMsg | Write-Verbose
		# Ask user to create it as disabled
		
		# Ask user to create registry key as disabled.
		"Key '$KeyName' does not exist." | Write-LogFile -WarningMsg | Write-Warning
		"`nIn order to prevent Windows 10 from publishing administrative shares, the registry key '$KeyPath' needs a Dword parameter named AutoShareWks (for desktop versions of Windows) or AutoShareServer (for Windows Server) and the value 0.`n" | Write-LogFile | Write-Host
		"After a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.`n" | Write-LogFile -WarningMsg | Write-Warning
		
		#$null = New-ItemProperty -Path $KeyPath -Name $KeyName -Type DWORD -Value 1
		New-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -NewValue 0 @CommonParameters
	}
} Else {
	# Either no key or a key with value 1 will enable it.
	
	If ($KeyValue) {
		"Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -VerboseMsg | Write-Verbose
		If ($KeyValue.$KeyName -eq 0) {
			"'$KeyName' is disabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask user to enable it or delete it.
			
			# Ask user to enable or delete registry key.
			"'$KeyName' is disabled." | Write-LogFile -WarningMsg | Write-Warning
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($KeyValue.$KeyName) (False)"
			}
			"`nRegistry path:`n$KeyPath\`nKey:$KeyName" | Write-LogFile | Write-Host
			$DisplayTable | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
			"`nFor Windows 10 to automatically create & publish administrative shares after a reboot, the registry key '$KeyPath' needs a Dword parameter either named '$KeyName' with the value 1 (enabled), or for that parameter to be deleted completely. Currently '$KeyName' is set as $($KeyValue.$KeyName) (disabled).`n" | Write-LogFile | Write-Host
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
					"Changing '$KeyName' reg key from $($KeyValue.$KeyName) (disabled) to 1 (enabled)." | Write-LogFile -VerboseMsg | Write-Verbose
					
					#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1
					Set-ItemProperty -Path $KeyPath -Name $KeyName -Value 1 @CommonParameters
				}
				1 {
					"Deleting registry key: '$KeyName'" | Write-LogFile -VerboseMsg | Write-Verbose
					
					#Remove-ItemProperty -Path $KeyPath -Name $KeyName -Verbose
					Remove-ItemProperty -Path $KeyPath -Name $KeyName @CommonParameters
					#Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -ServerOS $ServerOS -OSName $OSName @CommonParameters
				}
				2 {
					"Keeping registry key the same: '$KeyName' ($($KeyValue.$KeyName))" | Write-LogFile -VerboseMsg | Write-Verbose
				}
				Default {
					"Disable registry key choice error." | Write-LogFile -ErrorMsg | Write-Error
					Throw "Disable registry key choice error."
				}
			}
			
		} Else {
			"'$KeyName' is already enabled." | Write-LogFile -VerboseMsg | Write-Verbose
			# Ask if user wants to delete it anyway.
			
			# Either deleting or enabling (1) this registry key will turn the Admin shares feature back on. User wants it on and it's already on (1), so we can leave the reg key as-is. But deleting it would also work.
			"Registry key '$KeyName' is already enabled ($($KeyValue.$KeyName)). Windows will already automatically publish Administrative shares when this key is set to 1, or is deleted. No registry changes are necessary, but it can also be deleted for the same effect." | Write-LogFile | Write-Host
			
			#Remove-ItemProperty -Path $KeyPath -Name $KeyName -Verbose
			#Remove-ItemProperty -Path $KeyPath -Name $KeyName @CommonParameters
			Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyNameDesktop -OptionalRemoval @CommonParameters
		}
	} Else {
		"'$KeyName' doesn't exist, Admin shares are already enabled." | Write-LogFile -VerboseMsg | Write-Verbose
		# Ask if user wants to explicitly set it to enabled anyway.
		
		# Ask user to create registry key as enabled.
		"Registry key '$KeyName' already doesn't exist. Windows will automatically publish Administrative shares. No registry changes are necessary, but this key can still be created as enabled if desired.`n" | Write-LogFile | Write-Host
		
		#$null = New-ItemProperty -Path $KeyPath -Name $KeyName -Type DWORD -Value 1
		New-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -NewValue 1 @CommonParameters
	}
}

"Restarting LanmanServer service..." | Write-LogFile -VerboseMsg | Write-Verbose
Get-Service LanmanServer @CommonParameters | Restart-Service @CommonParameters

"`n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -" | Write-LogFile | Write-Host

$RegKey2 = "Reg key 2: LocalAccountTokenFilterPolicy (disable Remote UAC)"
$RegKey2 | Write-LogFile | Write-Host

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

- Go to the following reg key HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System ;
- Create a new DWORD (32-bit) parameter with the name LocalAccountTokenFilterPolicy;
- Set the LocalAccountTokenFilterPolicy parameter value to 1;
- Restart your computer to apply the changes.

Note. You can create the LocalAccountTokenFilterPolicy registry parameter using the following command:

- reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t REG_DWORD /d 1 /f

After rebooting, try to remotely open the C$ admin share on a computer running Windows 10. Log in using an account that is a member of the local Administrators group. A File Explorer window should open with the contents of the C:\ drive.
#>

# Set registry key path & name
#$KeyPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$KeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$KeyName = "LocalAccountTokenFilterPolicy"
# Check if registry key(s) exists:
Remove-Variable -Name KeyValue -Force -ErrorAction 'SilentlyContinue'
Try {
	$KeyValue = Get-ItemProperty -Path $KeyPath -Name $KeyName -ErrorAction 'Stop'
} Catch {
	"Registry key '$KeyName' does not exist." | Write-LogFile -VerboseMsg | Write-Verbose
	If ($KeyValue) {Remove-Variable -Name KeyValue -Force -ErrorAction 'SilentlyContinue'}
}

$DescriptionText = @"
The registry key LocalAccountTokenFilterPolicy with DWORD value 1 is used to disable Remote UAC.

Remote UAC (User Account Control for remote connections) filters the tokens of local and Microsoft accounts and blocks remote access to admin shares under such accounts. When accessing under the domain accounts, this restriction is not applied.`n`n
"@

$EnableText = @"
If you wish to enable Admin shares, but are having these problems:
 - Using the credentials of an account that is a member of the local Administrators group still gets an "Access is denied" error.
 - I can access administrative shares under the built-in Administrator account.

Then it is RECOMMENDED to disable Remote UAC by setting the LocalAccountTokenFilterPolicy reg key with DWORD value 1.`n
"@

$DisableText = @"
If you wish to disable Admin shares, it is recommended to delete the LocalAccountTokenFilterPolicy reg key to enable Remote UAC.`n
"@

If ($Disable) {
	$DescriptionText += $DisableText
} Else {
	$DescriptionText += $EnableText
}

# To enable remote shares, ask user to disable Remote UAC by creating the LocalAccountTokenFilterPolicy parameter as DWORD value 1 in the registry.
# To disable remote shares, ask user to delete the LocalAccountTokenFilterPolicy parameter in the registry to turn Remote UAC back on.
If ($Disable) {
	# To disable remote shares, ask user to delete the LocalAccountTokenFilterPolicy parameter in the registry to turn Remote UAC back on.
	If ($KeyValue) {
		"Key '$KeyName' exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -WarningMsg | Write-Warning
		Backup-RegistryPath -KeyPath $KeyPath -KeyName $KeyName -BackupFolderName $BackupFolderName @CommonParameters
		
		$DescriptionText | Write-LogFile | Write-Host
		Remove-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -Quiet @CommonParameters
	} Else {
		"Key '$KeyName' already doesn't exist, no changes necessary.`nSKIPPING...`n" | Write-LogFile | Write-Host
	}
} Else {
	# To enable remote shares, ask user to disable Remote UAC by creating the LocalAccountTokenFilterPolicy parameter as DWORD value 1 in the registry.
	If (!($KeyValue)) {
		"'$KeyName' does not exist." | Write-LogFile -VerboseMsg | Write-Verbose
		Backup-RegistryPath -KeyPath $KeyPath -KeyName $KeyName -BackupFolderName $BackupFolderName @CommonParameters
		
		$DescriptionText | Write-LogFile | Write-Host
		"Tip. This will slightly reduce the Windows security level." | Write-LogFile -WarningMsg | Write-Warning
		New-RegistryKey -KeyPath $KeyPath -KeyName $KeyName -NewValue 1 @CommonParameters
	} Else {
		"Key '$KeyName' already exists. Value = '$($KeyValue.$KeyName)'" | Write-LogFile -VerboseMsg | Write-Verbose
		If ($KeyValue.$KeyName -ne 1) {
			"Key '$KeyName' exists but does not equal 1." | Write-LogFile -WarningMsg | Write-Warning
			Backup-RegistryPath -KeyPath $KeyPath -KeyName $KeyName -BackupFolderName $BackupFolderName @CommonParameters
			
			$DescriptionText | Write-LogFile | Write-Host
			$DisplayTable = [PSCustomObject]@{
				Key = $KeyName
				Value = "$($KeyValue.$KeyName) (False)"
			}
			"`nRegistry path:`n$KeyPath\`nKey:$KeyName" | Write-LogFile | Write-Host
			$DisplayTable | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}
			"Tip. This will slightly reduce the Windows security level." | Write-LogFile -WarningMsg | Write-Warning
			# Ask user to either disable or delete registry key
			$Title = "Change setting of registry key to 1?"
			$Info = "Change the value of '$KeyName' to 1 (disabled) to disable Remote UAC?"
			# Use Ampersand & in front of letter to designate that as the choice key. E.g. "&Yes" for Y, "Y&Ellow" for E.
			$Yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Change the '$KeyName' registry key to value 1 (disable Remote UAC)."
			$No = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not make any changes to the registry."
			$Options = [System.Management.Automation.Host.ChoiceDescription[]]($Yes, $No)
			[int]$DefaultChoice = 0 # First choice starts at zero
			$Result = $Host.UI.PromptForChoice($Title, $Info, $Options, $DefaultChoice)
			switch ($Result) {
				0 {
					"Changing '$KeyName' reg key from $($KeyValue.$KeyName) to 1 (Remote UAC disabled)." | Write-LogFile -VerboseMsg | Write-Verbose
					
					#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1
					Set-ItemProperty -Path $KeyPath -Name $KeyName -Value 1 @CommonParameters
				}
				1 {
					"Keeping registry key the same: '$KeyName' ($($KeyValue.$KeyName))" | Write-LogFile -VerboseMsg | Write-Verbose
				}
				Default {
					"Change '$KeyName' (Remote UAC) registry key choice error." | Write-LogFile -ErrorMsg | Write-Error
					Throw "Change '$KeyName' (Remote UAC) registry key choice error."
				}
			}
		} Else {
			Write-Host "Key '$KeyName' already exists with DWORD value 1, no changes necessary.`nSKIPPING...`n"
		}
	}
}

"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$Step5 = "Step 5: Specify which user(s) can access the Admin Shares (Disk Volumes)."
#Write-Host "Step 5: Specify which user(s) can access the Admin Shares (Disk Volumes)." -BackgroundColor Black -ForegroundColor White
#Write-Host $Step5 -BackgroundColor Black -ForegroundColor White
$Step5 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

"Users in Administrators group:" | Write-LogFile | Write-Host
$AdminGroupMembers = Get-LocalGroupMember -Group "Administrators" @CommonParameters
$AdminGroupMembers | Select-Object -Property Name, ObjectClass, PrincipalSource | Format-Table | Tee-Object -FilePath $TeeFilePath | Out-Host
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}

"`n" | Write-LogFile | Write-Host
"TODO - Check if current user name is in the Admin group of the local machine." | Write-LogFile -WarningMsg | Write-Warning
"TODO - Ask user to activate default local Administrator account." | Write-LogFile -WarningMsg | Write-Warning
"`n" | Write-LogFile | Write-Host




#New-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Type DWORD -Value 0
#You can deploy this registry parameter to all domain computers through a GPO.

# Now, after a reboot, administrative shares will not be created. In this case, the tools for remote computer manage, including psexec, will stop working.

# If you want to enable admin shares on Windows, you need to change the parameter value to 1 or delete it:

#Set-ItemProperty -Name AutoShareWks -Path HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Value 1 @CommonParameters

# To have Windows recreate the hidden admin shares, simply restart the Server service with the command:

#Get-Service LanmanServer @CommonParameters | Restart-Service -Verbose @CommonParameters




Pause

"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$Step6 = "Step 6: TODO - Create/Delete Admininistrative shares."
#Write-Host $Step6 -BackgroundColor Black -ForegroundColor White
$Step6 | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""



"-----------------------------------------------------------------------------------------------------------------------" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
$EndOfSteps = "End of Steps: Admin shares on this PC ($env:COMPUTERNAME) should now be active."
#Write-Host "End of Steps: Admin shares on this PC ($env:COMPUTERNAME) should now be active." -BackgroundColor Black -ForegroundColor White
#Write-Host $EndOfSteps -BackgroundColor Black -ForegroundColor White
$EndOfSteps | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
Write-Host ""

"Current network shares:" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
"C:\> net share" | Write-LogFile | Write-Host
net share | Tee-Object -FilePath $TeeFilePath
Get-Content -Path $TeeFilePath | Add-Content -Path $LogFilePath
If (Test-Path -Path $TeeFilePath) {Remove-Item -Path $TeeFilePath}

If ($Disable) {
	"Admin shares should be disabled on this machine now." | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
} Else {
	"`nTry accessing a share from another PC, e.g.:" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
	" - \\$env:COMPUTERNAME\C$" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
	
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
			" - \\$($IP.IPAddress)\C$ - (DHCP error: Unassigned APIPA network address in use.)" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Red
		} Else {
			" - \\$($IP.IPAddress)\C$" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor White
		}
	}
	
	"`nTroubleshooting:" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	" - C:\> nslookup $env:COMPUTERNAME" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	" - C:\> ping $env:COMPUTERNAME" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	ForEach ($IP in $ValidIPs) {
		If ($IP.IPAddress -notlike "169.254.*") {
			" - C:\> ping $($IP.IPAddress)" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
		}
	}
	" - Check for custom CIFS / SMB firewall Block rules:" | Write-LogFile | Write-Host
	# Thanks to: https://social.technet.microsoft.com/Forums/en-US/68249d31-4927-43fb-b17b-ead92c3bd05e/protocolsports-for-windows-file-sharing-on-a-firewall
	<#
	I understood SMB to be an application layer "protocol" with the underlying transport mechanism being TCP. As it relates to opening firewall ports the minimum requirement is:
	
	TCP: 445
	
	UDP: 137, 138
	
	TCP: 137, 139
	
	Note: Historically CIFS / SMB are vulnerable to security threats. Also, the next admin admin to work on the server is 100% likely to set a local file permission incorrectly which could expose data. I suggest specifying specific source IP addresses in your firewall tables if you're going to enable SMB. 
	
	https://en.wikipedia.org/wiki/Server_Message_Block
	#>
	"     - TCP: 445" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	"     - UDP: 137, 138" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
	"     - TCP: 137, 139" | Write-LogFile | Write-Host -BackgroundColor Black -ForegroundColor Yellow
}

"`n`n`n" | Write-LogFile | Write-Host

Pause


