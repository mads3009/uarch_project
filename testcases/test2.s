.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0xc00, %eax
movw    %ax, %fs
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
movl    $0xCD, %ebx

movl    $0xDEADBEEF, (%ebx) 
movl    $0x12345678, %es:(%ebx) 
movl    $0xABCD9988, %fs:(%ebx) 

movl    (%ebx), %esi 
movl    %es:(%ebx), %edi 
movl    %fs:(%ebx), %edx 

movl    (%ebx), %esi 
movl    %es:(%ebx), %edi 
movl    %fs:(%ebx), %edx 
addl    %esi, (%ebx) 
hlt
