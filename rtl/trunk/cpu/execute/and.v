module and32 #(parameter N = 32)(out, in0, in1);
input [N-1:0]in0;
input [N-1:0]in1;
output [N-1:0]out;
genvar i;  
generate 
  for (i=0; i < N; i=i+1)  
  begin: gen_and  
    and2$ and_inst (.out(out[i]), .in0(in0[i]), .in1(in1[i]));  
  end  
endgenerate  
endmodule	

module and_flags(in, alu1_op_size, flags);
input [31:0] in;
input [1:0]  alu1_op_size;
output [5:0] flags;
localparam CF = 3'd0;
localparam PF = 3'd1;
localparam AF = 3'd2;
localparam ZF = 3'd3;
localparam SF = 3'd4;
localparam OF = 3'd5;

wire  [5:0] flag8;
wire  [5:0] flag16;
wire  [5:0] flag32;


assign flag8[CF]  = 1'b0;
assign flag16[CF] = 1'b0;
assign flag32[CF] = 1'b0;

assign flag8[OF]  = 1'b0;
assign flag16[OF] = 1'b0;
assign flag32[OF] = 1'b0;

assign flag8[SF]  = in[7];
assign flag16[SF] = in[15];
assign flag32[SF] = in[31];

zero8  u_z8 (.in(in[7:0]), .out(flag8[ZF]));
zero16 u_z16(.in(in[15:0]), .out(flag16[ZF]));
zero32 u_z32(.in(in), .out(flag32[ZF]));

parity u_par8 (.in(in[7:0]), .out(flag8[PF]));
parity u_par16(.in(in[7:0]), .out(flag16[PF]));
parity u_par32 (.in(in[7:0]), .out(flag32[PF]));

assign flag8[AF]  = 1'b0;
assign flag16[AF] = 1'b0;
assign flag32[AF] = 1'b0;

mux_nbit_4x1 #6 flag_mux(.a0(flag8), .a1(flag16), .a2(flag32), .a3(6'b0), .sel(alu1_op_size), .out(flags));

endmodule

