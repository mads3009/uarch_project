.ORG   0x00000000
movl    $0x300, %esp
movl    $0x400, %edi
movw    %di, %ss

movl    $0xC000, %edx
movw    %dx, %fs
movl    $0x00000000, %edi

andl    $0x0, %ebx

loop:
jne label
movl    %fs:(%edi), %ebx
andl    $0x1, %ebx
jmp loop

label: 
movl    %fs:0x4(%edi), %ebx
movl    $0x00000000, %fs:(%edi)


hlt

