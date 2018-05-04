.ORG   0x00000000

movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %edx
movw    %ax, %es
movl    $0x400, %edx
movw    %dx, %ss
movl    $4000, %esp

movl $1, %ebp

movl $0x12345678, (%edx,%ebp,4)
movl $0x945728fa, %esi

movl $0x90abcdef ,%ecx
xchgw %cx, %ax
xchgl %ecx, %eax

xchg %ah, (%edx, %ebp, 4)
xchgw %cx, (%edx, %ebp, 4)
xchgl %esi, (%edx, %ebp, 4)

hlt
