Setup()
return

; Locations and Hotkeys #########################################

#IfWinActive, Update Med
    F2::UpdateMedSearch()
    ^Space::Click, 558, 543


#IfWinActive, New Medication
    ^Space::Click, 686, 659


#IfWinActive, Update Prob
    F3::Send !n
    ^Space::Click, 890, 580


#IfWinActive, Edit Problem
    ^Space::Click, 419, 538


#IfWinActive, New Problem
    ^Space::Click, 420, 537
    
    
#IfWinActive, Update Orde
    F3::Click, 650, 237
    ^Space::Click, 549, 641


#IfWinActive, End Update
    \::PatternHotKey(".->End()", "..->EndDouble()")
    ^Space::SignUpdateBackToDesktop()


#IfWinActive, Update -
    F1::PatternHotKey(".->OrderSearch()")
    F2::PatternHotKey(".->UpdateMeds()", "..->MedSearch()")
    F3::PatternHotKey(".->UpdateProblems()", "..->ProblemSearch()")
    `::WinActivate, Chart
    \::PatternHotKey(".->End()", "..->EndDouble()")
    ^Space::
    	EndUpdate()
        SignUpdateBackToDesktop()
        return
    !c::GoCPOEForm()
        

#IfWinActive, Care Alert Warning
    ^Space::Send !c
    
    
#IfWinActive, Append to Document
    ^Space::
        Send !s
        GoChartDesktop()
        return
        
        
#IfWinActive, New Alert/Flag
     ^Space::Send !s


#IfWinActive, Forward Flag
     ^Space::Send !s


#IfWinActive, Reply Flag
     ^Space::Send !s


#IfWinActive, Customize Letter
    ^Space::LetterPrintAndSign()


#IfWinActive, Change Medication
    ^Space::Click, 683, 652


#IfWinActive, Route Documen
    \::Send !r


#IfWinActive, Centricity Practice Solution Brow
    \::Send !{F4}
    Space::PatternHotKey(".->BrowserPageDown()", "..->BrowserCloseandSign()")    
    $c::AttachmentCPOEAppend()
    ^Space::AttachmentSign()


#IfWinActive, Chart Deskto
    ;#$Space::PatternHotKey(".->SingleSpace()", "..->DoubleSpace()")
    `::ChartDesktopSwap()
    $c::ChartDesktopCPOEAppend()
    $l::send l
        

#IfWinActive


SetTitleMatchMode, 3
#IfWinActive, Chart
    `::ChartSwap()
    c::ChartCPOEAppend()
    F5::ChartNewPhoneNote()
    l::LettertoCustomize()
#IfWinActive
SetTitleMatchMode, 1
; Hotkey Functions #########################################

Setup(){
    global
    #NoEnv
    SendMode Input
    SetWorkingDir %A_ScriptDir%
    CoordMode, Mouse, Window
    #SingleInstance force
    #Persistent
    SetKeyDelay, 100

    Menu, Tray, NoStandard
    Menu, Tray, Add, Edit Buddy, EditBuddy
    Menu, Tray, Add, Reload, ReloadScript
    Menu, Tray, Add, Exit, ExitScript
    Menu, Tray, Icon, %SetWorkingDir%\files\favicon.ico
    Menu, Tray, Default, Edit Buddy

    SplashImage, %SetWorkingDir%\files\FCN-macros.png,B2 FS18 C0, 
    Sleep, 700
    SplashImage, Off

    FirstRun()
    IniRead, Buddy, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
    FormatTime, login_date,, ShortDate
    login_telemetry := A_UserName . "," . login_date
    telemetry_file := "\\fcnjboss01\AHK_Telemetry$\" . A_UserName . ".csv"
    FileAppend, %login_telemetry%`n, %telemetry_file%
    return
}

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
        Reload
        }
return

ExitScript:
ExitApp
return

ReloadScript:
Reload
Return

SwitchDocumentFocus(){
    ControlGetFocus, chartfocus
    if (chartfocus = "SysTreeView322") {
        ControlFocus, "SftTreeControl701"
    }
}

OrderSearch(){
    Click, 254, 38
    WinWaitActive, Update Orders, , 3
    if (ErrorLevel = 0) {
        sleep, 150
        Click, 263, 269
        sleep, 150
        Click 406, 313
    }
}

MedSearch(){
    Click, 350, 38
    WinWaitActive, Update Medications, , 3
    if (ErrorLevel = 0) {
        UpdateMedSearch()
    }
}

UpdateMedSearch(){
    sleep, 150
    Send !n
    WinWaitActive, New Medication, , 3
    if (ErrorLevel = 0) {
        sleep, 150
        Click, 712, 65
        WinWaitActive, Find Medication, , 5
        If (ErrorLevel = 1) {
        exit
        }
    }
}

LetterPrintAndSign(){
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
}

AttachmentCPOEAppend(){
    Keywait, c
    Send !{F4}
    Sleep, 400
    IfWinExist, Chart Desktop
        WinActivate, Chart Desktop
    IfWinExist, Chart
        WinActivate, Chart
    Sleep, 400
    If (ImageMouseMove("append")) {
        Click
        CreateCPOEAppend()
    }
    if (imageMouseMove("append-chart")) {
        Click
        CreateCPOEAppend()
    }
}

ChartNewPhoneNote(){
	PixelSearch, clickx, clicky, 107, 69, 113, 75, 0x32CD32
	if not ErrorLevel { 
		Click, %clickx%, %clicky%
		WinWaitActive, Update, , 10
		if (ErrorLevel = 0) {
			Sleep, 300
			Send {Up 2}{Enter}
			Send .fd{Enter}
			Sleep, 300
			Send {Up 6}{Space}
			exit
		}
	}
}

AttachmentSign(){
    Send !{F4}
    Sleep, 400
    IfWinExist, Chart Desktop
        WinActivate, Chart Desktop
    IfWinExist, Chart
        WinActivate, Chart
    Sleep, 400
    If (ImageMouseMove("sign-chart")) {
        Click
    }
    if (imageMouseMove("sign-chart-desktop")) {
        Click
    }
}

GoChartDesktop(){
    sleep, 500
    Loop, 3
    {
        If (ImageMouseMove("chart-desktop")) {
            Click
            Sleep, 1000
        }
        IfWinActive, Chart Desktop
            break
    } 
}


LettertoCustomize(){
	global
	keywait, l
	WinGetPos, xpos, ypos, winwidth, winheight,Chart
	GUI -MinimizeBox -MaximizeBox
	GUI, font, s18 Calibri
	GUI, margin, 0, 0
	GUI, add, Listbox, sort x10 y10 w380 h230 gSubmitDoubleClick vLetterName,Blank Letter to Patient|Imaging (Not MBI)|Letters||Results Lab Letter|MBI|Physical Therapy
	GUI, font, s12 Calibri
	GUI, Add, Button, x200 y250 w190 Default, Customize Letter
	GUI, Add, Button, x10 y250 gButtonCancel , Cancel
	gui, font, s9 Calibri
	GUI, Add, Text, x10 y223,Hint: Type first letter then enter 
	guilocationx := xpos + (winwidth//2) - 200
	guilocationy := ypos + (winheight//2) - 145
	GUI, show, x%guilocationx% y%guilocationy% w400 h290 ,Letter to Customize:
}

SubmitDoubleClick:
if (A_GuiEvent = "Doubleclick"){
GoSub, ButtonCustomizeLetter
}
return

ButtonCancel:
GUI, Destroy
exit
return

GUIclose:
GUI, Destroy
exit
return

ButtonCustomizeLetter:
GUI, Submit
GUI, destroy
if (LetterName = "Blank Letter to Patient"){
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    ControlClick, MLogicListBox1
	    Sleep, 400
	    Send B
	    Sleep, 400
	    Click, 392, 351
	}
	exit
} else if (lettername = "Imaging (Not MBI)") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	Send i
	}
	exit
} else if (lettername = "Results Lab Letter") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    ControlClick, MLogicListBox1
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Click, 392, 351
	}
	exit
} else if (lettername = "MBI") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) { 
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	Send m
	    Sleep, 400
	Send {Down 4}
	}
	exit
} else if (lettername = "Letters") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down}
	    ControlClick, MLogicListBox1
	    Sleep, 400
	    Send p
	    Sleep, 400
	}
	exit
} else if (lettername = "Physical Therapy") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 400
	    Send l
	    Sleep, 400
	    Send {Down 2}
	    Sleep, 400
	    Send {Right 2}
	    Sleep, 400
	Send p
	    Sleep, 400
	Send {Down 5}

	}
	exit
} else {
exit
}
return

ChartOpenLetter(){
keywait, r
}

OpenPrintNav:
WinActivate, Chart
Sleep, 200
Send ^p
WinWaitActive, Print, , 5
return

UpdateMeds(){
    Click, 350, 38
}

ProblemSearch(){
    Click, 428, 38
    WinWaitActive, Update Problems, , 3
    if (ErrorLevel = 0) {
        sleep, 150
        Send !n
    }
}

UpdateProblems(){
    Click, 428, 38
}

BrowserPageDown(){
    WinGetPos , , , WinWidth, WinHeight, A
    xclick := WinWidth - 18
    yclick := WinHeight -30
    Click, %xclick%, %yclick%
}

BrowserCloseandSign(){
    Send !{F4}
    Sleep, 500
    If WinExist("Chart Desktop"){
        WinActivate, Chart Desktop
        sleep, 150
        If (ImageMouseMove("sign-chart-desktop")) {
            Click
        }
    }
}

ChartDesktopSwap(){
    If WinExist("Update") { 
        WinActivate, Update
    } else {
        If (ImageMouseMove("chart")) {
            Click
        }
    } 
}

ChartSwap(){
    If WinExist("Update") { 
        WinActivate, Update
    } else {
        GoChartDesktop()
    }
}

ChartDesktopCPOEAppend(){
    SwitchDocumentFocus()
    If (ImageMouseMove("append")) {
        Keywait, c
        Click
        CreateCPOEAppend()
        exit
    } else {
        send c
    }
}

ChartCPOEAppend(){
    SwitchDocumentFocus()
    If (ImageMouseMove("append-chart")) {
        Keywait, c
        Click
        CreateCPOEAppend()
        exit
    } else {
        send c
    }
}

End(){
    If WinActive("End Update") {
        Send !o
    }
    else If WinActive("Update") {
        EndUpdate()
    }
}

EndDouble(){
    If WinActive("Update") {
        EndUpdate()
        WinWaitActive, End Update, , 5
        if (ErrorLevel = 0) {
            SendtoBuddy()
        }
    } 
    else If WinActive("End Update") {
        SendtoBuddy()
    }   
}

SendtoBuddy(){
    global 
    WinGetPos, xpos, ypos, winwidth, winheight, End Update
    progressy := ypos + (winheight//2) -30
    Progress, ZH0 B1 FM36 W%winwidth% H60 X%xpos% Y%progressy% WM700 CW98df8a,, %Buddy%, , Calibri
    Send !m
    Send !m
    Send !m
    Send !n
    WinWaitActive, New Routing Information, , 3
    if (ErrorLevel = 0) {
	Sleep 100
	Click 148, 86
	Sleep 100
	Click 182, 95
	Sleep 100
	ControlFocus, Edit1
	Sleep, 200
        Send %Buddy%
        Sleep, 100
        ; Citrix loses window focus so use tab to go through controls. 
        Send {Enter}{Tab 9}{Enter}
        WinWaitActive, End Update, , 3
        if (ErrorLevel =0) {
            Send !o
	    Progress, Off
            WinWaitActive, Chart, , 15
            if (ErrorLevel = 0) {
                GoChartDesktop()
            }
        }
    }
    Progress, Off
}


SignUpdateBackToDesktop(){
    Send !m
    Send !m
    Send !m
    Send !m
    Send !s
    WinWaitActive, Chart, , 15
    if (ErrorLevel = 0) {
        GoChartDesktop()
    }
}

EndUpdate(){
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
}

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
                Sleep, 1000
                Send, {F8}
                Loop, 3
                {    
                    Sleep, 1000
                    If (ImageMouseMove("CPOE-form")) {
                        Click, 2
                        Exit
                    }
                }
            }
        }
    }
}

GoCPOEForm(){
    If (ImageMouseMove("CPOE-form")) {
        Click, 2
    }
}

ImageMouseMove(imagename){
    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    ImagePathandName := A_ScriptDir . "\files\" . imagename . ".PNG"
    ImageSearch, FoundX, FoundY, x1, y1, %A_ScreenWidth%, %A_ScreenHeight%, *n20 %ImagePathandName%
    if (ErrorLevel = 0) {
        MouseMove, %FoundX%, %FoundY%
        CoordMode, Pixel, Window
        CoordMode, Mouse, Window
        return 1
    }
    CoordMode, Pixel, Window
    CoordMode, Mouse, Window
    if (ErrorLevel >= 1) {
        return 0
    }
}

; Downloaded Functions #########################################
; http://www.autohotkey.com/board/topic/66855-patternhotkey-map-shortlong-keypress-patterns-to-anything/?hl=%2Bpatternhotkey
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

