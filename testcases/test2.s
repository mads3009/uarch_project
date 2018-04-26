.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xDE54      , %eax

movb    %ah          , %al 
movb    %al          , %ch 
movb    %dh          , %dl 
movb    %dh          , %bh

 
movw    %cx          , %bp 
movw    %ds          , %sp 

movw    $0x1134        , %si    
movb    $0x11          , %dh    
hlt

