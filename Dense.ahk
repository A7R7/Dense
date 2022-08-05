;=================================================================================================================================
; initializations
;=================================================================================================================================

SetWorkingDir, %A_ScriptDir%
SetStoreCapslockMode, Off
SetWinDelay, 20

; load icon
IfExist, Dense_icon.ico                                 
{
    menu, TRAY, Icon, Dense_icon.ico, , 1
}


; if settings.ini doesn't exist, create new one
IfNotExist, settings.ini                                
{
    FileAppend, , settings.ini, UTF-16
}


gosub initTextProcess
gosub initAppShortCut
gosub initSudokuMouseMove
gosub initSwitchVirtualDesktops
; ListHotkeys
#Include lib
#Include appShortCut.ahk
#Include sudokuMouseMove.ahk
#Include switchVirtualDesktop.ahk
#Include textProcess.ahk
return




















;=================================================================================================================================
; Hotkeys begin
;=================================================================================================================================

CapslockDown := ""
CapsLock::
CapslockDown := 1          ; press capslock key
KeyWait, CapsLock
if (A_ThisHotkey = "CapsLock") {
    SendEvent, {Esc down}
    sleep, 20
    SendEvent, {Esc up}
}
CapslockDown := 0          ; release/unlock capslock key
return
!CapsLock::return
#CapsLock::return
+CapsLock::return









#If CapslockDown
#InputLevel, 0
;=================================================================================================================================
; pure capslock Hotkeys
;=================================================================================================================================

;Capslock + ... = move mode ----------------------------
;1st row -------------------
y::Send, ^{left}
u::Send, {down 5}
i::Send, {up 5}
o::Send, ^{right}
p::Send, ^{BackSpace}
[::Send, ^{Del}
]::Send, {home}+{end}{Del}
;2ed row -------------------
h::left
j::down
k::up
l::right
`;::Send, {BackSpace}
'::Send, {Del}
;3rd row -------------------
n::Send, {Home}
m::Send, {End}
,::Send, ^z
.::Send, ^y
; miscellaneous-------------
e::Send, #e                 ; file explorer
r::Send, #r                 ; run
a::Send, ^a                 ; choose all
s::Send, ^s                 ; save
f::Send, ^f                 ; find
x::Send, ^x                 ; cut
c::Send, ^{Insert}          ; copy
v::Send, +{Insert}          ; paste
/::Send, ^/                 ; comment
Space::Send, {Enter}
Enter::Send, {End}{Enter}
;-------------------------------------------------------














;=================================================================================================================================
; capslock + w/a/s/d Hotkeys
;=================================================================================================================================


; Capslock + q + ... = mouse move mode -----------------
q & Space::LButton
q & m::MouseMove, -20, 20, 0, R 
q & ,::MouseMove, 0, 20, 0, R
q & .::MouseMove, 20, 20, 0, R
q & j::MouseMove, -20, 0, 0, R
q & k::MButton
q & l::MouseMove, 20, 0, 0, R
q & u::MouseMove, -20, -20, 0, R
q & i::MouseMove, 0, -20, 0, R
q & o::MouseMove, 20, -20, 0, R
q & `;::RButton
q & d::
sudokuMouseMove()
keywait, d
rectHide()
return







;Capslock + w + ... = window mode ----------------------

; 1st row ------------------
w & y::Send, #{Left}
w & u::Send, #{Down}
w & i::Send, #{Up}
w & o::Send, #{Right}
w & p::winset, AlwaysOnTop, , A
w & [::Send, !{F4}          ; close current window
w & ]::                     ; close all windows
GroupAdd, AllWindows, , , , Program Manager   
WinClose ahk_group AllWindows
return
; 2ed row ------------------
w & h::Send, ^{PgUp}        ; left tab
w & j::Send, {PgDn}
w & k::Send, {PgUp}
w & l::Send, ^{PgDn}        ; right tab
w & `;::
WinGet, active_id, ID, A
WinHide, ahk_id %active_id%
keywait, `;
WinShow, ahk_id %active_id%
WinActivate, ahk_id %active_id%
return

w & '::Send, ^w
; 3rd row ------------------
w & n::         
createVirtualDesktop()
keywait, n
return

w & m::
keywait, m
return 

w & ,::Send, ^#{left}
w & .::Send, ^#{right}
w & /::
deleteVirtualDesktop()
keywait, /
return



; miscellaneous--------------------------
w & Space::Send, ^{Esc}
w & e::Send, #e
w & r::Send, #r
w & x::Send, #x
w & v::Send, #v
w & b::Send, #b{enter} ; show mini icon tray
;-----------------------------------------------------------


; CapsLock + a + ... = select mode -------------------------

; 1st row -------------------
a & y::Send, +^{left}
a & u::Send, +{down 5}
a & i::Send, +{up 5}
a & o::Send, +^{right} 
a & p::Send, {Home}+{End}    ;select whole line
; 2ed row -------------------
a & h::Send, +{left}
a & j::Send, +{down}
a & k::Send, +{up}
a & l::Send, +{right}
a & `;::Send, {Home}+{End}{BackSpace}
; 3rd row -------------------
a & n::Send, +{Home}
a & m::Send, +{End}


;bracket surrounding--------
a & [::
surround("[", "]")
keywait, [
return

a & ]::
surround("{{}", "{}}")
keywait, ]
return

a & '::
surround("""", """")
keywait, '
return

a & ,::
surround("<" , ">")
keywait, `,
return

a & .::
surround("(", ")")
keywait, .
return
;-----------------------------------------------------------






;Capslock + s + ... = symbol mode --------------------------
; 1st row ------------------
s & y::Send, `\
s & u::Send, `@
s & i::Send, `$
s & o::Send, {#}
s & p::Send, `%
s & [::Send, `(
s & ]::Send, `)
; 2ed row ------------------
s & h::Send, {+}
s & j::Send, `-
s & k::Send, `*
s & l::Send, `/
s & `;::Send, `=
s & '::Send, ``
; 3rd row ------------------
s & n::Send, `~
s & m::Send, {^}
s & ,::Send, `&
s & .::Send, `|
s & /::Send, `{!}
; 4th row ------------------
s & Space::Send, _

;-------------------------------------------------------




;Capslock + d + ... = digit mode -----------------------
d::Return        
; digits -------------------

#InputLevel, 1
d & Space::SendEvent, {Blind}{0 down}
d & Space up::SendEvent, {Blind}{0 up}

d & m::SendEvent, {Blind}{1 down}
d & m up::SendEvent, {Blind}{1 up}

d & ,::SendEvent, {Blind}{2 down}
d & , up::SendEvent, {Blind}{2 up}

d & .::SendEvent, {Blind}{3 down}
d & . up::SendEvent, {Blind}{3 up}

d & j::SendEvent, {Blind}{4 down}
d & j up::SendEvent, {Blind}{4 up}

d & k::SendEvent, {Blind}{5 down}
d & k up::SendEvent, {Blind}{5 up}

d & l::SendEvent, {Blind}{6 down}
d & l up::SendEvent, {Blind}{6 up}

d & u::SendEvent, {Blind}{7 down}
d & u up::SendEvent, {Blind}{7 up}

d & i::SendEvent, {Blind}{8 down}
d & i up::SendEvent, {Blind}{8 up}

d & o::SendEvent, {Blind}{9 down}
d & o up::SendEvent, {Blind}{9 up}


;-------------------------------------------------------









#InputLevel, 0
;=================================================================================================================================
; capslock + number Hotkeys
;=================================================================================================================================
; sudoku mouse move mode ---
q & 1::toBottomLeft()
q & 2::toBottom()
q & 3::toBottomRight()
q & 4::toLeft()
q & 5::toCenter()
q & 6::toRight()
q & 7::toTopLeft()
q & 8::toTop()
q & 9::toTopRight()
q & 0::
rectHide()
Send, {LButton}
return


; window mode --------------
w & 0::Send, #d
w & 1::Send, #1
w & 2::Send, #2
w & 3::Send, #3
w & 4::Send, #4
w & 5::Send, #5
w & 6::Send, #6
w & 7::Send, #7
w & 8::Send, #8
w & 9::Send, #9

; application mode ----------
!a::appBindMode()
a & 0 up::launchApp(0)
a & 1 up::launchApp(1)
a & 2 up::launchApp(2)
a & 3 up::launchApp(3)
a & 4 up::launchApp(4)
a & 5 up::launchApp(5)
a & 6 up::launchApp(6)
a & 7 up::launchApp(7)
a & 8 up::launchApp(8)
a & 9 up::launchApp(9)

; switching desktop mode ---
s & 0 up::Send, #{Tab}
s & 1 up::switchDesktop(1)
s & 2 up::switchDesktop(2)
s & 3 up::switchDesktop(3)
s & 4 up::switchDesktop(4)
s & 5 up::switchDesktop(5)
s & 6 up::switchDesktop(6)
s & 7 up::switchDesktop(7)
s & 8 up::switchDesktop(8)
s & 9 up::switchDesktop(9)




;=================================================================================================================================
; capslock + fake number Hotkeys
;=================================================================================================================================

; capslock + f + fake number = F(num)

f & m::f1
f & ,::f2
f & .::f3
f & j::f4
f & k::f5
f & l::f6
f & u::f7
f & i::f8
f & o::f9
f & p::f10
f & [::f11
f & ]::f12

; capslock + x + fake number = cut to str(num)
x & Space::cutText(0)
x & m::cutText(1)
x & ,::cutText(2)
x & .::cutText(3)
x & j::cutText(4)
x & k::cutText(5)
x & l::cutText(6)
x & u::cutText(7)
x & i::cutText(8)
x & o::cutText(9)


; capslock + c + fake number = copy to str(num)
c & Space::copyText(0) 
c & m::copyText(1)
c & ,::copyText(2)
c & .::copyText(3)
c & j::copyText(4)
c & k::copyText(5)
c & l::copyText(6)
c & u::copyText(7)
c & i::copyText(8)
c & o::copyText(9)
return


; capslock + v + fake num = paste to str(num)
v & Space::pasteText(0)
v & m::pasteText(1)
v & ,::pasteText(2)
v & .::pasteText(3)
v & j::pasteText(4)
v & k::pasteText(5)
v & l::pasteText(6)
v & u::pasteText(7)
v & i::pasteText(8)
v & o::pasteText(9)
return













;=================================================================================================================================
; window sensitive Hotkeys
;=================================================================================================================================



#IfWinExist waitNumberWin 
#InputLevel, 0
; this is triggered by capslock + alt + a

0::bindApp(0)
1::bindApp(1)
2::bindApp(2)
3::bindApp(3)
4::bindApp(4)
5::bindApp(5)
6::bindApp(6)
7::bindApp(7)
8::bindApp(8)
9::bindApp(9)
Esc::bindExit()
return