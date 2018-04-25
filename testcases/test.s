.ORG 0X0000

inc %ax
xchg %bx, %ax
mov $0x55, %bx
xchg %ebx, %ecx
hlt
