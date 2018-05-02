.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es

movl    $0xCD, %ebx
movl    $0x2, %ecx
movl $0x1234ABCD, (%ebx)
movl $0xDEADBEEF, %es:(%ebx)

addb $0x8, %ah
addb $0x8, %al
addb $0xFF, (%ebx)
addb %al, (%ebx)
addb (%ebx,%ecx), %ah

addw $0xABCD, %ax
addw $0x1234, (%ebx,%ecx)
addw $0x1234, %si
addw $0xFF, %si
addw %si, %es:(%ebx,%ecx)
addw %si, %di
addw (%ebx), %bp

andb $0x99, %ah
hlt
