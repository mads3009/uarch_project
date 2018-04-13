import re
import sys

linecount=0
f0 = open("introm_dump0.txt","w")
f1 = open("introm_dump1.txt","w")
f2 = open("introm_dump2.txt","w")

cols=85
rows=9

start=2

with open('introm_csv.csv') as fr:
	content = fr.read()
	content = re.split("\r\n",content)

print(type(content))
print(len(content))
#f1.write(content[0]);
for i in range(1,rows):
	words=content[i].split(',')
	count=0;
	for j in range(start,start+cols):
		for c in words[j]:
			if(count<15):
				f2.write(c);
			elif(count<79):
				f1.write(c);
			else:
				f0.write(c);
			count=count+1

	f0.write("\n")
	f1.write("\n")
	f2.write("\n")
				
f0.close()
f1.close()
f2.close()



