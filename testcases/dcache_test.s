.ORG 0X0000
movl    $0xa00, %edx		
movw    %dx, %ds                
addw    $0x100, %dx           
movw    %dx, %fs                
movl    $0x08090a0b, %eax       
movl    $0xfd, %ebx             
movl    $0x03040506, 0xffffffff(%ebx)
                               
movl    %eax, 0x3(%ebx)        
                               
sarl    (%ebx)		       
                               
                               
movb    %ah, 0x2(%ebx)         
                               
movl    %eax, 0x0800(%ebx)     
                               
movl    %edx, %fs:(%ebx)       
                               
addl    (%ebx), %eax           
                               
      			       
      			       
hlt 
