 ; WARNING: For whatever reason {Enter} correctly sends the return key to most applications, except Notepad++
 ; Test the script in regular Notepad to see if it works, or a blank version of the same application.

	MsgBox Notepad++ Find-and-Replace (2 spaces) function `n`nCtrl-Shift-X = to activate Part 1 of Find-and-Replace function. `nAlt-D = to activate Part 2 of Find-and-Replace function. ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "." And `n indicates a linefeed character. For breaking up even longer text, see MsgBox continuation section.
Return

^+x:: ; Ctrl-Shift-X to activate Part 1 of Find-and-Replace function. 
	SendInput, {Home}{ShiftDown}{End}{ShiftUp} ; This presses keys: Home, holds down Shift, End, releases Shift - (Select entire line)
	Sleep 150  ; The number of milliseconds between keystrokes
	
	SendInput, {CtrlDown}{c}{h}{CtrlUp}{Tab} ; This presses keys: holds down Ctrl, C, H, releases Ctrl, Tab = (Ctrl+C = Copy to clipboard), (Ctrl+H = Replace)
	Sleep 150  ; The number of milliseconds between keystrokes
	
	SendInput, {CtrlDown}{v}{CtrlUp} ; This presses keys: holds down Ctrl, V, releases Ctrl = Ctrl+V (Paste from clipboard)
	;Send ^v ; This presses keys: Ctrl+V (Paste from clipboard)
	Sleep 150  ; The number of milliseconds between keystrokes
	
	SendInput, {Home}{Right}{Right}{Delete} ; This presses keys: Home, Right Arrow, Delete
	Sleep 150  ; The number of milliseconds between keystrokes
	
Return

!d:: ; Alt-D to activate Part 2 of Find-and-Replace function. 
	SendInput, {CtrlDown}{a}{CtrlUp} ; This presses keys: holds down Ctrl, A, releases Ctrl = Ctrl+A (Select All)
	;Send ^a ; This presses keys: Ctrl+A (Select All)
	Sleep 150  ; The number of milliseconds between keystrokes
	
	SendInput, {CtrlDown}{c}{CtrlUp} ; This presses keys: holds down Ctrl, C, releases Ctrl = Ctrl+C (Copy to clipboard)
	;Send ^c ; This presses keys: Ctrl+C (Copy to clipboard)
	Sleep 150  ; The number of milliseconds between keystrokes
	
	SendInput, {Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab} ; This presses keys: Tab x10 times
	Sleep 150  ; The number of milliseconds between keystrokes
	
	Sleep 500  ; The number of milliseconds between keystrokes
	
	SendInput, {Enter} ; This presses keys: Enter
	Sleep 150  ; The number of milliseconds between keystrokes
	
	Sleep 1000  ; The number of milliseconds between keystrokes
	
	SendInput, {Escape} ; This presses keys: Esc
	Sleep 150  ; The number of milliseconds between keystrokes
	
	Sleep 500  ; The number of milliseconds between keystrokes
	
	SendInput, {Down}{Home} ; This presses keys: Down Arrow, Home
	Sleep 150  ; The number of milliseconds between keystrokes
	
Return



