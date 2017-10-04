; Toggle CGx Layout with altL + altR
ToggleCGxLayout := True

; Toggle Numeric Layout with '2'
ToggleNumLayout := False

; Toggle Symbolic Layout with '3'
ToggleSymLayout := False

; Toggle Mouse Layout with '9'
ToggleMouseLayout := False

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

	Return
}

^2::ToggleLayout(2)

^3::ToggleLayout(3)

^9::ToggleLayout(9)

^0::ToggleLayout(0)

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
w::l
e::r
r::j
t::;
y::/
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
h::.
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
-::^c
=::^v

; Numbers
2 & m::Send, {1}
2 & ,::Send, {2}
2 & .::Send, {3}
2 & j::Send, {4}
2 & k::Send, {5}
2 & l::Send, {6}
2 & u::Send, {7}
2 & i::Send, {8}
2 & o::Send, {9}
2 & /::Send, {0}
2 & `;::Send, {.}
2 & p::Send, {,}

; Symbols
3 & i::Send, {`(}
3 & o::Send, {`)}
3 & k::Send, {`[}
3 & l::Send, {`]}
3 & ,::Send, {`{}
3 & .::Send, {`}}

3 & j::Send, {+}
3 & `;::Send, {-}
3 & u::Send, {*}
3 & p::Send, {^}
3 & /::Send, {/}
3 & m::Send, {`%}

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