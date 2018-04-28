.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0x02      , %eax
movl    $0x01      , %ebx
movl    $0x06      , %ebp
movl    $0x12      , (%eax)
movl    $0x13      , (%ebp)
movl    $0xCD      , %esi

addl    $0xDEADBEEF,(%eax,%ebx,0x4) 
movq    (%eax)     ,%mm1     

movl    $0x32      , %eax
movl    $0x36      , %ebx
movl    $0x98767FF3,(%eax)
movl    $0xABCD9876,(%ebx)
movq    (%eax)     ,%mm2

paddsw   %mm1        ,%mm2
pshufw   $0x8D  ,%mm2  ,%mm1
hlt

