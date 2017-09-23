; Toggle CGx Layout with altL + altR
ToggleCGxLayout := True

; Toggle Numeric Layout with '1'
ToggleNumLayout := False

; Toggle Symbolic Layout with '2'
ToggleSymLayout := False

TurnOfLayouts() {
    global
    ToggleCGxLayout := False
    ToggleNumLayout := False
    ToggleSymLayout := False
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
    } Else If (x = 1) {
        If (ToggleNumLayout = False) {
            TurnOfLayouts()
            ToggleNumLayout := True
        } Else {
            TurnOfLayouts()
            ToggleCGxLayout := True
        }
    } Else If (x = 2) {
        If (ToggleSymLayout = False) {
            TurnOfLayouts()
            ToggleSymLayout := True
        } Else {
            TurnOfLayouts()
            ToggleCGxLayout := True
        }
    }

    Return
}

^1::ToggleLayout(1)

^2::ToggleLayout(2)

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

#if ToggleSymLayout
i::Send, {`(}
o::Send, {`)}
k::Send, {`[}
l::Send, {`]}
,::Send, {`{}
.::Send, {`}}

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
;]::

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

; Numbers
1 & m::Send, {1}
1 & ,::Send, {2}
1 & .::Send, {3}
1 & j::Send, {4}
1 & k::Send, {5}
1 & l::Send, {6}
1 & u::Send, {7}
1 & i::Send, {8}
1 & o::Send, {9}
1 & /::Send, {0}
1 & `;::Send, {.}

; Symbols
2 & i::Send, {`(}
2 & o::Send, {`)}
2 & k::Send, {`[}
2 & l::Send, {`]}
2 & ,::Send, {`{}
2 & .::Send, {`}}