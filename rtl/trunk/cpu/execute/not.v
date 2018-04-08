module not32 #(parameter N = 32)(out, in);
input [N-1:0]in;
output [N-1:0]out;
genvar i;  
generate 
  for (i=0; i < N; i=i+1)  
  begin: gen_and  
    inv1$ and_inst (.out(out[i]), .in(in[i]));  
  end  
endgenerate  
endmodule	


