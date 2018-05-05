.ORG   0x00000000
movl    $0x400, %edx
movw    %dx, %ds
movl    $0x300, %esp
movl    $0xa00, %edi
movw    %di, %ss
movl    $0xffe,%eax

movl    $0x12345678, (%eax)
addl (%eax), %edx
addl %edx, (%eax)
movl $0xdddddddd, %ecx
hlt

.ORG 0x52
movl $0xdead, %ecx
hlt

.ORG 0x58
movl $0xbeaf, %ecx
hlt
iret

//02000070: 58 00 00 00
//02000074: 00 00 00 00
//
//02000068: 52 00 00 00
//0200006c: 00 00 00 00

