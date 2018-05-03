.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0x400, %eax
movw    %ax, %fs

movl  $0x400, %eax
movl  $0x01234567, (%eax)
movl  $0x89abcdef, 0x4(%eax)

movl  $0x030303e3,  %ecx
salb  $0x1, (%eax) 
salb  %cl, 0x4(%eax) 
salb  $0x2, 0x4(%eax)


