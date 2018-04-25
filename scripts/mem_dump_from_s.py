import re
import sys
import os

name = sys.argv[1]
out = name.split(".s")[0] + ".o"
outtxt = name.split(".s")[0] + ".txt"

os.system("gcc -m32 -c "+name+" -o "+out)
os.system("readelf -x .text "+out+" > "+outtxt)

inFile = outtxt
size = 256;

for i in range(0,8):
  f_data = open("hex_data"+str(i)+".txt", "w")
  for j in range(0,16*size):
    f_data.write("00\n")
  f_data.close()

f_data = open("hex_data0.txt", "w")

def zero_extend(value):
    zeros = '0' * (8-len(value))
    new_value = zeros + value
    return new_value

with open(inFile, 'r') as f1:
    content = f1.read()
    content = re.split("\n", content)
content = [x.strip() for x in content]
content = list(line for line in content if line)

page='0';
lines=0;

print("size=%d bytes"%(size*16))

for cnt in range(0,len(content)):
    if(cnt>=1):
        line = content[cnt]
        val = line.split()
        mem_addr = val[0]
        n = len(val)
   
        if((cnt % size) == 1): #next page
          mem_addr_no_x = zero_extend(mem_addr.split('x')[1])

          if(size==256):
            if(mem_addr_no_x[:5]=='00000'):
                page = '0'
            elif (mem_addr_no_x[:5]=='02000'):
                page = '2' 
            elif (mem_addr_no_x[:5]=='04000'):
                page = '5' 
            elif (mem_addr_no_x[:5]=='0b000'):
                page = '4' 
            elif (mem_addr_no_x[:5]=='0c000'):
                page = '7' 
            elif (mem_addr_no_x[:5]=='0a000'):
                page = '5' 

          else:
            if(mem_addr_no_x[5:7]=='00'):
                page = '0'
            elif (mem_addr_no_x[5:7]=='08'):
                page = '2' 
            elif (mem_addr_no_x[5:7]=='10'):
                page = '5' 
            elif (mem_addr_no_x[5:7]=='18'):
                page = '4' 
            elif (mem_addr_no_x[5:7]=='20'):
                page = '7' 
            elif (mem_addr_no_x[5:7]=='28'):
                page = '5' 
            elif (mem_addr_no_x[5:7]=='30'):
                page = '6' 

          f_data.close();
          f_data = open("hex_data"+page+".txt", "w")
          lines = 0;

          print("page=%s"%page)

        if (n>=5):
            n=5
        for col in range(1,n):
            if('..' not in val[col]):
                k = 0
                l = int((len(val[col]))/2)
                for j in range (0,l):
                    lines=lines+1;
                    f_data.write(val[col][k:k+2])
                    f_data.write('\n')
                    k = k+2

print("lines=%d"%lines)
for i in range(lines,size*16):
  f_data.write("00\n")

