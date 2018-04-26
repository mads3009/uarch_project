.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xAB      , %eax
movl    $0xCD      , %ecx

addb    %cl        ,(%eax) 

hlt

