.ORG   0x00000000
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
movl    $0x8000, %edx
movw    %dx, %fs
movl    $0x00000000, %edi
movl    $0xABCD9876, %fs:(%edi)
movl    $0x5010, %fs:0x4(%edi)
movl    $0x100, %fs:0x8(%edi)
movl    $0x1, %fs:0xc(%edi)

addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
hlt

.ORG 0x02000010
.fill 0x00000030
.fill 0x00000c00


.ORG 0x0c000030
addl    $0x8, %edi
iret

