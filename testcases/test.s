.ORG 0X0000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %ecx
movw    %cx, %ss
inc %ax
mov $0x5566, %bx
jmp L1
movw $1234, %dx
L1 : movw $200, %dx

movl    $0xAB      , %eax
movw    $0x400      , (%eax)

movl $0xff, %esp 
call $0x0200,$00000000
L3 : mov $5555, %edx

.ORG 0x2000000
L2: mov $3569, %esp
hlt
callw (%eax)
