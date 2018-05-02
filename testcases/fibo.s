.ORG 0X0000

movl    $0xa00, %edx
movw    %dx, %ds
movl    $0xc00, %edx
movw    %dx, %ss
movw    %dx, %fs
movl    $0xFF, %esp
movl    %esp , %edx
movl    $0x3, %fs:(%edx)


fib:
        
        movl    %esp , %edx
        movl %fs:0x4(%edx), %eax # get arg
        movl %eax, %esi # get arg
        movl %esi, %edi
        not %edi
        jne temp
        ret
temp:
        addl $0xFFFFFFFF, %esi # if x<=1 fib(x)=x
        jne endf
        ret
endf:
        pushl %ebx # save ebx
        addl $0xFFFFFFFF,%eax # eax=n-1
        pushl %eax # set arg
        call fib # res in eax
        mov %eax, %ebx # ebx=fib(n-1)
        movl    %esp , %edx
        addl $0xFFFFFFFF, %fs:(%edx) # arg -= 1
        call fib # res in eax
        addl $4, %esp # free arg
        addl %ebx, %eax #fib(n)=fib(n-1)+fib(n-2)
        popl %ebx # restore ebx
 
        

hlt 
