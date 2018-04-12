import re
import sys

linecount=0
f1 = open("subrom_dump_upper.txt","w")
f2 = open("subrom_dump_lower.txt","w")

cols=97+15+1
rows=17

start=6
index=1

with open('subrom_csv.csv') as fr:
	content = fr.read()
	content = re.split("\r\n",content)

sum=0;
print(type(content))
print(len(content))
#f1.write(content[0]);
for i in range(1,rows-1):
	line1 = re.split(',',content[i])
	line2 = re.split(',',content[i+1])
	diff = int(line2[index]) - int(line1[index])
	sum+=diff
	if(diff <= 1):
		print("index=%s diff=1"%line1[index])
		#f1.write(content[i])
		#f1.write("\n");
		words=content[i].split(',')
		for j in range(start,start+49):
			f1.write(words[j]);
		f1.write("\n")
		for j in range(start+49,len(words)):
			f2.write(words[j]);
		f2.write("\n")
	else:
		print("index=%s diff=%d"%(line1[index],diff))
		#f1.write(content[i])
		#f1.write("\n");
		words=content[i].split(',')
		for j in range(start,start+49):
			f1.write(words[j]);
		f1.write("\n")
		for j in range(start+49,len(words)):
			f2.write(words[j]);
		f2.write("\n")

		for loop in range(0,diff-1):
			for loop2 in range(0,49):
				f1.write("x")
			f1.write("\n");
			for loop2 in range(49,cols):
				f2.write("x")
			f2.write("\n");
				
line1 = re.split(',',content[i+1])
line2 = re.split(',',content[i+2])
diff = int(line2[index]) - int(line1[index])
sum+=diff
print("index=%s diff=%d"%(line1[index],diff))
#f1.write(content[i])
#f1.write("\n");
words=content[i+1].split(',')
for j in range(start,start+49):
	f1.write(words[j]);
f1.write("\n")
for j in range(start+49,len(words)):
	f2.write(words[j]);
f2.write("\n")

for loop in range(0,diff-1):
	for loop2 in range(0,49):
		f1.write("x")
	f1.write("\n");
	for loop2 in range(49,cols):
		f2.write("x")
	f2.write("\n");

f1.close()
f2.close()

print("Total rows : %d"%sum)
