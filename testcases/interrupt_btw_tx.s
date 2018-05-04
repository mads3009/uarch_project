.ORG   0x00000000
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss
movl    $0x8000, %edx
movw    %dx, %fs
movl    $0x00000000, %edi
movl    $0xABCD9876, %fs:(%edi)
movl    $0x5010, %fs:0x4(%edi)
movl    $0x50, %fs:0x8(%edi)
movl    $0x1, %fs:0xc(%edi)

addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi
addl    $0x1, %edi

movl    $100, %ebx
L1 :    addl $0x1, %edi
        addl $-0x1, %ebx
        jne L1

hlt

.ORG 0x0c000030
addl    $0x8, %edi
iret

// 2000010: 30 00 00 00
// 2000014: 00 0c 00 00

