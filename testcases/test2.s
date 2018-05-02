.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es

movl    $0xCD, %ebx
movl    $0x2, %ecx
movl $0x1234ABCD, (%ebx)

addb $0x8, %ah
addb $0x8, %al
addb $0xFF, (%ebx)
addb %al, (%ebx)
addb (%ebx,%ecx), %ah
hlt
