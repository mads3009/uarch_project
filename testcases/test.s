.ORG 0X0000
inc %ax
mov $0x5566, %bx
xchg %bl, %cl
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
L1: add $0x0, %edx
jne L1
add $0x1, %edx
jne L3
mov $0x1234, %bx
L3: hlt

.ORG 0x500
L2: mov $3569, %esp
hlt

