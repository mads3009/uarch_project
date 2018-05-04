// Exception Test Public Test Program
// EE382N Spring 2018

.ORG 0x52
addw	  $-1, %bx
iret

.ORG 0x58
movl $0xdeaddead, %ecx
hlt
iret
		
.ORG 0x00000FD6
movl    $0x300, %esp			
movl    $0x400, %edi      
movw    %di, %ss          
movl    $0xb00, %eax      
movw    %ax, %es          
movl    $0x03b7, %ebx     
movl    $0x10, %ebp       
salw	  $0x8, %ax         

movw    $0x0a09, %es:0x8(%ebx, %ebp, 4)  
inc     %eax
addl    $0x1, %eax
hlt

//0b0003fc:	01 02 03 04
//0b000400:	05 06 07 08

//02000070: 58 00 00 00
//02000074: 00 00 00 00
//
//02000068: 52 00 00 00
//0200006c: 00 00 00 00

