.ORG 0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es

movl $0xABCD1234, %ebx
addl $-0xABCD1234, %ebx
jnbe L1
addl $0x9999, %ebx
jnbe L1
movl $0xDEAD, %esi

L1: addl $0x1, %edi
addl $-0x1, %edi
jne L2
addl $0x5, %edi
jne L2
movl $0xDEAD, %esi

L2: orl $0x10, %edi
hlt
