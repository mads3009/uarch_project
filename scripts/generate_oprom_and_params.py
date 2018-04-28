import re
import sys

linecount=0
f1 = open("oprom_dump_upper.txt","w")
f2 = open("oprom_dump_lower.txt","w")
f3 = open("localparams.txt","w")

cols=97+15+1
rows=127

start=4
index=2

with open('rom_csv.csv') as fr:
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
heading = content[0];
#heading= "sub_rom_sel	sr1_eax	sr1_rm	sr2_rm	sr1_needed	sr2_needed	ld_sr1	ld_sr2	reg_op_override	mod_rm_pr	mm1_needed	mm2_needed	eip_change	CF_needed	DF_needed	AF_needed	sr3_eax	sr3_esp	sr2_ecx	cmps_op	cxchg_op	stack_write	stack_read	seg2_sel	seg3_needed	seg3_sel[2:0]			seg3_sel_over	stack_off_sel_16		stack_off_sel_32		imm_sel_16		imm_sel_32		mem_rd_size[1:0]		mem_rd_size_no_over	mem_wr_size[1:0]		mem_wr_size_no_over	reg_wr_size[1:0]		reg_wr_size_no_over	sr1_sel_reg		sr1_sel_mem		sr2_sel_reg		sr2_sel_mem		mm_sr1_sel_H	EIP_EFLAGS_sel		mem_rd_addr_sel	ld_seg	dseg[2:0]			ld_mmx	df_val	CF_expected	ZF_expected	cond_wr_CF	cond_wr_ZF	wr_reg1_data_sel	wr_reg2_data_sel	wr_seg_data_sel		wr_eip_alu_res_sel			wr_mem_data_Sel		wr_mem_addr_sel	alu1_op	alu2_op	alu3_op	alu1_op_size[1:0]		alu_op_size_no_over	ld_flags[CF]	ld_flags[PF]	ld_flags[AF]	ld_flags[ZF]	ld_flags[SF]	ld_flags[DF]	ld_flags[OF]"

words = heading.split(',');
index = 0;
flag=0;
print("\n");
print (words)
print("\n");

for i in reversed(words):
	i=i.upper();
	
	if("INST_SIZE_32" in i):
		flag=1;
		a=re.findall(r'(\d:\d)', i);
		if(len(a)):
			a=a[0];
			b=a.split(":")
			diff = int(b[0]) - int(b[1]) +1
			i=i.split("[")
			cmd = "localparam " + i[0] + "_BL = 8'd" + str(index) + ";" 
			f3.write(cmd+"\n");
			cmd = "localparam " + i[0] + "_BH = 8'd" + str(index+ diff - 1) + ";" 
			f3.write(cmd+"\n");
			cmd = "localparam " + i[0] + "_W = 4'd" + str(diff) + ";" 
			f3.write(cmd+"\n");
			index=index+diff;
			
		elif(i is not ''):
			cmd = "localparam " + i + " = 8'd" + str(index) + ";"
			f3.write(cmd+"\n");
			cmd = "localparam " + i + "_W = 4'd1" + ";" 
			f3.write(cmd+"\n");
			index=index+1	

	elif(flag==1):		
		a=re.findall(r'(\d:\d)', i);
		if(len(a)):
			a=a[0];
			b=a.split(":")
			diff = int(b[0]) - int(b[1]) +1
			i=i.split("[")
			cmd = "localparam " + i[0] + "_BL = 8'd" + str(index)  + ";"
			f3.write(cmd+"\n");
			cmd = "localparam " + i[0] + "_BH = 8'd" + str(index+ diff - 1)  + ";"
			f3.write(cmd+"\n");
			cmd = "localparam " + i[0] + "_W = 4'd" + str(diff)  + ";"
			f3.write(cmd+"\n");
			index=index+diff;
			
		elif(i is not ''):
			cmd = "localparam " + i + " = 8'd" + str(index)  + ";"
			f3.write(cmd+"\n");
			cmd = "localparam " + i + "_W = 4'd1"  + ";"
			f3.write(cmd+"\n");
			index=index+1
			
		#if(i is "sub_rom_sel"):
		#	f3.write("mad")
		#	sys.exit();
		#	break;
