Setup()
return

; Locations and Hotkeys #########################################

#IfWinActive, Update Med
    F2::UpdateMedSearch()
    ^Space::Click, 558, 543

RButton::
MouseGetPos, xpos, ypos
if ( 21 < xpos AND xpos < 790 AND 73 < ypos AND ypos < 247) {
    Click %xpos%, %ypos%
    Sleep, 150
    Send !r
    WinWaitActive, Remove Medication,,3
    if (ErrorLevel=0) {
	Sleep, 150
	Send {Enter}
	LogUsage("Right Click Remove Medication")
    } 
} else {
	Click    
}
return

#IfWinActive, New Medication
    ^Space::Click, 686, 659


#IfWinActive, Update Prob
    F3::Send !n
    ^Space::Click, 890, 580

	RButton::
	MouseGetPos, xpos, ypos
	; Problems
	if ( 21 < xpos AND xpos < 995 AND 82 < ypos AND ypos < 229) {
	    Click %xpos%, %ypos%
	    Sleep, 150
	    Send !r
		WinWaitActive, Remove Problem,,3
		if (ErrorLevel = 0) {
			Sleep, 100
			Send {Enter}
			LogUsage("Right Click Remove Problem")
	    	} else {
			LogUsage("Right Click Remove Problem", "Remove Problem Window didn't open") 
		}
	}else {
	    	Click    
	}
	return

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


#IfWinActive, Chart
    `::ChartSwap()
    ~c::ChartCPOEAppend()
    F5::PatternHotKey(".->ChartNewPhoneNote()", "..->ChartNewPhoneCPOE()")
    ~l::LettertoCustomize()
#IfWinActive
; Hotkey Functions #########################################

Setup(){
    global telemetry_prefs, telemetry_log, Buddy, enable_logging
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

    SplashImage, %SetWorkingDir%\files\welcome-splashscreen.png,B2 FS18 C0, 
    Sleep, 700
    SplashImage, Off
    
    OnClipboardChange("ClipChanged")
    
    telemetry_folder := "\\fcnjboss01\AHK_Telemetry$\" 
    telemetry_prefs := telemetry_folder . A_UserName . "-Preferences.ini"
    telemetry_log := telemetry_folder . A_UserName . "-Usage.csv"
    enable_logging := True

    IfNotExist, %telemetry_prefs%
    {
	IfExist, Z:\FCN-Macro-Settings.ini
	{
		IniRead, Buddy, Z:\FCN-Macro-Settings.ini, Preferences, Buddy
		IniWrite, %Buddy%, %telemetry_prefs%, Preferences, Buddy
	}
	IfNotExist, Z:\FCN-Macro-Settings.ini
        {
        InputBox, BuddyName, Who's your Buddy?,
        (
    
        Who do you 'hold' things to most frequently
        in Centricity?
    
        Typically this might be your CAs last name...
        ), , 300, , , , , , 
        if (Errorlevel= 0) {
		IniWrite, %BuddyName%, %telemetry_prefs%, Preferences, Buddy
		SplashImage, %SetWorkingDir%\files\edit-buddy-help.png, B2 ZH200 ZW-1 FM24 FS18 C0, Later look for the FCN Logo to change your buddy., Thanks!
		Sleep 8000
		SplashImage, Off
    	}
        }
    } else {
	IniRead, Buddy, %telemetry_prefs%, Preferences, Buddy
    }
    ifNotExist, %telemetry_log%
    {
    LogFileHeaders := "Year,Month,Day,Hour,User,Hotkey,Function,Error"
    FileAppend, %LogFileHeaders%`n, %telemetry_log%
    }
    Return
}

ClipChanged(){
	StringLeft, IsRecall, Clipboard, 11
	if (IsRecall = "wcc-recall:"){
		patient_name := SubStr(Clipboard,12)
		if (WinExist("Chart") or WinExist("Chart Desktop")){
			WinActivate
			Sleep, 1000
			Send ^f
			WinWaitActive, Find Patient, , 5
			if not ErrorLevel {
				Send !b
				Sleep 50
				Send n
				Sleep 50
				send !f
				Sleep 50
				Send %patient_name%{Enter}
				LogUsage("ClipChanged Open Patient")
			} else {
				LogUsage("ClipChanged Open Patient","Find Patient Didn't Open")
			}

	} else {
		exit
	}
}
}

EditBuddy:
global Buddy, telemetry_prefs

IniRead, Buddy, %telemetry_prefs%, Preferences, Buddy
InputBox, BuddyName, Who's your Buddy?,
    (

    Who do you 'hold' things to most frequently
    in Centricity?

    Typically this might be your CAs last name...
    ), , 300, , , , , , %Buddy%
    if (Errorlevel= 0) {
        IniWrite, %BuddyName%, %telemetry_prefs%, Preferences, Buddy
        Reload
        }
return


ExitScript:
ExitApp
return


ReloadScript:
Reload
Return


LogUsage(Function, Error=""){
global telemetry_log, enable_logging
ifExist, %telemetry_log% 
{
    if (enable_logging = True) {
        line_to_log := A_YYYY . "," A_MM . "," A_DD . "," A_Hour . "," A_UserName . "," A_ThisHotkey . "," Function . "," Error
        FileAppend, %line_to_log%`n, %telemetry_log%
    }
}
}


SwitchDocumentFocus(){
    ControlGetFocus, chartfocus
    if (chartfocus = "SysTreeView322") {
        ControlFocus, "SftTreeControl701"
	Sleep, 200
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
        LogUsage("OrderSearch()")
        exit
    } else {
	LogUsage("OrderSearch()", "Update Orders Window did not open")
	exit
    }
}

MedSearch(){
    Click, 350, 38
    WinWaitActive, Update Medications, , 3
    if (ErrorLevel = 0) {
        LogUsage("MedSearch()")
        UpdateMedSearch()
    } else {
    	LogUsage("MedSearch()", "Update Medications window did not open")
	exit
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
        if (ErrorLevel = 0) {
            LogUsage("UpdateMedSearch()")
            exit
        } else If (ErrorLevel = 1) {
            LogUsage("UpdateMedSearch()" ,"Find Medication Window didn't open")
            exit
        }
    } else {
	LogUsage("UpdateMedSearch()", "New Medication Window didn't open")
	exit
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
                    WinWaitActive, Chart, , 5
                    if (ErrorLevel = 0) {
                        LogUsage("LetterPrintAndSign()")
                        Exit
                    } else {
                        LogUsage("LetterPrintAndSign()", "Chart did not activate")
                        Exit
                    } 
                } else {
                    LogUsage("LetterPrintAndSign()" ,"Print Window didn't open")
                    exit
                }
            }  else {
                LogUsage("LetterPrintAndSign()", "Route Document Window didn't open ")
                exit
            }
        }  else {
            LogUsage("LetterPrintAndSign()", "Customize Letter Window didn't open")
            exit
		}
    } else {
        LogUsage("LetterPrintAndSign()", "Customize Letter Window didn't close")
        exit
    }
}

AttachmentCPOEAppend(){
    Keywait, c
    Send !{F4}
    Sleep, 600
    IfWinExist, Chart Desktop
	{
        WinActivate, Chart Desktop
	WinWaitActive, Chart Desktop, ,5
	if (ErrorLevel = 0 ) {
		Sleep 600
	    If (ImageMouseMove("append")) {
		Click
		LogUsage("AttachmentCPOEAppend()")
		CreateCPOEAppend()
	    } else {
	    	LogUsage("AttachmentCPOEAppend()", "Append Image not found")
		exit
	    }
	} else {
		LogUsage("AttachmentCPOEAppend()", "Chart Desktop didn't activate")
		exit
	}
	}
    IfWinExist, Chart
    {
        WinActivate, Chart
    	WinWaitActive, Chart, , 5
	if (Errorlevel = 0) {
	    Sleep, 600
	    if (imageMouseMove("append-chart")) {
		Click
		LogUsage("AttachmentCPOEAppend()")
		CreateCPOEAppend()
	    } else {
	    	LogUsage("AttachmentCPOEAppend()", "append-chart image not found")
		exit
		}
	} else {
		LogUsage("AttachmentCPOEAppend()", "Chart didn't activate")
		exit
	}
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
			Sleep, 100
			Send .fd{Enter}
			Sleep, 300
			Send {Up 6}{Space}
			LogUsage("ChartNewPhoneNote()")
			exit
		} else {
			LogUsage("ChartNewPhoneNote()","Update didn't activate")
			exit
			}
	} else {
		LogUsage("ChartNewPhoneNote()", "Didn't find green pixel color")
		exit
		}
}

ChartNewPhoneCPOE(){
	PixelSearch, clickx, clicky, 107, 69, 113, 75, 0x32CD32
	if not ErrorLevel { 
		Click, %clickx%, %clicky%
		WinWaitActive, Update, , 10
		if (ErrorLevel = 0) {
			Sleep, 600
			LogUsage("ChartNewPhoneCPOE()")
			GoCPOEForm()
		} else {
			LogUsage("ChartNewPhoneCPOE()","Update didn't activate")
			exit
			}
	} else {
		LogUsage("ChartNewPhoneNote()", "Didn't find green pixel color")
		exit
		}
}

AttachmentSign(){
    Send !{F4}
    Sleep, 600
    IfWinExist, Chart Desktop
    {
	WinActivate, Chart Desktop
    	WinWaitActive, Chart Desktop, , 5
	If (Errorlevel = 0) {
		Sleep, 500
		
	    if (imageMouseMove("sign-chart-desktop")) {
		Click
		LogUsage("AttachmentSign()")
		exit
	    } else {
		LogUsage("AttachmentSign()","sign-chart-desktop image not found")
		exit
	    }
	} else {
		LogUsage("AttachmentSign()", "Chart Desktop didn't activate")
		exit
	}
    }
    IfWinExist, Chart
    {
        WinActivate, Chart
	WinWaitActive, Chart, , 5
	if (Errorlevel = 0) {
	    Sleep, 500
	    If (ImageMouseMove("sign-chart")) {
		Click
		LogUsage("AttachmentSign()")
		exit
	    } else {
	    	LogUsage("AttachmentSign()", "sign-chart image not found")
		exit
		}
    } else {
	LogUsage("AttachmentSign()", "Chart didn't activate")
	exit
    }
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
	{
	    LogUsage("GoChartDesktop()")
    	    exit
	    }
    } 
    LogUsage("GoChartDesktop()","chart-desktop image not found")
}


LettertoCustomize(){
	keywait, l
	WinGetTitle, IsChartActive
	if not (IsChartActive == "Chart"){
		exit
		}
	ControlGetFocus, ActiveControl
	if not Errorlevel {
		IsEdit := substr(ActiveControl, 1, 4)
		if (IsEdit = "edit") {
			msgbox Edit field active
			exit
		}
	}
	WinGetPos, xpos, ypos, winwidth, winheight,Chart
	GUI -MinimizeBox -MaximizeBox
	GUI, font, s18 Calibri
	GUI, margin, 0, 0
	GUI, add, Listbox, sort x10 y10 w380 h230 gSubmitDoubleClick vLetterName,Blank Letter to Patient|Imaging (Not MBI)|Letters||MBI|MTC|Physical Therapy|Results Lab Letter|
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
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    ControlClick, MLogicListBox1
	    Sleep, 600
	    Send B
	    Sleep, 600
	    Click, 392, 351
	    LogUsage("Blank Letter to Patien")
	}
	exit
} else if (lettername = "Imaging (Not MBI)") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	    Send i
	    LogUsage("Imaging (Not MBI)")
	}
	exit
} else if (lettername = "Results Lab Letter") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    ControlClick, MLogicListBox1
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Click, 392, 351
	    LogUsage("Results Lab Letter")
	}
	exit
} else if (lettername = "MBI") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) { 
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	Send m
	    Sleep, 600
	Send {Down 4}
	LogUsage("MBI")
	}
	exit
} else if (lettername = "MTC") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) { 
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	Send m
	    Sleep, 600
	Send {Down 1}
	LogUsage("MTC")
	}
	exit
} else if (lettername = "Letters") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down}
	    ControlClick, MLogicListBox1
	    Sleep, 600
	    Send p
	    Sleep, 600
	    LogUsage("Letters")
	}
	exit
} else if (lettername = "Physical Therapy") {
	GoSub, OpenPrintNav
	if (ErrorLevel = 0) {
	    Sleep, 600
	    Send l
	    Sleep, 600
	    Send {Down 2}
	    Sleep, 600
	    Send {Right 2}
	    Sleep, 600
	Send p
	    Sleep, 600
	Send {Down 5}

	LogUsage("Physical Therapy")
	}
	exit
} else {
exit
}
return


OpenPrintNav:
WinActivate, Chart
Sleep, 200
Send ^p
WinWaitActive, Print, , 5
return

UpdateMeds(){
    Click, 350, 38
    WinWaitActive, Update Medications, ,3
    if (ErrorLevel = 0) {
	LogUsage("UpdateMeds()")
    } else {
	LogUsage("UpdateMeds()", "Updates Meds didn't open")
    }
}

ProblemSearch(){
    Click, 428, 38
    WinWaitActive, Update Problems, , 3
    if (ErrorLevel = 0) {
        sleep, 250
        Send !n
	WinwaitActive, New Problem, ,5
	if (Errorlevel = 0) {
		LogUsage("ProblemSearch()")
		exit
	} else {
		LogUsage("ProblemSearch()", "New Problem didn't open")
		exit
	}
    } else {
	LogUsage("ProblemSearch()", "Update Problems didn't open")
	exit
    }
}

UpdateProblems(){
    Click, 428, 38
    WinWaitActive, Update Problems, , 3
    if (ErrorLevel = 0) {
	LogUsage("UpdateProblems()")
	exit
    } else {
	LogUsage("UpdateProblems()", "Update Problems didn't open")
    }
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
	WinWaitActive, Chart Desktop, , 5
	{
        	sleep, 150
        	If (ImageMouseMove("sign-chart-desktop")) {
			Click
			LogUsage("BrowserCloseandSign()")
			exit
        	} else {
			LogUsage("BrowserCloseandSign()", "sign-chart-desktop image not found")
			exit
		}
	}
		LogUsage("BrowserCloseandSign()", "Chart Desktop didn't activate")
		exit
    }
}

ChartDesktopSwap(){
    If WinExist("Update") { 
        WinActivate, Update
	WinWaitActive, Update, ,5
	if (Errorlevel = 0) {
		LogUsage("ChartDesktopSwap()")
		Exit
	} else {
		LogUsage("ChartDesktopSwap()","Update didn't activate")
	}
    } else {
        If (ImageMouseMove("chart")) {
            Click
	    LogUsage("ChartDesktopSwap()")
	    exit
        } else {
		LogUsage("ChartDesktopSwap()", "chart image not found")
		exit
	}
    } 
}

ChartSwap(){
    If WinExist("Update") { 
        WinActivate, Update
	WinWaitActive, Update, , 5
	if (Errorlevel = 0) {
		LogUsage("ChartSwap()")
		exit
	} else {
		LogUsage("ChartSwap()", "Update didn't activate")
		exit
	}
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
        Keywait, c
	WinGetTitle, IsChartActive
	if not (IsChartActive == "Chart"){
		exit
	}
    SwitchDocumentFocus()
    If (ImageMouseMove("append-chart")) {
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
        } else {
		LogUsage("EndDouble()", "End Update didn't open")
		exit
	}
    } 
    else If WinActive("End Update") {
        SendtoBuddy()
    }   
}

SendtoBuddy(){
    global Buddy
    WinGetPos, xpos, ypos, winwidth, winheight, End Update
    progressy := ypos + (winheight//2) -30
    Progress, ZH0 B1 FM36 W%winwidth% H60 X%xpos% Y%progressy% WM700 CW98df8a,, %Buddy%, , Calibri
    Send !m
    Send !m
    Send !m
    Send !n
    WinWaitActive, New Routing Information, , 3
    if (ErrorLevel = 0) {
	Sleep 200
	Click 148, 86
	Sleep 200
	Click 182, 95
	Sleep 200
	ControlFocus, Edit1
	Sleep, 200
        Send %Buddy%
        Sleep, 200
        Send {Enter}
	Sleep, 200
	Click, 239, 329
        WinWaitActive, End Update, , 3
        if (ErrorLevel = 0) {
            Send !o
	    Progress, Off
            WinWaitActive, Chart, , 15
            if (ErrorLevel = 0) {
		LogUsage("SendtoBuddy()")
                GoChartDesktop()
            } else {
		LogUsage("SendtoBuddy()", "Chart didn't activate")
		Progress, Off
		exit
	    }
        } else {
		LogUsage("SendtoBuddy()", "End Update window didn't open")
		Progress, Off
		exit
	}
    } else {
	Progress, Off
	LogUsage("SendtoBuddy()", "New Routing Information didn't open")
	exit
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
    	LogUsage("SignUpdateBackToDesktop()")
        GoChartDesktop()
    } else {
	LogUsage("SignUpdateBackToDesktop()", "Chart didn't activate")
	exit
    }
}

EndUpdate(){
    Send ^e
    ; Sometimes Fails, Try a few times?
    WinWaitActive, End Update, , 3
    if (ErrorLevel = 0) {
	LogUsage("EndUpdate()")
    }
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
                Loop, 2
                {    
                    Sleep, 1000
                    If (ImageMouseMove("CPOE-form")) {
                        Click, 2
			LogUsage("CreateCPOEAppend()")
                        Exit
                    }
		}

		    LogUsage("CreateCPOEAppend()", "CPOE-form image not found")
		    exit
                } else {
			LogUsage("CreateCPOEAppend()", "Update didn't activate")
			exit
		}
            } else {
		LogUsage("CreateCPOEAppend()", "Append document didn't activate")
		exit
	    }
        } else {
		LogUsage("CreateCPOEAppend()", "Append to didn't activate")
		exit
	}
    }

GuiDefaultFont() { ; By SKAN www.autohotkey.com/forum/viewtopic.php?p=465438#465438
hFont := DllCall( "GetStockObject", UInt,17 ) ; DEFAULT_GUI_FONT
VarSetCapacity( LF, szLF := 60 * ( A_IsUnicode ? 2 : 1 ) )
DllCall( "GetObject", UInt,hFont, Int,szLF, UInt,&LF )
hDC := DllCall( "GetDC", UInt,hwnd ),
DPI := DllCall( "GetDeviceCaps", UInt,hDC, Int,90 )
DllCall( "ReleaseDC", Int,0, UInt,hDC ),
S := Round( ( -NumGet( LF,0,"Int" )*72 ) / DPI )
Return DllCall( "MulDiv",Int,&LF+28, Int,1,Int,1, Str )
, DllCall( "SetLastError", UInt,S )
}


GoCPOEForm(){
    If (ImageMouseMove("CPOE-form")) {
        Click, 2
	LogUsage("GoCPOEForm()")
	exit
    } else {
	LogUsage("GoCPOEForm()", "CPOE-Form image not found")
	exit
    }
}

ImageMouseMove(imagename){
    ImagePathandName := A_ScriptDir . "\files\" . imagename . ".PNG"
    SysGet, VirtualWidth, 78
    SysGet, VirtualHeight, 79
	Loop, 3 {
    ImageSearch, FoundX, FoundY, -4000, -4000, %VirtualWidth%, %VirtualHeight%, *n20 %ImagePathandName%
    if (ErrorLevel = 0) {
        MouseMove, %FoundX%, %FoundY%
        return 1
    }
	Sleep, 1000
	}
	return 0
    }

::pmhj::
	Send `;pmh{Space}
	Sleep 1000
	Click, 899, 118
	Sleep, 600
	Click, 675, 588
return

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
