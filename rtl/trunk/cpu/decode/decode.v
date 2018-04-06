/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module:Decode                                        */
/* Description:                                         */
/********************************************************/

module decode (r_de_ic_data_shifted,
               r_de_EIP_curr, 
               r_de_CS_curr, 
               de_EIP_curr,
               de_CS_curr,
               de_base_sel,
               de_disp_sel,
               de_SIB_pr,
               de_scale,
               de_imm_rel_ptr32,
               de_disp32,
               de_in1_needed,
               de_in2_needed,
               de_in3_needed,
               de_in4_needed,
               de_esp_needed,
               de_eax_needed,
               de_ecx_needed,
               de_in1,
               de_in2,
               de_in3,
               de_in4,
               de_dreg1,
               de_dreg2,
               de_dreg3, 
               de_ld_reg1, 
               de_ld_reg2, 
               de_ld_reg3, 
               de_ld_reg1_strb, 
               de_ld_reg2_strb, 
               de_ld_reg3_strb, 
               de_reg8_sr1_HL_sel, 
               de_reg8_sr2_HL_sel, 
               de_mm1_needed, 
               de_mm2_needed, 
               de_mm1, 
               de_mm2, 
               de_ld_mm, 
               de_dmm, 
               de_mm_sr1_sel_H, 
               de_mm_sr1_sel_L, 
               de_mm_sr2_sel, 
               de_seg1_needed, 
               de_seg2_needed, 
               de_seg3_needed, 
               de_seg1, 
               de_seg2, 
               de_seg3, 
               de_ld_seg, 
               de_dseg, 
               de_ld_mem, 
               de_mem_read, 
               de_mem_rd_size, 
               de_mem_wr_size, 
               de_mem_rd_addr_sel, 
               de_eip_change, 
               de_cmps_op, 
               de_cxchg_op, 
               de_CF_needed, 
               de_DF_needed, 
               de_AF_needed, 
               de_pr_size_over, 
               de_EIP_next, 
               de_stack_off_sel, 
               de_imm_sel, 
               de_EIP_EFLAGS_sel, 
               de_sr1_sel, 
               de_sr2_sel, 
               de_alu1_op, 
               de_alu2_op, 
               de_alu3_op, 
               de_alu1_op_size, 
               de_df_val, 
               de_CF_expected, 
               de_ZF_expected, 
               de_cond_wr_CF, 
               de_cond_wr_ZF, 
               de_wr_reg1_data_sel, 
               de_wr_reg2_data_sel, 
               de_wr_seg_data_sel, 
               de_wr_eip_alu_res_sel, 
               de_wr_mem_data_sel, 
               de_wr_mem_addr_sel, 
               de_ld_flag_CF, 
               de_ld_flag_PF, 
               de_ld_flag_AF, 
               de_ld_flag_ZF, 
               de_ld_flag_SF, 
               de_ld_flag_DF, 
               de_ld_flag_OF);

input [255:0]r_de_ic_data_shifted;
input [31:0] r_de_EIP_curr;
input [15:0] r_de_CS_curr;


output [31:0]de_EIP_curr;
output [15:0]de_CS_curr;
output       de_base_sel;
output [1:0] de_disp_sel;
output       de_SIB_pr;
output [1:0] de_scale;
output [31:0]de_imm_rel_ptr32;
output [31:0]de_disp32;
output       de_in1_needed;
output       de_in2_needed;
output       de_in3_needed;
output       de_in4_needed;
output       de_esp_needed;
output       de_eax_needed;
output       de_ecx_needed;
output [2:0] de_in1;
output [2:0] de_in2;
output [2:0] de_in3;
output [2:0] de_in4;
output [2:0] de_dreg1;
output [2:0] de_dreg2;
output [2:0] de_dreg3;
output       de_ld_reg1;
output       de_ld_reg2;
output       de_ld_reg3;
output [3:0] de_ld_reg1_strb;
output [3:0] de_ld_reg2_strb;
output [3:0] de_ld_reg3_strb;
output       de_reg8_sr1_HL_sel;
output       de_reg8_sr2_HL_sel;
output       de_mm1_needed;
output       de_mm2_needed;
output [2:0] de_mm1;
output [2:0] de_mm2;
output       de_ld_mm;
output [2:0] de_dmm;
output       de_mm_sr1_sel_H;
output       de_mm_sr1_sel_L;
output       de_mm_sr2_sel;
output       de_seg1_needed;
output       de_seg2_needed;
output       de_seg3_needed;
output [2:0] de_seg1;
output [2:0] de_seg2;
output [2:0] de_seg3;
output       de_ld_seg;
output [2:0] de_dseg;
output       de_ld_mem;
output       de_mem_read;
output [1:0] de_mem_rd_size;
output [1:0] de_mem_wr_size;
output       de_mem_rd_addr_sel;
output       de_eip_change;
output       de_cmps_op;
output       de_cxchg_op;
output       de_CF_needed;
output       de_DF_needed;
output       de_AF_needed;
output       de_pr_size_over;
output [31:0]de_EIP_next;
output [1:0] de_stack_off_sel;
output [1:0] de_imm_sel;
output       de_EIP_EFLAGS_sel;
output [1:0] de_sr1_sel;
output [1:0] de_sr2_sel;
output [3:0] de_alu1_op;
output       de_alu2_op;
output       de_alu3_op;
output [1:0] de_alu1_op_size;
output       de_df_val;
output       de_CF_expected;
output       de_ZF_expected;
output       de_cond_wr_CF;
output       de_cond_wr_ZF;
output       de_wr_reg1_data_sel;
output       de_wr_reg2_data_sel;
output [1:0] de_wr_seg_data_sel;
output       de_wr_eip_alu_res_sel;
output [1:0] de_wr_mem_data_sel;
output       de_wr_mem_addr_sel;
output       de_ld_flag_CF;
output       de_ld_flag_PF;
output       de_ld_flag_AF;
output       de_ld_flag_ZF;
output       de_ld_flag_SF;
output       de_ld_flag_DF;
output       de_ld_flag_OF;


wire [127:0] de_lower_16bytes;
wire [127:0] de_upper_16bytes;
wire [31:0]  de_eip;

wire [7:0]  SIB;
wire [15:0] ptr_cs;
wire [31:0] ptr_eip;

wire [127:0] control_signals;
wire [15:0] ptr_cs_1;
wire [31:0] imm;
//Inputs
assign de_lower_16bytes = r_de_ic_data_shifted[127:0]; 
assign de_upper_16bytes = r_de_ic_data_shifted[255:128]; 
assign de_eip = r_de_EIP_curr;

//Opcode rom parameters
localparam INST_SIZE_32_BL = 8'd0;
localparam INST_SIZE_32_BH = 8'd2;
localparam INST_SIZE_32_W = 4'd3;
localparam INST_SIZE_16_BL = 8'd3;
localparam INST_SIZE_16_BH = 8'd5;
localparam INST_SIZE_16_W = 4'd3;
localparam LD_FLAG_OF = 8'd6;
localparam LD_FLAG_OF_W = 4'd1;
localparam LD_FLAG_DF = 8'd7;
localparam LD_FLAG_DF_W = 4'd1;
localparam LD_FLAG_SF = 8'd8;
localparam LD_FLAG_SF_W = 4'd1;
localparam LD_FLAG_ZF = 8'd9;
localparam LD_FLAG_ZF_W = 4'd1;
localparam LD_FLAG_AF = 8'd10;
localparam LD_FLAG_AF_W = 4'd1;
localparam LD_FLAG_PF = 8'd11;
localparam LD_FLAG_PF_W = 4'd1;
localparam LD_FLAG_CF = 8'd12;
localparam LD_FLAG_CF_W = 4'd1;
localparam ALU_OP_SIZE_NO_OVER = 8'd13;
localparam ALU_OP_SIZE_NO_OVER_W = 4'd1;
localparam ALU1_OP_SIZE_BL = 8'd14;
localparam ALU1_OP_SIZE_BH = 8'd15;
localparam ALU1_OP_SIZE_W = 4'd2;
localparam ALU3_OP_BL = 8'd16;
localparam ALU3_OP_BH = 8'd19;
localparam ALU3_OP_W = 4'd4;
localparam ALU2_OP_BL = 8'd20;
localparam ALU2_OP_BH = 8'd23;
localparam ALU2_OP_W = 4'd4;
localparam ALU1_OP3_BL = 8'd24;
localparam ALU1_OP3_BH = 8'd27;
localparam ALU1_OP3_W = 4'd4;
localparam ALU1_OP2_BL = 8'd28;
localparam ALU1_OP2_BH = 8'd31;
localparam ALU1_OP2_W = 4'd4;
localparam ALU1_OP1_BL = 8'd32;
localparam ALU1_OP1_BH = 8'd35;
localparam ALU1_OP1_W = 4'd4;
localparam WR_MEM_ADDR_SEL = 8'd36;
localparam WR_MEM_ADDR_SEL_W = 4'd1;
localparam WR_MEM_DATA_SEL_BL = 8'd37;
localparam WR_MEM_DATA_SEL_BH = 8'd38;
localparam WR_MEM_DATA_SEL_W = 4'd2;
localparam WR_EIP_ALU_RES_SEL = 8'd39;
localparam WR_EIP_ALU_RES_SEL_W = 4'd1;
localparam WR_SEG_DATA_SEL_BL = 8'd40;
localparam WR_SEG_DATA_SEL_BH = 8'd41;
localparam WR_SEG_DATA_SEL_W = 4'd2;
localparam WR_REG2_DATA_SEL = 8'd42;
localparam WR_REG2_DATA_SEL_W = 4'd1;
localparam WR_REG1_DATA_SEL = 8'd43;
localparam WR_REG1_DATA_SEL_W = 4'd1;
localparam COND_WR_ZF = 8'd44;
localparam COND_WR_ZF_W = 4'd1;
localparam COND_WR_CF = 8'd45;
localparam COND_WR_CF_W = 4'd1;
localparam ZF_EXPECTED = 8'd46;
localparam ZF_EXPECTED_W = 4'd1;
localparam CF_EXPECTED = 8'd47;
localparam CF_EXPECTED_W = 4'd1;
localparam DF_VAL = 8'd48;
localparam DF_VAL_W = 4'd1;
localparam LD_MMX = 8'd49;
localparam LD_MMX_W = 4'd1;
localparam DSEG_BL = 8'd50;
localparam DSEG_BH = 8'd52;
localparam DSEG_W = 4'd3;
localparam LD_SEG = 8'd53;
localparam LD_SEG_W = 4'd1;
localparam MEM_RD_ADDR_SEL = 8'd54;
localparam MEM_RD_ADDR_SEL_W = 4'd1;
localparam EIP_EFLAGS_SEL = 8'd55;
localparam EIP_EFLAGS_SEL_W = 4'd1;
localparam MM_SR1_SEL_H = 8'd56;
localparam MM_SR1_SEL_H_W = 4'd1;
localparam SR2_SEL_MEM_BL = 8'd57;
localparam SR2_SEL_MEM_BH = 8'd58;
localparam SR2_SEL_MEM_W = 4'd2;
localparam SR2_SEL_REG_BL = 8'd59;
localparam SR2_SEL_REG_BH = 8'd60;
localparam SR2_SEL_REG_W = 4'd2;
localparam SR1_SEL_MEM_BL = 8'd61;
localparam SR1_SEL_MEM_BH = 8'd62;
localparam SR1_SEL_MEM_W = 4'd2;
localparam SR1_SEL_REG_BL = 8'd63;
localparam SR1_SEL_REG_BH = 8'd64;
localparam SR1_SEL_REG_W = 4'd2;
localparam REG_RW_SIZE_NO_OVER = 8'd65;
localparam REG_RW_SIZE_NO_OVER_W = 4'd1;
localparam REG_RW_SIZE_BL = 8'd66;
localparam REG_RW_SIZE_BH = 8'd67;
localparam REG_RW_SIZE_W = 4'd2;
localparam MEM_WR_SIZE_NO_OVER = 8'd68;
localparam MEM_WR_SIZE_NO_OVER_W = 4'd1;
localparam MEM_WR_SIZE_BL = 8'd69;
localparam MEM_WR_SIZE_BH = 8'd70;
localparam MEM_WR_SIZE_W = 4'd2;
localparam MEM_RD_SIZE_NO_OVER = 8'd71;
localparam MEM_RD_SIZE_NO_OVER_W = 4'd1;
localparam MEM_RD_SIZE_BL = 8'd72;
localparam MEM_RD_SIZE_BH = 8'd73;
localparam MEM_RD_SIZE_W = 4'd2;
localparam IMM_SEL_32_BL = 8'd74;
localparam IMM_SEL_32_BH = 8'd75;
localparam IMM_SEL_32_W = 4'd2;
localparam IMM_SEL_16_BL = 8'd76;
localparam IMM_SEL_16_BH = 8'd77;
localparam IMM_SEL_16_W = 4'd2;
localparam STACK_OFF_SEL_32_BL = 8'd78;
localparam STACK_OFF_SEL_32_BH = 8'd79;
localparam STACK_OFF_SEL_32_W = 4'd2;
localparam STACK_OFF_SEL_16_BL = 8'd80;
localparam STACK_OFF_SEL_16_BH = 8'd81;
localparam STACK_OFF_SEL_16_W = 4'd2;
localparam SEG3_SEL_OVER = 8'd82;
localparam SEG3_SEL_OVER_W = 4'd1;
localparam SEG3_SEL_BL = 8'd83;
localparam SEG3_SEL_BH = 8'd85;
localparam SEG3_SEL_W = 4'd3;
localparam SEG3_NEEDED = 8'd86;
localparam SEG3_NEEDED_W = 4'd1;
localparam SEG2_SEL = 8'd87;
localparam SEG2_SEL_W = 4'd1;
localparam STACK_READ = 8'd88;
localparam STACK_READ_W = 4'd1;
localparam STACK_WRITE = 8'd89;
localparam STACK_WRITE_W = 4'd1;
localparam RET_OP = 8'd90;
localparam RET_OP_W = 4'd1;
localparam CXCHG_OP = 8'd91;
localparam CXCHG_OP_W = 4'd1;
localparam CMPS_OP = 8'd92;
localparam CMPS_OP_W = 4'd1;
localparam SR2_ECX = 8'd93;
localparam SR2_ECX_W = 4'd1;
localparam SR3_ESP = 8'd94;
localparam SR3_ESP_W = 4'd1;
localparam SR3_EAX = 8'd95;
localparam SR3_EAX_W = 4'd1;
localparam AF_NEEDED = 8'd96;
localparam AF_NEEDED_W = 4'd1;
localparam DF_NEEDED = 8'd97;
localparam DF_NEEDED_W = 4'd1;
localparam CF_NEEDED = 8'd98;
localparam CF_NEEDED_W = 4'd1;
localparam EIP_CHANGE = 8'd99;
localparam EIP_CHANGE_W = 4'd1;
localparam MM2_NEEDED = 8'd100;
localparam MM2_NEEDED_W = 4'd1;
localparam MM1_NEEDED = 8'd101;
localparam MM1_NEEDED_W = 4'd1;
localparam MOD_RM_PR = 8'd102;
localparam MOD_RM_PR_W = 4'd1;
localparam REG_OP_OVERRIDE = 8'd103;
localparam REG_OP_OVERRIDE_W = 4'd1;
localparam LD_SR2 = 8'd104;
localparam LD_SR2_W = 4'd1;
localparam LD_SR1 = 8'd105;
localparam LD_SR1_W = 4'd1;
localparam SR2_NEEDED = 8'd106;
localparam SR2_NEEDED_W = 4'd1;
localparam SR1_NEEDED = 8'd107;
localparam SR1_NEEDED_W = 4'd1;
localparam SR2_RM = 8'd108;
localparam SR2_RM_W = 4'd1;
localparam SR1_RM = 8'd109;
localparam SR1_RM_W = 4'd1;
localparam SR1_EAX = 8'd110;
localparam SR1_EAX_W = 4'd1;
localparam SUB_ROM_SEL = 8'd111;
localparam SUB_ROM_SEL_W = 4'd1;
localparam LITERALS = 8'd112;
localparam LITERALS_W = 4'd1;
localparam PREFIX = 8'd115;
localparam PREFIX_W = 4'd1;

//MODROM
localparam MOD_ROM_SIZE_BL = 3'd0;
localparam MOD_ROM_SIZE_BH = 3'd2;
localparam MOD_ROM_SIZE_W = 3'd3;
localparam DISP_SEL_BL = 3'd3;
localparam DISP_SEL_BH = 3'd4;
localparam DISP_SEL_W = 3'd2;
localparam BASE_SEL = 3'd5;
localparam BASE_SEL_W = 3'd1;
localparam SIB_PR = 3'd6;
localparam SIB_PR_W = 3'd1;



//Internal variables
wire [3:0] w_pr_repne;
wire [3:0] w_pr_cs_over;
wire [3:0] w_pr_ss_over;
wire [3:0] w_pr_ds_over;
wire [3:0] w_pr_es_over;
wire [3:0] w_pr_fs_over;
wire [3:0] w_pr_gs_over;
wire [3:0] w_pr_size_over;
wire [3:0] w_pr_0f;
wire [3:0] w_pr_pos;

wire [2:0]  w_mux_sel;
wire [7:0]  w_opcode;
wire [7:0]  w_modrm;

wire [7:0]  w_oprom_oe;
wire [63:0] w_oprom_out_0;
wire [63:0] w_oprom_out_1;
wire [127:0] w_oprom_out;

wire [31:0] w_modrom_out;
wire [3:0]  de_eip_len;

//Prefix Comparison
genvar i;
generate
  for (i=0; i<4; i=i+1) begin : pref_comp_gen
eq_checker8 u_eq_checker8_1(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'hF2), .eq_out(w_pr_repne[i]));
eq_checker8 u_eq_checker8_2(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h2E), .eq_out(w_pr_cs_over[i]));
eq_checker8 u_eq_checker8_3(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h36), .eq_out(w_pr_ss_over[i]));
eq_checker8 u_eq_checker8_4(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h3E), .eq_out(w_pr_ds_over[i]));
eq_checker8 u_eq_checker8_5(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h26), .eq_out(w_pr_es_over[i]));
eq_checker8 u_eq_checker8_6(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h64), .eq_out(w_pr_fs_over[i]));
eq_checker8 u_eq_checker8_7(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h65), .eq_out(w_pr_gs_over[i]));
eq_checker8 u_eq_checker8_8(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h66), .eq_out(w_pr_size_over[i]));
eq_checker8 u_eq_checker8_9(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h0F), .eq_out(w_pr_0f[i]));
or9 u_or9_1 (.in0(w_pr_repne[i]), .in1(w_pr_cs_over[i]), .in2(w_pr_ss_over[i]), .in3(w_pr_ds_over[i]), 
             .in4(w_pr_es_over[i]), .in5(w_pr_fs_over[i]), .in6(w_pr_gs_over[i]), .in7(w_pr_size_over[i]), .in8(w_pr_0f[i]), .out(w_pr_pos[i]) );
  end
endgenerate

//Prefix Counter
wire pr_pos_0_bar;
wire pr_pos_1_bar;
wire pr_pos_2_bar;
wire and_temp1;
wire nand_temp1;
wire nand_temp2;
wire nand_temp3;

inv1$ inv1 (.in(w_pr_pos[0]), .out(pr_pos_0_bar));
inv1$ inv3 (.in(w_pr_pos[2]), .out(pr_pos_2_bar));

and4$ and4_1 (.in0(w_pr_pos[0]), .in1(w_pr_pos[1]), .in2(w_pr_pos[2]), .in3(w_pr_pos[3]), .out(w_mux_sel[2]));

and2$ and2_1 (.in0(w_pr_pos[3]), .in1(w_pr_pos[2]), .out(and_temp1)); 
nand2$ nand2_1   (.in0(w_pr_pos[1]), .in1(w_pr_pos[0]), .out(nand_temp1)); 
and2$ and2_2 (.in0(and_temp1), .in1(nand_temp1), .out(w_mux_sel[1])); 

nand2$ nand2_2 (.in0(w_pr_pos[3]), .in1(pr_pos_2_bar), .out(nand_temp2)); 
nand3$ nand3_1 (.in0(w_pr_pos[3]), .in1(w_pr_pos[1]), .in2(pr_pos_0_bar), .out(nand_temp3)); 
nand2$ nand2_3   (.in0(nand_temp2), .in1(nand_temp3), .out(w_mux_sel[0])); 

//Thermometer encoder
wire [3:0] w_therm_byte;
wire [3:0] masked_repne;
wire [3:0] masked_cs_over;
wire [3:0] masked_ss_over;
wire [3:0] masked_ds_over;
wire [3:0] masked_es_over;
wire [3:0] masked_fs_over;
wire [3:0] masked_gs_over;
wire [3:0] masked_size_over;
wire [3:0] masked_0f;


assign w_therm_byte[0] = w_pr_pos[0];
and2$ and_therm0 (.in0(w_therm_byte[0]), .in1(w_pr_pos[1]), .out(w_therm_byte[1])); 
and3$ and_therm1 (.in0(w_therm_byte[0]), .in1(w_therm_byte[1]), .in2(w_pr_pos[2]), .out(w_therm_byte[2])); 
and4$ and_therm2 (.in0(w_therm_byte[0]), .in1(w_therm_byte[1]), .in2(w_therm_byte[2]), .in3(w_pr_pos[3]), .out(w_therm_byte[3]));

generate
  for (i=0; i<4; i=i+1) begin : masked_prefixes
and2$ and_mask0 (.in1(w_pr_repne[i]), .in0(w_therm_byte[i]), .out(masked_repne[i]));
and2$ and_mask1 (.in1(w_pr_cs_over[i]), .in0(w_therm_byte[i]),  .out(masked_cs_over[i]));
and2$ and_mask2 (.in1(w_pr_ss_over[i]), .in0(w_therm_byte[i]), .out(masked_ss_over[i]));
and2$ and_mask3 (.in1(w_pr_ds_over[i]), .in0(w_therm_byte[i]), .out(masked_ds_over[i]));
and2$ and_mask4 (.in1(w_pr_es_over[i]), .in0(w_therm_byte[i]), .out(masked_es_over[i]));
and2$ and_mask5 (.in1(w_pr_fs_over[i]), .in0(w_therm_byte[i]), .out(masked_fs_over[i]));
and2$ and_mask6 (.in1(w_pr_gs_over[i]), .in0(w_therm_byte[i]), .out(masked_gs_over[i]));
and2$ and_mask7 (.in1(w_pr_size_over[i]), .in0(w_therm_byte[i]), .out(masked_size_over[i]));
and2$ and_mask8 (.in1(w_pr_0f[i]), .in0(w_therm_byte[i]), .out(masked_0f[i]));

  end
endgenerate
or4$ or_pr1(.in0(masked_repne[0]), .in1(masked_repne[1]), .in2(masked_repne[2]), .in3(masked_repne[3]), .out(prefix_repne_pr));
nor4$ or_pr2(.in0(masked_cs_over[0]), .in1(masked_cs_over[1]), .in2(masked_cs_over[2]), .in3(masked_cs_over[3]), .out(prefix_cs_pr));
nor4$ or_pr3(.in0(masked_ss_over[0]), .in1(masked_ss_over[1]), .in2(masked_ss_over[2]), .in3(masked_ss_over[3]), .out(prefix_ss_pr));
nor4$ or_pr4(.in0(masked_ds_over[0]), .in1(masked_ds_over[1]), .in2(masked_ds_over[2]), .in3(masked_ds_over[3]), .out(prefix_ds_pr));
nor4$ or_pr5(.in0(masked_es_over[0]), .in1(masked_es_over[1]), .in2(masked_es_over[2]), .in3(masked_es_over[3]), .out(prefix_es_pr));
nor4$ or_pr6(.in0(masked_fs_over[0]), .in1(masked_fs_over[1]), .in2(masked_fs_over[2]), .in3(masked_fs_over[3]), .out(prefix_fs_pr));
nor4$ or_pr7(.in0(masked_gs_over[0]), .in1(masked_gs_over[1]), .in2(masked_gs_over[2]), .in3(masked_gs_over[3]), .out(prefix_gs_pr));
or4$ or_pr8(.in0(masked_size_over[0]), .in1(masked_size_over[1]), .in2(masked_size_over[2]), .in3(masked_size_over[3]), .out(prefix_op_size_pr));
or4$ or_pr9(.in0(masked_0f[0]), .in1(masked_0f[1]), .in2(masked_0f[2]), .in3(masked_0f[3]), .out(prefix_0f_pr));

nand3$ seg_nor1(.in0(prefix_cs_pr), .in1(prefix_ss_pr), .in2(prefix_ds_pr), .out(nor_temp1));
nand3$ seg_nor2(.in0(prefix_es_pr), .in1(prefix_fs_pr), .in2(prefix_gs_pr), .out(nor_temp2));
or2$ seg_nand(.in0(nor_temp1), .in1(nor_temp2), .out(prefix_seg_over_pr));

wire [2:0]prefix_seg_reg;
pencoder8_3$ enc (.enbar(1'b0), .X({1'b0,1'b0,prefix_gs_pr, prefix_fs_pr,prefix_ds_pr, prefix_ss_pr, prefix_cs_pr, prefix_es_pr}), .Y(prefix_seg_reg));


//Mux array to select opcode (dispa nd imm not done yet)
wire [1:0] mod; 
wire [2:0] r_m; 
wire [2:0] reg_op_mod; 
wire [2:0] reg_op; 
wire [2:0]disp_sel;
wire [3:0]imm_sel;
wire [2:0]mod_size;
wire [3:0]disp_sel_1;
wire [3:0]imm_sel_sum;

//disp
nibble_low disp_add  ( .a({1'b0,w_mux_sel}), .b(4'd1), .cin(1'd0), .s(disp_sel_1), .cout(/*unused*/));
mux_nbit_2x1#3 disp_mux(.a1(disp_sel[2:0]), .a0(w_mux_sel), .sel(w_modrom_out[SIB_PR]), .out(disp_sel));

//imm

mux_nbit_2x1#3 mod_sel(.a1(w_modrom_out[MOD_ROM_SIZE_BH:MOD_ROM_SIZE_BL]), .a0(3'd0), .sel(control_signals[MOD_RM_PR]), .out(mod_size));
nibble_low imm_add  ( .a({1'b0,w_mux_sel}), .b({1'b0,mod_size}), .cin(1'd0), .s(imm_sel), .cout(/*unused*/));

//Muxes
mux8bit_8x1 mux_op    (.IN0(de_lower_16bytes[7:0]), .IN1(de_lower_16bytes[15:8]), .IN2(de_lower_16bytes[23:16]), .IN3(de_lower_16bytes[31:24]),
                       .IN4(de_lower_16bytes[39:32]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(w_opcode));

mux8bit_8x1 mux_mod   (.IN0(de_lower_16bytes[15:8]), .IN1(de_lower_16bytes[23:16]), .IN2(de_lower_16bytes[31:24]), .IN3(de_lower_16bytes[39:32]),
                       .IN4(de_lower_16bytes[47:40]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(w_modrm));


mux8bit_8x1 mux_sib   (.IN0(de_lower_16bytes[23:16]), .IN1(de_lower_16bytes[31:24]), .IN2(de_lower_16bytes[39:32]), .IN3(de_lower_16bytes[47:40]),
                       .IN4(de_lower_16bytes[55:48]), .IN5(8'd0), .IN6(8'd0), .IN7(8'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(SIB));


mux32bit_8x1 mux_disp (.IN0(de_lower_16bytes[47:16]), .IN1(de_lower_16bytes[55:24]), .IN2(de_lower_16bytes[63:32]), .IN3(de_lower_16bytes[71:40]),
                       .IN4(de_lower_16bytes[79:48]), .IN5(de_lower_16bytes[87:56]), .IN6(32'd0), .IN7(32'd0), .S0(disp_sel[0]), .S1(disp_sel[1]),
                       .S2(disp_sel[2]), .Y(de_disp32));

mux32bit_16x1 mux_imm (.IN0(de_lower_16bytes[39:8]), .IN1(de_lower_16bytes[47:16]), .IN2(de_lower_16bytes[55:24]), .IN3(de_lower_16bytes[63:32]),
                       .IN4(de_lower_16bytes[71:40]), .IN5(de_lower_16bytes[79:48]), .IN6(de_lower_16bytes[87:56]), .IN7(de_lower_16bytes[95:64]), 
                       .IN8(de_lower_16bytes[103:72]), .IN9(de_lower_16bytes[111:80]), .IN10(de_lower_16bytes[119:88]), .IN11(32'd0), .IN12(32'd0),
                       .IN13(32'd0), .IN14(32'd0), .IN15(32'd0), .S0(imm_sel[0]), .S1(imm_sel[1]),
                       .S2(imm_sel[2]), .S3(imm_sel[3]), .Y(imm));
assign de_imm_rel_ptr32 = imm;

mux16bit_8x1 mux_ptr1 (.IN0(de_lower_16bytes[55:40]), .IN1(de_lower_16bytes[63:48]), .IN2(de_lower_16bytes[71:56]), .IN3(de_lower_16bytes[79:64]),
                       .IN4(de_lower_16bytes[87:72]), .IN5(16'd0), .IN6(16'd0), .IN7(16'd0), .S0(w_mux_sel[0]), .S1(w_mux_sel[1]),
                       .S2(w_mux_sel[2]), .Y(ptr_cs_1));

mux_nbit_2x1#16 mux_disp_sel(.a1(imm[31:16]), .a0(ptr_cs_1), .sel(prefix_op_size_pr), .out(ptr_cs));

assign mod = w_modrm[7:6];
assign r_m = w_modrm[2:0];
assign reg_op_mod = w_modrm[5:3];

wire [2:0] index;
wire [2:0] base;

assign de_scale = SIB[7:6];
assign index = SIB[5:3];
assign base = SIB[2:0];


//Accessing Opcode ROM
wire [7:0] w_oprom_oebar;
decoder3_8$ decode1 (.SEL(w_opcode[7:5]), .Y(w_oprom_oe), .YBAR(w_oprom_oebar));

generate
  for (i=0; i<8; i=i+1) begin : op_rom_gen
 
rom64b32w$ rom0(.A(w_opcode[4:0]), .OE(w_oprom_oe[i]), .DOUT(w_oprom_out_0[63:0]));
rom64b32w$ rom1(.A(w_opcode[4:0]), .OE(w_oprom_oe[i]), .DOUT(w_oprom_out_1[63:0]));
  
  end
endgenerate

assign w_oprom_out = {w_oprom_out_0,w_oprom_out_1};

//Acessing Sub oprom
wire [63:0] w_subrom_out_0;
wire [63:0] w_subrom_out_1;
wire [127:0] w_subrom_out;
wire [7:0] w_subrom_oe;
wire [7:0] w_subrom_oebar;
wire [7:0] w_subrom_addr;
assign w_subrom_addr = {prefix_0f_pr, w_opcode[3:0], reg_op} ; 
decoder3_8$ decode2 (.SEL(w_subrom_addr[7:5]), .Y(w_subrom_oe), .YBAR(w_subrom_oebar));

generate
  for (i=0; i<8; i=i+1) begin : sub_rom_gen
 
rom64b32w$ subrom0(.A(w_subrom_addr[4:0]), .OE(w_subrom_oe[i]), .DOUT(w_subrom_out_0[63:0]));
rom64b32w$ subrom1(.A(w_subrom_addr[4:0]), .OE(w_subrom_oe[i]), .DOUT(w_subrom_out_1[63:0]));
  
  end
endgenerate

assign w_subrom_out = {w_subrom_out_0,w_subrom_out_1};

// Select between op rom and sub rom outputs

mux_nbit_2x1#128 mux_rom(.a0(w_oprom_out), .a1(w_subrom_out), .sel(w_oprom_out[SUB_ROM_SEL]), .out(control_signals));


//Accessing MOD ROM
wire [4:0] w_modrom_addr;
assign w_modrom_addr = {mod,r_m};
rom32b32w$ modrom(.A(w_modrom_addr), .OE(1'b1), .DOUT(w_modrom_out));
  
//mux for 16 bit vs 32 bit op size
wire [2:0] oprom_size;
mux_nbit_2x1#INST_SIZE_32_W  mux_size(.a0(control_signals[INST_SIZE_32_BH:INST_SIZE_32_BL]), .a1(control_signals[INST_SIZE_16_BH:INST_SIZE_16_BL]), .sel(prefix_op_size_pr), .out(oprom_size));

//mod size
wire [2:0] modrom_size;
mux_nbit_2x1#3 mux_mod_rom(.a1(w_modrom_out[MOD_ROM_SIZE_BH:MOD_ROM_SIZE_BL]), .a0(3'd0), .sel(control_signals[MOD_RM_PR]), .out(modrom_size));

//Intruction Size calculation
cond_sum_abc de_len_add (.a({1'b0,w_mux_sel}), .b({1'b0,oprom_size}), .c({1'b0,modrom_size}), .sum(de_eip_len));



//Reg_op mux
mux_nbit_2x1#3 mux_regop(.a1(w_opcode[2:0]), .a0(reg_op_mod), .sel(control_signals[REG_OP_OVERRIDE]), .out(reg_op));

// All signal muxing
wire [1:0]reg_rw_size;
register_addr_dependency reg_vals(.sr1_needed(control_signals[SR1_NEEDED]),
                                  .sr2_needed(control_signals[SR2_NEEDED]),
                                  .sr1_eax(control_signals[SR1_EAX]),
                                  .sr2_ecx(control_signals[SR2_ECX]),
                                  .sr3_eax(control_signals[SR3_EAX]),
                                  .sr3_esp(control_signals[SR3_ESP]),
                                  .sr1_rm(control_signals[SR1_RM]),
                                  .sr2_rm(control_signals[SR2_RM]),
                                  .mod(mod),
                                  .base(base),
                                  .index(index),
                                  .r_m(r_m),
                                  .mod_rm_pr(control_signals[MOD_RM_PR]),
                                  .sib_pr(w_modrom_out[SIB_PR]),
                                  .cmps_op(control_signals[CMPS_OP]),
                                  .cxchg_op(control_signals[CXCHG_OP]),
                                  .reg_op(reg_op),
                                  .reg_rw_size(reg_rw_size),
                                  .prefix_repne(prefix_repne_pr),
                                  .ld_sr1(control_signals[LD_SR1]),
                                  .ld_sr2(control_signals[LD_SR2]),
                                  .stack_read(control_signals[STACK_READ]),
                                  .stack_write(control_signals[STACK_WRITE]),
                                  .in1_needed(de_in1_needed),
                                  .in2_needed(de_in2_needed),
                                  .in3_needed(de_in3_needed),
                                  .in4_needed(de_in4_needed),
                                  .in1(de_in1),
                                  .in2(de_in2),
                                  .in3(de_in3),
                                  .in4(de_in4),
                                  .reg8_sr1_HL_sel(de_reg8_sr1_HL_sel),
                                  .reg8_sr2_HL_sel(de_reg8_sr2_HL_sel),
                                  .dreg1(de_dreg1),
                                  .dreg2(de_dreg2),
                                  .dreg3(de_dreg3),
                                  .ld_reg1_strb(de_ld_reg1_strb),
                                  .ld_reg2_strb(de_ld_reg2_strb),
                                  .ld_reg3_strb(de_ld_reg3_strb),
                                  .ld_reg1(de_ld_reg1),
                                  .ld_reg2(de_ld_reg2),
                                  .ld_reg3(de_ld_reg3));

mmx_addr_dependency mmx_vals (.mm1_needed_in(control_signals[MM1_NEEDED]),
                              .mm2_needed_in(control_signals[MM2_NEEDED]),
                              .sr1_rm(control_signals[SR1_RM]),
                              .sr2_rm(control_signals[SR2_RM]),
                              .mod(mod),
                              .r_m(r_m),
                              .mod_rm_pr(control_signals[MOD_RM_PR]),
                              .reg_op(reg_op),
                              .ld_mm_in(control_signals[LD_MMX]),
                              .ret_op(control_signals[RET_OP]),
                              .ld_mm(de_ld_mm),
                              .mm1_needed(de_mm1_needed),
                              .mm2_needed(de_mm2_needed),
                              .mm1(de_mm1),
                              .mm2(de_mm2),
                              .mm_sr1_sel_L(de_mm_sr1_sel_L),
                              .mm_sr2_sel(de_mm_sr2_sel),
                              .dmm(de_dmm));

segment_addr_dependency seg_vals (.cmps_op(control_signals[CMPS_OP]),
                                  .mod(mod),
                                  .reg_op(reg_op),
                                  .seg3_sel(control_signals[SEG3_SEL_BH:SEG3_SEL_BL]),
                                  .prefix_seg_reg(prefix_seg_reg),
                                  .mod_rm_pr(control_signals[MOD_RM_PR]),
                                  .stack_read(control_signals[STACK_READ]),
                                  .stack_write(control_signals[STACK_WRITE]),
                                  .seg3_needed_in(control_signals[SEG3_NEEDED]),
                                  .seg3_sel_over(control_signals[SEG3_SEL_OVER]),
                                  .prefix_seg_over(prefix_seg_over_pr),
                                  .seg2_sel(control_signals[SEG2_SEL]),
                                  .dseg_in(control_signals[DSEG_BH:DSEG_BL]),
                                  .ld_seg_in(control_signals[LD_SEG]),
                                  .seg1_needed(de_seg1_needed),
                                  .seg2_needed(de_seg2_needed),
                                  .seg3_needed(de_seg3_needed),
                                  .seg1(de_seg1),
                                  .seg2(de_seg2),
                                  .seg3(de_seg3),
                                  .dseg(de_dseg),
                                  .ld_seg(de_ld_seg)
                               );

rom_value_select rom_vals ( .sr1_sel_reg(control_signals[SR1_SEL_REG_BH:SR1_SEL_REG_BL]),
                            .sr1_sel_mem(control_signals[SR1_SEL_MEM_BH:SR1_SEL_MEM_BL]),
                            .sr2_sel_reg(control_signals[SR2_SEL_REG_BH:SR2_SEL_REG_BL]),
                            .sr2_sel_mem(control_signals[SR2_SEL_MEM_BH:SR2_SEL_MEM_BL]),
                            .imm_sel_16(control_signals[IMM_SEL_16_BH:IMM_SEL_16_BL]),
                            .imm_sel_32(control_signals[IMM_SEL_32_BH:IMM_SEL_32_BL]),
                            .stack_off_sel_16(control_signals[STACK_OFF_SEL_16_BH:STACK_OFF_SEL_16_BL]),
                            .stack_off_sel_32(control_signals[STACK_OFF_SEL_32_BH:STACK_OFF_SEL_32_BL]),
                            .reg_rw_size_in(control_signals[REG_RW_SIZE_BH:REG_RW_SIZE_BL]),
                            .mem_rd_size_in(control_signals[MEM_RD_SIZE_BH:MEM_RD_SIZE_BL]),
                            .mem_wr_size_in(control_signals[MEM_WR_SIZE_BH:MEM_WR_SIZE_BL]),
                            .alu1_op_size_in(control_signals[ALU1_OP_SIZE_BH:ALU1_OP_SIZE_BL]),
                            .alu1_op1(control_signals[ALU1_OP1_BH:ALU1_OP1_BL]),
                            .alu1_op2(control_signals[ALU1_OP2_BH:ALU1_OP2_BL]),
                            .alu1_op3(control_signals[ALU1_OP3_BH:ALU1_OP3_BL]),
                            .base_sel_in(w_modrom_out[BASE_SEL]),
                            .disp_sel_in(w_modrom_out[DISP_SEL_BH:DISP_SEL_BL]),
                            .SIB_pr_in(w_modrom_out[SIB_PR]),
                            .mod(mod),
                            .mod_rm_pr(control_signals[MOD_RM_PR]),
                            .reg_op(reg_op),
                            .prefix_op_size(prefix_op_size_pr),
                            .reg_rw_size_no_over(control_signals[REG_RW_SIZE_NO_OVER]),
                            .mem_rd_size_no_over(control_signals[MEM_RD_SIZE_NO_OVER]),
                            .mem_wr_size_no_over(control_signals[MEM_WR_SIZE_NO_OVER]),
                            .alu1_op_size_no_over(control_signals[ALU_OP_SIZE_NO_OVER]),
		            .ret_op(control_signals[RET_OP]),
                            .ld_seg(control_signals[LD_SEG]),
                            .sr1_sel(de_sr1_sel),
                            .sr2_sel(de_sr2_sel),
                            .imm_sel(de_imm_sel),
                            .stack_off_sel(de_stack_off_sel),
                            .reg_rw_size(reg_rw_size),
                            .mem_rd_size(de_mem_rd_size),
                            .mem_wr_size(de_mem_wr_size),
                            .alu1_op_size(de_alu1_op_size),
                            .alu1_op(de_alu1_op),
                            .base_sel(de_base_sel),
                            .disp_sel(de_disp_sel),
                            .SIB_pr(de_SIB_pr));

//Read mem and Load Mem generation

nand2$ mem_nand0( .in0(mod[0]), .in1(mod[1]), .out(mod_not_11));
nand2$ mem_nand1( .in0(mod_not_11), .in1(control_signals[SR1_RM]), .out(mem_nand1_out));
nor2$  mem_nor0 ( .in0(control_signals[LD_SR1]), .in1(control_signals[LD_MMX]), .out(mem_nor0_out));
nor2$  mem_nor1 ( .in0(mem_nor0_out), .in1(mem_nand1_out), .out(mem_nor1_out));
or2$   mem_or0  ( .in0(mem_nor1_out), .in1(control_signals[STACK_WRITE]), .out(de_ld_mem));


or2$   mem_or1  ( .in0(control_signals[SR1_RM]), .in1(control_signals[SR2_RM]), .out(w_mem_or1_out));
and2$  mem_and0 ( .in0(w_mem_or1_out), .in1(mod_not_11), .out(w_mem_and0_out));
or2$   mem_or2  ( .in0(control_signals[CMPS_OP]), .in1(control_signals[STACK_READ]), .out(w_mem_or2_out));
or2$   mem_or3  ( .in0(w_mem_or2_out), .in1(w_mem_and0_out), .out(de_mem_read));



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

mux32bit_16x1 mux_eip(.Y(de_EIP_next), .IN0(de_eip), .IN1(nxt_eip0), .IN2(nxt_eip1), .IN3(nxt_eip2), .IN4(nxt_eip3), .IN5(nxt_eip4)
                      , .IN6(nxt_eip5), .IN7(nxt_eip6), .IN8(nxt_eip7), .IN9(nxt_eip8), .IN10(nxt_eip9), .IN11(nxt_eip10)
                      , .IN12(nxt_eip11), .IN13(nxt_eip12), .IN14(nxt_eip13), .IN15(nxt_eip14)
                      , .S0(de_eip_len[0]), .S1(de_eip_len[1]), .S2(de_eip_len[2]), .S3(de_eip_len[3]));


//output direct assignments

assign de_EIP_curr =  r_de_EIP_curr;
assign de_CS_curr =  de_CS_curr;
assign de_esp_needed = control_signals[SR3_ESP];
assign de_eax_needed = control_signals[SR3_EAX];
assign de_ecx_needed = prefix_repne_pr;
assign de_mm_sr1_sel_H = control_signals[MM_SR1_SEL_H];
assign de_mem_rd_addr_sel = control_signals[MEM_RD_ADDR_SEL];
assign de_eip_change = control_signals[EIP_CHANGE];
assign de_cmps_op = control_signals[CMPS_OP];
assign de_cxchg_op = control_signals[CXCHG_OP];
assign de_CF_needed = control_signals[CF_NEEDED];
assign de_DF_needed = control_signals[DF_NEEDED];
assign de_AF_needed = control_signals[AF_NEEDED];
assign de_pr_size_over = prefix_op_size_pr;
assign de_EIP_EFLAGS_sel = control_signals[EIP_EFLAGS_SEL];
assign de_alu2_op = control_signals[ALU2_OP_BH:ALU2_OP_BL];
assign de_alu2_op = control_signals[ALU2_OP_BH:ALU2_OP_BL];
assign de_df_val = control_signals[DF_VAL];
assign de_CF_expected = control_signals[CF_EXPECTED];
assign de_ZF_expected = control_signals[ZF_EXPECTED];
assign de_cond_wr_CF = control_signals[COND_WR_CF];
assign de_cond_wr_ZF = control_signals[COND_WR_ZF];
assign de_wr_reg1_data_sel = control_signals[WR_REG1_DATA_SEL];
assign de_wr_reg2_data_sel = control_signals[WR_REG2_DATA_SEL];
assign de_wr_seg_data_sel = control_signals[WR_SEG_DATA_SEL_BH:WR_SEG_DATA_SEL_BL];
assign de_wr_eip_alu_res_sel = control_signals[WR_EIP_ALU_RES_SEL];
assign de_wr_mem_data_sel = control_signals[WR_MEM_DATA_SEL_BH:WR_MEM_DATA_SEL_BL];
assign de_wr_mem_addr_sel = control_signals[WR_MEM_ADDR_SEL];
assign de_ld_flag_CF = control_signals[LD_FLAG_CF];
assign de_ld_flag_PF = control_signals[LD_FLAG_PF];
assign de_ld_flag_AF = control_signals[LD_FLAG_AF];
assign de_ld_flag_ZF = control_signals[LD_FLAG_ZF];
assign de_ld_flag_SF = control_signals[LD_FLAG_SF];
assign de_ld_flag_DF = control_signals[LD_FLAG_DF];
assign de_ld_flag_OF = control_signals[LD_FLAG_OF];










endmodule


// Helper blocks


module or9 (in0, in1, in2, in3, in4, in5, in6, in7, in8, out);
input in0;
input in1;
input in2;
input in3;
input in4;
input in5;
input in6;
input in7;
input in8;
output out;

wire w_or0;
wire w_or1;
or3$ or0(.in0(in0), .in1(in1), .in2(in2), .out(w_or0));
or3$ or1(.in0(in3), .in1(in4), .in2(in5), .out(w_or1));
or3$ or2(.in0(in6), .in1(in7), .in2(in8), .out(w_or2));
or3$ or3(.in0(w_or0), .in1(w_or1), .in2(w_or2), .out(out));

endmodule


