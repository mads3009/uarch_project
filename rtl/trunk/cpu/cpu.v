module cpu (clk, rst_n);
  input clk;
  input rst_n;

// ********** Hardcoded entries ***********
//TLB entries
reg [26:0] TLB[7:0]; 

//Segment_limit_Regs
reg [19:0] CS_limit;
reg [19:0] DS_limit;
reg [19:0] SS_limit;
reg [19:0] ES_limit;
reg [19:0] FS_limit;
reg [19:0] GS_limit;

//Segment_Regs
reg [15:0] r_CS;
reg [15:0] r_DS;
reg [15:0] r_SS;
reg [15:0] r_ES;
reg [15:0] r_FS;
reg [15:0] r_GS;

initial begin
  TLB[0] = 30'h0000;
  TLB[1] = 30'h0000;
  TLB[2] = 30'h0000;
  TLB[3] = 30'h0000;
  TLB[4] = 30'h0000;
  TLB[5] = 30'h0000;
  TLB[6] = 30'h0000;
  TLB[7] = 30'h0000;
  
  CS_limit = 20'h3ff;
  r_CS = 16'h000;
end

//Loads and Valids of pipeline latches
wire r_V_de;
wire r_V_ag;
wire r_V_ro;
wire r_V_ex;
wire r_V_wb;
wire w_ld_de;
wire w_ld_ag;
wire w_ld_ro;
wire w_ld_ex;
wire w_ld_wb;

//Dependencies and stalls
wire w_stall_fe;
wire w_stall_de;
wire w_hlt_stall;
wire w_repne_stall;
wire w_de_iret_op;
wire de_br_stall;
wire ag_br_stall;
wire ro_br_stall;
wire ex_br_stall;
wire wb_br_stall;

//Writeback's internal signals for writeback
wire [31:0] w_wb_wr_reg_data1;
wire [31:0] w_wb_wr_reg_data2;
wire [31:0] w_wb_wr_reg_data3;
wire [15:0] w_wb_wr_seg_data;
wire [3:0] w_v_wb_ld_reg1_strb;
wire [3:0] w_v_wb_ld_reg2_strb;
wire [3:0] w_v_wb_ld_reg3_strb;
wire w_v_wb_ld_reg1;
wire w_v_wb_ld_reg2;
wire w_v_wb_ld_reg3;
wire w_v_wb_ld_mm;
wire w_v_wb_ld_seg;

//Interrupts and Exceptions
wire INT;
wire w_dc_exp;
wire w_ic_exp;
wire w_ic_prot_exp;
wire w_ic_page_fault;
wire w_block_ren;

//Output latches FE -> DE
wire [255:0] r_de_ic_data_shifted;
wire [31:0]  r_de_EIP_curr;
wire [15:0]  r_de_CS_curr;

//Output latches DE -> AG
wire [31:0]r_ag_EIP_curr;
wire [15:0]r_ag_CS_curr;
wire       r_ag_base_sel;
wire [1:0] r_ag_disp_sel;
wire       r_ag_SIB_pr;
wire [1:0] r_ag_scale;
wire [31:0]r_ag_imm_rel_ptr32;
wire [31:0]r_ag_disp32;
wire       r_ag_in1_needed;
wire       r_ag_in2_needed;
wire       r_ag_in3_needed;
wire       r_ag_in4_needed;
wire       r_ag_esp_needed;
wire       r_ag_eax_needed;
wire       r_ag_ecx_needed;
wire [2:0] r_ag_in1;
wire [2:0] r_ag_in2;
wire [2:0] r_ag_in3;
wire [2:0] r_ag_in4;
wire [2:0] r_ag_dreg1;
wire [2:0] r_ag_dreg2;
wire [2:0] r_ag_dreg3;
wire       r_ag_ld_reg1;
wire       r_ag_ld_reg2;
wire       r_ag_ld_reg3;
wire [3:0] r_ag_ld_reg1_strb;
wire [3:0] r_ag_ld_reg2_strb;
wire [3:0] r_ag_ld_reg3_strb;
wire       r_ag_reg8_sr1_HL_sel;
wire       r_ag_reg8_sr2_HL_sel;
wire       r_ag_mm1_needed;
wire       r_ag_mm2_needed;
wire [2:0] r_ag_mm1;
wire [2:0] r_ag_mm2;
wire       r_ag_ld_mm;
wire [2:0] r_ag_dmm;
wire       r_ag_mm_sr1_sel_H;
wire       r_ag_mm_sr1_sel_L;
wire       r_ag_mm_sr2_sel;
wire       r_ag_seg1_needed;
wire       r_ag_seg2_needed;
wire       r_ag_seg3_needed;
wire [2:0] r_ag_seg1;
wire [2:0] r_ag_seg2;
wire [2:0] r_ag_seg3;
wire       r_ag_ld_seg;
wire [2:0] r_ag_dseg;
wire       r_ag_ld_mem;
wire       r_ag_mem_read;
wire [1:0] r_ag_mem_rd_size;
wire [1:0] r_ag_mem_wr_size;
wire       r_ag_mem_rd_addr_sel;
wire       r_ag_eip_change;
wire       r_ag_cmps_op;
wire       r_ag_cxchg_op;
wire       r_ag_CF_needed;
wire       r_ag_DF_needed;
wire       r_ag_AF_needed;
wire       r_ag_pr_size_over;
wire [31:0]r_ag_EIP_next;
wire [1:0] r_ag_stack_off_sel;
wire [1:0] r_ag_imm_sel;
wire [1:0] r_ag_EIP_EFLAGS_sel;
wire [1:0] r_ag_sr1_sel;
wire [1:0] r_ag_sr2_sel;
wire [3:0] r_ag_alu1_op;
wire       r_ag_alu2_op;
wire       r_ag_alu3_op;
wire [1:0] r_ag_alu1_op_size;
wire       r_ag_df_val;
wire       r_ag_CF_expected;
wire       r_ag_ZF_expected;
wire       r_ag_cond_wr_CF;
wire       r_ag_cond_wr_ZF;
wire       r_ag_wr_reg1_data_sel;
wire       r_ag_wr_reg2_data_sel;
wire [1:0] r_ag_wr_seg_data_sel;
wire       r_ag_wr_eip_alu_res_sel;
wire [1:0] r_ag_wr_mem_data_sel;
wire       r_ag_wr_mem_addr_sel;
wire       r_ag_ld_flag_CF;
wire       r_ag_ld_flag_PF;
wire       r_ag_ld_flag_AF;
wire       r_ag_ld_flag_ZF;
wire       r_ag_ld_flag_SF;
wire       r_ag_ld_flag_DF;
wire       r_ag_ld_flag_OF;

//Output latches AG -> RO
wire [31:0]  r_ro_EIP_curr;
wire [15:0]  r_ro_CS_curr;
wire         r_ro_in3_needed;
wire         r_ro_in4_needed;
wire         r_ro_eax_needed;
wire         r_ro_ecx_needed;
wire [2:0]   r_ro_in3;
wire [2:0]   r_ro_in4;
wire [2:0]   r_ro_dreg1;
wire [2:0]   r_ro_dreg2;
wire [2:0]   r_ro_dreg3;
wire         r_ro_ld_reg1;
wire         r_ro_ld_reg2;
wire         r_ro_ld_reg3;
wire [3:0]   r_ro_ld_reg1_strb;
wire [3:0]   r_ro_ld_reg2_strb;
wire [3:0]   r_ro_ld_reg3_strb;
wire         r_ro_reg8_sr1_HL_sel;
wire         r_ro_reg8_sr2_HL_sel;
wire         r_ro_mm1_needed;
wire         r_ro_mm2_needed;
wire [2:0]   r_ro_mm1;
wire [2:0]   r_ro_mm2;
wire         r_ro_ld_mm;
wire [2:0]   r_ro_dmm;
wire         r_ro_mm_sr1_sel_H;
wire         r_ro_mm_sr1_sel_L;
wire         r_ro_mm_sr2_sel;
wire         r_ro_seg3_needed;
wire [2:0]   r_ro_seg3;
wire         r_ro_ld_seg;
wire [2:0]   r_ro_dseg;
wire         r_ro_ld_mem;
wire         r_ro_mem_read;
wire [1:0]   r_ro_mem_rd_size;
wire [1:0]   r_ro_mem_wr_size;
wire         r_ro_mem_rd_addr_sel;
wire         r_ro_eip_change;
wire         r_ro_cmps_op;
wire         r_ro_cxchg_op;
wire         r_ro_CF_needed;
wire         r_ro_DF_needed;
wire         r_ro_AF_needed;
wire         r_ro_pr_size_over;
wire [31:0]  r_ro_EIP_next;
wire [1:0]   r_ro_imm_sel;
wire [1:0]   r_ro_EIP_EFLAGS_sel;
wire [1:0]   r_ro_sr1_sel;
wire [1:0]   r_ro_sr2_sel;
wire [3:0]   r_ro_alu1_op;
wire         r_ro_alu2_op;
wire         r_ro_alu3_op;
wire [1:0]   r_ro_alu1_op_size;
wire         r_ro_df_val;
wire         r_ro_CF_expected;
wire         r_ro_ZF_expected;
wire         r_ro_cond_wr_CF;
wire         r_ro_cond_wr_ZF;
wire         r_ro_wr_reg1_data_sel;
wire         r_ro_wr_reg2_data_sel;
wire [1:0]   r_ro_wr_seg_data_sel;
wire         r_ro_wr_eip_alu_res_sel;
wire [1:0]   r_ro_wr_mem_data_sel;
wire         r_ro_wr_mem_addr_sel;
wire         r_ro_ld_flag_CF;
wire         r_ro_ld_flag_PF;
wire         r_ro_ld_flag_AF;
wire         r_ro_ld_flag_ZF;
wire         r_ro_ld_flag_SF;
wire         r_ro_ld_flag_DF;
wire         r_ro_ld_flag_OF;
wire [31:0]  r_ro_ESP;
wire [31:0]  r_ro_addr1;
wire [31:0]  r_ro_addr2;
wire [19:0]  r_ro_seg1_limit;
wire [19:0]  r_ro_seg2_limit;
wire [31:0]  r_ro_addr1_offset;
wire [31:0]  r_ro_addr2_offset;
wire         r_ro_ISR;

//Output latches RO -> EX
wire [2:0]   r_ex_dreg1;
wire [2:0]   r_ex_dreg2;
wire [2:0]   r_ex_dreg3;
wire         r_ex_ld_reg1;
wire         r_ex_ld_reg2;
wire         r_ex_ld_reg3;
wire [3:0]   r_ex_ld_reg1_strb;
wire [3:0]   r_ex_ld_reg2_strb;
wire [3:0]   r_ex_ld_reg3_strb;
wire         r_ex_reg8_sr1_HL_sel;
wire         r_ex_reg8_sr2_HL_sel;
wire         r_ex_ld_mm;
wire [2:0]   r_ex_dmm;
wire         r_ex_ld_seg;
wire [2:0]   r_ex_dseg;
wire         r_ex_ld_mem;
wire [1:0]   r_ex_mem_rd_size;
wire [1:0]   r_ex_mem_wr_size;
wire         r_ex_eip_change;
wire         r_ex_cmps_op;
wire         r_ex_cxchg_op;
wire         r_ex_CF_needed;
wire         r_ex_DF_needed;
wire         r_ex_AF_needed;
wire         r_ex_pr_size_over;
wire [31:0]  r_ex_EIP_next;
wire [3:0]   r_ex_alu1_op;
wire         r_ex_alu2_op;
wire         r_ex_alu3_op;
wire [1:0]   r_ex_alu1_op_size;
wire         r_ex_df_val;
wire         r_ex_CF_expected;
wire         r_ex_ZF_expected;
wire         r_ex_cond_wr_CF;
wire         r_ex_cond_wr_ZF;
wire         r_ex_wr_reg1_data_sel;
wire         r_ex_wr_reg2_data_sel;
wire [1:0]   r_ex_wr_seg_data_sel;
wire         r_ex_wr_eip_alu_res_sel;
wire [1:0]   r_ex_wr_mem_data_sel;
wire         r_ex_wr_mem_addr_sel;
wire         r_ex_ld_flag_CF;
wire         r_ex_ld_flag_PF;
wire         r_ex_ld_flag_AF;
wire         r_ex_ld_flag_ZF;
wire         r_ex_ld_flag_SF;
wire         r_ex_ld_flag_DF;
wire         r_ex_ld_flag_OF;
wire [31:0]  r_ex_ESP;
wire         r_ex_ISR;
wire [31:0]  r_ex_ECX;
wire [31:0]  r_ex_EAX;
wire [31:0]  r_ex_sr1;
wire [31:0]  r_ex_sr2;
wire [63:0]  r_ex_mm_sr1;
wire [63:0]  r_ex_mm_sr2;
wire [31:0]  r_ex_mem_out;
wire [31:0]  r_ex_mem_out_latched;

//Output latches EX -> WB
wire [2:0]   r_wb_dreg1;
wire [2:0]   r_wb_dreg2;
wire [2:0]   r_wb_dreg3;
wire         r_wb_ld_reg1;
wire         r_wb_ld_reg2;
wire         r_wb_ld_reg3;
wire [3:0]   r_wb_ld_reg1_strb;
wire [3:0]   r_wb_ld_reg2_strb;
wire [3:0]   r_wb_ld_reg3_strb;
wire         r_wb_reg8_sr1_HL_sel;
wire         r_wb_reg8_sr2_HL_sel;
wire         r_wb_ld_mm;
wire [2:0]   r_wb_dmm;
wire         r_wb_ld_seg;
wire [2:0]   r_wb_dseg;
wire         r_wb_ld_mem;
wire [1:0]   r_wb_mem_wr_size;
wire         r_wb_eip_change;
wire         r_wb_cmps_op;
wire         r_wb_cxchg_op;
wire         r_wb_pr_size_over;
wire [31:0]  r_wb_EIP_next;
wire         r_wb_CF_expected;
wire         r_wb_ZF_expected;
wire         r_wb_cond_wr_CF;
wire         r_wb_cond_wr_ZF;
wire         r_wb_wr_reg1_data_sel;
wire         r_wb_wr_reg2_data_sel;
wire [1:0]   r_wb_wr_seg_data_sel;
wire         r_wb_wr_eip_alu_res_sel;
wire [1:0]   r_wb_wr_mem_data_sel;
wire         r_wb_wr_mem_addr_sel;
wire         r_wb_ld_flag_CF;
wire         r_wb_ld_flag_PF;
wire         r_wb_ld_flag_AF;
wire         r_wb_ld_flag_ZF;
wire         r_wb_ld_flag_SF;
wire         r_wb_ld_flag_DF;
wire         r_wb_ld_flag_OF;
wire [31:0]  r_wb_alu_res1;
wire [31:0]  r_wb_alu_res2;
wire [63:0]  r_wb_alu_res3;
wire [6:0]   r_wb_alu1_flags;
wire [6:0]   r_wb_cmps_flags;
wire         r_wb_df_val_ex;

//Input to fetch //Change to relavant places later 
wire        w_de_p;
wire [31:0] w_de_EIP_next;
wire [31:0] r_wb_alu_res1;
wire [31:0] r_wb_alu_res3;
wire r_wb_wr_eip_alu_res_sel;
wire r_wb_prefix_op_size_pr;

// ***************** FETCH STAGE ******************

//EIP register
wire [31:0] r_EIP;
EIP_reg u_EIP_reg (
  .clk                       (clk),
  .rst_n                     (rst_n),
  .r_wb_alu_res1             (r_wb_alu_res1),
  .r_wb_alu_res3             (r_wb_alu_res3[31:0]),
  .r_wb_wr_eip_alu_res_sel   (r_wb_wr_eip_alu_res_sel),
  .w_de_EIP_next             (w_de_EIP_next),
  .r_V_wb                    (r_V_wb),
  .r_wb_eip_change           (r_wb_eip_change),
  .r_wb_cond_wr_CF           (r_wb_cond_wr_CF),
  .r_wb_cond_wr_ZF           (r_wb_cond_wr_ZF),
  .r_wb_expected_CF          (r_wb_expected_CF),
  .r_wb_expected_ZF          (r_wb_expected_ZF),
  .r_V_de                    (r_V_de),
  .w_not_stall_fe            (w_not_stall_fe),
  .r_EIP                     (r_EIP)
);

//Output of fetch
wire [255:0] w_fe_ic_data_shifted;
wire [31:0]  w_fe_EIP_curr;
wire [15:0]  w_fe_CS_curr;
wire         w_V_de_next;

assign w_fe_EIP_curr = r_EIP;
assign w_fe_CS_curr = r_CS;

//ICACHE to/from MMU
wire          w_ic_miss;
wire [31:0]   w_ic_miss_address;
wire          w_ic_miss_ack;
wire [31:0]   w_ic_miss_ack_address;
wire [255:0]  w_ic_fill_data;

//Internal to fetch
wire [1:0]    r_fe_curr_state;
wire [1:0]    w_fe_next_state;
wire          w_fe_address_sel; 
wire [31:0]   w_fe_address;
wire [2:0]    w_fe_PFN;
wire [1:0]    w_fe_ld_buf;
wire          w_fe_ren;
wire          w_ic_hit;
wire [127:0]  w_icache_lower_data;
wire [127:0]  w_icache_upper_data;
wire [127:0]  r_icache_lower_data;
wire [127:0]  r_icache_upper_data;
wire [255:0]  w_ic_data_shifted_00;
wire [255:0]  w_ic_data_shifted_01;
wire [255:0]  w_ic_data_shifted_10;
wire [255:0]  w_ic_data_shifted_11;

wire [31:0] w_EIP_plus_32;
kogge_stone #32 u_EIP_reg_plus32 ( .a(r_EIP), .b(32'h10), .cin(1'b0), .out(w_EIP_plus_32), .vout(/*Unused*/) , .cout(/*Unused*/) ); 

//fetch_address
mux_nbit_2x1 #32 u_fe_address( .a0(w_EIP_plus_32), .a1(r_EIP), .sel(w_fe_address_sel), .out(w_fe_address));

//Logic for fe_ren
//fe_ren = !(stall_de || xx_br_stall || repne_stall || hlt_stall || dc_exp || INT || de_iret_op || block_ren)
wire [2:0] w_fe_ren_temp;
or4$ u_fe_ren_or0 (.in0(w_ro_br_stall), .in1(w_de_br_stall), .in2(w_ag_br_stall), .in3(w_ex_br_stall), .out(w_fe_ren_temp[0])); 
or4$ u_fe_ren_or1 (.in0(w_wb_br_stall), .in1(w_repne_stall), .in2(w_hlt_stall), .in3(w_de_iret_op), .out(w_fe_ren_temp[1])); 
or4$ u_fe_ren_or2 (.in0(w_block_ren), .in1(INT), .in2(w_fe_ren_temp[0]), .in3(w_fe_ren_temp[1]), .out(w_fe_ren_temp[2])); 
nor3$ u_fe_ren_nor3 (.in0(w_fe_ren_temp[2]), .in1(w_stall_de), .in2(w_dc_exp), .out(w_fe_ren)); 

//Logic for w_V_de_next
wire w_fe_next_state_not_10;
wire w_not_fe_next_state1;
inv1$ u_not_fe_next_state1(.out(w_not_fe_next_state1), .in(w_fe_next_state[1]));
nor2$ u_fe_next_state_not_10 (.out(w_fe_next_state_not_10), .in0(w_fe_next_state[0]), .in1(w_not_fe_next_state1));
and2$ u_w_V_de_next (.out(w_V_de_next), .in0(w_ic_hit), .in1(w_fe_next_state_not_10));

//Logic for ld_de;
wire w_hlt_or_repne;
or2$ u_hlt_or_repne (.out(w_hlt_or_repne), .in0(w_hlt_stall), .in1(w_repne_stall));
wire w_not_stall_fe;
nor2$ u_not_stall_fe (.out(w_not_stall_fe), .in0(w_hlt_or_repne), .in1(w_stall_de));
or2$ u_ld_de (.out(w_ld_de), .in0(w_not_stall_fe), .in1(w_dc_exp));

//Fetch FSM
fetch_fsm u_fe_fsm (
  .clk      (clk),
  .rst_n    (rst_n),
  .de_p     (w_de_p),
  .eip_4    (r_EIP[4]),
  .ic_hit   (w_ic_hit),
  .r_V_de   (r_V_de),
  .f_ld_buf   (w_fe_ld_buf),
  .f_curr_st  (r_fe_curr_state),
  .f_next_st  (w_fe_next_state),
  .f_address_sel  (w_fe_address_sel)
  );

//Fetch TLB lookup
fetch_TLB_lookup u_fe_tlb_lookup(
  .TLB({TLB[7], TLB[6], TLB[5], TLB[4], TLB[3], TLB[2], TLB[1], TLB[0]}),  
  .CS_limit     (CS_limit),
  .f_ren        (w_fe_ren),
  .f_address    (w_fe_address),  
  .f_PFN        (w_fe_PFN),
  .ic_prot_exp  (w_ic_prot_exp),
  .ic_page_fault(w_ic_page_fault)
);

or2$ u_ic_exp(.out(w_ic_exp), .in0(w_ic_prot_exp), .in1(w_ic_page_fault));

//Instruction cache
i_cache u_i_cache (
  .clk          (clk),
  .rst_n        (rst_n),
  .ren          (w_fe_ren),
  .index        (w_fe_address[8:5]),
  .tag_14_12    (w_fe_PFN),
  .tag_11_9     (w_fe_address[11:9]),
  .ic_fill_data (w_ic_fill_data),
  .ic_miss_ack  (w_ic_miss_ack),
  .ic_exp       (w_ic_exp),
  .r_data       ({w_icache_upper_data,w_icache_lower_data}),
  .ic_hit       (w_ic_hit),
  .ic_miss      (w_ic_miss),
  .ic_miss_addr (w_ic_miss_addr)
);              

//icache buf
register #128 u_icache_lower_data(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_fe_ld_buf[0]), .data_i(w_icache_lower_data), .data_o(r_icache_lower_data));
register #128 u_icache_upper_data(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_fe_ld_buf[1]), .data_i(w_icache_upper_data), .data_o(r_icache_upper_data));

//4 shifters
shift_right_rotate #32 u_ic_data_shifter_00(
  .amt(r_EIP[4:0]),
  .in({r_icache_upper_data, r_icache_lower_data}),
  .out(w_ic_data_shifted_00)
  );
shift_right_rotate #32 u_ic_data_shifter_01(
  .amt(r_EIP[4:0]),
  .in({r_icache_upper_data, w_icache_lower_data}),
  .out(w_ic_data_shifted_01)
  );
shift_right_rotate #32 u_ic_data_shifter_10(
  .amt(r_EIP[4:0]),
  .in({w_icache_upper_data, r_icache_lower_data}),
  .out(w_ic_data_shifted_10)
  );
shift_right_rotate #32 u_ic_data_shifter_11(
  .amt(r_EIP[4:0]),
  .in({w_icache_upper_data, w_icache_lower_data}),
  .out(w_ic_data_shifted_11)
  );

//Muxing between the shifters
mux_nbit_4x1 #256 u_w_fe_ic_data_shifted(.a0(w_ic_data_shifted_00), .a1(w_ic_data_shifted_01), .a2(w_ic_data_shifted_10), .a3(w_ic_data_shifted_11), .sel(w_fe_ld_buf), .out(w_fe_ic_data_shifted));


//Output of decode latches
register #256 u_de_ic_data_shifted (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_fe_ic_data_shifted), .data_o(r_de_ic_data_shifted));
register  #32 u_de_EIP_curr        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_fe_EIP_curr       ), .data_o(r_de_EIP_curr       ));
register  #16 u_de_CS_curr         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_fe_CS_curr        ), .data_o(r_de_CS_curr        ));
register   #1 u_V_de               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_V_de_next         ), .data_o(r_V_de              ));

// ***************** DECODE STAGE ******************
//Output of Decode
wire [31:0]w_de_EIP_curr;
wire [15:0]w_de_CS_curr;
wire       w_de_base_sel;
wire [1:0] w_de_disp_sel;
wire       w_de_SIB_pr;
wire [1:0] w_de_scale;
wire [31:0]w_de_imm_rel_ptr32;
wire [31:0]w_de_disp32;
wire       w_de_in1_needed;
wire       w_de_in2_needed;
wire       w_de_in3_needed;
wire       w_de_in4_needed;
wire       w_de_esp_needed;
wire       w_de_eax_needed;
wire       w_de_ecx_needed;
wire [2:0] w_de_in1;
wire [2:0] w_de_in2;
wire [2:0] w_de_in3;
wire [2:0] w_de_in4;
wire [2:0] w_de_dreg1;
wire [2:0] w_de_dreg2;
wire [2:0] w_de_dreg3;
wire       w_de_ld_reg1;
wire       w_de_ld_reg2;
wire       w_de_ld_reg3;
wire [3:0] w_de_ld_reg1_strb;
wire [3:0] w_de_ld_reg2_strb;
wire [3:0] w_de_ld_reg3_strb;
wire       w_de_reg8_sr1_HL_sel;
wire       w_de_reg8_sr2_HL_sel;
wire       w_de_mm1_needed;
wire       w_de_mm2_needed;
wire [2:0] w_de_mm1;
wire [2:0] w_de_mm2;
wire       w_de_ld_mm;
wire [2:0] w_de_dmm;
wire       w_de_mm_sr1_sel_H;
wire       w_de_mm_sr1_sel_L;
wire       w_de_mm_sr2_sel;
wire       w_de_seg1_needed;
wire       w_de_seg2_needed;
wire       w_de_seg3_needed;
wire [2:0] w_de_seg1;
wire [2:0] w_de_seg2;
wire [2:0] w_de_seg3;
wire       w_de_ld_seg;
wire [2:0] w_de_dseg;
wire       w_de_ld_mem;
wire       w_de_mem_read;
wire [1:0] w_de_mem_rd_size;
wire [1:0] w_de_mem_wr_size;
wire       w_de_mem_rd_addr_sel;
wire       w_de_eip_change;
wire       w_de_cmps_op;
wire       w_de_cxchg_op;
wire       w_de_CF_needed;
wire       w_de_DF_needed;
wire       w_de_AF_needed;
wire       w_de_pr_size_over;
wire [31:0]w_de_EIP_next;
wire [1:0] w_de_stack_off_sel;
wire [1:0] w_de_imm_sel;
wire [1:0] w_de_EIP_EFLAGS_sel;
wire [1:0] w_de_sr1_sel;
wire [1:0] w_de_sr2_sel;
wire [3:0] w_de_alu1_op;
wire       w_de_alu2_op;
wire       w_de_alu3_op;
wire [1:0] w_de_alu1_op_size;
wire       w_de_df_val;
wire       w_de_CF_expected;
wire       w_de_ZF_expected;
wire       w_de_cond_wr_CF;
wire       w_de_cond_wr_ZF;
wire       w_de_wr_reg1_data_sel;
wire       w_de_wr_reg2_data_sel;
wire [1:0] w_de_wr_seg_data_sel;
wire       w_de_wr_eip_alu_res_sel;
wire [1:0] w_de_wr_mem_data_sel;
wire       w_de_wr_mem_addr_sel;
wire       w_de_ld_flag_CF;
wire       w_de_ld_flag_PF;
wire       w_de_ld_flag_AF;
wire       w_de_ld_flag_ZF;
wire       w_de_ld_flag_SF;
wire       w_de_ld_flag_DF;
wire       w_de_ld_flag_OF;

decode u_decode ( 
      .r_de_ic_data_shifted                       (r_de_ic_data_shifted), 
      .r_de_EIP_curr                              (r_de_EIP_curr), 
      .r_de_CS_curr                               (r_de_CS_curr), 
      .de_EIP_curr                                (w_de_EIP_curr),
      .de_CS_curr                                 (w_de_CS_curr),
      .de_base_sel                                (w_de_base_sel),
      .de_disp_sel                                (w_de_disp_sel),
      .de_SIB_pr                                  (w_de_SIB_pr),
      .de_scale                                   (w_de_scale),
      .de_imm_rel_ptr32                           (w_de_imm_rel_ptr32),
      .de_disp32                                  (w_de_disp32),
      .de_in1_needed                              (w_de_in1_needed),
      .de_in2_needed                              (w_de_in2_needed),
      .de_in3_needed                              (w_de_in3_needed),
      .de_in4_needed                              (w_de_in4_needed),
      .de_esp_needed                              (w_de_esp_needed),
      .de_eax_needed                              (w_de_eax_needed),
      .de_ecx_needed                              (w_de_ecx_needed),
      .de_in1                                     (w_de_in1),
      .de_in2                                     (w_de_in2),
      .de_in3                                     (w_de_in3),
      .de_in4                                     (w_de_in4),
      .de_dreg1                                   (w_de_dreg1),
      .de_dreg2                                   (w_de_dreg2),
      .de_dreg3                                   (w_de_dreg3), 
      .de_ld_reg1                                 (w_de_ld_reg1), 
      .de_ld_reg2                                 (w_de_ld_reg2), 
      .de_ld_reg3                                 (w_de_ld_reg3), 
      .de_ld_reg1_strb                            (w_de_ld_reg1_strb), 
      .de_ld_reg2_strb                            (w_de_ld_reg2_strb), 
      .de_ld_reg3_strb                            (w_de_ld_reg3_strb), 
      .de_reg8_sr1_HL_sel                         (w_de_reg8_sr1_HL_sel), 
      .de_reg8_sr2_HL_sel                         (w_de_reg8_sr2_HL_sel), 
      .de_mm1_needed                              (w_de_mm1_needed), 
      .de_mm2_needed                              (w_de_mm2_needed), 
      .de_mm1                                     (w_de_mm1), 
      .de_mm2                                     (w_de_mm2), 
      .de_ld_mm                                   (w_de_ld_mm), 
      .de_dmm                                     (w_de_dmm), 
      .de_mm_sr1_sel_H                            (w_de_mm_sr1_sel_H), 
      .de_mm_sr1_sel_L                            (w_de_mm_sr1_sel_L), 
      .de_mm_sr2_sel                              (w_de_mm_sr2_sel), 
      .de_seg1_needed                             (w_de_seg1_needed), 
      .de_seg2_needed                             (w_de_seg2_needed), 
      .de_seg3_needed                             (w_de_seg3_needed), 
      .de_seg1                                    (w_de_seg1), 
      .de_seg2                                    (w_de_seg2), 
      .de_seg3                                    (w_de_seg3), 
      .de_ld_seg                                  (w_de_ld_seg), 
      .de_dseg                                    (w_de_dseg), 
      .de_ld_mem                                  (w_de_ld_mem), 
      .de_mem_read                                (w_de_mem_read), 
      .de_mem_rd_size                             (w_de_mem_rd_size), 
      .de_mem_wr_size                             (w_de_mem_wr_size), 
      .de_mem_rd_addr_sel                         (w_de_mem_rd_addr_sel), 
      .de_eip_change                              (w_de_eip_change), 
      .de_cmps_op                                 (w_de_cmps_op), 
      .de_cxchg_op                                (w_de_cxchg_op), 
      .de_CF_needed                               (w_de_CF_needed), 
      .de_DF_needed                               (w_de_DF_needed), 
      .de_AF_needed                               (w_de_AF_needed), 
      .de_pr_size_over                            (w_de_pr_size_over), 
      .de_EIP_next                                (w_de_EIP_next), 
      .de_stack_off_sel                           (w_de_stack_off_sel), 
      .de_imm_sel                                 (w_de_imm_sel), 
      .de_EIP_EFLAGS_sel                          (w_de_EIP_EFLAGS_sel), 
      .de_sr1_sel                                 (w_de_sr1_sel), 
      .de_sr2_sel                                 (w_de_sr2_sel), 
      .de_alu1_op                                 (w_de_alu1_op), 
      .de_alu2_op                                 (w_de_alu2_op), 
      .de_alu3_op                                 (w_de_alu3_op), 
      .de_alu1_op_size                            (w_de_alu1_op_size), 
      .de_df_val                                  (w_de_df_val), 
      .de_CF_expected                             (w_de_CF_expected), 
      .de_ZF_expected                             (w_de_ZF_expected), 
      .de_cond_wr_CF                              (w_de_cond_wr_CF), 
      .de_cond_wr_ZF                              (w_de_cond_wr_ZF), 
      .de_wr_reg1_data_sel                        (w_de_wr_reg1_data_sel), 
      .de_wr_reg2_data_sel                        (w_de_wr_reg2_data_sel), 
      .de_wr_seg_data_sel                         (w_de_wr_seg_data_sel), 
      .de_wr_eip_alu_res_sel                      (w_de_wr_eip_alu_res_sel), 
      .de_wr_mem_data_sel                         (w_de_wr_mem_data_sel), 
      .de_wr_mem_addr_sel                         (w_de_wr_mem_addr_sel), 
      .de_ld_flag_CF                              (w_de_ld_flag_CF), 
      .de_ld_flag_PF                              (w_de_ld_flag_PF), 
      .de_ld_flag_AF                              (w_de_ld_flag_AF), 
      .de_ld_flag_ZF                              (w_de_ld_flag_ZF), 
      .de_ld_flag_SF                              (w_de_ld_flag_SF), 
      .de_ld_flag_DF                              (w_de_ld_flag_DF), 
      .de_ld_flag_OF                              (w_de_ld_flag_OF));

//Decode to AG latches

register #32      u_r_ag_EIP_curr              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_EIP_curr),              .data_o(r_ag_EIP_curr));
register #16      u_r_ag_CS_curr               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_CS_curr),               .data_o(r_ag_CS_curr));
register #1       u_r_ag_base_sel              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_base_sel),              .data_o(r_ag_base_sel));
register #2       u_r_ag_disp_sel              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_disp_sel),              .data_o(r_ag_disp_sel));
register #1       u_r_ag_SIB_pr                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_SIB_pr),                .data_o(r_ag_SIB_pr));
register #2       u_r_ag_scale                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_scale),                 .data_o(r_ag_scale));
register #32      u_r_ag_imm_rel_ptr32         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_imm_rel_ptr32),         .data_o(r_ag_imm_rel_ptr32));
register #32      u_r_ag_disp32                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_disp32),                .data_o(r_ag_disp32));
register #1       u_r_ag_in1_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in1_needed),            .data_o(r_ag_in1_needed));
register #1       u_r_ag_in2_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in2_needed),            .data_o(r_ag_in2_needed));
register #1       u_r_ag_in3_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in3_needed),            .data_o(r_ag_in3_needed));
register #1       u_r_ag_in4_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in4_needed),            .data_o(r_ag_in4_needed));
register #1       u_r_ag_esp_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_esp_needed),            .data_o(r_ag_esp_needed));
register #1       u_r_ag_eax_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_eax_needed),            .data_o(r_ag_eax_needed));
register #1       u_r_ag_ecx_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ecx_needed),            .data_o(r_ag_ecx_needed));
register #3       u_r_ag_in1                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in1),                   .data_o(r_ag_in1));
register #3       u_r_ag_in2                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in2),                   .data_o(r_ag_in2));
register #3       u_r_ag_in3                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in3),                   .data_o(r_ag_in3));
register #3       u_r_ag_in4                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_in4),                   .data_o(r_ag_in4));
register #3       u_r_ag_dreg1                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_dreg1),                 .data_o(r_ag_dreg1));
register #3       u_r_ag_dreg2                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_dreg2),                 .data_o(r_ag_dreg2));
register #3       u_r_ag_dreg3                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_dreg3),                 .data_o(r_ag_dreg3));
register #1       u_r_ag_ld_reg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg1),               .data_o(r_ag_ld_reg1));
register #1       u_r_ag_ld_reg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg2),               .data_o(r_ag_ld_reg2));
register #1       u_r_ag_ld_reg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg3),               .data_o(r_ag_ld_reg3));
register #4       u_r_ag_ld_reg1_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg1_strb),          .data_o(r_ag_ld_reg1_strb));
register #4       u_r_ag_ld_reg2_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg2_strb),          .data_o(r_ag_ld_reg2_strb));
register #4       u_r_ag_ld_reg3_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_reg3_strb),          .data_o(r_ag_ld_reg3_strb));
register #1       u_r_ag_reg8_sr1_HL_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_reg8_sr1_HL_sel),       .data_o(r_ag_reg8_sr1_HL_sel));
register #1       u_r_ag_reg8_sr2_HL_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_reg8_sr2_HL_sel),       .data_o(r_ag_reg8_sr2_HL_sel));
register #1       u_r_ag_mm1_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm1_needed),            .data_o(r_ag_mm1_needed));
register #1       u_r_ag_mm2_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm2_needed),            .data_o(r_ag_mm2_needed));
register #3       u_r_ag_mm1                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm1),                   .data_o(r_ag_mm1));
register #3       u_r_ag_mm2                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm2),                   .data_o(r_ag_mm2));
register #1       u_r_ag_ld_mm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_mm),                 .data_o(r_ag_ld_mm));
register #3       u_r_ag_dmm                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_dmm),                   .data_o(r_ag_dmm));
register #1       u_r_ag_mm_sr1_sel_H          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm_sr1_sel_H),          .data_o(r_ag_mm_sr1_sel_H));
register #1       u_r_ag_mm_sr1_sel_L          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm_sr1_sel_L),          .data_o(r_ag_mm_sr1_sel_L));
register #1       u_r_ag_mm_sr2_sel            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mm_sr2_sel),            .data_o(r_ag_mm_sr2_sel));
register #1       u_r_ag_seg1_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg1_needed),           .data_o(r_ag_seg1_needed));
register #1       u_r_ag_seg2_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg2_needed),           .data_o(r_ag_seg2_needed));
register #1       u_r_ag_seg3_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg3_needed),           .data_o(r_ag_seg3_needed));
register #3       u_r_ag_seg1                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg1),                  .data_o(r_ag_seg1));
register #3       u_r_ag_seg2                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg2),                  .data_o(r_ag_seg2));
register #3       u_r_ag_seg3                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_seg3),                  .data_o(r_ag_seg3));
register #1       u_r_ag_ld_seg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_seg),                .data_o(r_ag_ld_seg));
register #3       u_r_ag_dseg                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_dseg),                  .data_o(r_ag_dseg));
register #1       u_r_ag_ld_mem                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_mem),                .data_o(r_ag_ld_mem));
register #1       u_r_ag_mem_read              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mem_read),              .data_o(r_ag_mem_read));
register #2       u_r_ag_mem_rd_size           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mem_rd_size),           .data_o(r_ag_mem_rd_size));
register #2       u_r_ag_mem_wr_size           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mem_wr_size),           .data_o(r_ag_mem_wr_size));
register #1       u_r_ag_mem_rd_addr_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_mem_rd_addr_sel),       .data_o(r_ag_mem_rd_addr_sel));
register #1       u_r_ag_eip_change            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_eip_change),            .data_o(r_ag_eip_change));
register #1       u_r_ag_cmps_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_cmps_op),               .data_o(r_ag_cmps_op));
register #1       u_r_ag_cxchg_op              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_cxchg_op),              .data_o(r_ag_cxchg_op));
register #1       u_r_ag_CF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_CF_needed),             .data_o(r_ag_CF_needed));
register #1       u_r_ag_DF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_DF_needed),             .data_o(r_ag_DF_needed));
register #1       u_r_ag_AF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_AF_needed),             .data_o(r_ag_AF_needed));
register #1       u_r_ag_pr_size_over          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_pr_size_over),          .data_o(r_ag_pr_size_over));
register #32      u_r_ag_EIP_next              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_EIP_next),              .data_o(r_ag_EIP_next));
register #2       u_r_ag_stack_off_sel         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_stack_off_sel),         .data_o(r_ag_stack_off_sel));
register #2       u_r_ag_imm_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_imm_sel),               .data_o(r_ag_imm_sel));
register #2       u_r_ag_EIP_EFLAGS_sel        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_EIP_EFLAGS_sel),        .data_o(r_ag_EIP_EFLAGS_sel));
register #2       u_r_ag_sr1_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_sr1_sel),               .data_o(r_ag_sr1_sel));
register #2       u_r_ag_sr2_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_sr2_sel),               .data_o(r_ag_sr2_sel));
register #4       u_r_ag_alu1_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_alu1_op),               .data_o(r_ag_alu1_op));
register #1       u_r_ag_alu2_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_alu2_op),               .data_o(r_ag_alu2_op));
register #1       u_r_ag_alu3_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_alu3_op),               .data_o(r_ag_alu3_op));
register #2       u_r_ag_alu1_op_size          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_alu1_op_size),          .data_o(r_ag_alu1_op_size));
register #1       u_r_ag_df_val                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_df_val),                .data_o(r_ag_df_val));
register #1       u_r_ag_CF_expected           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_CF_expected),           .data_o(r_ag_CF_expected));
register #1       u_r_ag_ZF_expected           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ZF_expected),           .data_o(r_ag_ZF_expected));
register #1       u_r_ag_cond_wr_CF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_cond_wr_CF),            .data_o(r_ag_cond_wr_CF));
register #1       u_r_ag_cond_wr_ZF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_cond_wr_ZF),            .data_o(r_ag_cond_wr_ZF));
register #1       u_r_ag_wr_reg1_data_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_reg1_data_sel),      .data_o(r_ag_wr_reg1_data_sel));
register #1       u_r_ag_wr_reg2_data_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_reg2_data_sel),      .data_o(r_ag_wr_reg2_data_sel));
register #2       u_r_ag_wr_seg_data_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_seg_data_sel),       .data_o(r_ag_wr_seg_data_sel));
register #1       u_r_ag_wr_eip_alu_res_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_eip_alu_res_sel),    .data_o(r_ag_wr_eip_alu_res_sel));
register #2       u_r_ag_wr_mem_data_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_mem_data_sel),       .data_o(r_ag_wr_mem_data_sel));
register #1       u_r_ag_wr_mem_addr_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_wr_mem_addr_sel),       .data_o(r_ag_wr_mem_addr_sel));
register #1       u_r_ag_ld_flag_CF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_CF),            .data_o(r_ag_ld_flag_CF));
register #1       u_r_ag_ld_flag_PF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_PF),            .data_o(r_ag_ld_flag_PF));
register #1       u_r_ag_ld_flag_AF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_AF),            .data_o(r_ag_ld_flag_AF));
register #1       u_r_ag_ld_flag_ZF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_ZF),            .data_o(r_ag_ld_flag_ZF));
register #1       u_r_ag_ld_flag_SF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_SF),            .data_o(r_ag_ld_flag_SF));
register #1       u_r_ag_ld_flag_DF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_DF),            .data_o(r_ag_ld_flag_DF));
register #1       u_r_ag_ld_flag_OF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ag), .data_i(w_de_ld_flag_OF),            .data_o(r_ag_ld_flag_OF));

// ***************** ADDRESS GEN STAGE ******************

//Just getting passed to RO:
register #32        u_r_ro_EIP_curr            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_EIP_curr),              .data_o(r_ro_EIP_curr));
register #16        u_r_ro_CS_curr             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_CS_curr),               .data_o(r_ro_CS_curr));
register #1         u_r_ro_in3_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_in3_needed),            .data_o(r_ro_in3_needed));
register #1         u_r_ro_in4_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_in4_needed),            .data_o(r_ro_in4_needed));
register #1         u_r_ro_eax_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_eax_needed),            .data_o(r_ro_eax_needed));
register #1         u_r_ro_ecx_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ecx_needed),            .data_o(r_ro_ecx_needed));
register #3         u_r_ro_in3                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_in3),                   .data_o(r_ro_in3));
register #3         u_r_ro_in4                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_in4),                   .data_o(r_ro_in4));
register #3         u_r_ro_dreg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_dreg1),                 .data_o(r_ro_dreg1));
register #3         u_r_ro_dreg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_dreg2),                 .data_o(r_ro_dreg2));
register #3         u_r_ro_dreg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_dreg3),                 .data_o(r_ro_dreg3));
register #1         u_r_ro_ld_reg1             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg1),               .data_o(r_ro_ld_reg1));
register #1         u_r_ro_ld_reg2             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg2),               .data_o(r_ro_ld_reg2));
register #1         u_r_ro_ld_reg3             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg3),               .data_o(r_ro_ld_reg3));
register #4         u_r_ro_ld_reg1_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg1_strb),          .data_o(r_ro_ld_reg1_strb));
register #4         u_r_ro_ld_reg2_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg2_strb),          .data_o(r_ro_ld_reg2_strb));
register #4         u_r_ro_ld_reg3_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_reg3_strb),          .data_o(r_ro_ld_reg3_strb));
register #1         u_r_ro_reg8_sr1_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_reg8_sr1_HL_sel),       .data_o(r_ro_reg8_sr1_HL_sel));
register #1         u_r_ro_reg8_sr2_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_reg8_sr2_HL_sel),       .data_o(r_ro_reg8_sr2_HL_sel));
register #1         u_r_ro_mm1_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm1_needed),            .data_o(r_ro_mm1_needed));
register #1         u_r_ro_mm2_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm2_needed),            .data_o(r_ro_mm2_needed));
register #3         u_r_ro_mm1                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm1),                   .data_o(r_ro_mm1));
register #3         u_r_ro_mm2                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm2),                   .data_o(r_ro_mm2));
register #1         u_r_ro_ld_mm               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_mm),                 .data_o(r_ro_ld_mm));
register #3         u_r_ro_dmm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_dmm),                   .data_o(r_ro_dmm));
register #1         u_r_ro_mm_sr1_sel_H        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm_sr1_sel_H),          .data_o(r_ro_mm_sr1_sel_H));
register #1         u_r_ro_mm_sr1_sel_L        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm_sr1_sel_L),          .data_o(r_ro_mm_sr1_sel_L));
register #1         u_r_ro_mm_sr2_sel          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mm_sr2_sel),            .data_o(r_ro_mm_sr2_sel));
register #1         u_r_ro_seg3_needed         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_seg3_needed),           .data_o(r_ro_seg3_needed));
register #3         u_r_ro_seg3                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_seg3),                  .data_o(r_ro_seg3));
register #1         u_r_ro_ld_seg              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_seg),                .data_o(r_ro_ld_seg));
register #3         u_r_ro_dseg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_dseg),                  .data_o(r_ro_dseg));
register #1         u_r_ro_ld_mem              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_mem),                .data_o(r_ro_ld_mem));
register #1         u_r_ro_mem_read            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mem_read),              .data_o(r_ro_mem_read));
register #2         u_r_ro_mem_rd_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mem_rd_size),           .data_o(r_ro_mem_rd_size));
register #2         u_r_ro_mem_wr_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mem_wr_size),           .data_o(r_ro_mem_wr_size));
register #1         u_r_ro_mem_rd_addr_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_mem_rd_addr_sel),       .data_o(r_ro_mem_rd_addr_sel));
register #1         u_r_ro_eip_change          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_eip_change),            .data_o(r_ro_eip_change));
register #1         u_r_ro_cmps_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_cmps_op),               .data_o(r_ro_cmps_op));
register #1         u_r_ro_cxchg_op            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_cxchg_op),              .data_o(r_ro_cxchg_op));
register #1         u_r_ro_CF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_CF_needed),             .data_o(r_ro_CF_needed));
register #1         u_r_ro_DF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_DF_needed),             .data_o(r_ro_DF_needed));
register #1         u_r_ro_AF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_AF_needed),             .data_o(r_ro_AF_needed));
register #1         u_r_ro_pr_size_over        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_pr_size_over),          .data_o(r_ro_pr_size_over));
register #32        u_r_ro_EIP_next            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_EIP_next),              .data_o(r_ro_EIP_next));
register #2         u_r_ro_imm_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_imm_sel),               .data_o(r_ro_imm_sel));
register #2         u_r_ro_EIP_EFLAGS_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_EIP_EFLAGS_sel),        .data_o(r_ro_EIP_EFLAGS_sel));
register #2         u_r_ro_sr1_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_sr1_sel),               .data_o(r_ro_sr1_sel));
register #2         u_r_ro_sr2_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_sr2_sel),               .data_o(r_ro_sr2_sel));
register #4         u_r_ro_alu1_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_alu1_op),               .data_o(r_ro_alu1_op));
register #1         u_r_ro_alu2_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_alu2_op),               .data_o(r_ro_alu2_op));
register #1         u_r_ro_alu3_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_alu3_op),               .data_o(r_ro_alu3_op));
register #2         u_r_ro_alu1_op_size        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_alu1_op_size),          .data_o(r_ro_alu1_op_size));
register #1         u_r_ro_df_val              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_df_val),                .data_o(r_ro_df_val));
register #1         u_r_ro_CF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_CF_expected),           .data_o(r_ro_CF_expected));
register #1         u_r_ro_ZF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ZF_expected),           .data_o(r_ro_ZF_expected));
register #1         u_r_ro_cond_wr_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_cond_wr_CF),            .data_o(r_ro_cond_wr_CF));
register #1         u_r_ro_cond_wr_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_cond_wr_ZF),            .data_o(r_ro_cond_wr_ZF));
register #1         u_r_ro_wr_reg1_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_reg1_data_sel),      .data_o(r_ro_wr_reg1_data_sel));
register #1         u_r_ro_wr_reg2_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_reg2_data_sel),      .data_o(r_ro_wr_reg2_data_sel));
register #2         u_r_ro_wr_seg_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_seg_data_sel),       .data_o(r_ro_wr_seg_data_sel));
register #1         u_r_ro_wr_eip_alu_res_sel  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_eip_alu_res_sel),    .data_o(r_ro_wr_eip_alu_res_sel));
register #2         u_r_ro_wr_mem_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_mem_data_sel),       .data_o(r_ro_wr_mem_data_sel));
register #1         u_r_ro_wr_mem_addr_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_wr_mem_addr_sel),       .data_o(r_ro_wr_mem_addr_sel));
register #1         u_r_ro_ld_flag_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_CF),            .data_o(r_ro_ld_flag_CF));
register #1         u_r_ro_ld_flag_PF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_PF),            .data_o(r_ro_ld_flag_PF));
register #1         u_r_ro_ld_flag_AF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_AF),            .data_o(r_ro_ld_flag_AF));
register #1         u_r_ro_ld_flag_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_ZF),            .data_o(r_ro_ld_flag_ZF));
register #1         u_r_ro_ld_flag_SF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_SF),            .data_o(r_ro_ld_flag_SF));
register #1         u_r_ro_ld_flag_DF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_DF),            .data_o(r_ro_ld_flag_DF));
register #1         u_r_ro_ld_flag_OF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_lo_ro), .data_i(r_ag_ld_flag_OF),            .data_o(r_ro_ld_flag_OF));


//Register file
wire [31:0] r_ag_reg_out1;
wire [31:0] r_ag_reg_out2;
wire [31:0] r_ro_reg_out3;
wire [31:0] r_ro_reg_out4;

regfile u_regfile (
  .clk             (clk),
  .rst_n           (rst_n),
  .wr_en1          (w_v_wb_ld_reg1),
  .wr_en2          (w_v_wb_ld_reg2),
  .wr_en3          (w_v_wb_ld_reg3),
  .wr_reg1         (r_wb_dreg1),
  .wr_reg2         (r_wb_dreg2),
  .wr_reg3         (r_wb_dreg3),
  .wr_strb1        (w_v_wb_ld_reg1_strb),
  .wr_strb2        (w_v_wb_ld_reg2_strb),
  .wr_strb3        (w_v_wb_ld_reg3_strb),
  .wr_data1        (w_wb_wr_reg_data1),
  .wr_data2        (w_wb_wr_reg_data2),
  .wr_data3        (w_wb_wr_reg_data3),
  .in1             (r_ag_in1),
  .in2             (r_ag_in2),
  .in3             (r_ro_in3),
  .in4             (r_ro_in4),
  .r_reg_data1     (r_ag_reg_out1),
  .r_reg_data2     (r_ag_reg_out2),
  .r_reg_data3     (r_ro_reg_out3),
  .r_reg_data4     (r_ro_reg_out4)
);

//MMX regfile
wire [63:0] r_ro_mm_data1;
wire [63:0] r_ro_mm_data2;

mmx_regfile u_mmx_regfile (
  .clk        (clk),
  .rst_n      (rst_n),
  .wr_en      (w_v_wb_ld_mm),
  .wr_reg     (r_wb_dmm),
  .wr_data    (r_wb_alu_res3),
  .mm1        (r_ro_mm1),
  .mm2        (r_ro_mm2),
  .r_mm_data1 (r_ro_mm_data1),
  .r_mm_data2 (r_ro_mm_data2)
);

//SEG register file
wire [15:0] r_ag_seg_data1;
wire [15:0] r_ag_seg_data2;
wire [15:0] r_ag_seg_data3;

seg_regfile u_seg_regfile(
  .clk            (clk),
  .rst_n          (rst_n),
  .wr_en          (w_v_wb_ld_seg),
  .wr_reg         (r_wb_dseg),
  .wr_data        (w_wb_wr_seg_data),
  .seg1           (r_ag_seg1),
  .seg2           (r_ag_seg2),
  .seg3           (r_ro_seg3),
  .r_seg_data1    (r_ag_seg_data1),
  .r_seg_data2    (r_ag_seg_data2),
  .r_seg_data3    (r_ag_seg_data3)
);



endmodule

