.ORG 0x52
popl %ecx
movl $0xffe, %ecx
pushl %ecx
hlt
iret

.ORG   0x00000fce
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
movl $0x1000,%eax
movl $0x2000,%eax
movl $0x3000,%eax
movl $0x4000,%eax
movl $0x5000,%eax
movl $0x6000,%eax
addl $0x12345678, %eax
inc %eax
inc %ebx

// 2000068: 52 00 00 00
// 200006c: 00 00 00 00
// 2000070: 52 00 00 00
// 2000074: 00 00 00 00

//1. hlt before prefetch exp(pagefault)
//hlt
//hlt
//addl $0x1, %eax

//2. Instruction on prefetch data. exp has to wait until EIP gets there
//inc %eax
//inc %ebx
//addl $0x1, %eax

//3.opcode modrm split
//addl $0x1, %edi



