module alu1 (sr1, sr2, mem_out, mem_out_latched, eax, alu1_op, alu1_op_size, mem_rd_size, 
             CF_in, AF_in, DF_in, alu_res1, alu1_flags, df_val_ex, df_val, ISR, cmps_flags,
             ld_flag_CF_in, ld_flag_PF_in, ld_flag_AF_in, ld_flag_ZF_in, ld_flag_SF_in, ld_flag_OF_in,
             ld_flag_CF, ld_flag_PF, ld_flag_AF, ld_flag_ZF, ld_flag_SF, ld_flag_OF );
input [31:0]  sr1; 
input [31:0]  sr2; 
input [31:0]  mem_out; 
input [31:0]  mem_out_latched; 
input [31:0]  eax; 
input [3:0]   alu1_op;
input [1:0]   alu1_op_size;
input [1:0]   mem_rd_size;
input         CF_in;
input         AF_in;
input         DF_in;
input         df_val;
input         ISR;
input         ld_flag_CF_in;
input         ld_flag_PF_in;
input         ld_flag_AF_in;
input         ld_flag_ZF_in;
input         ld_flag_SF_in;
input         ld_flag_OF_in;

output [31:0] alu_res1; 
output [5:0]  alu1_flags;
output [5:0]  cmps_flags;
output        df_val_ex;
output        ld_flag_CF;
output        ld_flag_PF;
output        ld_flag_AF;
output        ld_flag_ZF;
output        ld_flag_SF;
output        ld_flag_OF;


localparam CF = 3'd0;
localparam PF = 3'd1;
localparam AF = 3'd2;
localparam ZF = 3'd3;
localparam SF = 3'd4;
localparam OF = 3'd5;

wire [5:0]  ld_flags_in;
wire [31:0] w_or_res;
wire [31:0] w_and_res;
wire [31:0] w_sal_res;
wire [32:0] w_sal_res_cf;
wire [32:0] w_sar_res_cf;
wire [31:0] w_sar_res;

wire [5:0] w_or_flags;
wire [5:0] w_and_flags;
wire [5:0] w_sal_flags;
wire [5:0] w_sar_flags;

assign ld_flags_in = {ld_flag_OF_in, ld_flag_SF_in, ld_flag_ZF_in, ld_flag_AF_in, ld_flag_PF_in, ld_flag_CF_in};
//OR
or32 u_or(.in0(sr1), .in1(sr2), .out(w_or_res)); 
or_flags u_or_flgs(.in(w_or_res), .alu1_op_size(alu1_op_size), .flags(w_or_flags)); 

//AND
and32 u_and(.in0(sr1), .in1(sr2), .out(w_and_res)); 
and_flags u_and_flgs(.in(w_and_res), .alu1_op_size(alu1_op_size), .flags(w_and_flags)); 

//SAL
bit_shift_left_flgs u_left(.amt(sr2[4:0]), .sin(1'b0), .in(sr1), .out(w_sal_res), .out_cf(w_sal_res_cf), .sr2_count_0(ld_override));
sal_flags u_sal_flgs(.in(w_sal_res_cf), .flags(w_sal_flags), .alu1_op_size(alu1_op_size));

//SAR
bit_shift_right_flgs u_right(.amt(sr2[4:0]), .sin(1'b0), .in(sr1), .out(w_sar_res), .out_cf(w_sar_res_cf), .sr2_count_0(ld_override));
sar_flags u_sar_flgs(.in(w_sar_res_cf), .flags(w_sar_flags), .alu1_op_size(alu1_op_size));

//MUX0
wire [31:0]w_mux0_res;
wire [5:0] w_mux0_flags;
mux_nbit_4x1 #32 mux0_res  (.a0(w_or_res), .a1(w_and_res), .a2(w_sal_res), .a3(w_sar_res), .sel(alu1_op[1:0]), .out(w_mux0_res));
mux_nbit_4x1 #6 mux0_flags (.a0(w_or_flags), .a1(w_and_flags), .a2(w_sal_flags), .a3(w_sar_flags), .sel(alu1_op[1:0]), .out(w_mux0_flags));

/************************/
wire [31:0]w_not_res;
wire [31:0]w_mux1_res;
wire [5:0] w_mux1_flags;

//sr1 to flags
assign w_mux1_flags[CF] = sr1[0];
assign w_mux1_flags[PF] = sr1[2];
assign w_mux1_flags[AF] = sr1[4];
assign w_mux1_flags[ZF] = sr1[6];
assign w_mux1_flags[SF] = sr1[7];
assign w_mux1_flags[OF] = sr1[11];

//NOT
not32 u_not (.in(sr1), .out(w_not_res));

//MUX1
mux_nbit_4x1 #32 mux1_res  (.a0(sr1), .a1(sr2), .a2(32'd0), .a3(w_not_res), .sel(alu1_op[1:0]), .out(w_mux1_res));

/************************/
wire [31:0] w_inc_res;
wire [31:0] w_add_res;
wire [31:0] w_sr1_ch_res;
wire [31:0] w_daa_res;
wire [5:0] w_inc_flags;
wire [5:0] w_add_flags;
wire [5:0] w_comp_flags;
wire [5:0] w_daa_flags;

//INC
cond_sum32_c u_inc( .A(sr1), .B(32'd1), .CIN(1'd0), .S(w_inc_res), .COUT(c32_inc), .c4(c4_inc), .c8(c8_inc), .c16(c16_inc));
add_flags u_inc_flags(.A(sr1), .B(32'd1), .s(w_inc_res), .c32(c32_inc), .c16(c16_inc), .c8(c8_inc), .c4(c4_inc), 
                      .flags(w_inc_flags), .alu1_op_size(alu1_op_size));
 
//ADD
cond_sum32_c u_add( .A(sr1), .B(sr2), .CIN(1'd0), .S(w_add_res), .COUT(c32_add), .c4(c4_add), .c8(c8_add), .c16(c16_add));
add_flags u_add_flags(.A(sr1), .B(sr2), .s(w_add_res), .c32(c32_add), .c16(c16_add), .c8(c8_add), .c4(c4_add), 
                      .flags(w_add_flags), .alu1_op_size(alu1_op_size));
 
//COMP_PASS_SR1
wire [31:0] sr1_bar;
wire [31:0] sr1_comp;
wire [31:0] w_comp_res;
not32 u_sr1_inv(.in(sr1), .out(sr1_bar));
cond_sum32_c u_sr1_bar( .A(sr1_bar), .B(32'b1), .CIN(1'd0), .S(sr1_comp), .COUT(/*unused*/), .c4(/*unused*/), .c8(/*unused*/), .c16(/*unused*/));
cond_sum32_c u_comp   ( .A(eax), .B(sr1_comp), .CIN(1'd0), .S(w_comp_res), .COUT(c32_comp), .c4(c4_comp), .c8(c8_comp), .c16(c16_comp));
add_flags u_comp_flags(.A(eax), .B(sr1_comp), .s(w_comp_res), .c32(c32_comp), .c16(c16_comp), .c8(c8_comp), .c4(c4_comp), 
                       .flags(w_comp_flags), .alu1_op_size(alu1_op_size));

//CMPS PTR CH
wire [31:0]w_sr1_ch;
wire [31:0]res_df_0;
wire [31:0]res_df_1;


mux_nbit_4x1 #32 mux_size_inc (.a0(32'd1), .a1(32'd2), .a2(32'd4), .a3(32'd8), .sel(mem_rd_size), .out(res_df_0));
mux_nbit_4x1 #32 mux_size_dec (.a0(32'hFFFFFFFF), .a1(32'hFFFFFFFE), .a2(32'hFFFFFFFC), .a3(32'hFFFFFFF8), .sel(mem_rd_size), .out(res_df_1));
mux_nbit_2x1 #32 mux_df (.a0(res_df_0), .a1(res_df_1), .sel(DF_in), .out(w_sr1_ch));
cond_sum32 u_sr2_ch( .A(sr1), .B(w_sr1_ch), .CIN(1'd0), .S(w_sr1_ch_res), .COUT(/*unused*/));

//MUX2

wire [31:0]w_mux2_res;
wire [5:0] w_mux2_flags;
mux_nbit_4x1 #32 mux2_res (.a0(w_inc_res), .a1(w_add_res), .a2(w_sr1_ch_res), .a3(sr1), .sel(alu1_op[1:0]), .out(w_mux2_res));
mux_nbit_4x1 #6 mux2_flags (.a0(w_inc_flags), .a1(w_add_flags), .a2(6'd0), .a3(w_comp_flags), .sel(alu1_op[1:0]), .out(w_mux2_flags));


/************************/
//DAA

compare4 u_comp0 ( .in0(eax[3:0]), .in1(4'h9), .out(sign0));
compare8 u_comp1 ( .in0(eax[7:0]), .in1(8'h99), .out(sign1));

inv1$ u_af(.in(AF_in), .out(AF_bar));
inv1$ u_cf(.in(CF_in), .out(CF_bar));

nand2$ u_sel0( .in0(sign0), .in1(AF_bar), .out(s0));
nand2$ u_sel1( .in0(sign1), .in1(CF_bar), .out(s1));

wire [7:0] w_al_6;
wire [7:0] w_al_60;
wire [7:0] w_al_66;
cond_sum8 u_al6 ( .A(eax[7:0]), .B(8'h6), .CIN(1'b0), .S(w_al_6), .COUT(/*unused*/ ));
cond_sum8 u_al60( .A(eax[7:0]), .B(8'h60), .CIN(1'b0), .S(w_al_60), .COUT(/*unused*/ ));
cond_sum8 u_al66( .A(eax[7:0]), .B(8'h66), .CIN(1'b0), .S(w_al_66), .COUT(/*unused*/ ));

mux_nbit_4x1 #32 daa_res (.a0(eax), .a1({eax[31:8],w_al_6}), .a2({eax[31:8],w_al_60}), .a3({eax[31:8],w_al_66}), .sel({s1,s0}), .out(w_daa_res));

mux2$ af_mux(.outb(w_daa_flags[AF]), .in0(1'b0), .in1(1'b1), .s0(s0));
mux2$ cf_mux(.outb(w_daa_flags[CF]), .in0(1'b0), .in1(1'b1), .s0(s1));

zero8 u_z6(.in(w_al_6), .out(daa_flag6_zf));
zero8 u_z60(.in(w_al_60), .out(daa_flag60_zf));
zero8 u_z66(.in(w_al_66), .out(daa_flag66_zf));
zero8 u_z0(.in(eax[7:0]), .out(daa_flag0_zf));

parity u_par6(.in(w_al_6), .out(daa_flag6_pf));
parity u_par60(.in(w_al_60), .out(daa_flag60_pf));
parity u_par66(.in(w_al_66), .out(daa_flag66_pf));
parity u_par0(.in(eax[7:0]), .out(daa_flag0_pf));

mux4$ mux_zf (.in0(daa_flag0_zf), .in1(daa_flag6_zf), .in2(daa_flag60_zf), .in3(daa_flag66_zf), .s1(s1), .s0(s0), .outb(w_daa_flags[ZF]));
mux4$ mux_pf (.in0(daa_flag0_pf), .in1(daa_flag6_pf), .in2(daa_flag60_pf), .in3(daa_flag66_pf), .s1(s1), .s0(s0), .outb(w_daa_flags[PF]));
mux4$ mux_sf (.in0(eax[7]), .in1(w_al_6[7]), .in2(w_al_60[7]), .in3(w_al_66[7]), .s0(s0), .s1(s1), .outb(w_daa_flags[SF]));

assign w_daa_flags[OF] = 1'b0;

//DF Mux
mux2$ df_mux(.outb(df_val_ex), .in0(df_val), .in1(sr2[10]), .s0(ISR));

/***************************************/
//Final Mux

mux_nbit_4x1 #32 mux_res  (.a0(w_mux0_res), .a1(w_mux1_res), .a2(w_mux2_res), .a3(w_daa_res), .sel(alu1_op[3:2]), .out(alu_res1));
mux_nbit_4x1 #6 mux_flags (.a0(w_mux0_flags), .a1(w_mux1_flags), .a2(w_mux2_flags), .a3(w_daa_flags), .sel(alu1_op[3:2]), .out(alu1_flags));

//CMPS flags
wire [31:0] mem_out_bar;
wire [31:0] mem_out_comp;
wire [31:0] w_cmps_res;
wire [5:0]  w_cmps_flags;
not32 u_mem_inv(.in(mem_out), .out(mem_out_bar));

cond_sum32_c u_mem_out_comp(.A(mem_out_bar), .B(32'b1), .CIN(1'd0), .S(mem_out_comp), .COUT(/*unused*/), .c4(/*unused*/), .c8(/*unused*/), .c16(/*unused*/));
cond_sum32_c u_cmps_op     (.A(mem_out_latched), .B(mem_out_comp), .CIN(1'd0), .S(w_cmps_res), .COUT(c32_cmps), .c4(c4_cmps), .c8(c8_cmps), .c16(c16_cmps));
add_flags u_cmps_flags     (.A(mem_out_latched), .B(mem_out_comp), .s(w_cmps_res), .c32(c32_cmps), .c16(c16_cmps), .c8(c8_cmps), .c4(c4_cmps), 
                            .flags(cmps_flags), .alu1_op_size(mem_rd_size));

//ld_override mux
wire [5:0] ld_flags_out;
ld_override u_ld_over (.ld_override(ld_override), .ld_flags_in(ld_flags_in), .alu1_op(alu1_op), .ld_flags_out(ld_flags_out));

assign ld_flag_CF = ld_flags_out[CF];
assign ld_flag_PF = ld_flags_out[PF];
assign ld_flag_AF = ld_flags_out[AF];
assign ld_flag_ZF = ld_flags_out[ZF];
assign ld_flag_SF = ld_flags_out[SF];
assign ld_flag_OF = ld_flags_out[OF];

endmodule


