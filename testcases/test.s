.ORG 0X0000

inc %ax
mov $0x5566, %bx
xchg %bl, %cl
cmpxchg %cx,%bx 
cmpxchg %cx,%bx 
hlt
