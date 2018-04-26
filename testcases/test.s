.ORG 0X0000
inc %ax
mov $0x5566, %bx
xchg %bl, %cl
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
L1: add $0x10000000, %ebx
jnbe L2
mov $0x1234, %bx
hlt

.ORG 0x500
L2: mov $3569, %esp
hlt

