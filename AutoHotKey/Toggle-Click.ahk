#Requires AutoHotkey v2.0

clickHeld := false
OnExit ReleaseHeldClick

^LButton::
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
