with open('subrom_indices.txt') as f:
	for line in f:
		ans=0;
		nib = line[1];
		if(nib is 'f' or nib is 'F'):
			ans=ans+15
		elif(nib is 'e' or nib is 'E'):
			ans=ans+14
		elif(nib is 'd' or nib is 'D'):
			ans=ans+13
		elif(nib is 'c' or nib is 'C'):
			ans=ans+12
		elif(nib is 'b' or nib is 'B'):
			ans=ans+11
		elif(nib is 'a' or nib is 'A'):
			ans=ans+10
		else:
			ans=ans+int(nib)

		nib = line[0];
		if(nib is 'f' or nib is 'F'):
			ans=ans+(15*16)
		elif(nib is 'e' or nib is 'E'):
			ans=ans+(14*16)
		elif(nib is 'd' or nib is 'D'):
			ans=ans+(13*16)
		elif(nib is 'c' or nib is 'C'):
			ans=ans+(12*16)
		elif(nib is 'b' or nib is 'B'):
			ans=ans+(11*16)
		elif(nib is 'a' or nib is 'A'):
			ans=ans+(10*16)
		else:
			ans=ans+(int(nib)*16)

		#print("first:%s second:%s ans:%d"%(line[0],line[1],ans))
		print("%d"%ans)
