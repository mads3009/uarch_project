.ORG   0x00000000

movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %edx
movw    %ax, %es
movl    $0x400, %edx
movw    %dx, %ss
movl    $4000, %esp

movl $1, %ebp

movl $0x12345678, (%edi,%ebp,4)
movl $0x90abcdef, 0x4(%edi,%ebp,4)

movq (%edi,%ebp,4), %mm1

movq %mm1, %mm3
movq %mm3, (%edx)

pshufw $0x36 ,(%edi,%ebp,4) ,%mm5  
pshufw $0xb1 ,%mm3 ,%mm3  

paddw %mm1, %mm3
paddw (%edx), %mm3

hlt
