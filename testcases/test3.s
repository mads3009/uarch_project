.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xAB      , %eax
movl    $0xCD      , %ecx
movl    $0xABCDFFFF, %edx
movl    $0xCD      , (%eax)
movl    $0xFFFF0001  ,(%ecx)

addb    %cl         ,(%eax) 
addl    %edx        ,(%eax) 
addw    %dx         ,(%ecx) 

andl    %edx        ,(%ecx)
hlt
