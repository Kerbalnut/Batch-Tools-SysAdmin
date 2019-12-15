 ; WARNING: For whatever reason {Enter} correctly sends the return key to most applications, except Notepad++
 ; Test the script in regular Notepad to see if it works, or a blank version of the same application.
 
 ; A script for auto-filling a lot of bullshit data into an Access table. 
 ; Got good speed out of adding data so set it fast. 
 ; Luckily there is no extra keypress to edit so it's simple too. 

	MsgBox Startup. `nCtrl-Shift-X to activate for sequences like: "(602) 586-7342". `nAlt-D  to activate for sequences like: "602-586-7342". ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "." And `n indicates a linefeed character. For breaking up even longer text, see MsgBox continuation section.
Return

^+x:: ; Ctrl-Shift-X to activate for sequences like: "(602) 586-7342".
 ; 	Send, {F2}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{BS}{BS}{Left}{Left}{Left}{BS}{BS}{Enter} ; This presses keys F2, Left Arrow (x4), Backspace, Left Arrow (x3), Backspace (x2), Left Arrow (x3), Backspace (x2), and then Enter.
	SendInput, {F2}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{BS}{BS}{Left}{Left}{Left}{BS}{BS}{Enter} ; This presses keys F2, Left Arrow (x4), Backspace, Left Arrow (x3), Backspace (x2), Left Arrow (x3), Backspace (x2), and then Enter.
	Sleep 150  ; The number of milliseconds between keystrokes
Return

!d:: ; Alt-D to activate for sequences like: "602-586-7342".
	SendInput, {F2}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{Backspace}{Enter} ; This presses keys F2, Left Arrow (x4), Backspace, Left Arrow (x3), Backspace, and then Enter.
	Sleep 150  ; The number of milliseconds between keystrokes
Return

