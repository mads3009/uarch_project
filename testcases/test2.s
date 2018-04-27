.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %ecx
movw    %cx, %gs
movl    $0x02      , %eax
movl    $0x01      , %ebx
movl    $0x06      , %ebp
movl    $0x12      , %gs:(%eax)
movl    $0x13      , %gs:(%ebp)

addw    %dx       ,%gs:0x3(%eax,%ebx,0x2) 

hlt

