.ORG   0x00000000
movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xb00, %eax
movw    %ax, %es
movl    $0x400, %eax
movw    %ax, %fs

movl  $0x400, %eax
movl  $0x01234567, (%eax)
movl  $0x89abcfef, 0x4(%eax)

movl  $0x030303e3,  %ecx
salb  $0x1, (%eax) 
salb  %cl, 0x4(%eax) 
salb  $0x2, 0x4(%eax)

movl $0x123f5678, %ebx
mov $0, %cl
sarb %cl, (%eax)
sarb $0x1, 4(%eax)
sarb $0x2, %bh

mov $0xe3, %cl
sarw %cl, (%eax)
sarw $0x1, (%eax)
sarw $0x4, 0x4(%eax)

salw %cl, %ebx
sarw $0x1, %ebx
salw $0x0, %ebx
salw $20, %ebx

sarl %cl, 4(%eax)
sarl $1, 4(%eax)
sarl $5, (%eax)

sall $0, 4(%eax)
sall $5, 4(%eax)
movl  $0x01234567, (%eax)
sall $29, (%eax)

mov $0xdeaddead, %eax

hlt

