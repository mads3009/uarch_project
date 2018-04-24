import sys
import os

name = sys.argv[1]
out = name.split(".")[0] + ".o"
outtxt = name.split(".")[0] + ".txt"

os.system("gcc -m32 -c "+name+" -o "+out)
os.system("readelf -x .text "+out+" > "+outtxt)
