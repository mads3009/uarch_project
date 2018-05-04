.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0xc00, %eax
movw    %ax, %fs
movl    $0xd00, %eax
movw    %ax, %gs
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss

push %ds
push %es
push %fs
push %gs
push %ss
push %cs

popl %ebx
pop %ss
pop %ds  
pop %es 
pop %fs
pop %gs

movw %dx, %ds
movl $0x0200, %ebx
movl $0x020, %ecx

movl $0xDEADBEEF, (%ebx,%ecx,0x8)
pushl (%ebx,%ecx,0x8)
popl %edi

pushw %di
pushw 0x2(%ebx,%ecx,0x8)

popw (%ebx)
popw (%ecx)

pushl $0xABCD1234
popl %esp

movl    $0x300, %esp
push %esp
 
hlt

//ds 0d00
//es 0c00
//fs 0b00
//gs 0a00
