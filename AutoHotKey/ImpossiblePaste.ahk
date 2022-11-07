#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox,
	(LTrim
		Impossible Paste: Paste text into locked fields that block it.
		
		1. Copy text normally (Ctrl+C).
		2. Ctrl+Shift+V for Impossible Paste.
		
		(To stop this script right-click the AutoHotKey icon in the TaskBar notification tray, and select "Pause Script" or "Exit".)
	) ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

; Impossible Paste:
; Paste text into locked fields that block clipboard pasting, by allowing AHK to type the clipboard's contents via HID keyboard instead.
; (Remember to update the help text above if you change the activation hotkey below!)
; !+v:: ; Alt+Shift+V to activate
; ^!v:: ; Ctrl+Alt+V to activate
^+v:: ; Ctrl+Shift+V to activate
	;Send, %Clipboard% ;  Types the contents of the %Clipboard% variable (a built-in var) --- using the same method as the pre-1.0.43 Send command, synonymous with SendEvent.
	SendInput %Clipboard% ;  Types the contents of the %Clipboard% variable (a built-in var) --- uses the same syntax as Send but is generally faster and more reliable.
Return
