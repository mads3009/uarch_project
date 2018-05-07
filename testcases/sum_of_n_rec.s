.ORG   0x00000000
movl    $30, %eax
movl    $0xb00, %ecx
movw    %cx, %ss

movl    $0x100, %esp

call   $0xa00, $0x00000000
hlt

.ORG 0xa000000
L1 : addl %eax, %ebx
addl $-0x1, %eax
jne L2
retf
//L2: calll L1
L2 : call   $0xa00, $0x00000000
retf
