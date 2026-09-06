#Warn  ; Enable warnings to assist with detecting common errors.
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir A_InitialWorkingDir  ; Ensures a consistent starting directory. (Forces the script to use the folder it was initially launched from as its working directory.)
msgboxtitle := "Right-Shift Tab shortcut enabled"
message := '
    (
        Right-Shift Tab shortcut enabled.

        Pressing the RightShift key will now also type Tab.

        (To stop this script, right-click the AutoHotKey icon in the TaskBar notification tray, and select "Pause Script" or "Exit".)
    )'
; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
MsgBox Format(message, msgboxtitle)
;Return

; Author: Kerbalnut
; https://github.com/Kerbalnut/Batch-Tools-SysAdmin
; https://github.com/Kerbalnut/ScrapingSharepointTimesNotes

; !+v:: ; Alt+Shift+V to activate
; ^!v:: ; Ctrl+Alt+V to activate
; ^+v:: ; Ctrl+Shift+V to activate
RShift:: ; Right-Shift activate
{
	SendInput "{Tab}" ;  Types the Underscore (_) character
}
Return
