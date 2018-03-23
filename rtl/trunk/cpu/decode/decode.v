/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module:Decode                                        */
/* Description:                                         */
/********************************************************/

module decode ( de_lower_16bytes,
				de_upper_16bytes,
				de_eip,
				de_v,
                agen_next_eip,
                agen_SIB,
                agen_rel,
                agen_ptr_cs,
                agen_ptr_eip,
                agen_control_signals);




input [127:0] de_lower_16bytes;
input [127:0] de_upper_16bytes;
input [31:0]  de_eip;
input         de_v;

output [31:0] agen_next_eip;
output [7:0]  agen_SIB;
output [31:0] agen_rel;
output [15:0] agen_ptr_cs;
output [31:0] agen_ptr_eip;
output [31:0] agen_control_signals;



//Internal variables
wire [3:0] w_pr_repne;
wire [3:0] w_pr_cs_over;
wire [3:0] w_pr_ss_over;
wire [3:0] w_pr_ds_over;
wire [3:0] w_pr_es_over;
wire [3:0] w_pr_fs_over;
wire [3:0] w_pr_gs_over;
wire [3:0] w_pr_size_over;
wire [3:0] w_pr_pos;

wire [2:0]  w_mux_sel;
wire [7:0]  w_opcode;
wire [7:0]  w_modrm;

wire [7:0]  w_oprom_oe;
wire [31:0] w_oprom_out [7:0];

wire [7:0]  w_modrom_oe;
wire [31:0] w_modrom_out [7:0];
wire [31:0] w_mod_rom_signals;
wire [3:0]  de_eip_len;

//Prefix Comparison
genvar i;
generate
  for (i=0; i<4; i=i+1) begin : pref_comp_gen
eq_checker#8 u_eq_checker8_1(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'hF2), .eq_out(w_pr_repne[i]));
eq_checker#8 u_eq_checker8_2(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h2E), .eq_out(w_pr_cs_over[i]));
eq_checker#8 u_eq_checker8_3(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h36), .eq_out(w_pr_ss_over[i]));
eq_checker#8 u_eq_checker8_4(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h3E), .eq_out(w_pr_ds_over[i]));
eq_checker#8 u_eq_checker8_5(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h26), .eq_out(w_pr_es_over[i]));
eq_checker#8 u_eq_checker8_6(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h64), .eq_out(w_pr_fs_over[i]));
eq_checker#8 u_eq_checker8_7(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h65), .eq_out(w_pr_gs_over[i]));
eq_checker#8 u_eq_checker8_8(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h66), .eq_out(w_pr_size_over[i]));
or8 u_or8_1 (.in0(w_pr_repne[i]), .in1(w_pr_cs_over[i]), .in2(w_pr_ss_over[i]), .in3(w_pr_ds_over[i]), 
             .in4(w_pr_es_over[i]), .in5(w_pr_fs_over[i]), .in6(w_pr_gs_over[i]), .in7(w_pr_size_over[i]), .out(w_pr_pos[i]) );
  end
endgenerate

//Logic for mux array select
wire pr_pos_0_bar;
wire pr_pos_1_bar;
wire pr_pos_2_bar;
wire and_temp1;
wire or_temp1;
wire and_temp2;
wire and_temp3;

inv1$ inv1 (.in(w_pr_pos[0]), .out(pr_pos_0_bar));
inv1$ inv2 (.in(w_pr_pos[1]), .out(pr_pos_1_bar));
inv1$ inv3 (.in(w_pr_pos[2]), .out(pr_pos_2_bar));

and4$ and4_1 (.in0(w_pr_pos[0]), .in1(w_pr_pos[1]), .in2(w_pr_pos[2]), .in3(w_pr_pos[3]), .out(w_mux_sel[2]));

and2$ and2_1 (.in0(w_pr_pos[3]), .in1(w_pr_pos[2]), .out(and_temp1)); 
or2$ or2_1   (.in0(pr_pos_1_bar), .in1(pr_pos_0_bar), .out(or_temp1)); 
and2$ and2_2 (.in0(and_temp1), .in1(or_temp1), .out(w_mux_sel[1])); 

and2$ and2_3 (.in0(w_pr_pos[3]), .in1(pr_pos_2_bar), .out(and_temp2)); 
and3$ and3_1 (.in0(w_pr_pos[3]), .in1(w_pr_pos[1]), .in2(pr_pos_0_bar), .out(and_temp3)); 
or2$ or2_2   (.in0(and_temp2), .in1(and_temp3), .out(w_mux_sel[0])); 


//Mux array to select opcode (dispa nd imm not done yet)

mux8bit_8x1 mux_op    (.IN0(de_lower_16bytes[7:0]), .IN1(de_lower_16bytes[15:8]), .IN2(de_lower_16bytes[23:16]), .IN3(de_lower_16bytes[31:24]),
                       .IN4(de_lower_16bytes[39:32]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(w_opcode));

mux8bit_8x1 mux_mod   (.IN0(de_lower_16bytes[15:8]), .IN1(de_lower_16bytes[23:16]), .IN2(de_lower_16bytes[31:24]), .IN3(de_lower_16bytes[39:32]),
                       .IN4(de_lower_16bytes[47:40]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(w_modrm));

mux8bit_8x1 mux_sib   (.IN0(de_lower_16bytes[23:16]), .IN1(de_lower_16bytes[31:24]), .IN2(de_lower_16bytes[39:32]), .IN3(de_lower_16bytes[47:40]),
                       .IN4(de_lower_16bytes[55:48]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(agen_SIB));

mux32bit_8x1 mux_rel  (.IN0(de_lower_16bytes[39:8]), .IN1(de_lower_16bytes[47:16]), .IN2(de_lower_16bytes[55:24]), .IN3(de_lower_16bytes[63:32]),
                       .IN4(de_lower_16bytes[71:40]), .IN5(32'd0), .IN6(32'd0), .IN7(32'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(agen_rel));


mux16bit_8x1 mux_ptr1 (.IN0(de_lower_16bytes[23:8]), .IN1(de_lower_16bytes[31:16]), .IN2(de_lower_16bytes[39:24]), .IN3(de_lower_16bytes[47:32]),
                       .IN4(de_lower_16bytes[55:40]), .IN5(16'd0), .IN6(16'd0), .IN7(16'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(agen_ptr_cs));

mux32bit_8x1 mux_ptr2 (.IN0(de_lower_16bytes[55:24]), .IN1(de_lower_16bytes[63:32]), .IN2(de_lower_16bytes[71:40]), .IN3(de_lower_16bytes[79:48]),
                       .IN4(de_lower_16bytes[87:56]), .IN5(32'd0), .IN6(32'd0), .IN7(32'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(agen_ptr_eip));


//Accessing Opcode ROM
wire [7:0] w_oprom_oebar;
decoder3_8$ decode1 (.SEL(w_opcode[7:5]), .Y(w_oprom_oe), .YBAR(w_oprom_oebar));

generate
  for (i=0; i<8; i=i+1) begin : op_rom_gen
 
rom32b32w$ rom0(.A(w_opcode[4:0]), .OE(w_oprom_oe[i]), .DOUT(agen_control_signals));
  
  end
endgenerate



//Accessing MOD ROM
wire [7:0] w_modrom_oebar;
decoder3_8$ decode2 (.SEL(w_modrm[7:5]), .Y(w_modrom_oe), .YBAR(w_modrom_oebar));

generate
  for (i=0; i<8; i=i+1) begin : mod_rom_gen
 
rom32b32w$ rom1(.A(w_modrm[4:0]), .OE(w_modrom_oe[i]), .DOUT(w_mod_rom_signals));
  
  end
endgenerate

//EIP mux
wire [31:0] nxt_eip0;
wire [31:0] nxt_eip1;
wire [31:0] nxt_eip2;
wire [31:0] nxt_eip3;
wire [31:0] nxt_eip4;
wire [31:0] nxt_eip5;
wire [31:0] nxt_eip6;
wire [31:0] nxt_eip7;
wire [31:0] nxt_eip8;
wire [31:0] nxt_eip9;
wire [31:0] nxt_eip10;
wire [31:0] nxt_eip11;
wire [31:0] nxt_eip12;
wire [31:0] nxt_eip13;
wire [31:0] nxt_eip14;
wire [31:0] nxt_eip15;
cond_sum32 add0  ( .A(de_eip), .B(32'd1), .CIN(1'd0), .S(nxt_eip0), .COUT(/*unused*/)); 
cond_sum32 add1  ( .A(de_eip), .B(32'd2), .CIN(1'd0), .S(nxt_eip1), .COUT(/*unused*/)); 
cond_sum32 add2  ( .A(de_eip), .B(32'd3), .CIN(1'd0), .S(nxt_eip2), .COUT(/*unused*/)); 
cond_sum32 add3  ( .A(de_eip), .B(32'd4), .CIN(1'd0), .S(nxt_eip3), .COUT(/*unused*/)); 
cond_sum32 add4  ( .A(de_eip), .B(32'd5), .CIN(1'd0), .S(nxt_eip4), .COUT(/*unused*/)); 
cond_sum32 add5  ( .A(de_eip), .B(32'd6), .CIN(1'd0), .S(nxt_eip5), .COUT(/*unused*/)); 
cond_sum32 add6  ( .A(de_eip), .B(32'd7), .CIN(1'd0), .S(nxt_eip6), .COUT(/*unused*/)); 
cond_sum32 add7  ( .A(de_eip), .B(32'd8), .CIN(1'd0), .S(nxt_eip7), .COUT(/*unused*/)); 
cond_sum32 add8  ( .A(de_eip), .B(32'd9), .CIN(1'd0), .S(nxt_eip8), .COUT(/*unused*/)); 
cond_sum32 add9  ( .A(de_eip), .B(32'd10), .CIN(1'd0), .S(nxt_eip9), .COUT(/*unused*/)); 
cond_sum32 add10 ( .A(de_eip), .B(32'd11), .CIN(1'd0), .S(nxt_eip10), .COUT(/*unused*/)); 
cond_sum32 add11 ( .A(de_eip), .B(32'd12), .CIN(1'd0), .S(nxt_eip11), .COUT(/*unused*/)); 
cond_sum32 add12 ( .A(de_eip), .B(32'd13), .CIN(1'd0), .S(nxt_eip12), .COUT(/*unused*/)); 
cond_sum32 add13 ( .A(de_eip), .B(32'd14), .CIN(1'd0), .S(nxt_eip13), .COUT(/*unused*/)); 
cond_sum32 add14 ( .A(de_eip), .B(32'd15), .CIN(1'd0), .S(nxt_eip14), .COUT(/*unused*/)); 
cond_sum32 add15 ( .A(de_eip), .B(32'd16), .CIN(1'd0), .S(nxt_eip15), .COUT(/*unused*/));

mux32bit_16x1 mux_eip(.Y(agen_next_eip), .IN0(nxt_eip0), .IN1(nxt_eip1), .IN2(nxt_eip2), .IN3(nxt_eip3), .IN4(nxt_eip4)
                      , .IN5(nxt_eip5), .IN6(nxt_eip6), .IN7(nxt_eip7), .IN8(nxt_eip8), .IN9(nxt_eip9), .IN10(nxt_eip10)
                      , .IN11(nxt_eip11), .IN12(nxt_eip12), .IN13(nxt_eip13), .IN14(nxt_eip14), .IN15(nxt_eip15)
                      , .S0(de_eip_len[0]), .S1(de_eip_len[1]), .S2(de_eip_len[2]), .S3(de_eip_len[3]));

 


endmodule


// Helper blocks



module eq_checker #(parameter WIDTH = 3) (in1, in2, eq_out);

input [WIDTH-1:0] in1, in2;
output            eq_out;

assign eq_out = (in1 == in2);

endmodule

module or8 (in0, in1, in2, in3, in4, in5, in6, in7, out);
input in0;
input in1;
input in2;
input in3;
input in4;
input in5;
input in6;
input in7;
output out;

wire w_or0;
wire w_or1;
or4$ or0(.in0(in0), .in1(in1), .in2(in2), .in3(in3), .out(w_or0));
or4$ or1(.in0(in4), .in1(in5), .in2(in6), .in3(in7), .out(w_or1));
or2$ or3(.in0(w_or0), .in1(w_or1), .out(out));

endmodule


