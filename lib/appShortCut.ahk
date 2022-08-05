;_______________________________________________________________________________________________________________________________
; initializations
;_______________________________________________________________________________________________________________________________
initAppShortCut:

global appPaths:=[]

; load information from settings.ini
idx:= 0
while idx < 10 {
    IniRead, appPath, settings.ini, Apps, %idx%
    if (appPath = ERROR) {
        Iniwrite, "", settings.ini, Apps, %idx%
    }
    appPaths[idx]:=appPath
    idx++
}




; create guis --------------------------------------------------------------
Gui, WaitNumber:new, +LastFound +AlwaysOnTop +Owner -Caption, waitNumberWin
Gui, Color, 000000, 000000
WinSet, Transparent, 200
Gui, margin, 20, 10
Gui, Font, S16 , Microsoft YaHei UI
Gui, Add, Text, R1 Center cwhite, Press a number (0~9)`nto bind this application

Gui, bindFeedback:new, +LastFound +AlwaysOnTop +Owner -Caption, bindFeedbackWin
Gui, Color, 000000, 000000
WinSet, Transparent, 200
Gui, Font, S18 , Microsoft YaHei UI Bold
Gui, Add, Text, R1 W300 Center cwhite vappName, appname
Gui, margin, 20, 0
Gui, Font, S16 , Microsoft YaHei UI
Gui, Add, Text, R1 W300 Center cwhite, is successfully bound to
Gui, Font, S18 , Microsoft YaHei UI Bold
Gui, Add, Text, R1 W300 Center cwhite vhotkeyName, CapsLock+a+x
Gui, margin, 20, 10

Gui, accessFailure:new, +LastFound +AlwaysOnTop +Owner -Caption, accessFailureWin
Gui, Color, 000000, 000000
WinSet, Transparent, 200
Gui, Font, S18 , Microsoft YaHei UI Bold
Gui, Add, Text, R1 W400 Center cwhite, Access Failure
Gui, margin, 20, 0
Gui, Font, S14 , Microsoft YaHei UI
Gui, Add, Text, R2 W400 Center cwhite, This app may be a UWP or else
Gui, Add, Button, R1 W400 gHintForUWP, How to RUN it?
Gui, margin, 20, 20

Gui, hintUWP:new, +LastFound, How to bind a UWP
Gui, Color, 000000, 000000
Gui, Font, S14 , Microsoft YaHei UI
Gui, Add, Edit, R7 w650 cwhite ReadOnly, 1. Open PowerShell, type in StartApps.`n2. Search for the target app's name.`n3. Copy the app's APPID on the right column.`n4. Open settings.ini in the script's working directory.`n5. In session [Apps], select the key you want to bind the app on.`n6. After the '=' sign, input `"explorer.exe shell:appsFolder\`"(without `"`").`n7. Then paste the APPID after that (with no spaces). Done.

return





;_______________________________________________________________________________________________________________________________
; functions and labels
;_______________________________________________________________________________________________________________________________

HintForUWP:
Gui, accessFailure:hide
Gui, hintUWP:show
return




;----------------------------------------------------------------
; This function opens the waitNumber window that waits for a number to bind the current application

appBindMode() {
	Gui, WaitNumber:show, NoActivate
}

bindExit() {
	Gui, WaitNumber:hide
}


;----------------------------------------------------------------
; This function binds application path to number n for launch

bindApp(idx) 
{
	Gui, WaitNumber:hide
    tempId:=WinExist("A")                                        	; get id
	WinGet, tempName, ProcessName, ahk_id %tempId%					; get name
    if (tempName = "ApplicationFrameHost.exe") {
        showAccessFailure()
        return
    }
    WinGet, tempPath, ProcessPath, ahk_id %tempId%			        ; get path
    appPaths[idx]:= tempPath                                        ; register path to memory
    IniWrite, %tempPath%, settings.ini, Apps, %idx%                 ; register path to ini
    showBindFeedback(tempName, idx)
    return
}

showBindFeedback(name, idx) {
	GuiControl, bindFeedback:text, appName, %name%
	GuiControl, bindFeedback:text, hotkeyName, CapsLock+a+%idx%
	Gui, bindFeedback:show, NoActivate								; show feedback window
    sleep, 4000
    Gui, bindFeedback:hide    
}

showAccessFailure() {
    Gui, accessFailure:show, NoActivate
}

;---------------------------------------------------------------
; This function activates window by number n
; pressing 0 causes n = 10, because AHK starts an array with index 1

launchApp(idx)
{	
    appPath:=appPaths[idx]
    try 
    {
        run, %appPath%
    } 
    catch e 
    {
        showAccessFailure()
    }         
    return
}
