.ORG 0X0000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xc00, %edx
movw    %dx, %ss
movl    $0xFF, %esp
movw    $0xCD, %bx
movw    $0x2,  %cx
movl    $0xABCD1234 , (%ebx)
pushw   (%ebx,%ecx)

hlt 
