import re
import sys
import os
import numpy as np

res = sys.argv[1]
name = sys.argv[2]

out = name.split(".s")[0] + ".o"
outobj = name.split(".s")[0] + ".objdump"

cmd = "gcc -m32 -c "+name+" -o "+out
print(cmd)
os.system(cmd)

cmd = "objdump -d "+out+" > "+outobj
print(cmd)
os.system(cmd)

size = 4096*8

data = np.empty((size,), dtype=object)
for i in range(0,size): 
    data[i]="00"

def zero_extend(value):
    zeros = '0' * (8-len(value))
    new_value = zeros + value
    return new_value

with open(outobj, 'r') as f1:
    content = f1.read().splitlines()

for cnt in range(6,len(content)):
    line = content[cnt]
    line = line[:32]
    line.replace(".","")

    if(len(line) and line[0]!=""):
        vals = line.split()
        n = len(vals) - 1

        if(len(vals)>1 and "<" in vals[1]):
            print("Label:"+line)
            continue #labels

        elif(":" in vals[0]):
            mem_addr = vals[0].split(":")[0]
            mem_addr_no_x = zero_extend(mem_addr)

            if(mem_addr_no_x[:5]=='00000'):
                page = 0
            elif (mem_addr_no_x[:5]=='02000'):
                page = 2 
            elif (mem_addr_no_x[:5]=='04000'):
                page = 5 
            elif (mem_addr_no_x[:5]=='0b000'):
                page = 4 
            elif (mem_addr_no_x[:5]=='0c000'):
                page = 7 
            elif (mem_addr_no_x[:5]=='0a000'):
                page = 5 

            print(mem_addr_no_x)
            offset = int(mem_addr_no_x[5:8],16)
            addr = (4096*page) + offset

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


