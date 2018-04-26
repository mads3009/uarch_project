.ORG 0X0000
movl    $0x100, %esp
movl    $0xa00, %ecx		
movw    %cx, %ds             
movl    $0x08090a0b, %eax       
pushl   %eax
popl    %ebx		       
hlt

