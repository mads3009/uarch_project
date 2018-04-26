.ORG 0X0000

inc %ax
mov $0x5566, %bx
xchg %bl, %cl
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
cmpxchg %cx,%bx 
cmovc %ebx, %ebp
hlt
