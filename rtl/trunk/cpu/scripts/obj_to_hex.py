import re
import sys
inFile = sys.argv[1]
f_addr = open("hex_addr.txt", "w")
f_data = open("hex_data.txt", "w")
f_num = open("num_lines.txt", "w")
def zero_extend(value):
    zeros = '0' * (8-len(value))
    new_value = zeros + value
    return new_value

with open(inFile, 'r') as f1:
    content = f1.read()
    content = re.split("\n", content)
content = [x.strip() for x in content]
content = list(line for line in content if line)

cnt = 0
no_of_lines = 0
for i in content:
    if(cnt>=1):
        line = content[cnt]
        val = line.split()
        mem_addr = val[0]
        n = len(val)
        if (n>=5):
            n=5
        for col in range(1,n):
            if('..' not in val[col]):
                k = 0
                l = int((len(val[col]))/2)
                for j in range (0,l):
                    mem_addr_no_x = zero_extend(mem_addr.split('x')[1])
                    if(mem_addr_no_x[:5]=='00000'):
                        mem_addr_no_x = '0'+ mem_addr_no_x[5:]
                    elif (mem_addr_no_x[:5]=='02000'):
                        mem_addr_no_x = '2' + mem_addr_no_x[5:]
                    elif (mem_addr_no_x[:5]=='04000'):
                        mem_addr_no_x = '5' + mem_addr_no_x[5:]
                    elif (mem_addr_no_x[:5]=='0b000'):
                        mem_addr_no_x = '4' + mem_addr_no_x[5:]
                    elif (mem_addr_no_x[:5]=='0c000'):
                        mem_addr_no_x = '7' + mem_addr_no_x[5:]
                    elif (mem_addr_no_x[:5]=='0a000'):
                        mem_addr_no_x = '5' + mem_addr_no_x[5:]
                    f_addr.write('15\'h'+str(mem_addr_no_x))
                    f_data.write(val[col][k:k+2])
                    f_addr.write('\n')
                    f_data.write('\n')
                    no_of_lines = no_of_lines+1
                    k = k+2
                    tmp = hex(int(mem_addr,16) + 1)
                    mem_addr = tmp
    cnt = cnt +1
f_num.write(str(no_of_lines))

