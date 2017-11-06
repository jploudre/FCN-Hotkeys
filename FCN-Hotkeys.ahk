﻿; Setup #########################################

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Window
#Persistent
SetKeyDelay, 30

FirstRun()
IniRead, Buddy, Settings.ini, Preferences, Buddy
YourBuddyName = %Buddy%
RWin::return
LWin::return
Menu, Tray, NoStandard
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Add, Exit, ExitScript
return

FirstRun(){
IfNotExist, Settings.ini
{
InputBox, BuddyName, Who's your Buddy?,
(

Who do you 'hold' things to most frequently
in Centricity?

Typically this might be your CAs last name...
), , 300, , , , , , 
if (Errorlevel= 0) {
IniWrite, %BuddyName%, Settings.ini, Preferences, Buddy
MsgBox, 64, Thanks,
(
If this is your first time:
    

   - Did you get some stickers for your keyboard?



)

}
}
}

ExitScript:
ExitApp
return

ReloadScript:
Reload
Return

; Hotkeys #########################################

`::
If WinActive("Update -") {
	WinActivate, Chart
	Exit
}
If WinActive("Chart Desktop -") {
	IfWinExist, Update 
	{
		WinActivate, Update
		Exit
	}
	IfWinNotExist, Update 
	{
		If (ImageMouseMove("chart")) {
			Click
			Exit
		}
	}
}
If WinActive("Chart -") {
	IfWinExist, Update 
	{
		WinActivate, Update
		Exit
	}
	IfWinNotExist, Update 
	{
		If (ImageMouseMove("chart-desktop")) {
			Click
			Exit
		}
	}
} else {
	ifWinExist, Update -
		WinActivate, Update -
	ifWinExist, Chart Desktop -
		WinActivate, Chart Desktop -
	IfWinExist, Chart -
		WinActivate, Chart -
}
return

\::PatternHotKey(".->End", "..->EndDouble")
return

End:
IfWinActive, End Update -
{
	Send !o
	Exit
}
IfWinActive, Update -
{
	gosub, EndUpdate
	Exit
}
return

EndDouble:
IfWinActive, Update -
{
	gosub, EndUpdate
	WinWaitActive, End Update -, , 5
	if (ErrorLevel = 0) {
        gosub, SendtoBuddy
	}
} 
IfWinActive, End Update -
{
    gosub, SendtoBuddy
}    
else {
	return
}
return

EndUpdate:
Send ^e
WinWaitActive, End Update, , 3
; Sometimes Fails, Try a few times?
if (ErrorLevel = 1) {
	Send ^e
	WinWaitActive, End Update, , 2
	if (ErrorLevel = 1) {
		Send ^e
	}
}
return

SendtoBuddy:
Send !n
WinWaitActive, New Routing Information, , 3
if (ErrorLevel = 0) {
    Send %YourBuddyName%
    Sleep, 100
    ; Citrix loses window focus so use tab to go through controls. 
    Send {Enter}{Tab 9}{Enter}
    WinWaitActive, End Update -, , 3
    if (ErrorLevel =0) {
        Send !o
        WinWaitActive, Chart -, , 15
        if (ErrorLevel = 0) {
            Sleep, 1000
            If (ImageMouseMove("chart-desktop")) {
                Click
                Exit
            }
        }
    }
}
return

#c::

return

#s::

return

;Space::
;Send {Space}
;return

~::
scaledclick(100, 200)
return

; Functions #########################################

; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey
; Usage : hotkey::PatternHotKey("command1", ["command2", "command3", length(integer), period(float)])
;     where commands match one of the following formats:
;         "pattern:keys"                  ; Maps pattern to send keys
;         "pattern->label"                ; Maps pattern to label (GoSub)
;         "pattern->function()"           ; Maps pattern to function myfunction with
;                                           no parameter
;         "pattern->function(value)"      ; Maps pattern to function myfunction with
;                                           the first parameter equal to 'value'
;         and patterns match the following formats:
;             '.' or '0' represents a short press
;             '-' or '_' represents a long press of any length
;             '?' represents any press
PatternHotKey(arguments*)
{
    period = 0.2
    length = 1
    for index, argument in arguments
    {
        if argument is float
            period := argument, continue
        if argument is integer
            length := argument, continue
        separator := InStr(argument, ":", 1) - 1
        if ( separator >= 0 )
        {
            pattern   := SubStr(argument, 1, separator)
            command    = Send
            parameter := SubStr(argument, separator + 2)
        }
        else
        {
            separator := InStr(argument, "->", 1) - 1
            if ( separator >= 0 )
            {
                pattern := SubStr(argument, 1, separator)

                call := Trim(SubStr(argument, separator + 3))
                parenthesis := InStr(call, "(", 1, separator) - 1
                if ( parenthesis >= 0 )
                {
                    command   := SubStr(call, 1, parenthesis)
                    parameter := Trim(SubStr(call, parenthesis + 1), "()"" `t")
                }
                else
                {
                    command    = GoSub
                    parameter := call
                }
            }
            else
                continue
        }

        if ( Asc(pattern) = Asc("~") )
            pattern := SubStr(pattern, 2)
        else
        {
            StringReplace, pattern, pattern, ., 0, All
            StringReplace, pattern, pattern, -, [1-9A-Z], All
            StringReplace, pattern, pattern, _, [1-9A-Z], All
            StringReplace, pattern, pattern, ?, [0-9A-Z], All
            pattern := "^" . pattern . "$"
            if ( length < separator )
                length := separator
        }

        patterns%index%   := pattern
        commands%index%   := command
        parameters%index% := parameter
    }
    keypress := KeyPressPattern(length, period)
    Loop %index%
    {
        pattern   := patterns%A_Index%
        command   := commands%A_Index%
        parameter := parameters%A_Index%

        if ( pattern && RegExMatch(keypress, pattern) )
        {
            if ( command = "Send" )
                Send % parameter
            else if ( command = "GoSub" and IsLabel(parameter) )
                gosub, %parameter%
            else if ( IsFunc(command) )
                %command%(parameter)
        }
    }
}

KeyPressPattern(length = 2, period = 0.2)
{
    key := RegExReplace(A_ThisHotKey, "[\*\~\$\#\+\!\^]")
    IfInString, key, %A_Space%
        StringTrimLeft, key, key, % InStr(key, A_Space, 1)
    if key in Alt,Ctrl,Shift,Win
        modifiers := "{L" key "}{R" key "}"
    current = 0
    loop
    {
        KeyWait %key%, T%period%
        if ( ! ErrorLevel )
        {
            pattern .= current < 10
                       ? current
                       : Chr(55 + ( current > 36 ? 36 : current ))
            current = 0
        }
        else
            current++
        if ( StrLen(pattern) >= length )
            return pattern
        if ( ! ErrorLevel )
        {
            if ( key in Capslock, LButton, MButton, RButton or Asc(A_ThisHotkey) = Asc("$") )
            {
                KeyWait, %key%, T%period% D
                if ( ErrorLevel )
                    return pattern
            }
            else
            {
                Input,, T%period% L1 V,{%key%}%modifiers%
                if ( ErrorLevel = "Timeout" )
                    return pattern
                else if ( ErrorLevel = "Max" )
                    return
                else if ( ErrorLevel = "NewInput" )
                    return
            }
        }
    }
}

; If found, moves mouse, returns boolean.
; Currently searches all screen (not window)
; TODO: Search others besides 100% Screen Magnification

ImageMouseMove(imagename, x1:=-2000, y1:=-2000, x2:=0, y2:=0){
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImagePathandName := A_ScriptDir . "\files\" . imagename . ".PNG"
    if (x1 = -2000 AND y1 = -2000 AND x2 = 0 AND y2 = 0) {
    ImageSearch, FoundX, FoundY, x1, y1, %A_ScreenWidth%, %A_ScreenHeight%, *n10 %ImagePathandName%
    } else {
    ImageSearch, FoundX, FoundY, x1, y1, x2, y2, *n10 %ImagePathandName%
    }
    if (ErrorLevel = 0) {
        MouseMove, %FoundX%, %FoundY%
        CoordMode, Pixel, Window
        CoordMode, Mouse, Window
        return 1
    }
    CoordMode, Pixel, Window
    CoordMode, Mouse, Window
    ; If image is not found, probably do not continue Hotkey that called. 
    if (ErrorLevel = 1) {
        return 0
    }
}