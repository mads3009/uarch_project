.ORG   0x00000000
movl    $0x300, %esp
movl    $0x400, %ebp
movw    %bp, %ss
movl    $0xb00, %eax
movw    %ax, %es
movl    $0xa00, %eax
movw    %ax, %ds
movl    $0xff7     , %esi
movl    $0x3f7     , %edi
movl    $0x12345678, (%esi)
movl    $0xDEADBEEF, %es:(%edi)
movl    $0xffb     , %esi
movl    $0x3fb     , %edi
movl    $0xDEADBEEF, (%esi)
movl    $0xABCD9999, %es:(%edi)
movl    $0x3 , %ecx

movl    $0xff7     , %esi
movl    $0x3f7     , %edi

repne cmpsl

hlt

.ORG 0x70
movl    $0xff7     , %esi
movl    $0x3f7     , %edi
iret

.ORG 0x2000068

