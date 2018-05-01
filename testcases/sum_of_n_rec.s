.ORG   0x00000000
movl    $20, %eax
movl    $0x0, %ebx
movl    $0xb00, %ecx
movw    %cx, %ss
movl    $0x100, %esp

calll    L1
hlt

.ORG 0x400
L1 : addl %eax, %ebx
addl $-0x1, %eax
jne L2
retl
L2: calll L1
retl
