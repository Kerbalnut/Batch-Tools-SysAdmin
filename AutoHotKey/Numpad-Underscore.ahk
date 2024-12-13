#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox,
	(LTrim
		Numpad Underscore shortcut enabled.
		
		Press Shift + Numpad(-) to print Underscore(_)
		
		(To stop this script right-click the AutoHotKey icon in the TaskBar notification tray, and select "Pause Script" or "Exit".)
	) ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

; !+v:: ; Alt+Shift+V to activate
; ^!v:: ; Ctrl+Alt+V to activate
; ^+v:: ; Ctrl+Shift+V to activate
+NumpadSub:: ; Shift + Numpad hyphen/dash/minus (-) to activate
	SendInput _ ;  Types the Underscore (_) character
Return
