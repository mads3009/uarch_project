.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xFFFFFFFF      , %eax
movl    $0xFF00FF00      , %ecx

not     %eax
or      %ax              ,%cx
salw    %cl              ,%ax
sarb    $1               ,%cl
sarl    $7               ,%eax
            

hlt

