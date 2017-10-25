CheckIcon() {
	global
	If (ToggleCGxLayout = True) {
		Menu, Tray, Icon, on.ico, , 1
	} Else {
		Menu, Tray, Icon, off.ico, , 1
	}
	Return
}

; LED Control

Indicator(num) {
	KeyboardLED(4, "off", 144)
	Loop, %num% {
		Sleep, 150
		KeyboardLED(4, "on", 144)
		Sleep, 150
		KeyboardLED(4, "off", 144)
	}
	Sleep, 1000

	return 0
}

/*

    Keyboard LED control for AutoHotkey_L
        http://www.autohotkey.com/forum/viewtopic.php?p=468000#468000

    KeyboardLED(LEDvalue, "Cmd", Kbd)
        LEDvalue  - ScrollLock=1, NumLock=2, CapsLock=4
        Cmd       - on/off/switch
        Kbd       - index of keyboard (probably 0 or 2)

*/

KeyboardLED(LEDvalue, Cmd, Kbd=0)
{
  SetUnicodeStr(fn,"\Device\KeyBoardClass" Kbd)
  h_device:=NtCreateFile(fn,0+0x00000100+0x00000080+0x00100000,1,1,0x00000040+0x00000020,0)
  
  If Cmd= switch  ;switches every LED according to LEDvalue
   KeyLED:= LEDvalue
  If Cmd= on  ;forces all choosen LED's to ON (LEDvalue= 0 ->LED's according to keystate)
   KeyLED:= LEDvalue | (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
  If Cmd= off  ;forces all choosen LED's to OFF (LEDvalue= 0 ->LED's according to keystate)
    {
    LEDvalue:= LEDvalue ^ 7
    KeyLED:= LEDvalue & (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    }
  
  success := DllCall( "DeviceIoControl"
              ,  "ptr", h_device
              , "uint", CTL_CODE( 0x0000000b     ; FILE_DEVICE_KEYBOARD
                        , 2
                        , 0             ; METHOD_BUFFERED
                        , 0  )          ; FILE_ANY_ACCESS
              , "int*", KeyLED << 16
              , "uint", 4
              ,  "ptr", 0
              , "uint", 0
              ,  "ptr*", output_actual
              ,  "ptr", 0 )
  
  NtCloseFile(h_device)
  return success
}

CTL_CODE( p_device_type, p_function, p_method, p_access )
{
  Return, ( p_device_type << 16 ) | ( p_access << 14 ) | ( p_function << 2 ) | p_method
}


NtCreateFile(ByRef wfilename,desiredaccess,sharemode,createdist,flags,fattribs)
{
  VarSetCapacity(objattrib,6*A_PtrSize,0)
  VarSetCapacity(io,2*A_PtrSize,0)
  VarSetCapacity(pus,2*A_PtrSize)
  DllCall("ntdll\RtlInitUnicodeString","ptr",&pus,"ptr",&wfilename)
  NumPut(6*A_PtrSize,objattrib,0)
  NumPut(&pus,objattrib,2*A_PtrSize)
  status:=DllCall("ntdll\ZwCreateFile","ptr*",fh,"UInt",desiredaccess,"ptr",&objattrib
                  ,"ptr",&io,"ptr",0,"UInt",fattribs,"UInt",sharemode,"UInt",createdist
                  ,"UInt",flags,"ptr",0,"UInt",0, "UInt")
  return % fh
}

NtCloseFile(handle)
{
  return DllCall("ntdll\ZwClose","ptr",handle)
}


SetUnicodeStr(ByRef out, str_)
{
  VarSetCapacity(out,2*StrPut(str_,"utf-16"))
  StrPut(str_,&out,"utf-16")
}

MouseManager() {
	global
	if (Mouse_Speed < 7) {
		Mouse_Speed += 0.5
	}
	ToolTip, Speed %Mouse_Speed%.
	local speed := 2**Mouse_Speed
	local x := 0
	local y := 0

	if (MMU = True) {
		y -= 1
	}
	if (MMD = True) {
		y += 1
	}
	if (MML = True) {
		x -= 1
	}
	if (MMR = True) {
		x += 1
	}
	
	MouseMove, x*speed, y*speed, 0, R
}

MouseReset() {
	global
	if (MMU = False and MMD = False and MML = False and MMR = False) {
		Mouse_Speed := 3
	}
}

; Toggle CGx Layout with \
ToggleCGxLayout := True

; Toggle Numeric Layout with '2'
ToggleNumLayout := False

; Toggle Symbolic Layout with '3'
ToggleSymLayout := False

; Toggle Mouse Layout with '9'
ToggleMouseLayout := False

MMU := False
MMD := False
MML := False
MMR := False
Mouse_Speed := 3

CheckIcon()

TurnOfLayouts() {
	global
	ToggleCGxLayout := False
	ToggleNumLayout := False
	ToggleSymLayout := False
	ToggleMouseLayout := False
}

ToggleLayout(x) {
	global
	If (x = 0) {
		ToggleCGxLayout := !ToggleCGxLayout
		If (ToggleCGxLayout = True) {
			TurnOfLayouts()
			ToggleCGxLayout := True
		} Else {
			TurnOfLayouts()
		}
	} Else If (x = 2) {
		If (ToggleNumLayout = False) {
			TurnOfLayouts()
			ToggleNumLayout := True
		} Else {
			TurnOfLayouts()
			ToggleCGxLayout := True
		}
	} Else If (x = 3) {
		If (ToggleSymLayout = False) {
			TurnOfLayouts()
			ToggleSymLayout := True
		} Else {
			TurnOfLayouts()
			ToggleCGxLayout := True
		}
	} Else If (x = 9) {
		If (ToggleMouseLayout = False) {
			TurnOfLayouts()
			ToggleMouseLayout := True
		} Else {
			TurnOfLayouts()
			ToggleCGxLayout := True
		}
	}

	CheckIcon()

	Return
}

^2::ToggleLayout(2)

^3::ToggleLayout(3)

^9::ToggleLayout(9)

^\::ToggleLayout(0)

$Backspace::
	Send, {Delete}
Return

CapsLock::BackSpace

!CapsLock::CapsLock

#if ToggleNumLayout
m::Send, {1}
,::Send, {2}
.::Send, {3}
j::Send, {4}
k::Send, {5}
l::Send, {6}
u::Send, {7}
i::Send, {8}
o::Send, {9}
/::Send, {0}
`;::Send, {.}
p::Send, {,}

#if ToggleSymLayout
i::Send, {`(}
o::Send, {`)}
k::Send, {`[}
l::Send, {`]}
,::Send, {`{}
.::Send, {`}}

j::Send, {+}
`;::Send, {-}
u::Send, {*}
p::Send, {^}
/::Send, {/}
m::Send, {`%}

#if ToggleMouseLayout
; Right Hand Mouse
+e::MouseMove, 0, -100, .5, R
+s::MouseMove, -100, 0, .5, R
+d::MouseMove, 0, 100, .5, R
+f::MouseMove, 100, 0, .5, R

e::MouseMove, 0, -10, .5, R
s::MouseMove, -10, 0, .5, R
d::MouseMove, 0, 10, .5, R
f::MouseMove, 10, 0, .5, R
w::RButton
r::LButton
c::MButton

; Left Hand Mouse
+i::MouseMove, 0, -100, .5, R
+j::MouseMove, -100, 0, .5, R
+k::MouseMove, 0, 100, .5, R
+l::MouseMove, 100, 0, .5, R

i::MouseMove, 0, -10, .5, R
j::MouseMove, -10, 0, .5, R
k::MouseMove, 0, 10, .5, R
l::MouseMove, 10, 0, .5, R
u::LButton
o::RButton
,::MButton


#if ToggleCGxLayout

$3::
	ToolTip, Brackets Map
return

3 Up::
	ToolTip
return

~RControl::
	ToolTip, Brackets Map
return

~RControl Up::
	ToolTip
return

~LAlt::
	ToolTip, Brackets Map
return

~LAlt Up::
	ToolTip
return

~RAlt::
	ToolTip, Mouse & Direction Map
return

~RAlt Up::
	ToolTip
return

; Top Row
q::w
w::l
e::r
r::j
t::-
+t::_
y::!
+y::?
u::k
i::i
o::u
p::v
[::'
]::=

; Home Row
a::s
s::n
d::t
f::d
g::,
+g::&
h::.
+h::*
j::a
k::e
l::o
`;::h
'::;

; Bottom Row
z::z
x::p
c::c
v::y
b::q
n::x
m::m
,::f
.::b
/::g

; General Commands
^x::^x
^c::^c
^v::^v

^z::^z

^a::^a
^s::^s

^q::^q
^w::^w

^/::^!n

; Numbers
2 & y::Send, {-}
2 & u::Send, {7}
2 & i::Send, {8}
2 & o::Send, {9}
2 & p::Send, {,}
2 & [::Send, {`%}

2 & h::Send, {+}
2 & j::Send, {4}
2 & k::Send, {5}
2 & l::Send, {6}
2 & `;::Send, {.}
2 & '::Send, {/}

2 & n::Send, {*}
2 & m::Send, {1}
2 & ,::Send, {2}
2 & .::Send, {3}
2 & /::Send, {0}

; Symbols
3 & y::Send, {}
3 & u::Send, {}
3 & i::Send, {`(}
3 & o::Send, {`)}
3 & p::Send, {}
3 & [::Send, {}

3 & h::Send, {}
3 & j::Send, {}
3 & k::Send, {`[}
3 & l::Send, {`]}
3 & `;::Send, {}
3 & '::Send, {}

3 & n::Send, {}
3 & m::Send, {}
3 & ,::Send, {`{}
3 & .::Send, {`}}
3 & /::Send, {}

; More Symbols
0 & q::Send, {``}
0 & w::Send, {~}
0 & e::Send, {-}
0 & r::Send, {|}
0 & t::Send, {\}

0 & a::Send, {!}
0 & s::Send, {<}
0 & d::Send, {>}
0 & f::Send, {=}
0 & g::Send, {^}

0 & z::Send, {`@}
0 & x::Send, {$}
0 & c::Send, {&}
0 & v::Send, {#}
0 & b::Send, {`%}

;;

~RControl & q::Send, {}
~RControl & w::Send, {U+0CA5}_{U+0CA5} ; Crying
~RControl & e::Send, ({U+256F}{U+00B0}{U+25A1}{U+00B0}) {U+256F}{U+FE35} {U+253B}{U+2501}{U+253B} ; Flip Table
~RControl & r::Send, {}
~RControl & t::Send, {}

~RControl & a::Send, {}
~RControl & s::Send, {U+0CA0}_{U+0CA0} ; Look of disaproval
~RControl & d::Send, ( {U+0361}{U+00B0} {U+035C}{U+0296} {U+0361}{U+00B0}) ; Lenny Face
~RControl & f::Send, {U+00AF}{U+005C}{U+005F}{U+0028}{U+30C4}{U+0029}{U+005F}{U+002F}{U+00AF} ; Shrug
~RControl & g::Send, {}

~RControl & z::Send, {}
~RControl & x::Send, {}
~RControl & c::Send, {}
~RControl & v::Send, {}
~RControl & b::Send, {}

;;;

~LAlt & q::Send, {}
~LAlt & w::Send, {U+0CA5}_{U+0CA5} ; Crying
~LAlt & e::Send, ({U+256F}{U+00B0}{U+25A1}{U+00B0}) {U+256F}{U+FE35} {U+253B}{U+2501}{U+253B} ; Flip Table
~LAlt & r::Send, {}
~LAlt & t::Send, {}

~LAlt & a::Send, {}
~LAlt & s::Send, {U+0CA0}_{U+0CA0} ; Look of disaproval
~LAlt & d::Send, ( {U+0361}{U+00B0} {U+035C}{U+0296} {U+0361}{U+00B0}) ; Lenny Face
~LAlt & f::Send, {U+00AF}{U+005C}{U+005F}{U+0028}{U+30C4}{U+0029}{U+005F}{U+002F}{U+00AF} ; Shrug
~LAlt & g::Send, {}

~LAlt & z::Send, {}
~LAlt & x::Send, {}
~LAlt & c::Send, {}
~LAlt & v::Send, {}
~LAlt & b::Send, {}

; Direction
; Left Hand
~RAlt & q::Send, {PgUp}
~RAlt & w::Send, {Home}
~RAlt & e::Send, {Up}
~RAlt & r::Send, {End}
~RAlt & t::Send, {}

~RAlt & a::Send, {PgDn}
~RAlt & s::Send, {Left}
~RAlt & d::Send, {Down}
~RAlt & f::Send, {Right}
~RAlt & g::Send, {}

~RAlt & z::Send, {}
~RAlt & x::Send, {}
~RAlt & c::Send, {}
~RAlt & v::Send, {}
~RAlt & b::Send, {}

; Right Hand

~RAlt & y::Send, {}
~RAlt & u::Send, {LButton}

~RAlt & i::
	MMU := True
	MouseManager()
Return
~RAlt & i Up::
	MMU := False
	MouseReset()
Return

~RAlt & o::Send, {RButton}
~RAlt & p::Send, {}
~RAlt & [::Send, {}

~RAlt & h::Send, {}

~RAlt & j::
	MML := True
	MouseManager()
Return
~RAlt & j Up::
	MML := False
	MouseReset()
Return

~RAlt & k::
	MMD := True
	MouseManager()
Return
~RAlt & k Up::
	MMD := False
	MouseReset()
Return

~RAlt & l::
	MMR := True
	MouseManager()
Return
~RAlt & l Up::
	MMR := False
	MouseReset()
Return

~RAlt & `;::Send, {}
~RAlt & '::Send, {}

~RAlt & n::Send, {}
~RAlt & m::Send, {}
~RAlt & ,::Send, {MButton}
~RAlt & .::Send, {}
~RAlt & /::Send, {}
