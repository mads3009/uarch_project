.ORG 0X0000

inc %ax
xchg %bx, %ax
mov $0x5566, %bx
xchg %bl, %cl
hlt
