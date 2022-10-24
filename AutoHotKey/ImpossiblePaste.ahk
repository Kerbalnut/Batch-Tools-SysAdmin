#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
MsgBox,
	(LTrim
		Impossible Paste: Paste text into locked fields that block clipboard access by allowing AHK to type it via HID instead.
		
		1. Copy text normally (Ctrl+C).
		2. Ctrl+Shift+V for Impossible Paste.
		
		To stop this script, right-click the AutoHotKey icon in the TaskBar notification tray, and select 'Pause Script' or 'Exit'.
	) ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

;ClipSaved := ClipboardAll 

;tesing

;ClipSaved := ClipboardAll   ; Save the entire clipboard to a variable of your choice.
; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
;Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
;ClipSaved := ""   ; Free the memory in case the clipboard was very large.


;clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
;Send ^c

;OnClipboardChange(Func [, AddRemove])
;
;FunctionName(Type)
;Add(x, y)
;{
;    return x + y   ; "Return" expects an expression.
;}

;ConfirmClip(Type)
;{
;	MsgBox Ctrl+Shift+V for Impossible Paste.`n`nCopied the following text to clipboard:`n`n%ClipSaved%`n`n%clipboard%`n`n%Type%
;}
;
;OnClipboardChange(ConfirmClip(1),1)
;
;Return


;; Detect copy
;^c:: ; Wait for Ctrl+C
;	clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
;	Send ^c
;	ClipWait, 5, 0  ; Wait for the clipboard to contain text.
;	ClipSaved := clipboard
;	MsgBox Ctrl+Shift+V for Impossible Paste.`n`nCopied the following text to clipboard:`n`n%ClipSaved%`n`n%clipboard%
;Return

; Paste
^+v:: ; Ctrl+Shift+V to activate
	;Send, %ClipSaved% ; Sends the contents of the %ClipSaved% variable to the AHK HID keyboard.
	SendInput %Clipboard% ; Sends the contents of the %ClipSaved% variable to the AHK HID keyboard.
Return



