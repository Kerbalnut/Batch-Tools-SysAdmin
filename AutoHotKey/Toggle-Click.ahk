#Requires AutoHotkey v2.0

clickHeld := false
OnExit ReleaseHeldClick

; ^LButton:: ; Ctrl+LeftClick to activate
; ^+LButton:: ; Ctrl+Shift+LeftClick to activate
; !LButton:: ; Alt+LeftClick to activate
^+LButton:: ; Ctrl+Shift+LeftClick to activate
{
    global clickHeld
    clickHeld := !clickHeld
    if clickHeld
        Send "{LButton down}"
    else
        Send "{LButton up}"
}

#HotIf clickHeld
*LButton Up::return
#HotIf

ReleaseHeldClick(*)
{
    global clickHeld
    if clickHeld
        Send "{LButton up}"
}
