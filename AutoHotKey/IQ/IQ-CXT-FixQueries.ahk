
!d:: ; Lookup next query. (Alt + D)
	Sleep 100  ; The number of milliseconds between keystrokes
	SendInput ! ; Press the "Alt" key
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput f ; Press the "F" key
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput l ; Press the "L" key
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput +{TAB 2} ; Presses Shift-Tab 2 times.
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput Add a stop to route SAL ; Types "Add a stop to route SAL".
	Sleep 250  ; The number of milliseconds between keystrokes
	SendInput +{TAB} ; Presses "Shift + Tab".
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput {Home} ; Presses the "Home" key on keyboard.
Return

!e:: ; Fix Query. (Alt + E)
	Sleep 100  ; The number of milliseconds between keystrokes
	SendInput {Alt} ; Press the "Alt" key
	Sleep 300  ; The number of milliseconds between keystrokes
	Send ^q ; Presses "Ctrl + Q".
	Sleep 600  ; The number of milliseconds between keystrokes
	SendInput +{TAB} ; Presses "Shift + Tab".
	Sleep 500  ; The number of milliseconds between keystrokes
	SendInput EXEC{Space} ; Types "EXEC ".
	Sleep 450  ; The number of milliseconds between keystrokes
	SendInput +{TAB 2} ; Presses Shift-Tab 2 times.
	Sleep 450  ; The number of milliseconds between keystrokes
	SendInput {Enter} ; Presses the Enter key.
	Sleep 600  ; The number of milliseconds between keystrokes
	Send {Alt} ; Press the "Alt" key
	Sleep 400  ; The number of milliseconds between keystrokes
	SendInput f ; Press the "F" key
	Sleep 450  ; The number of milliseconds between keystrokes
	SendInput q ; Press the "Q" key
	Sleep 700  ; The number of milliseconds between keystrokes
	SendInput {Enter} ; Presses the Enter key.
	Sleep 450  ; The number of milliseconds between keystrokes
	SendInput {Enter} ; Presses the Enter key.
Return
