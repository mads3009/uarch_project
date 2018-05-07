.ORG 0x0
movl $0x34, %eax
movl $0x83, %ebx
addl %ebx, %eax
daa

movl $0x98, %eax
movl $0x12, %ebx
addl %ebx, %eax
daa

movl $0x68, %eax
movl $0x19, %ebx
addl %ebx, %eax
daa

movl $0x64, %eax
movl $0x15, %ebx
addl %ebx, %eax
daa

mov $0x64, %al
mov $0xa5, %bl
add %bl, %al
daa

hlt
