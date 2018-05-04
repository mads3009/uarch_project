.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
movl $0x1000,%eax
jmp *%eax
mov $0xdeaddead, %eax
hlt

.ORG 0x52
popl %ecx
movl $0xffe, %ecx
pushl %ecx
iret

.ORG 0xffe 
inc %edi
hlt

.ORG 0x2000068
