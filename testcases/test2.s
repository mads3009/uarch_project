.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es

movl    $0x3D      , %esi
movl    $0x4E      , %edi
movl    $0x98767FF3, (%esi)
movl    $0x98CD9876, %es:(%edi)
movl    $0x14547FF3, 0x4(%esi)
movl    $0x12349876, %es:0x4(%edi)
movl    $0x14547FF3, 0x8(%esi)
movl    $0x12349876, %es:0x8(%edi)
addl $0x8, %esi
addl $0x8, %edi
std
movl    $0x7       , %ecx
repne cmpsw

hlt

movl    $0x98767FF3, (%esi)
movl    $0x98CD9876, %es:(%edi)
