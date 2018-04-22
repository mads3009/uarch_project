.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0x0, %ebx
addl   (%ebx), %eax 
hlt

