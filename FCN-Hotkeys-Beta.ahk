; Setup #########################################
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
#SingleInstance force
#Persistent
SetKeyDelay, 30

Menu, Tray, NoStandard
Menu, Tray, Add, Edit Buddy, EditBuddy
Menu, Tray, Add, Reload, ReloadScript
Menu, Tray, Add, Exit, ExitScript
Menu, Tray, Icon, %SetWorkingDir%\files\favicon.ico
Menu, Tray, Default, Edit Buddy

FirstRun()
IniRead, Buddy, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
YourBuddyName = %Buddy%
return

FirstRun(){
IfNotExist, Z:\FCN-Macro-Settings.ini
    {
    InputBox, BuddyName, Who's your Buddy?,
    (

    Who do you 'hold' things to most frequently
    in Centricity?

    Typically this might be your CAs last name...
    ), , 300, , , , , , 
    if (Errorlevel= 0) {
        IniWrite, %BuddyName%, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
        SplashImage, %SetWorkingDir%\files\edit-buddy-help.png, B2 ZH200 ZW-1 FM24 FS18 C0, Later look for the FCN Logo to change your buddy., Thanks!
        Sleep 8000
        SplashImage, Off
        }
    }
}
return

EditBuddy:
IniRead, Buddy, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
InputBox, BuddyName, Who's your Buddy?,
    (

    Who do you 'hold' things to most frequently
    in Centricity?

    Typically this might be your CAs last name...
    ), , 300, , , , , , %Buddy%
    if (Errorlevel= 0) {
        IniWrite, %BuddyName%, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
        }
return

ExitScript:
ExitApp
return

ReloadScript:
Reload
Return

; Hotkey Logic #########################################

\::PatternHotKey(".->End", "..->EndDouble")
return

;$Space::PatternHotKey(".->SingleSpace", "..->DoubleSpace")
;return

`::
If WinActive("Update") {
	WinActivate, Chart
}
else If WinActive("Chart Desktop") {
	If WinExist("Update") { 
		WinActivate, Update
	} else {
		If (ImageMouseMove("chart")) {
			Click
		}
	}
} 
else If WinActive("Chart") {
	If WinExist("Update") { 
		WinActivate, Update
	} else {
		If (ImageMouseMove("chart-desktop")) {
			Click
		}
	}
} 
else {
    If WinExist("Update") {
        WinActivate, Update
        Exit
    }
	If WinExist("Chart") {
        WinActivate, Chart
        Exit
    }
	If WinExist("Chart Desktop") {
        WinActivate, Chart Desktop
        Exit
    }
}
return

~c::
if WinActive("Chart Desktop"){
	If (ImageMouseMove("append")) {
    	Keywait, c
    	Click
    	CreateCPOEAppend()
    	exit
	}

} else if WinActive("Chart"){
	If (ImageMouseMove("append-chart")) {
    	Keywait, c
    	Click
    	CreateCPOEAppend()
    	exit
	}
} else if WinActive("Centricity Practice Solution Browser"){
	Keywait, c
	Send !{F4}
	Sleep, 200
	IfWinExist, Chart Desktop
    WinActivate, Chart Desktop
	IfWinExist, Chart
    WinActivate, Chart
    Sleep, 200
	If (ImageMouseMove("append")) {
    	Click
    	CreateCPOEAppend()
	}
	if (imageMouseMove("append-chart")) {
    	Click
    	CreateCPOEAppend()
	}
return
}
return

; I'm Done
^Space::
If WinActive("End Update") {
    gosub, SignUpdateBackToDesktop
}
else If WinActive("Append to Document") {
	Send !s
    Sleep, 100
    If (ImageMouseMove("chart-desktop")) {
        Click
    }
}
else If WinActive("Care Alert Warning") {
	Send !c
}
else If WinActive("Update Problems") {
	Click, 890, 580
}
else If WinActive("Update Medications") {
	Click, 558, 543
}
else If WinActive("Update Orders") {
	Click, 549, 641
}
else If WinActive("Update") {
	gosub, EndUpdate
    gosub, SignUpdateBackToDesktop
}
else If WinActive("Customize Letter") {
	Send !p
	WinWaitNotActive, Customize Letter, , 10
	if (ErrorLevel = 0) {
    	Sleep, 100
    	WinWaitActive, Customize Letter, , 30
    	if (ErrorLevel = 0) {
        	Sleep, 100
        	Send !s
        	WinWaitActive, Route Document, , 30
        	if (ErrorLevel = 0) {
            	Sleep, 100
            	Send !s
            	WinWaitActive, Print, , 30
            	if (ErrorLevel = 0) {
                	Sleep, 100
                	Click 568, 355
            	}	
        	}
        }
    }
} else if WinActive("Centricity Practice Solution Browser"){
	Send !{F4}
	Sleep, 200
	IfWinExist, Chart Desktop
    WinActivate, Chart Desktop
	IfWinExist, Chart
    WinActivate, Chart
    Sleep, 200
	If (ImageMouseMove("sign-chart")) {
    	Click
	}
	if (imageMouseMove("sign-chart-desktop")) {
    	Click
	}
} 
else {
    return
}
return

#IfWinActive, Update Med

F2::
gosub, UpdateMedSearch
return

#IfWinActive

#IfWinActive, Update Prob

F3::
Send !n
return

#IfWinActive

#IfWinActive, Update Orde

F3::
Click, 650, 237
return

#IfWinActive


#IfWinActive, Update -

F1::PatternHotKey(".->OrderSearch")
F2::PatternHotKey(".->UpdateMeds", "..->MedSearch")
F3::PatternHotKey(".->UpdateProblems", "..->ProblemSearch")

#IfWinActive




; Hotkey Functions #########################################


OrderSearch:
Click, 254, 38
WinWaitActive, Update Orders, , 3
if (ErrorLevel = 0) {
    CitrixSleep()
    Click, 263, 269
    CitrixSleep()
    Click 406, 313
}
return

MedSearch:
Click, 350, 38
WinWaitActive, Update Medications, , 3
if (ErrorLevel = 0) {
	GoSub, UpdateMedSearch
}
return

UpdateMedSearch:
CitrixSleep()
Send !n
WinWaitActive, New Medication, , 3
if (ErrorLevel = 0) {
	CitrixSleep()
	Click, 712, 65
	WinWaitActive, Find Medication, , 5
	If (ErrorLevel = 1) {
	exit
	}
}
return

UpdateMeds:
Click, 350, 38
return

ProblemSearch:
Click, 428, 38
WinWaitActive, Update Problems, , 3
if (ErrorLevel = 0) {
	CitrixSleep()
	Send !n
}
return

UpdateProblems:
Click, 428, 38
return


CitrixSleep(){
Sleep, 150
}
return

SingleSpace:
If WinActive("Update") {
    send {Space}
    exit
} else If WinActive("Centricity Practice Solution Browser") {
    gosub, BrowserPageDown
} else If WinActive("Chart Desktop") {
    ControlClick, Button3
} else {
    Send {Space}
}
return

DoubleSpace:
If WinActive("Update") {
    send {Space 2}
    exit
}
If WinActive("Centricity Practice Solution Browser") {
    gosub, BrowserCloseandSign
} else {
    Send {Space 2}
}

return

BrowserPageDown:
WinGetPos , , , WinWidth, WinHeight, A
xclick := WinWidth - 18
yclick := WinHeight -30
Click, %xclick%, %yclick%
return

BrowserCloseandSign:
Send !{F4}
Sleep, 500
If WinExist("Chart Desktop"){
    WinActivate, Chart Desktop
    sleep, 150
    If (ImageMouseMove("sign-chart-desktop")) {
        Click
    }
}
return

End:
If WinActive("End Update") {
	Send !o
}
else If WinActive("Update") {
	gosub, EndUpdate
}
else If WinActive("Centricity Practice Solution Browser") {
    Send !{F4}
}
else If WinActive("Route Document") {
    Send !r
}
else {
    return
}
return

EndDouble:
If WinActive("Update") {
	gosub, EndUpdate
	WinWaitActive, End Update, , 5
	if (ErrorLevel = 0) {
        gosub, SendtoBuddy
	}
} 
else If WinActive("End Update") {
    gosub, SendtoBuddy
}   
else {
	return
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
    WinWaitActive, End Update, , 3
    if (ErrorLevel =0) {
        Send !o
        WinWaitActive, Chart, , 15
        if (ErrorLevel = 0) {
            If (ImageMouseMove("chart-desktop")) {
                Sleep, 800
                Click
            }
        }
    }
}
return

SignUpdateBackToDesktop:
Send !m
Send !m
Send !m
Send !m
Send !s
WinWaitActive, Chart, , 15
if (ErrorLevel = 0) {
    Sleep, 500
    If (ImageMouseMove("chart-desktop")) {
        Click
    }
}
return

EndUpdate:
Send ^e
; Sometimes Fails, Try a few times?
WinWaitActive, End Update, , 3
if (ErrorLevel = 1) {
	Send ^e
	WinWaitActive, End Update, , 2
	if (ErrorLevel = 1) {
		Send ^e
	}
}
sleep, 300
return

CreateCPOEAppend(){
WinWaitActive, Append to, , 3
    if (ErrorLevel = 0) {
        Sleep, 100
        Send !F
        WinWaitActive, Append Document, , 7
        if (ErrorLevel = 0) {
            Sleep, 100
            Send CPOE{Enter}
            WinWaitActive, Update, , 20
            if (ErrorLevel = 0) {
                Sleep, 500
                Send {F8}
				Exit
            }
        }
    }
}

ImageMouseMove(imagename, x1:=-2000, y1:=-2000, x2:=0, y2:=0){
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImagePathandName := A_ScriptDir . "\files\" . imagename . ".PNG"
    if (x1 = -2000 AND y1 = -2000 AND x2 = 0 AND y2 = 0) {
    ImageSearch, FoundX, FoundY, x1, y1, %A_ScreenWidth%, %A_ScreenHeight%, *n20 %ImagePathandName%
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
    if (ErrorLevel = 2) {
        MsgBox, Missing Image File. 
        return 0
    }
}

; Downloaded Functions #########################################
; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey
;         "pattern->label"                ; Maps pattern to label (GoSub)
;         and patterns match the following formats:
;             '.' or '0' represents a short press
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
