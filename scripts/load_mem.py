import re
import sys
import os
import numpy as np

name = sys.argv[2]
res = sys.argv[1]

size = 4096

data = np.empty((8*4096,), dtype=object)
for i in range(0,8*size): 
    data[i]="00"

def zero_extend(value):
    zeros = '0' * (8-len(value))
    new_value = zeros + value
    return new_value

with open(name, 'r') as f1:
    content = f1.read()
    content = re.split("\n", content)

content = [x.strip() for x in content]
content = list(line for line in content if line)

for cnt in range(0,len(content)):
    line = content[cnt]
    line = line.split("/")[0]

    if(len(line) and line[0]!=""):
        vals = line.split()
        n = len(vals) - 1

        if("0x" in vals[0]):
            mem_addr = vals[0].split(":")[0]
            mem_addr_no_x = zero_extend(mem_addr.split('x')[1])

            print(mem_addr_no_x)
            #if(mem_addr_no_x[:5]=='00000'):
            #    page = 0
            #elif (mem_addr_no_x[:5]=='02000'):
            #    page = 2 
            #elif (mem_addr_no_x[:5]=='04000'):
            #    page = 5 
            #elif (mem_addr_no_x[:5]=='0b000'):
            #    page = 4 
            #elif (mem_addr_no_x[:5]=='0c000'):
            #    page = 7 
            #elif (mem_addr_no_x[:5]=='0a000'):
            #    page = 5 
            #else:
            #    print("pagefault!")

            #offset = int(mem_addr_no_x[5:8],16)
            #addr = (size*page) + offset

            addr = int(mem_addr_no_x,16)

            for v in range(0,n):
              data[addr] = vals[v+1]
              addr += 1
        else:
            for v in range(0,n+1):
              data[addr] = vals[v]
              addr += 1


#Write data into hexdata 
for i in range(0,8):
    f_data = open(res+"/hex_data"+str(i)+".txt", "w")
    for j in range(i*4096,(i+1)*4096):
        f_data.write(data[j])
        f_data.write("\n")
    f_data.close()


