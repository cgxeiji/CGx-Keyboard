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

; Toggle CGx Layout with \
ToggleCGxLayout := True

; Toggle Numeric Layout with '2'
ToggleNumLayout := False

; Toggle Symbolic Layout with '3'
ToggleSymLayout := False

; Toggle Mouse Layout with '9'
ToggleMouseLayout := False

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

<!CapsLock::CapsLock

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
; Top Row
q::w
w::g
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
/::l

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
2 & y::Send, {}
2 & u::Send, {7}
2 & i::Send, {8}
2 & o::Send, {9}
2 & p::Send, {,}
2 & [::Send, {}

2 & h::Send, {=}
2 & j::Send, {4}
2 & k::Send, {5}
2 & l::Send, {6}
2 & `;::Send, {.}
2 & '::Send, {}

2 & n::Send, {$}
2 & m::Send, {1}
2 & ,::Send, {2}
2 & .::Send, {3}
2 & /::Send, {0}

; Symbols
3 & y::Send, {}
3 & u::Send, {*}
3 & i::Send, {`(}
3 & o::Send, {`)}
3 & p::Send, {^}
3 & [::Send, {&}

3 & h::Send, {}
3 & j::Send, {+}
3 & k::Send, {`[}
3 & l::Send, {`]}
3 & `;::Send, {-}
3 & '::Send, {#}

3 & n::Send, {}
3 & m::Send, {`%}
3 & ,::Send, {`{}
3 & .::Send, {`}}
3 & /::Send, {/}

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
0 & b::Send, {}

;;

0 & y::SendInput, ({U+256F}{U+00B0}{U+25A1}{U+00B0}) {U+256F}{U+FE35} {U+253B}{U+2501}{U+253B} ; Flip Table
0 & u::SendInput, {U+0CA0}_{U+0CA0} ; Look of disaproval
0 & i::SendInput, {U+0CA5}_{U+0CA5} ; Crying
0 & o::Send, {}
0 & p::Send, {}
0 & [::Send, {}

0 & h::Send, {}
0 & j::SendInput, {U+00AF}{U+005C}{U+005F}{U+0028}{U+30C4}{U+0029}{U+005F}{U+002F}{U+00AF} ; Shrug
0 & k::SendInput, ( {U+0361}{U+00B0} {U+035C}{U+0296} {U+0361}{U+00B0}) ; Lenny Face
0 & l::Send, {}
0 & `;::Send, {}
0 & '::Send, {}

0 & n::Send, {}
0 & m::Send, {}
0 & ,::Send, {}
0 & .::Send, {}
0 & /::Send, {}

; Mouse
; Right Hand Mouse
	;9 & w::MouseMove, 0, -10, .5, R
	;9 & a::MouseMove, -10, 0, .5, R
	;9 & s::MouseMove, 0, 10, .5, R
	;9 & d::MouseMove, 10, 0, .5, R
9 & e::Send, {Up}
9 & s::Send, {Left}
9 & d::Send, {Down}
9 & f::Send, {Right}
9 & w::Send, {RButton}
9 & r::Send, {LButton}
9 & c::Send, {MButton}

; Left Hand Mouse
9 & i::MouseMove, 0, -10, .5, R
9 & j::MouseMove, -10, 0, .5, R
9 & k::MouseMove, 0, 10, .5, R
9 & l::MouseMove, 10, 0, .5, R
9 & u::Send, {LButton}
9 & o::Send, {RButton}
9 & ,::Send, {MButton}
