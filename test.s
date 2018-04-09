.ORG 0X0000

L1: add %EAX, %EBX
add %AX, %BX
add %AX, %ES:0x2010(%EBX)
add %EAX, 0x2010(%EBX, %ECX,0x8)
add    $0xa5, %EBX
add    $0xa5, %BL

jmp L1
jmp $0x12,$0x3456
