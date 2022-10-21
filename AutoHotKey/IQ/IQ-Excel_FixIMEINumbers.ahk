 ; WARNING: For whatever reason {Enter} correctly sends the return key to most applications, except Notepad++
 ; Test the script in regular Notepad to see if it works, or a blank version of the same application.
 
 ; A script for auto-filling a lot of bullshit data into an Access table. 
 ; Got good speed out of adding data so set it fast. 
 ; Luckily there is no extra keypress to edit so it's simple too. 

	MsgBox Startup. `nCtrl-Shift-X to activate for sequences like: "8914 8000 0014 7517 1418". `nAlt-D  to activate for sequences like: "9900 0483 3818 374". ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "." And `n indicates a linefeed character. For breaking up even longer text, see MsgBox continuation section.
Return

^+x:: ; Ctrl-Shift-X to activate for sequences like: "8914 8000 0014 7517 1418".
 ; 	Send, {F2}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{Left}{BS}{Left}{Left}{Left}{Left}{BS}{Left}{Left}{Left}{Left}{BS}{Enter} ; This presses keys F2, (Left Arrow (x4), Backspace) x4 times, and then Enter.
	SendInput, {F2}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{Left}{BS}{Left}{Left}{Left}{Left}{BS}{Left}{Left}{Left}{Left}{BS}{Enter} ; This presses keys F2, (Left Arrow (x4), Backspace) x4 times, and then Enter.
	Sleep 150  ; The number of milliseconds between keystrokes
Return

!d:: ; Alt-D to activate for sequences like: "9900 0483 3818 374".
	SendInput, {F2}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{Left}{Backspace}{Left}{Left}{Left}{Left}{Backspace}{Enter} ; This presses keys F2, Left Arrow (x3), Backspace, Left Arrow (x4), Backspace, Left Arrow (x4), Backspace, and then Enter.
	Sleep 150  ; The number of milliseconds between keystrokes
Return

