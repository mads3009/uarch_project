module alu3(mm1, mm2, sr2, ecx, alu3_op, alu_res3);
input  [63:0] mm1;
input  [63:0] mm2;
input  [31:0] sr2;
input  [31:0] ecx;
input  [4:0]  alu3_op;
output [63:0] alu_res3;


//PSHUFW
wire [63:0] w_pshufw_res;
mux_nbit_4x1 #16 shufw0  (.a0(mm2[15:0]), .a1(mm2[31:16]), .a2(mm2[47:32]), .a3(mm2[63:48]), .sel(sr2[1:0]), .out(w_pshufw_res[15:0]));
mux_nbit_4x1 #16 shufw1  (.a0(mm2[15:0]), .a1(mm2[31:16]), .a2(mm2[47:32]), .a3(mm2[63:48]), .sel(sr2[3:2]), .out(w_pshufw_res[31:16]));
mux_nbit_4x1 #16 shufw2  (.a0(mm2[15:0]), .a1(mm2[31:16]), .a2(mm2[47:32]), .a3(mm2[63:48]), .sel(sr2[5:4]), .out(w_pshufw_res[47:32]));
mux_nbit_4x1 #16 shufw3  (.a0(mm2[15:0]), .a1(mm2[31:16]), .a2(mm2[47:32]), .a3(mm2[63:48]), .sel(sr2[7:6]), .out(w_pshufw_res[63:48]));

//PADDW
wire [63:0] w_paddw_res;
cond_sum16 addw0 ( .A(mm1[15:0]), .B(mm2[15:0]), .CIN(1'b0), .S(w_paddw_res[15:0]), .COUT(/*unused*/ ));
cond_sum16 addw1 ( .A(mm1[31:16]), .B(mm2[31:16]), .CIN(1'b0), .S(w_paddw_res[31:16]), .COUT(/*unused*/ ));
cond_sum16 addw2 ( .A(mm1[47:32]), .B(mm2[47:32]), .CIN(1'b0), .S(w_paddw_res[47:32]), .COUT(/*unused*/ ));
cond_sum16 addw3 ( .A(mm1[63:48]), .B(mm2[63:48]), .CIN(1'b0), .S(w_paddw_res[63:48]), .COUT(/*unused*/ ));

//PADDD
wire [63:0] w_paddd_res;
cond_sum32 addd0 ( .A(mm1[31:0]), .B(mm2[31:0]), .CIN(1'b0), .S(w_paddd_res[31:0]), .COUT(/*unused*/ ));
cond_sum32 addd1 ( .A(mm1[63:32]), .B(mm2[63:32]), .CIN(1'b0), .S(w_paddd_res[63:32]), .COUT(/*unused*/ ));

//PADDSW
wire [63:0] w_paddsw_res;
wire [63:0] w_res;
wire [15:0] msb_sat0;
wire [15:0] msb_sat1;
wire [15:0] msb_sat2;
wire [15:0] msb_sat3;

cond_sum16 addsw0 ( .A(mm1[15:0]), .B(mm2[15:0]), .CIN(1'b0), .S(w_res[15:0]), .COUT(/*unused*/));
cond_sum16 addsw1 ( .A(mm1[31:16]), .B(mm2[31:16]), .CIN(1'b0), .S(w_res[31:16]), .COUT(/*unused*/));
cond_sum16 addsw2 ( .A(mm1[47:32]), .B(mm2[47:32]), .CIN(1'b0), .S(w_res[47:32]), .COUT(/*unused*/));
cond_sum16 addsw3 ( .A(mm1[63:48]), .B(mm2[63:48]), .CIN(1'b0), .S(w_res[63:48]), .COUT(/*unused*/));

xnor2$ u_msb0 (.out(msb_sign0), .in0(mm1[15]), .in1(mm2[15]));
xnor2$ u_msb1 (.out(msb_sign1), .in0(mm1[31]), .in1(mm2[31]));
xnor2$ u_msb2 (.out(msb_sign2), .in0(mm1[47]), .in1(mm2[47]));
xnor2$ u_msb3 (.out(msb_sign3), .in0(mm1[63]), .in1(mm2[63]));

xor2$ u_check0 (.out(check0), .in0(mm1[15]), .in1(w_res[15]));
xor2$ u_check1 (.out(check1), .in0(mm1[31]), .in1(w_res[31]));
xor2$ u_check2 (.out(check2), .in0(mm1[47]), .in1(w_res[47]));
xor2$ u_check3 (.out(check3), .in0(mm1[63]), .in1(w_res[63]));

nand2$ u_of0 (.out(of0), .in0(msb_sign0), .in1(check0));
nand2$ u_of1 (.out(of1), .in0(msb_sign1), .in1(check1));
nand2$ u_of2 (.out(of2), .in0(msb_sign2), .in1(check2));
nand2$ u_of3 (.out(of3), .in0(msb_sign3), .in1(check3));

mux_nbit_2x1 #16 sat0 (.a0(16'h7FFF), .a1(16'h8000), .sel(mm1[15]), .out(msb_sat0));
mux_nbit_2x1 #16 sat1 (.a0(16'h7FFF), .a1(16'h8000), .sel(mm1[31]), .out(msb_sat1));
mux_nbit_2x1 #16 sat2 (.a0(16'h7FFF), .a1(16'h8000), .sel(mm1[47]), .out(msb_sat2));
mux_nbit_2x1 #16 sat3 (.a0(16'h7FFF), .a1(16'h8000), .sel(mm1[63]), .out(msb_sat3));

mux_nbit_2x1 #16 mux_sw0 (.a0(msb_sat0), .a1(w_res[15:0]), .sel(of0), .out(w_paddsw_res[15:0]));
mux_nbit_2x1 #16 mux_sw1 (.a0(msb_sat1), .a1(w_res[31:16]), .sel(of1), .out(w_paddsw_res[31:16]));
mux_nbit_2x1 #16 mux_sw2 (.a0(msb_sat2), .a1(w_res[47:32]), .sel(of2), .out(w_paddsw_res[47:32]));
mux_nbit_2x1 #16 mux_sw3 (.a0(msb_sat3), .a1(w_res[63:48]), .sel(of3), .out(w_paddsw_res[63:48]));

//ECX dec
wire [31:0] w_ecx_res; 
wire [63:0] mux3_out; 
wire [63:0] shuf_cs_eip; 
cond_sum32 ecx_dec ( .A(ecx), .B(32'hFFFFFFFF), .CIN(1'b0), .S(w_ecx_res), .COUT(/*unused*/));
assign shuf_cs_eip = {mm1[47:32], mm1[31:16], mm1[63:48], mm1[15:0]};
mux_nbit_2x1 #64 mux3 (.a0({32'd0,w_ecx_res}), .a1(shuf_cs_eip), .sel(alu3_op[0]), .out(mux3_out));


//MUXes
wire [63:0] mux0_out;
wire [63:0] mux1_out;
wire [63:0] mux2_out;
mux_nbit_2x1 #64 mux0 (.a0(mm1), .a1(mm2), .sel(alu3_op[0]), .out(mux0_out));
mux_nbit_2x1 #64 mux1 (.a0(mux0_out), .a1(w_pshufw_res), .sel(alu3_op[1]), .out(mux1_out));
mux_nbit_2x1 #64 mux2 (.a0(mux1_out), .a1(w_paddw_res), .sel(alu3_op[2]), .out(mux2_out));

mux_nbit_4x1 #64 mux_res  (.a0(w_paddd_res), .a1(w_paddsw_res), .a2(mux2_out), .a3(mux3_out), .sel(alu3_op[4:3]), .out(alu_res3));

endmodule

