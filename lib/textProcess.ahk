;_______________________________________________________________________________________________________________________________
; initializations
;_______________________________________________________________________________________________________________________________
initTextProcess:
global savedTexts := []

idx := 0
while (idx < 10) {
    IniRead, savedText, settings.ini, Texts, %idx%
    if (savedText = ERROR) {
        Iniwrite, "", settings.ini, Texts, %idx%
    }
    savedTexts[idx]:=savedText
    idx++
}

return











;_______________________________________________________________________________________________________________________________
; functions
;_______________________________________________________________________________________________________________________________
surround(left, right)                                           
{                                         
    ClipSaved := ClipboardAll
    Clipboard := ""
    SendEvent, ^{insert}
    ClipWait, 0.2
    if(!ErrorLevel) {
        OutputDebug, % Clipboard
        if (Clipboard) {
            SendEvent, %left%
            SendEvent, +{insert}
            SendEvent, %right%
        }
    }
    Clipboard := ClipSaved
}

cutText(idx)
{
    ClipSaved := ClipboardAll
    Clipboard := ""
    SendEvent, ^x
    ClipWait, 0.2
    if(!ErrorLevel) {
        if (Clipboard) {
            Iniwrite, %Clipboard%, settings.ini,Texts, %idx%
            savedTexts[idx] := Clipboard
        }
    }
    Clipboard := ClipSaved
}

copyText(idx)
{
    ClipSaved := ClipboardAll
    Clipboard := ""
    SendEvent, ^{insert}
    ClipWait, 0.2
    if(!ErrorLevel) {
        if (Clipboard) {
            Iniwrite, %Clipboard%, settings.ini, Texts, %idx%
            savedTexts[idx] := Clipboard
        }
    }
    
    Clipboard := ClipSaved
}

pasteText(idx)
{
    SendInput, % savedTexts[idx]
}