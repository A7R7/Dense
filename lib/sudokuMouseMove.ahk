
;_______________________________________________________________________________________________________________________________
; initializations
;_______________________________________________________________________________________________________________________________
initSudokuMouseMove:

; global values ----------------------------------------
global x1:=0
global y1:=0
global x2:=A_ScreenWidth
global y2:=A_ScreenHeight


; create gui -------------------------------------------

; Large cursor box
Gui, cursorBoxL:new, +LastFound +AlwaysOnTop +Owner -Caption , cursorBoxLWin
Gui, Color, 000000, 
WinSet, Transparent, 70
Gui, add, text, ,   

; Horizontal cursor box
Gui, cursorBoxH:new, +LastFound +AlwaysOnTop +Owner -Caption , cursorBoxHWin
Gui, Color, ffffff
WinSet, Transparent, 70
Gui, add, text, ,  

; Vertical cursor box
Gui, cursorBoxV:new, +LastFound +AlwaysOnTop +Owner -Caption , cursorBoxVWin
Gui, Color, ffffff
WinSet, Transparent, 70
Gui, add, text, ,  

return

;_______________________________________________________________________________________________________________________________
; functions and labels
;_______________________________________________________________________________________________________________________________

; math functions ---------------------------------------
1Third(ByRef a, ByRef b) 
{
    fa:=a
    fb:=b
    a:=fa
    b:=(2 * fa + fb) / 3
}
2Third(ByRef a, ByRef b) 
{
    fa:=a
    fb:=b
    a:=(2 * fa + fb) / 3
    b:=(fa + 2 * fb) / 3     
}
3Third(ByRef a, ByRef b)
{
    fa:=a
    fb:=b
    a:=(fa + 2 * fb) / 3
    b:=fb
}


mouseMove()
{
    DllCall("SetCursorPos", "int", (x1 + x2)/2, "int", (y1 + y2)/2)
}

rectMove()
{   
    WinMove, cursorBoxLWin, , x1, y1, x2 - x1, y2 - y1
    WinMove, cursorBoxHWin, , x1, (2*y1 + y2)/3, x2 - x1, (y2 - y1)/3
    WinMove, cursorBoxVWin, , (2*x1 + x2)/3, y1, (x2 - x1)/3, y2 - y1
}

rectReset()
{
    x1:=0
    x2:=A_ScreenWidth
    y1:=0
    y2:=A_ScreenHeight
}

rectShow()
{
    Gui, cursorBoxL:show
    Gui, cursorBoxH:show
    Gui, cursorBoxV:show
}

rectHide()
{
    Gui, cursorBoxL:hide
    Gui, cursorBoxH:hide
    Gui, cursorBoxV:hide
}

; API functions -----------------------------------------
sudokuMouseMove() 
{
    rectReset()
    rectShow()
    mouseMove()
    rectMove()    
    
}


toBottomLeft()
{
    1Third(x1, x2)
    3Third(y1, y2)
    mouseMove()
    rectMove()
}
toBottom()
{
    2Third(x1, x2)
    3Third(y1, y2)
    mouseMove()
    rectMove()
}
toBottomRight()
{
    3Third(x1, x2)
    3Third(y1, y2)
    mouseMove()
    rectMove()
}
toLeft()
{
    1Third(x1, x2)
    2Third(y1, y2)
    mouseMove()
    rectMove()
}
toCenter()
{
    2Third(x1, x2)
    2Third(y1, y2)
    mouseMove()
    rectMove()
}
toRight()
{
    3Third(x1, x2)
    2Third(y1, y2)
    mouseMove()
    rectMove()
}
toTopLeft()
{
    1Third(x1, x2)
    1Third(y1, y2)
    mouseMove()
    rectMove()
}
toTop()
{
    2Third(x1, x2)
    1Third(y1, y2)
    mouseMove()
    rectMove()
}
toTopRight()
{
    3Third(x1, x2)
    1Third(y1, y2)
    mouseMove()
    rectMove()
}

