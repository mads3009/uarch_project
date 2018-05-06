.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0xc00, %eax
movw    %ax, %fs

movl    $0x3d      , %esi
movl    $0x40e      , %edi

movl    $40, %ecx
l1:     movl    $0x11111111, (%esi,%ecx)
        movl    $0x22222222, %es:(%esi,%ecx)
        movl    $0x33333333, %fs:(%esi,%ecx)
        addl    (%esi, %ecx), %ebx
        addl    %ebx, %es:(%esi,%ecx) 
        addl    %fs:(%esi,%ecx), %edx 
        addl    $-0x4, %ecx 
        jne l1

movl    $0xdeadbeaf, %ecx
hlt
