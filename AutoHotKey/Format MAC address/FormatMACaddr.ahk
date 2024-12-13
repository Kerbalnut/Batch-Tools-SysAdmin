#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox,
	(LTrim 
		Hotkey for formatting MAC addresses with colons (:) is active.
		
		E.g. B8A44FB9A975 to -> B8:A4:4F:B9:A9:75
		
		Press Ctrl + Shift + M to activate.
		
		(To stop this script right-click the AutoHotKey icon in the TaskBar notification tray, and select "Pause Script" or "Exit".)
	) ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

; !+v:: ; Alt+Shift+V to activate
; ^!v:: ; Ctrl+Alt+V to activate
; ^+v:: ; Ctrl+Shift+V to activate
^+m:: ; Ctrl+Shift+M to activate
	SendInput {F2} ;  Presses the F2 key, which starts editing a cell in Excel/LibreOffice Calc
	Sleep 50  ; The number of milliseconds between keystrokes
	SendInput {Home} ;  Presses the 'Home' key to return cursor to the front of line.
	SendInput {Right}{Right}: ;  Press the right arrow key twice, then type a colon (:)
	SendInput {Right}{Right}: ;  Press the right arrow key twice, then type a colon (:)
	SendInput {Right}{Right}: ;  Press the right arrow key twice, then type a colon (:)
	SendInput {Right}{Right}: ;  Press the right arrow key twice, then type a colon (:)
	SendInput {Right}{Right}: ;  Press the right arrow key twice, then type a colon (:)
Return
