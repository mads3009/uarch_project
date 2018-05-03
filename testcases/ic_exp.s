.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
jmp $0x0300,$0x00000000
hlt

.ORG 0x02000070
hlt
