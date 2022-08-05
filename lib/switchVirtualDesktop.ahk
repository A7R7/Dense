; Each virtual desktop has a Universally Unique Identifier(UUID)
; Each UUID of a virtual desktop should be a 32-char-long string
; the UUID of the current virtual desktop is stored in a value, called "CurrentVirtualDesktop", in the registry
; at: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
; when the current showing virtual desktop is changed to a new one, the value "CurrentVirtualDesktop"  is also changed, to the UUID of the new virtual desktop

; UUIDs of all the virtual desktops are put together, in order (just as in task view), to form a long string.
; This string is stored in another value, called "VirtualDesktopIDs", in the registry
; at: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
; if there is just one virtual desktop, "VirtualDesktopIDs" = "CurrentVirtualDesktop"
; when virtual desktops are added or deleted, their UUIDs are also added or removed in "VirtualDesktopIDs"

;_______________________________________________________________________________________________________________________________
; initializations
;_______________________________________________________________________________________________________________________________

initSwitchVirtualDesktops:

; global values ----------------------------------------
global IdLength := 32                                   ; the length of a desktop UUID should be 32. Will this change in the future?
global SessionId := ""

global CurrentDesktopIndex                              ; Desktop count is 1-indexed (Microsoft numbers them this way)
global CurrentDesktopId                                 ; UUID for current desktop

global DesktopCount := ""                               ; Windows starts with 2 desktops at boot
global DesktopIds := []                                 ; UUIDs of each desktop
global DesktopList                                      ; store UUIDs of desktops in a string
global working := false


; create gui -------------------------------------------

Gui, desktopNumber:new, +LastFound +AlwaysOnTop +Owner -Caption, desktopNumberWin
Gui, Color, 000000, 000000
WinSet, Transparent, 150
Gui, Font, S20, Microsoft YaHei UI Bold
Gui, Add, Text, R1 W150 Center cwhite vdesktopName, Desktop X


; first load registry info -----------------------------
loadRegInfo()

return





;_______________________________________________________________________________________________________________________________
; functions and labels
;_______________________________________________________________________________________________________________________________



; after-end functions ----------------------------------------------------------------------------------------------------------

loadRegInfo() 
{
    loadSessionId()
    loadCurrentDesktopId()
    loadDesktopList()
    getDesktopIds()
    getCurrentDesktopIndex()
	OutputDebug, ---------------------------------
}


loadSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    if ErrorLevel {
        OutputDebug, Error getting current process id: %ErrorLevel%
        return
    }
    OutputDebug, Current Process Id: %ProcessId%
    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    if ErrorLevel {
        OutputDebug, Error getting session id: %ErrorLevel%
        return
    }
    OutputDebug, Current Session Id: %SessionId%
}

loadCurrentDesktopId()
{
    RegRead, tempId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\%SessionId%\VirtualDesktops, CurrentVirtualDesktop
    
    if (tempId = CurrentDesktopId) {
        OutputDebug, Not changed : CurrentDesktopId,    %CurrentDesktopId%
        return true
    } else {
        CurrentDesktopId := tempId
        OutputDebug, Changed :     CurrentDesktopId,    %CurrentDesktopId%
        return false
    }
}

loadDesktopList()
{
    RegRead, tempList, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs

    if (tempList = DesktopList) {
        OutputDebug, Not changed : DesktopList,         %DesktopList%
        return true
    } else {
        DesktopList:= tempList
        OutputDebug, Changed :     DesktopList,         %DesktopList%
        DesktopCount:= StrLen(DesktopList) / IdLength
        OutputDebug, DesktopCount: %DesktopCount%
        return false
    }
}

getDesktopIds()
{
    i := 1
    StartPos := 1
    while (i <= DesktopCount) {
        DesktopIter := SubStr(DesktopList, StartPos, IdLength)
        DesktopIds[i] := DesktopIter
        OutputDebug, Desktop %i% :   %DesktopIter%
        StartPos += IdLength
        i++
    }
}

getCurrentDesktopIndex()
{
    i := 1
    while (i <= DesktopCount) {
        if (CurrentDesktopId = DesktopIds[i]) {
            CurrentDesktopIndex := i
            return
        }
        i++
    }
}

; front end functions ----------------------------------------------------------------------------------------------------------

showDesktopNumber()
{
    GuiControl, desktopNumber:text, desktopName, Desktop %CurrentDesktopIndex%
    Gui, desktopNumber:show
    sleep 750
    Gui, desktopNumber:hide
}


; API functions ----------------------------------------------------------------------------------------------------------------

switchDesktop(idx)
{   
    if (working) return
    Gui, desktopNumber:hide
    OutputDebug, ---------------------- start switching desktop! -------------------------------

    ; user may operate in other ways
    if (!loadDesktopList()) {
        ; the desktop list has changed
        getDesktopIds()
    }
    loadCurrentDesktopId()
    getCurrentDesktopIndex()

    working:= true
    while (idx > DesktopCount) {
        SendEvent, ^#d
        sleep 0
        DesktopCount++
    }
    loop 5 {
        ; one set of operations may fail to reach the target
        ; when switching past a desktop with an activated window, 
        ; it will cause a slight time delay
        ; which may make ^#{Left/Right} fail to trigger
        OutputDebug,  start at desktop %CurrentDesktopIndex% 
        ; Go right until we reach the desktop we want
        while(CurrentDesktopIndex < idx) {
            SendEvent ^#{Right}
            sleep 50
            CurrentDesktopIndex++
            OutputDebug, [right] target: %idx% current: %CurrentDesktopIndex%
        }

        ; Go left until we reach the desktop we want
        while(CurrentDesktopIndex > idx) {
            SendEvent ^#{Left}
            sleep 50
            CurrentDesktopIndex--
            OutputDebug, [left] target: %idx% current: %CurrentDesktopIndex%
        }
        sleep 100
        ; check if the previous action works
        loadCurrentDesktopId()
        if (CurrentDesktopId = DesktopIds[idx]) {
            OutputDebug,  target reached ! 
            break
        } else {
            OutputDebug,  target not reached 
            getCurrentDesktopIndex()
            continue
        }
    }
    showDesktopNumber()
    working:= false
}

createVirtualDesktop()
{
    if (working) return
    working:= true
    SendEvent, #^d
    DesktopCount++
    CurrentDesktopIndex = %DesktopCount%
    OutputDebug, [create] desktops: %DesktopCount% current: %CurrentDesktopIndex%
    working:= false
}

deleteVirtualDesktop()
{
    if (working) return
    working:= true
    SendEvent, #^{F4}
    DesktopCount--
    CurrentDesktopIndex--
    OutputDebug, [delete] desktops: %DesktopCount% current: %CurrentDesktopIndex%
    working:= false
}



























