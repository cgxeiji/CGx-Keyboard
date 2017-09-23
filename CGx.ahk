; Toggle Numeric Layout with '1'
ToggleNumLayout := False

^1::ToggleNumLayout := !ToggleNumLayout

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

#if Not ToggleNumLayout
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
