#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	MsgBox,
	(LTrim
		Script Startup: TrueNAS web shell Copy & Paste
		
		- Alt-C to Copy (Ctrl+Insert).
		
		- Alt-V to Paste (Shift+Insert).
		
		To stop this script, right-click the AutoHotKey icon in the TaskBar notification tray, and select 'Pause Script' or 'Exit'.
	) ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

; Script Description:
; Using the web shell for the TrueNAS web interface requires special keys to copy or paste to it. (Right click and Ctrl+C or Ctrl+V don't work.)

; The text reads as-is:
;   Copy and Paste
;   Context menu copy and paste operations are disabled in the Shell. Copy and paste shortcuts for Mac are Command+c and Command+v. For most operating systems, use Ctrl+Insert to copy and Shift+Insert to paste.

; However my laptop keyboard does not have an Insert key. So let's spoof it. In fact, let's spoof the whole shortcut(s).

; Copy
+!c:: ; Alt-C to activate
	Send ^{Ins} ; Presses the keys Ctrl+Insert, the command for copy in TrueNAS web shell.
Return

; Paste
+!v:: ; Alt-V to activate
	Send +{Ins} ; Presses the keys Shift+Insert, the command for paste in TrueNAS web shell.
Return



