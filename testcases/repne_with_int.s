.ORG   0x00000000
movl    $0x300, %esp
movl    $0x400, %ebp
movw    %bp, %ss
movl    $0x8000, %edx
movw    %dx, %fs
movl    $0x00000000, %eax
movl    $0xABCD9876, %fs:(%eax)
movl    $0x5013, %fs:0x4(%eax)
movl    $0x60, %fs:0x8(%eax)
movl    $0x1, %fs:0xc(%eax)

addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp
addl    $0x1, %ebp

movl    $0xb00, %eax
movw    %ax, %es
movl    $0xc00, %eax
movw    %ax, %ds

movl    $0x3d      , %esi
movl    $0x4e      , %edi

movl    $52       , %ecx

movl    $20, %ebx
L1 :    movl    $0x99767Ff3, (%esi)
        movl    $0x98cd9876, %es:(%edi)
        add $4, %esi
        add $4, %edi
        addl $-0x1, %ebx
        jne L1

movl    $0x3d      , %esi
movl    $0x4e      , %edi

//IDTR
movl    $0x200, %eax
movw    %ax, %ds
movl    $0x010,  %eax
movl    $0x0c000030, (%eax)
movl    $0x00000000, 0x4(%eax)

movl    $0xa00, %eax
movw    %ax, %ds

repne cmpsb

push $0x1234
push $0xdeadbeaf

hlt

.ORG 0x0c000030
addl    $0x8, %ebp
iret

