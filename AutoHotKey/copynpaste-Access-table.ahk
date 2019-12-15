 ; WARNING: For whatever reason {Enter} correctly sends the return key to most applications, except Notepad++
 ; Test the script in regular Notepad to see if it works, or a blank version of the same application.
 
 ; A script for auto-filling a lot of bullshit data into an Access table. 
 ; Got good speed out of adding data so set it fast. 
 ; Luckily there is no extra keypress to edit so it's simple too. 

	MsgBox Startup. Alt-Z to activate. ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "."
Return

!z:: ; Alt-Z to activate
Loop 130 ; WARNING! When using a Loop, don't forget you can't click away from the application while it types.
{
	Send, ^v{Enter} ; This pastes the clipboard (Ctrl+V) and hits Return.
	Sleep 200  ; The number of milliseconds between keystrokes.
}
Return

