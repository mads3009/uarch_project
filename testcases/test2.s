.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss

movl $0x0200, %ebx
movl $0x020, %ecx

movl $0xDEADBEEF, (%ebx,%ecx,0x8)
cmpxchgb %dh, (%ebx,%ecx,0x8)

movl $0xFFFFFFFF, %eax
cmpxchgw %ax, (%ebx,%ecx,0x8)

movl $0xFFFFFFFF, %eax
cmpxchgl %eax, (%ebx,%ecx,0x8)

movl $0xDEADBEEF, %eax 
movl $0xDEADBEEF, (%ebx,%ecx,0x8)
cmpxchgb %dh, (%ebx,%ecx,0x8)

movl $0xDEADBEEF, (%ebx,%ecx,0x8)
cmpxchgb %ah, (%ebx,%ecx,0x8)

movl $0xDEADBEEF, (%ebx,%ecx,0x8)
cmpxchgw %ax, (%ebx,%ecx,0x8)

cmpxchgl %edx, (%ebx,%ecx,0x8)
 
hlt

//ds 0d00
//es 0c00
//fs 0b00
//gs 0a00
