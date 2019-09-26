	killrepeat := false
	MsgBox % "Trim frames: Alt-z to execute. `nAlt-d or Alt-~ to try to stop." ; A period is used to concatenate (join) two strings, and % is used to designate a expression. E.g.: MsgBox % "Kill repeat: " . killrepeat . "." And `n indicates a linefeed character. For breaking up even longer text, see MsgBox continuation section.
Return

!d:: ; Stop the loop.
	killrepeat := true
	MsgBox % "Operation halted."
Return

!`:: ; Stop the loop, while in Notepad editor
	killrepeat := true
	MsgBox % "Operation halted."
Return

!z::
Loop 29
{
	Send ..is{Delete} ; Periods set the fps.
	Sleep 900  ; The number of milliseconds between keystrokes
	if killrepeat = true
	{
		break
		Return
	}
}
Return

 ; Old Version, still works:
 ; 
 ; !z::
 ; 		totalcycles := 1
 ; 		SetTimer, FramerateRepeat, 1000
 ; Return
 ; 
 ; FramerateRepeat:
 ; if (totalcycles <> 60)
 ; {
 ; 		send, ...is{Delete} ; a comment.
 ; 		totalcycles += 1
 ; }
 ; Return
 
 