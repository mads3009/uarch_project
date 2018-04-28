.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0x32      , %esi
movl    $0x36      , %edi
movl    $0x98767FF3,(%esi)
movl    $0xABCD9876, %es:(%edi)

cmpsb

hlt

