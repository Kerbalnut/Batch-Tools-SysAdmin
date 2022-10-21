	killrepeat := false
	framecount := 0
	MsgBox % "Startup. `nAlt-c to Start Counting. `nAlt-d to Stop. `nAlt-z for Status Update. `nFrame count: " . framecount . ". `nKill repeat: " . killrepeat . "."   ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "." And `n indicates a linefeed character. For breaking up even longer text, see MsgBox continuation section.
Return


!d:: ; Stop the loop.
	killrepeat := true
	Sleep 100  ; The number of milliseconds between keystrokes
	framecount -= 1
	SendInput a ;
	Sleep 150  ; The number of milliseconds between keystrokes
	SendInput o ;
	Sleep 150  ; The number of milliseconds between keystrokes
	MsgBox % "Framecount halted. `nFinal count at mark: " . framecount . "." ; A period is used to concatenate (join) two strings.
Return


!c:: ; Start counting.
While killrepeat = false
{
	framecount += 1
	SendInput s ; since sending this activates this hotkey activates this function again, it creates a loop.
	Sleep 400  ; The number of milliseconds between keystrokes
	if killrepeat = true
	{
		break
	}
}
Return

!z:: ; Status Update.
	MsgBox % "Frame count: " . framecount . ". `nKill repeat: " . killrepeat . "." ; A period is used to concatenate (join) two strings.
Return
