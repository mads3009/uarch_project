module cpu (
  input         clk,
  input         rst_n,
  //int
  input         int,
  output        int_clear,
  //MMU in/out ports
  output        m_cyc,
  output        m_we,
  output [3:0]  m_strb,
  output [31:0] m_addr,
  output [31:0] m_data_o,
  input         m_ack,
  input  [31:0] m_data_i
);

// ********** Hardcoded entries ***********
//TLB entries
reg [43:0] TLB[7:0]; 

//Segment_limit_Regs (In their order)
reg [19:0] ES_limit;
reg [19:0] CS_limit;
reg [19:0] SS_limit;
reg [19:0] DS_limit;
reg [19:0] FS_limit;
reg [19:0] GS_limit;

//EFlags
wire  [31:0] r_EFLAGS;
localparam CF=4'd0;
localparam PF=4'd2;
localparam AF=4'd4;
localparam ZF=4'd6;
localparam SF=4'd7;
localparam DF=4'd10;
localparam OF=4'd11;

//Loads and Valids of pipeline latches
wire w_V_de_next;
wire w_V_ag_next;
wire w_V_ro_next;
wire w_V_ex_next;
wire w_V_wb_next;
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
wire w_stall_ag;
wire w_stall_ro;
wire w_stall_ex;
wire w_de_dep_stall;
wire w_hlt_stall;
wire w_repne_stall;
wire w_de_iret_op;
wire w_de_br_stall;
wire w_ag_br_stall;
wire w_ro_br_stall;
wire w_ex_br_stall;
wire w_wb_br_stall;

wire w_v_ex_ld_mem;
wire w_mem_rd_busy;
wire w_ro_cmps_stall;
wire w_wb_mem_stall;

//Writeback's internal signals for writeback
wire [31:0] w_wb_wr_reg_data1;
wire [31:0] w_wb_wr_reg_data2;
wire [31:0] w_wb_wr_reg_data3;
wire [15:0] w_wb_wr_seg_data;
wire [3:0] w_v_wb_ld_reg1_strb;
wire [3:0] w_v_wb_ld_reg2_strb;
wire [3:0] w_v_wb_ld_reg3_strb;
wire [63:0] w_wb_mem_wr_data;
wire [31:0] w_wb_mem_wr_addr;
wire w_v_wb_ld_reg1;
wire w_v_wb_ld_reg2;
wire w_v_wb_ld_reg3;
wire w_v_wb_ld_mm;
wire w_v_wb_ld_seg;
wire w_v_wb_ld_mem;

//Write FIFO
wire w_fifo_full_bar;
wire w_fifo_empty_bar;
wire w_fifo_full;
wire w_fifo_empty;
wire [2:0] w_fifo_cnt;
wire w_fifo_to_be_full;
wire [31:0] w_fifo_mem_wr_addr_end;

//Interrupts and Exceptions
wire w_dc_exp;
wire w_ic_exp;
wire w_ic_prot_exp;
wire w_ic_page_fault;
wire w_block_ic_ren;
wire [31:0] w_IDT_address;

//Register files related
wire [31:0] w_ag_ESP;
wire [31:0] w_ro_ECX;
wire [31:0] w_ro_EAX;
wire [15:0] r_ag_seg_data1;
wire [15:0] r_ag_seg_data2;
wire [15:0] r_ro_seg_data3;

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
wire       r_ag_EIP_EFLAGS_sel;
wire [1:0] r_ag_sr1_sel;
wire [1:0] r_ag_sr2_sel;
wire [3:0] r_ag_alu1_op;
wire [3:0] r_ag_alu2_op;
wire [4:0] r_ag_alu3_op;
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
wire [15:0]r_ag_ptr_CS;

//Special ROM signals
wire        w_rseq_mux_sel;
wire [31:0] w_EIP_saved;
wire [15:0] w_CS_saved;
wire [2:0]  w_rseq_addr; 
wire [127:0]w_rseq_data; 

//OUTPUTS of SPECIAL ROM
wire       w_rseq_end_bit;
wire       w_rseq_V;
wire       w_rseq_IDT_address_sel;
wire       w_rseq_base_sel;
wire [1:0] w_rseq_disp_sel;
wire       w_rseq_SIB_pr;
wire [1:0] w_rseq_scale;
wire       w_rseq_in1_needed;
wire       w_rseq_in2_needed;
wire       w_rseq_in3_needed;
wire       w_rseq_in4_needed;
wire       w_rseq_esp_needed;
wire       w_rseq_eax_needed;
wire       w_rseq_ecx_needed;
wire [2:0] w_rseq_in1;
wire [2:0] w_rseq_in2;
wire [2:0] w_rseq_in3;
wire [2:0] w_rseq_in4;
wire [2:0] w_rseq_dreg1;
wire [2:0] w_rseq_dreg2;
wire [2:0] w_rseq_dreg3;
wire       w_rseq_ld_reg1;
wire       w_rseq_ld_reg2;
wire       w_rseq_ld_reg3;
wire [3:0] w_rseq_ld_reg1_strb;
wire [3:0] w_rseq_ld_reg2_strb;
wire [3:0] w_rseq_ld_reg3_strb;
wire       w_rseq_reg8_sr1_HL_sel;
wire       w_rseq_reg8_sr2_HL_sel;
wire       w_rseq_mm1_needed;
wire       w_rseq_mm2_needed;
wire [2:0] w_rseq_mm1;
wire [2:0] w_rseq_mm2;
wire       w_rseq_ld_mm;
wire [2:0] w_rseq_dmm;
wire       w_rseq_mm_sr1_sel_H;
wire       w_rseq_mm_sr1_sel_L;
wire       w_rseq_mm_sr2_sel;
wire       w_rseq_seg1_needed;
wire       w_rseq_seg2_needed;
wire       w_rseq_seg3_needed;
wire [2:0] w_rseq_seg1;
wire [2:0] w_rseq_seg2;
wire [2:0] w_rseq_seg3;
wire       w_rseq_ld_seg;
wire [2:0] w_rseq_dseg;
wire       w_rseq_ld_mem;
wire       w_rseq_mem_read;
wire [1:0] w_rseq_mem_rd_size;
wire [1:0] w_rseq_mem_wr_size;
wire       w_rseq_mem_rd_addr_sel;
wire       w_rseq_eip_change;
wire       w_rseq_cmps_op;
wire       w_rseq_cxchg_op;
wire       w_rseq_CF_needed;
wire       w_rseq_DF_needed;
wire       w_rseq_AF_needed;
wire       w_rseq_pr_size_over;
wire [1:0] w_rseq_stack_off_sel;
wire [1:0] w_rseq_imm_sel;
wire       w_rseq_EIP_EFLAGS_sel;
wire [1:0] w_rseq_sr1_sel;
wire [1:0] w_rseq_sr2_sel;
wire [3:0] w_rseq_alu1_op;
wire [3:0] w_rseq_alu2_op;
wire [4:0] w_rseq_alu3_op;
wire [1:0] w_rseq_alu1_op_size;
wire       w_rseq_df_val;
wire       w_rseq_CF_expected;
wire       w_rseq_ZF_expected;
wire       w_rseq_cond_wr_CF;
wire       w_rseq_cond_wr_ZF;
wire       w_rseq_wr_reg1_data_sel;
wire       w_rseq_wr_reg2_data_sel;
wire [1:0] w_rseq_wr_seg_data_sel;
wire       w_rseq_wr_eip_alu_res_sel;
wire [1:0] w_rseq_wr_mem_data_sel;
wire       w_rseq_wr_mem_addr_sel;
wire       w_rseq_ld_flag_CF;
wire       w_rseq_ld_flag_PF;
wire       w_rseq_ld_flag_AF;
wire       w_rseq_ld_flag_ZF;
wire       w_rseq_ld_flag_SF;
wire       w_rseq_ld_flag_DF;
wire       w_rseq_ld_flag_OF;

//Output latches AG -> RO
wire [31:0]  r_ro_EIP_curr;
wire [15:0]  r_ro_CS_curr;
wire [31:0]  r_ro_imm_rel_ptr32;
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
wire         r_ro_EIP_EFLAGS_sel;
wire [1:0]   r_ro_sr1_sel;
wire [1:0]   r_ro_sr2_sel;
wire [3:0]   r_ro_alu1_op;
wire [3:0]   r_ro_alu2_op;
wire [4:0]   r_ro_alu3_op;
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
wire [15:0]  r_ro_ptr_CS;
wire [31:0]  r_ro_ESP;
wire [31:0]  r_ro_addr1;
wire [31:0]  r_ro_addr2;
wire [31:0]  r_ro_addr1_end_rd;
wire [31:0]  r_ro_addr2_end_rd;
wire [31:0]  r_ro_addr1_end_wr;
wire [31:0]  r_ro_addr2_end_wr;
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
wire [1:0]   r_ex_imm_sel;
wire [31:0]  r_ex_EIP_next;
wire [3:0]   r_ex_alu1_op;
wire [3:0]   r_ex_alu2_op;
wire [4:0]   r_ex_alu3_op;
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
wire         r_ex_ld_flag_CF;
wire         r_ex_ld_flag_PF;
wire         r_ex_ld_flag_AF;
wire         r_ex_ld_flag_ZF;
wire         r_ex_ld_flag_SF;
wire         r_ex_ld_flag_DF;
wire         r_ex_ld_flag_OF;
wire [15:0]  r_ex_ptr_CS;
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
wire [31:0]  r_ex_mem_wr_addr;
wire [31:0]  r_ex_mem_wr_addr_end;

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
wire         r_wb_ld_flag_CF;
wire         r_wb_ld_flag_PF;
wire         r_wb_ld_flag_AF;
wire         r_wb_ld_flag_ZF;
wire         r_wb_ld_flag_SF;
wire         r_wb_ld_flag_DF;
wire         r_wb_ld_flag_OF;
wire [15:0]  r_wb_ptr_CS;
wire [31:0]  r_wb_mem_wr_addr;
wire [31:0]  r_wb_mem_wr_addr_end;
wire [31:0]  r_wb_alu_res1;
wire [31:0]  r_wb_alu_res2;
wire [63:0]  r_wb_alu_res3;
wire [5:0]   r_wb_alu1_flags;
wire [5:0]   r_wb_cmps_flags;
wire         r_wb_df_val_ex;

//Input to fetch //Change to relavant places later 
wire        w_de_p;
wire [31:0] w_de_EIP_next;

// ***************** FETCH STAGE ******************

wire w_hlt_or_repne;
wire w_not_stall_fe;
wire w_repne_and_int;

//EIP register
wire [31:0] r_EIP;
EIP_reg u_EIP_reg (
  .clk                       (clk),
  .rst_n                     (rst_n),
  .r_wb_alu_res1             (r_wb_alu_res1),
  .r_wb_alu_res3             (r_wb_alu_res3[31:0]),
  .r_wb_wr_eip_alu_res_sel   (r_wb_wr_eip_alu_res_sel),
  .w_de_EIP_next             (w_de_EIP_next),
  .r_wb_EIP_next             (r_wb_EIP_next),
  .r_V_wb                    (r_V_wb),
  .r_wb_eip_change           (r_wb_eip_change),
  .r_wb_cond_wr_CF           (r_wb_cond_wr_CF),
  .r_wb_cond_wr_ZF           (r_wb_cond_wr_ZF),
  .r_V_de                    (r_V_de),
  .w_de_br_stall             (w_de_br_stall),
  .w_not_stall_fe            (w_not_stall_fe),
  .r_wb_pr_size_over         (r_wb_pr_size_over),
  .w_wb_flag_ZF              (r_EFLAGS[ZF]),
  .w_wb_flag_CF              (r_EFLAGS[CF]),
  .r_wb_ZF_expected          (r_wb_ZF_expected),
  .r_wb_CF_expected          (r_wb_CF_expected),

  .r_EIP                     (r_EIP)
);

//Output of fetch
wire [255:0] w_fe_ic_data_shifted;
wire [31:0]  w_fe_EIP_curr;
wire [15:0]  w_fe_CS_curr;

//ICACHE to/from MMU
wire          w_ic_miss;
wire [31:0]   w_ic_miss_addr;
wire          w_ic_miss_ack;
wire [255:0]  w_ic_data_fill;

//Internal to fetch
wire [2:0]    r_fe_curr_state;
wire [2:0]    w_fe_next_state;
wire          w_fe_address_sel; 
wire [31:0]   w_fe_address;
wire [31:0]   w_fe_address_off;
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
wire [15:0]   r_CS;
wire          w_fe_nextstate_01_11;

//Passing outputs
assign w_fe_EIP_curr = r_EIP;
assign w_fe_CS_curr = r_CS;

wire [31:0] w_EIP_plus_32;
kogge_stone #32 u_EIP_reg_plus32 ( .a(r_EIP), .b(32'h20), .cin(1'b0), .out(w_EIP_plus_32), .vout(/*Unused*/) , .cout(/*Unused*/) ); 

//fetch_address
mux_nbit_2x1 #32 u_fe_address_off(  .a0(r_EIP), .a1(w_EIP_plus_32), .sel(w_fe_address_sel), .out(w_fe_address_off));
cond_sum32  u_fe_address ( .A(w_fe_address_off), .B({r_CS,16'h0}), .CIN(1'b0), .S(w_fe_address), .COUT(/*Unused*/) );

//Logic for fe_ren
//fe_ren = !(stall_de || xx_br_stall || repne_stall || hlt_stall || dc_exp || int || de_iret_op || block_ren)
wire [2:0] w_fe_ren_temp;
or4$ u_fe_ren_or0 (.in0(w_ro_br_stall), .in1(w_de_br_stall), .in2(w_ag_br_stall), .in3(w_ex_br_stall), .out(w_fe_ren_temp[0])); 
or4$ u_fe_ren_or1 (.in0(w_wb_br_stall), .in1(w_repne_stall), .in2(w_hlt_stall), .in3(w_de_iret_op), .out(w_fe_ren_temp[1])); 
or4$ u_fe_ren_or2 (.in0(w_block_ic_ren), .in1(int), .in2(w_fe_ren_temp[0]), .in3(w_fe_ren_temp[1]), .out(w_fe_ren_temp[2])); 
nor3$ u_fe_ren_nor3 (.in0(w_fe_ren_temp[2]), .in1(w_stall_de), .in2(w_dc_exp), .out(w_fe_ren)); 

//Logic for fe_ren_to_use
wire w_fe_ren_to_use;
mux2$ u_w_fe_ren_to_use(.outb(w_fe_ren_to_use),.in0(w_fe_ren),.in1(w_ic_miss),.s0(r_fe_ren));
dff$  u_r_fe_ren(.r(rst_n),.s(1'b1),.clk(clk),.d(w_fe_ren_to_use),.q(r_fe_ren),.qbar(/*Unused*/));

//Logic for w_V_de_next
//wire w_fe_next_state_not_10;
//wire w_not_fe_next_state0;
//inv1$ u_not_fe_next_state1(.out(w_not_fe_next_state0), .in(w_fe_next_state[0]));
//nand2$ u_fe_next_state_not_10 (.out(w_fe_next_state_not_10), .in0(w_fe_next_state[1]), .in1(w_not_fe_next_state0));
//and2$ u_w_V_de_next (.out(w_V_de_next), .in0(w_ic_hit), .in1(w_fe_next_state_not_10));
assign w_V_de_next = w_fe_nextstate_01_11;

//Logic for ld_de;
and2$ u_w_repne_and_int (.out(w_repne_and_int), .in0(w_repne_stall), .in1(int));
or2$ u_hlt_or_repne (.out(w_hlt_or_repne), .in0(w_hlt_stall), .in1(w_repne_stall));
nor3$ u_not_stall_fe (.out(w_not_stall_fe), .in0(w_hlt_or_repne), .in1(w_stall_de), .in2(w_de_dep_stall));
or3$ u_ld_de (.out(w_ld_de), .in0(w_not_stall_fe), .in1(w_dc_exp), .in2(w_repne_and_int));

//Fetch FSM
fetch_fsm u_fe_fsm (
  .clk      (clk),
  .rst_n    (rst_n),
  .de_p     (w_de_EIP_next[4]),
  .eip_4    (r_EIP[4]),
  .ic_hit   (w_ic_hit),
  .r_V_de   (r_V_de),
  .int(int),
  .ic_exp(w_ic_exp),
  .dc_exp(w_dc_exp),
  .de_br_stall(w_de_br_stall),
  .f_ld_buf   (w_fe_ld_buf),
  .f_curr_st  (r_fe_curr_state),
  .f_next_st  (w_fe_next_state),
  .f_address_sel  (w_fe_address_sel),
  .f_nextstate_01_11 (w_fe_nextstate_01_11)
  );

//Fetch TLB lookup
fetch_TLB_lookup u_fe_tlb_lookup(
  .TLB({TLB[7], TLB[6], TLB[5], TLB[4], TLB[3], TLB[2], TLB[1], TLB[0]}),  
  .CS_limit     (CS_limit),
  .f_ren        (w_fe_ren_to_use),
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
  .ren          (w_fe_ren_to_use),
  .index        (w_fe_address_off[8:5]),
  .tag_14_12    (w_fe_PFN),
  .tag_11_9     (w_fe_address_off[11:9]),
  .ic_fill_data (w_ic_data_fill),
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

wire [31:0] w_EIP_to_use;
mux_nbit_2x1 #32 u_w_EIP_to_use (.a0(r_EIP[31:0]), .a1(w_de_EIP_next[31:0]), .sel(r_V_de), .out(w_EIP_to_use));

//4 shifters
byte_rotate_right #32 u_ic_data_shifter_00(
  .amt(w_EIP_to_use[4:0]),
  .in({r_icache_upper_data, r_icache_lower_data}),
  .out(w_ic_data_shifted_00)
  );
byte_rotate_right #32 u_ic_data_shifter_01(
  .amt(w_EIP_to_use[4:0]),
  .in({r_icache_upper_data, w_icache_lower_data}),
  .out(w_ic_data_shifted_01)
  );
byte_rotate_right #32 u_ic_data_shifter_10(
  .amt(w_EIP_to_use[4:0]),
  .in({w_icache_upper_data, r_icache_lower_data}),
  .out(w_ic_data_shifted_10)
  );
byte_rotate_right #32 u_ic_data_shifter_11(
  .amt(w_EIP_to_use[4:0]),
  .in({w_icache_upper_data, w_icache_lower_data}),
  .out(w_ic_data_shifted_11)
  );

//Muxing between the shifters
mux_nbit_4x1 #256 u_w_fe_ic_data_shifted(.a0(w_ic_data_shifted_00), .a1(w_ic_data_shifted_01), .a2(w_ic_data_shifted_10), .a3(w_ic_data_shifted_11), .sel(w_fe_ld_buf), .out(w_fe_ic_data_shifted));


//Output of decode latches
register #256 u_de_ic_data_shifted (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_fe_ic_data_shifted), .data_o(r_de_ic_data_shifted));
register  #32 u_de_EIP_curr        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_de), .data_i(w_EIP_to_use        ), .data_o(r_de_EIP_curr       ));
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
wire [1:0] w_de_stack_off_sel;
wire [1:0] w_de_imm_sel;
wire       w_de_EIP_EFLAGS_sel;
wire [1:0] w_de_sr1_sel;
wire [1:0] w_de_sr2_sel;
wire [3:0] w_de_alu1_op;
wire [3:0] w_de_alu2_op;
wire [4:0] w_de_alu3_op;
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
wire [15:0]w_de_ptr_CS;

//Other decode signals for dependency
wire w_de_repne;
wire w_de_hlt;
wire w_de_iret;

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
      .de_ld_flag_OF                              (w_de_ld_flag_OF),
      .de_repne                                   (w_de_repne),
      .de_hlt                                     (w_de_hlt),
      .de_iret                                    (w_de_iret),
      .de_ptr_CS                                  (w_de_ptr_CS));

//Decode dep,V,ld logic

de_dep_v_ld_logic u_de_dep_v_ld_logic(
  .clk                (clk),
  .rst_n              (rst_n),
  .V_de               (r_V_de),
  .repne              (w_de_repne),
  .hlt                (w_de_hlt),
  .iret               (w_de_iret),
  .eip_change         (w_de_eip_change),
  .ECX                (w_ro_ECX),
  .ZF                 (r_EFLAGS[ZF]),
  .ag_dreg1           (r_ag_dreg1),
  .ag_dreg2           (r_ag_dreg2),
  .ag_dreg3           (r_ag_dreg3),
  .v_ag_ld_reg1       (w_v_ag_ld_reg1),
  .v_ag_ld_reg2       (w_v_ag_ld_reg2),
  .v_ag_ld_reg3       (w_v_ag_ld_reg3),
  .v_ag_ld_flag_ZF    (w_v_ag_ld_flag_ZF),
  .ro_dreg1           (r_ro_dreg1),
  .ro_dreg2           (r_ro_dreg2),
  .ro_dreg3           (r_ro_dreg3),
  .v_ro_ld_reg1       (w_v_ro_ld_reg1),
  .v_ro_ld_reg2       (w_v_ro_ld_reg2),
  .v_ro_ld_reg3       (w_v_ro_ld_reg3),
  .v_ro_ld_flag_ZF    (w_v_ro_ld_flag_ZF),
  .ex_dreg1           (r_ex_dreg1),
  .ex_dreg2           (r_ex_dreg2),
  .ex_dreg3           (r_ex_dreg3),
  .v_ex_ld_reg1       (w_v_ex_ld_reg1),
  .v_ex_ld_reg2       (w_v_ex_ld_reg2),
  .v_ex_ld_reg3       (w_v_ex_ld_reg3),
  .v_ex_ld_flag_ZF    (w_v_ex_ld_flag_ZF),
  .wb_dreg1           (r_wb_dreg1),
  .wb_dreg2           (r_wb_dreg2),
  .wb_dreg3           (r_wb_dreg3),
  .v_wb_ld_reg1       (w_v_wb_ld_reg1),
  .v_wb_ld_reg2       (w_v_wb_ld_reg2),
  .v_wb_ld_reg3       (w_v_wb_ld_reg3),
  .v_wb_ld_flag_ZF    (w_v_wb_ld_flag_ZF),
  .stall_ag           (w_stall_ag),
  .ag_dep_stall       (w_ag_dep_stall),
  .dc_exp             (w_dc_exp),

  .hlt_stall          (w_hlt_stall),
  .repne_stall        (w_repne_stall),
  .iret_op            (w_de_iret_op),
  .dep_stall          (w_de_dep_stall),
  .br_stall           (w_de_br_stall),
  .stall_de           (w_stall_de),
  .V_ag               (w_V_ag_next),
  .ld_ag              (w_ld_ag)
);

//Decode to AG latches

register #32      u_r_ag_EIP_curr              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_EIP_curr),              .data_o(r_ag_EIP_curr));
register #16      u_r_ag_CS_curr               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_CS_curr),               .data_o(r_ag_CS_curr));
register #1       u_r_ag_base_sel              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_base_sel),              .data_o(r_ag_base_sel));
register #2       u_r_ag_disp_sel              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_disp_sel),              .data_o(r_ag_disp_sel));
register #1       u_r_ag_SIB_pr                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_SIB_pr),                .data_o(r_ag_SIB_pr));
register #2       u_r_ag_scale                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_scale),                 .data_o(r_ag_scale));
register #32      u_r_ag_imm_rel_ptr32         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_imm_rel_ptr32),         .data_o(r_ag_imm_rel_ptr32));
register #32      u_r_ag_disp32                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_disp32),                .data_o(r_ag_disp32));
register #1       u_r_ag_in1_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in1_needed),            .data_o(r_ag_in1_needed));
register #1       u_r_ag_in2_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in2_needed),            .data_o(r_ag_in2_needed));
register #1       u_r_ag_in3_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in3_needed),            .data_o(r_ag_in3_needed));
register #1       u_r_ag_in4_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in4_needed),            .data_o(r_ag_in4_needed));
register #1       u_r_ag_esp_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_esp_needed),            .data_o(r_ag_esp_needed));
register #1       u_r_ag_eax_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_eax_needed),            .data_o(r_ag_eax_needed));
register #1       u_r_ag_ecx_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ecx_needed),            .data_o(r_ag_ecx_needed));
register #3       u_r_ag_in1                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in1),                   .data_o(r_ag_in1));
register #3       u_r_ag_in2                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in2),                   .data_o(r_ag_in2));
register #3       u_r_ag_in3                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in3),                   .data_o(r_ag_in3));
register #3       u_r_ag_in4                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_in4),                   .data_o(r_ag_in4));
register #3       u_r_ag_dreg1                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_dreg1),                 .data_o(r_ag_dreg1));
register #3       u_r_ag_dreg2                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_dreg2),                 .data_o(r_ag_dreg2));
register #3       u_r_ag_dreg3                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_dreg3),                 .data_o(r_ag_dreg3));
register #1       u_r_ag_ld_reg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg1),               .data_o(r_ag_ld_reg1));
register #1       u_r_ag_ld_reg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg2),               .data_o(r_ag_ld_reg2));
register #1       u_r_ag_ld_reg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg3),               .data_o(r_ag_ld_reg3));
register #4       u_r_ag_ld_reg1_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg1_strb),          .data_o(r_ag_ld_reg1_strb));
register #4       u_r_ag_ld_reg2_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg2_strb),          .data_o(r_ag_ld_reg2_strb));
register #4       u_r_ag_ld_reg3_strb          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_reg3_strb),          .data_o(r_ag_ld_reg3_strb));
register #1       u_r_ag_reg8_sr1_HL_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_reg8_sr1_HL_sel),       .data_o(r_ag_reg8_sr1_HL_sel));
register #1       u_r_ag_reg8_sr2_HL_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_reg8_sr2_HL_sel),       .data_o(r_ag_reg8_sr2_HL_sel));
register #1       u_r_ag_mm1_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm1_needed),            .data_o(r_ag_mm1_needed));
register #1       u_r_ag_mm2_needed            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm2_needed),            .data_o(r_ag_mm2_needed));
register #3       u_r_ag_mm1                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm1),                   .data_o(r_ag_mm1));
register #3       u_r_ag_mm2                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm2),                   .data_o(r_ag_mm2));
register #1       u_r_ag_ld_mm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_mm),                 .data_o(r_ag_ld_mm));
register #3       u_r_ag_dmm                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_dmm),                   .data_o(r_ag_dmm));
register #1       u_r_ag_mm_sr1_sel_H          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm_sr1_sel_H),          .data_o(r_ag_mm_sr1_sel_H));
register #1       u_r_ag_mm_sr1_sel_L          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm_sr1_sel_L),          .data_o(r_ag_mm_sr1_sel_L));
register #1       u_r_ag_mm_sr2_sel            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mm_sr2_sel),            .data_o(r_ag_mm_sr2_sel));
register #1       u_r_ag_seg1_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg1_needed),           .data_o(r_ag_seg1_needed));
register #1       u_r_ag_seg2_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg2_needed),           .data_o(r_ag_seg2_needed));
register #1       u_r_ag_seg3_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg3_needed),           .data_o(r_ag_seg3_needed));
register #3       u_r_ag_seg1                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg1),                  .data_o(r_ag_seg1));
register #3       u_r_ag_seg2                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg2),                  .data_o(r_ag_seg2));
register #3       u_r_ag_seg3                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_seg3),                  .data_o(r_ag_seg3));
register #1       u_r_ag_ld_seg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_seg),                .data_o(r_ag_ld_seg));
register #3       u_r_ag_dseg                  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_dseg),                  .data_o(r_ag_dseg));
register #1       u_r_ag_ld_mem                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_mem),                .data_o(r_ag_ld_mem));
register #1       u_r_ag_mem_read              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mem_read),              .data_o(r_ag_mem_read));
register #2       u_r_ag_mem_rd_size           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mem_rd_size),           .data_o(r_ag_mem_rd_size));
register #2       u_r_ag_mem_wr_size           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mem_wr_size),           .data_o(r_ag_mem_wr_size));
register #1       u_r_ag_mem_rd_addr_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_mem_rd_addr_sel),       .data_o(r_ag_mem_rd_addr_sel));
register #1       u_r_ag_eip_change            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_eip_change),            .data_o(r_ag_eip_change));
register #1       u_r_ag_cmps_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_cmps_op),               .data_o(r_ag_cmps_op));
register #1       u_r_ag_cxchg_op              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_cxchg_op),              .data_o(r_ag_cxchg_op));
register #1       u_r_ag_CF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_CF_needed),             .data_o(r_ag_CF_needed));
register #1       u_r_ag_DF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_DF_needed),             .data_o(r_ag_DF_needed));
register #1       u_r_ag_AF_needed             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_AF_needed),             .data_o(r_ag_AF_needed));
register #1       u_r_ag_pr_size_over          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_pr_size_over),          .data_o(r_ag_pr_size_over));
register #32      u_r_ag_EIP_next              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_EIP_next),              .data_o(r_ag_EIP_next));
register #2       u_r_ag_stack_off_sel         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_stack_off_sel),         .data_o(r_ag_stack_off_sel));
register #2       u_r_ag_imm_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_imm_sel),               .data_o(r_ag_imm_sel));
register #1       u_r_ag_EIP_EFLAGS_sel        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_EIP_EFLAGS_sel),        .data_o(r_ag_EIP_EFLAGS_sel));
register #2       u_r_ag_sr1_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_sr1_sel),               .data_o(r_ag_sr1_sel));
register #2       u_r_ag_sr2_sel               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_sr2_sel),               .data_o(r_ag_sr2_sel));
register #4       u_r_ag_alu1_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_alu1_op),               .data_o(r_ag_alu1_op));
register #4       u_r_ag_alu2_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_alu2_op),               .data_o(r_ag_alu2_op));
register #5       u_r_ag_alu3_op               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_alu3_op),               .data_o(r_ag_alu3_op));
register #2       u_r_ag_alu1_op_size          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_alu1_op_size),          .data_o(r_ag_alu1_op_size));
register #1       u_r_ag_df_val                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_df_val),                .data_o(r_ag_df_val));
register #1       u_r_ag_CF_expected           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_CF_expected),           .data_o(r_ag_CF_expected));
register #1       u_r_ag_ZF_expected           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ZF_expected),           .data_o(r_ag_ZF_expected));
register #1       u_r_ag_cond_wr_CF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_cond_wr_CF),            .data_o(r_ag_cond_wr_CF));
register #1       u_r_ag_cond_wr_ZF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_cond_wr_ZF),            .data_o(r_ag_cond_wr_ZF));
register #1       u_r_ag_wr_reg1_data_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_reg1_data_sel),      .data_o(r_ag_wr_reg1_data_sel));
register #1       u_r_ag_wr_reg2_data_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_reg2_data_sel),      .data_o(r_ag_wr_reg2_data_sel));
register #2       u_r_ag_wr_seg_data_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_seg_data_sel),       .data_o(r_ag_wr_seg_data_sel));
register #1       u_r_ag_wr_eip_alu_res_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_eip_alu_res_sel),    .data_o(r_ag_wr_eip_alu_res_sel));
register #2       u_r_ag_wr_mem_data_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_mem_data_sel),       .data_o(r_ag_wr_mem_data_sel));
register #1       u_r_ag_wr_mem_addr_sel       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_wr_mem_addr_sel),       .data_o(r_ag_wr_mem_addr_sel));
register #1       u_r_ag_ld_flag_CF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_CF),            .data_o(r_ag_ld_flag_CF));
register #1       u_r_ag_ld_flag_PF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_PF),            .data_o(r_ag_ld_flag_PF));
register #1       u_r_ag_ld_flag_AF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_AF),            .data_o(r_ag_ld_flag_AF));
register #1       u_r_ag_ld_flag_ZF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_ZF),            .data_o(r_ag_ld_flag_ZF));
register #1       u_r_ag_ld_flag_SF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_SF),            .data_o(r_ag_ld_flag_SF));
register #1       u_r_ag_ld_flag_DF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_DF),            .data_o(r_ag_ld_flag_DF));
register #1       u_r_ag_ld_flag_OF            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ld_flag_OF),            .data_o(r_ag_ld_flag_OF));
register #16      u_r_ag_ptr_CS                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_de_ptr_CS),                .data_o(r_ag_ptr_CS));
register #1       u_V_ag                       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ag), .data_i(w_V_ag_next),                .data_o(r_V_ag));

// ***************** ADDRESS GEN STAGE ******************

wire [16:0] blah;

//SPECIAL ROM instantiation
rseq_rom u_rseq_rom(
  .oe         (1'b0),
  .rseq_addr  (w_rseq_addr),
  .rseq_data  ({blah,
      w_rseq_end_bit,
      w_rseq_V,
      w_rseq_IDT_address_sel,
      w_rseq_base_sel,
      w_rseq_disp_sel,
      w_rseq_SIB_pr,
      w_rseq_scale,
      w_rseq_in1_needed,
      w_rseq_in2_needed,
      w_rseq_in3_needed,
      w_rseq_in4_needed,
      w_rseq_esp_needed,
      w_rseq_eax_needed,
      w_rseq_ecx_needed,
      w_rseq_in1,
      w_rseq_in2,
      w_rseq_in3,
      w_rseq_in4,
      w_rseq_dreg1,
      w_rseq_dreg2,
      w_rseq_dreg3,
      w_rseq_ld_reg1,
      w_rseq_ld_reg2,
      w_rseq_ld_reg3,
      w_rseq_ld_reg1_strb,
      w_rseq_ld_reg2_strb,
      w_rseq_ld_reg3_strb,
      w_rseq_reg8_sr1_HL_sel,
      w_rseq_reg8_sr2_HL_sel,
      w_rseq_mm1_needed,
      w_rseq_mm2_needed,
      w_rseq_mm1,
      w_rseq_mm2,
      w_rseq_ld_mm,
      w_rseq_dmm,
      w_rseq_mm_sr1_sel_H,
      w_rseq_mm_sr1_sel_L,
      w_rseq_mm_sr2_sel,
      w_rseq_seg1_needed,
      w_rseq_seg2_needed,
      w_rseq_seg3_needed,
      w_rseq_seg1,
      w_rseq_seg2,
      w_rseq_seg3,
      w_rseq_ld_seg,
      w_rseq_dseg,
      w_rseq_ld_mem,
      w_rseq_mem_read,
      w_rseq_mem_rd_size,
      w_rseq_mem_wr_size,
      w_rseq_mem_rd_addr_sel,
      w_rseq_eip_change,
      w_rseq_cmps_op,
      w_rseq_cxchg_op,
      w_rseq_CF_needed,
      w_rseq_DF_needed,
      w_rseq_AF_needed,
      w_rseq_pr_size_over,
      w_rseq_stack_off_sel,
      w_rseq_imm_sel,
      w_rseq_EIP_EFLAGS_sel,
      w_rseq_sr1_sel,
      w_rseq_sr2_sel,
      w_rseq_alu1_op,
      w_rseq_alu2_op,
      w_rseq_alu3_op,
      w_rseq_alu1_op_size,
      w_rseq_df_val,
      w_rseq_CF_expected,
      w_rseq_ZF_expected,
      w_rseq_cond_wr_CF,
      w_rseq_cond_wr_ZF,
      w_rseq_wr_reg1_data_sel,
      w_rseq_wr_reg2_data_sel,
      w_rseq_wr_seg_data_sel,
      w_rseq_wr_eip_alu_res_sel,
      w_rseq_wr_mem_data_sel,
      w_rseq_wr_mem_addr_sel,
      w_rseq_ld_flag_CF,
      w_rseq_ld_flag_PF,
      w_rseq_ld_flag_AF,
      w_rseq_ld_flag_ZF,
      w_rseq_ld_flag_SF,
      w_rseq_ld_flag_DF,
      w_rseq_ld_flag_OF
    })
);

//MUX out of decode out and special rom
wire       w_mux_ag_base_sel;
wire [1:0] w_mux_ag_disp_sel;
wire       w_mux_ag_SIB_pr;
wire [1:0] w_mux_ag_scale;
wire       w_mux_ag_in1_needed;
wire       w_mux_ag_in2_needed;
wire       w_mux_ag_in3_needed;
wire       w_mux_ag_in4_needed;
wire       w_mux_ag_esp_needed;
wire       w_mux_ag_eax_needed;
wire       w_mux_ag_ecx_needed;
wire [2:0] w_mux_ag_in1;
wire [2:0] w_mux_ag_in2;
wire [2:0] w_mux_ag_in3;
wire [2:0] w_mux_ag_in4;
wire [2:0] w_mux_ag_dreg1;
wire [2:0] w_mux_ag_dreg2;
wire [2:0] w_mux_ag_dreg3;
wire       w_mux_ag_ld_reg1;
wire       w_mux_ag_ld_reg2;
wire       w_mux_ag_ld_reg3;
wire [3:0] w_mux_ag_ld_reg1_strb;
wire [3:0] w_mux_ag_ld_reg2_strb;
wire [3:0] w_mux_ag_ld_reg3_strb;
wire       w_mux_ag_reg8_sr1_HL_sel;
wire       w_mux_ag_reg8_sr2_HL_sel;
wire       w_mux_ag_mm1_needed;
wire       w_mux_ag_mm2_needed;
wire [2:0] w_mux_ag_mm1;
wire [2:0] w_mux_ag_mm2;
wire       w_mux_ag_ld_mm;
wire [2:0] w_mux_ag_dmm;
wire       w_mux_ag_mm_sr1_sel_H;
wire       w_mux_ag_mm_sr1_sel_L;
wire       w_mux_ag_mm_sr2_sel;
wire       w_mux_ag_seg1_needed;
wire       w_mux_ag_seg2_needed;
wire       w_mux_ag_seg3_needed;
wire [2:0] w_mux_ag_seg1;
wire [2:0] w_mux_ag_seg2;
wire [2:0] w_mux_ag_seg3;
wire       w_mux_ag_ld_seg;
wire [2:0] w_mux_ag_dseg;
wire       w_mux_ag_ld_mem;
wire       w_mux_ag_mem_read;
wire [1:0] w_mux_ag_mem_rd_size;
wire [1:0] w_mux_ag_mem_wr_size;
wire       w_mux_ag_mem_rd_addr_sel;
wire       w_mux_ag_eip_change;
wire       w_mux_ag_cmps_op;
wire       w_mux_ag_cxchg_op;
wire       w_mux_ag_CF_needed;
wire       w_mux_ag_DF_needed;
wire       w_mux_ag_AF_needed;
wire       w_mux_ag_pr_size_over;
wire [1:0] w_mux_ag_stack_off_sel;
wire [1:0] w_mux_ag_imm_sel;
wire       w_mux_ag_EIP_EFLAGS_sel;
wire [1:0] w_mux_ag_sr1_sel;
wire [1:0] w_mux_ag_sr2_sel;
wire [3:0] w_mux_ag_alu1_op;
wire [3:0] w_mux_ag_alu2_op;
wire [4:0] w_mux_ag_alu3_op;
wire [1:0] w_mux_ag_alu1_op_size;
wire       w_mux_ag_df_val;
wire       w_mux_ag_CF_expected;
wire       w_mux_ag_ZF_expected;
wire       w_mux_ag_cond_wr_CF;
wire       w_mux_ag_cond_wr_ZF;
wire       w_mux_ag_wr_reg1_data_sel;
wire       w_mux_ag_wr_reg2_data_sel;
wire [1:0] w_mux_ag_wr_seg_data_sel;
wire       w_mux_ag_wr_eip_alu_res_sel;
wire [1:0] w_mux_ag_wr_mem_data_sel;
wire       w_mux_ag_wr_mem_addr_sel;
wire       w_mux_ag_ld_flag_CF;
wire       w_mux_ag_ld_flag_PF;
wire       w_mux_ag_ld_flag_AF;
wire       w_mux_ag_ld_flag_ZF;
wire       w_mux_ag_ld_flag_SF;
wire       w_mux_ag_ld_flag_DF;
wire       w_mux_ag_ld_flag_OF;

//MUXES between DE to AG latches and SPECIAL ROM
mux_nbit_2x1 #1       u_w_mux_ag_base_sel                (.a0(r_ag_base_sel        ),     .a1(w_rseq_base_sel),           .sel(w_rseq_mux_sel), .out(w_mux_ag_base_sel));           
mux_nbit_2x1 #2       u_w_mux_ag_disp_sel                (.a0(r_ag_disp_sel        ),     .a1(w_rseq_disp_sel),           .sel(w_rseq_mux_sel), .out(w_mux_ag_disp_sel));
mux_nbit_2x1 #1       u_w_mux_ag_SIB_pr                  (.a0(r_ag_SIB_pr          ),     .a1(w_rseq_SIB_pr),             .sel(w_rseq_mux_sel), .out(w_mux_ag_SIB_pr));
mux_nbit_2x1 #2       u_w_mux_ag_scale                   (.a0(r_ag_scale           ),     .a1(w_rseq_scale),              .sel(w_rseq_mux_sel), .out(w_mux_ag_scale));
mux_nbit_2x1 #1       u_w_mux_ag_in1_needed              (.a0(r_ag_in1_needed      ),     .a1(w_rseq_in1_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_in1_needed));
mux_nbit_2x1 #1       u_w_mux_ag_in2_needed              (.a0(r_ag_in2_needed      ),     .a1(w_rseq_in2_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_in2_needed));
mux_nbit_2x1 #1       u_w_mux_ag_in3_needed              (.a0(r_ag_in3_needed      ),     .a1(w_rseq_in3_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_in3_needed));
mux_nbit_2x1 #1       u_w_mux_ag_in4_needed              (.a0(r_ag_in4_needed      ),     .a1(w_rseq_in4_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_in4_needed));
mux_nbit_2x1 #1       u_w_mux_ag_esp_needed              (.a0(r_ag_esp_needed      ),     .a1(w_rseq_esp_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_esp_needed));
mux_nbit_2x1 #1       u_w_mux_ag_eax_needed              (.a0(r_ag_eax_needed      ),     .a1(w_rseq_eax_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_eax_needed));
mux_nbit_2x1 #1       u_w_mux_ag_ecx_needed              (.a0(r_ag_ecx_needed      ),     .a1(w_rseq_ecx_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ecx_needed));
mux_nbit_2x1 #3       u_w_mux_ag_in1                     (.a0(r_ag_in1             ),     .a1(w_rseq_in1),                .sel(w_rseq_mux_sel), .out(w_mux_ag_in1));
mux_nbit_2x1 #3       u_w_mux_ag_in2                     (.a0(r_ag_in2             ),     .a1(w_rseq_in2),                .sel(w_rseq_mux_sel), .out(w_mux_ag_in2));
mux_nbit_2x1 #3       u_w_mux_ag_in3                     (.a0(r_ag_in3             ),     .a1(w_rseq_in3),                .sel(w_rseq_mux_sel), .out(w_mux_ag_in3));
mux_nbit_2x1 #3       u_w_mux_ag_in4                     (.a0(r_ag_in4             ),     .a1(w_rseq_in4),                .sel(w_rseq_mux_sel), .out(w_mux_ag_in4));
mux_nbit_2x1 #3       u_w_mux_ag_dreg1                   (.a0(r_ag_dreg1           ),     .a1(w_rseq_dreg1),              .sel(w_rseq_mux_sel), .out(w_mux_ag_dreg1));
mux_nbit_2x1 #3       u_w_mux_ag_dreg2                   (.a0(r_ag_dreg2           ),     .a1(w_rseq_dreg2),              .sel(w_rseq_mux_sel), .out(w_mux_ag_dreg2));
mux_nbit_2x1 #3       u_w_mux_ag_dreg3                   (.a0(r_ag_dreg3           ),     .a1(w_rseq_dreg3),              .sel(w_rseq_mux_sel), .out(w_mux_ag_dreg3));
mux_nbit_2x1 #1       u_w_mux_ag_ld_reg1                 (.a0(r_ag_ld_reg1         ),     .a1(w_rseq_ld_reg1),            .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg1));
mux_nbit_2x1 #1       u_w_mux_ag_ld_reg2                 (.a0(r_ag_ld_reg2         ),     .a1(w_rseq_ld_reg2),            .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg2));
mux_nbit_2x1 #1       u_w_mux_ag_ld_reg3                 (.a0(r_ag_ld_reg3         ),     .a1(w_rseq_ld_reg3),            .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg3));
mux_nbit_2x1 #4       u_w_mux_ag_ld_reg1_strb            (.a0(r_ag_ld_reg1_strb    ),     .a1(w_rseq_ld_reg1_strb),       .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg1_strb));
mux_nbit_2x1 #4       u_w_mux_ag_ld_reg2_strb            (.a0(r_ag_ld_reg2_strb    ),     .a1(w_rseq_ld_reg2_strb),       .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg2_strb));
mux_nbit_2x1 #4       u_w_mux_ag_ld_reg3_strb            (.a0(r_ag_ld_reg3_strb    ),     .a1(w_rseq_ld_reg3_strb),       .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_reg3_strb));
mux_nbit_2x1 #1       u_w_mux_ag_reg8_sr1_HL_sel         (.a0(r_ag_reg8_sr1_HL_sel ),     .a1(w_rseq_reg8_sr1_HL_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_reg8_sr1_HL_sel));
mux_nbit_2x1 #1       u_w_mux_ag_reg8_sr2_HL_sel         (.a0(r_ag_reg8_sr2_HL_sel ),     .a1(w_rseq_reg8_sr2_HL_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_reg8_sr2_HL_sel));
mux_nbit_2x1 #1       u_w_mux_ag_mm1_needed              (.a0(r_ag_mm1_needed      ),     .a1(w_rseq_mm1_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_mm1_needed));
mux_nbit_2x1 #1       u_w_mux_ag_mm2_needed              (.a0(r_ag_mm2_needed      ),     .a1(w_rseq_mm2_needed),         .sel(w_rseq_mux_sel), .out(w_mux_ag_mm2_needed));
mux_nbit_2x1 #3       u_w_mux_ag_mm1                     (.a0(r_ag_mm1             ),     .a1(w_rseq_mm1),                .sel(w_rseq_mux_sel), .out(w_mux_ag_mm1));
mux_nbit_2x1 #3       u_w_mux_ag_mm2                     (.a0(r_ag_mm2             ),     .a1(w_rseq_mm2),                .sel(w_rseq_mux_sel), .out(w_mux_ag_mm2));
mux_nbit_2x1 #1       u_w_mux_ag_ld_mm                   (.a0(r_ag_ld_mm           ),     .a1(w_rseq_ld_mm),              .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_mm));
mux_nbit_2x1 #3       u_w_mux_ag_dmm                     (.a0(r_ag_dmm             ),     .a1(w_rseq_dmm),                .sel(w_rseq_mux_sel), .out(w_mux_ag_dmm));
mux_nbit_2x1 #1       u_w_mux_ag_mm_sr1_sel_H            (.a0(r_ag_mm_sr1_sel_H    ),     .a1(w_rseq_mm_sr1_sel_H),       .sel(w_rseq_mux_sel), .out(w_mux_ag_mm_sr1_sel_H));
mux_nbit_2x1 #1       u_w_mux_ag_mm_sr1_sel_L            (.a0(r_ag_mm_sr1_sel_L    ),     .a1(w_rseq_mm_sr1_sel_L),       .sel(w_rseq_mux_sel), .out(w_mux_ag_mm_sr1_sel_L));
mux_nbit_2x1 #1       u_w_mux_ag_mm_sr2_sel              (.a0(r_ag_mm_sr2_sel      ),     .a1(w_rseq_mm_sr2_sel),         .sel(w_rseq_mux_sel), .out(w_mux_ag_mm_sr2_sel));
mux_nbit_2x1 #1       u_w_mux_ag_seg1_needed             (.a0(r_ag_seg1_needed     ),     .a1(w_rseq_seg1_needed),        .sel(w_rseq_mux_sel), .out(w_mux_ag_seg1_needed));
mux_nbit_2x1 #1       u_w_mux_ag_seg2_needed             (.a0(r_ag_seg2_needed     ),     .a1(w_rseq_seg2_needed),        .sel(w_rseq_mux_sel), .out(w_mux_ag_seg2_needed));
mux_nbit_2x1 #1       u_w_mux_ag_seg3_needed             (.a0(r_ag_seg3_needed     ),     .a1(w_rseq_seg3_needed),        .sel(w_rseq_mux_sel), .out(w_mux_ag_seg3_needed));
mux_nbit_2x1 #3       u_w_mux_ag_seg1                    (.a0(r_ag_seg1            ),     .a1(w_rseq_seg1),               .sel(w_rseq_mux_sel), .out(w_mux_ag_seg1));
mux_nbit_2x1 #3       u_w_mux_ag_seg2                    (.a0(r_ag_seg2            ),     .a1(w_rseq_seg2),               .sel(w_rseq_mux_sel), .out(w_mux_ag_seg2));
mux_nbit_2x1 #3       u_w_mux_ag_seg3                    (.a0(r_ag_seg3            ),     .a1(w_rseq_seg3),               .sel(w_rseq_mux_sel), .out(w_mux_ag_seg3));
mux_nbit_2x1 #1       u_w_mux_ag_ld_seg                  (.a0(r_ag_ld_seg          ),     .a1(w_rseq_ld_seg),             .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_seg));
mux_nbit_2x1 #3       u_w_mux_ag_dseg                    (.a0(r_ag_dseg            ),     .a1(w_rseq_dseg),               .sel(w_rseq_mux_sel), .out(w_mux_ag_dseg));
mux_nbit_2x1 #1       u_w_mux_ag_ld_mem                  (.a0(r_ag_ld_mem          ),     .a1(w_rseq_ld_mem),             .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_mem));
mux_nbit_2x1 #1       u_w_mux_ag_mem_read                (.a0(r_ag_mem_read        ),     .a1(w_rseq_mem_read),           .sel(w_rseq_mux_sel), .out(w_mux_ag_mem_read));
mux_nbit_2x1 #2       u_w_mux_ag_mem_rd_size             (.a0(r_ag_mem_rd_size     ),     .a1(w_rseq_mem_rd_size),        .sel(w_rseq_mux_sel), .out(w_mux_ag_mem_rd_size));
mux_nbit_2x1 #2       u_w_mux_ag_mem_wr_size             (.a0(r_ag_mem_wr_size     ),     .a1(w_rseq_mem_wr_size),        .sel(w_rseq_mux_sel), .out(w_mux_ag_mem_wr_size));
mux_nbit_2x1 #1       u_w_mux_ag_mem_rd_addr_sel         (.a0(r_ag_mem_rd_addr_sel ),     .a1(w_rseq_mem_rd_addr_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_mem_rd_addr_sel));
mux_nbit_2x1 #1       u_w_mux_ag_eip_change              (.a0(r_ag_eip_change      ),     .a1(w_rseq_eip_change),         .sel(w_rseq_mux_sel), .out(w_mux_ag_eip_change));
mux_nbit_2x1 #1       u_w_mux_ag_cmps_op                 (.a0(r_ag_cmps_op         ),     .a1(w_rseq_cmps_op),            .sel(w_rseq_mux_sel), .out(w_mux_ag_cmps_op));
mux_nbit_2x1 #1       u_w_mux_ag_cxchg_op                (.a0(r_ag_cxchg_op        ),     .a1(w_rseq_cxchg_op),           .sel(w_rseq_mux_sel), .out(w_mux_ag_cxchg_op));
mux_nbit_2x1 #1       u_w_mux_ag_CF_needed               (.a0(r_ag_CF_needed       ),     .a1(w_rseq_CF_needed),          .sel(w_rseq_mux_sel), .out(w_mux_ag_CF_needed));
mux_nbit_2x1 #1       u_w_mux_ag_DF_needed               (.a0(r_ag_DF_needed       ),     .a1(w_rseq_DF_needed),          .sel(w_rseq_mux_sel), .out(w_mux_ag_DF_needed));
mux_nbit_2x1 #1       u_w_mux_ag_AF_needed               (.a0(r_ag_AF_needed       ),     .a1(w_rseq_AF_needed),          .sel(w_rseq_mux_sel), .out(w_mux_ag_AF_needed));
mux_nbit_2x1 #1       u_w_mux_ag_pr_size_over            (.a0(r_ag_pr_size_over    ),     .a1(w_rseq_pr_size_over),       .sel(w_rseq_mux_sel), .out(w_mux_ag_pr_size_over));
mux_nbit_2x1 #2       u_w_mux_ag_stack_off_sel           (.a0(r_ag_stack_off_sel   ),     .a1(w_rseq_stack_off_sel),      .sel(w_rseq_mux_sel), .out(w_mux_ag_stack_off_sel));
mux_nbit_2x1 #2       u_w_mux_ag_imm_sel                 (.a0(r_ag_imm_sel         ),     .a1(w_rseq_imm_sel),            .sel(w_rseq_mux_sel), .out(w_mux_ag_imm_sel));
mux_nbit_2x1 #1       u_w_mux_ag_EIP_EFLAGS_sel          (.a0(r_ag_EIP_EFLAGS_sel  ),     .a1(w_rseq_EIP_EFLAGS_sel),     .sel(w_rseq_mux_sel), .out(w_mux_ag_EIP_EFLAGS_sel));
mux_nbit_2x1 #2       u_w_mux_ag_sr1_sel                 (.a0(r_ag_sr1_sel         ),     .a1(w_rseq_sr1_sel),            .sel(w_rseq_mux_sel), .out(w_mux_ag_sr1_sel));
mux_nbit_2x1 #2       u_w_mux_ag_sr2_sel                 (.a0(r_ag_sr2_sel         ),     .a1(w_rseq_sr2_sel),            .sel(w_rseq_mux_sel), .out(w_mux_ag_sr2_sel));
mux_nbit_2x1 #4       u_w_mux_ag_alu1_op                 (.a0(r_ag_alu1_op         ),     .a1(w_rseq_alu1_op),            .sel(w_rseq_mux_sel), .out(w_mux_ag_alu1_op));
mux_nbit_2x1 #4       u_w_mux_ag_alu2_op                 (.a0(r_ag_alu2_op         ),     .a1(w_rseq_alu2_op),            .sel(w_rseq_mux_sel), .out(w_mux_ag_alu2_op));
mux_nbit_2x1 #5       u_w_mux_ag_alu3_op                 (.a0(r_ag_alu3_op         ),     .a1(w_rseq_alu3_op),            .sel(w_rseq_mux_sel), .out(w_mux_ag_alu3_op));
mux_nbit_2x1 #2       u_w_mux_ag_alu1_op_size            (.a0(r_ag_alu1_op_size    ),     .a1(w_rseq_alu1_op_size),       .sel(w_rseq_mux_sel), .out(w_mux_ag_alu1_op_size));
mux_nbit_2x1 #1       u_w_mux_ag_df_val                  (.a0(r_ag_df_val          ),     .a1(w_rseq_df_val),             .sel(w_rseq_mux_sel), .out(w_mux_ag_df_val));
mux_nbit_2x1 #1       u_w_mux_ag_CF_expected             (.a0(r_ag_CF_expected     ),     .a1(w_rseq_CF_expected),        .sel(w_rseq_mux_sel), .out(w_mux_ag_CF_expected));
mux_nbit_2x1 #1       u_w_mux_ag_ZF_expected             (.a0(r_ag_ZF_expected     ),     .a1(w_rseq_ZF_expected),        .sel(w_rseq_mux_sel), .out(w_mux_ag_ZF_expected));
mux_nbit_2x1 #1       u_w_mux_ag_cond_wr_CF              (.a0(r_ag_cond_wr_CF      ),     .a1(w_rseq_cond_wr_CF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_cond_wr_CF));
mux_nbit_2x1 #1       u_w_mux_ag_cond_wr_ZF              (.a0(r_ag_cond_wr_ZF      ),     .a1(w_rseq_cond_wr_ZF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_cond_wr_ZF));
mux_nbit_2x1 #1       u_w_mux_ag_wr_reg1_data_sel        (.a0(r_ag_wr_reg1_data_sel),     .a1(w_rseq_wr_reg1_data_sel),   .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_reg1_data_sel));
mux_nbit_2x1 #1       u_w_mux_ag_wr_reg2_data_sel        (.a0(r_ag_wr_reg2_data_sel),     .a1(w_rseq_wr_reg2_data_sel),   .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_reg2_data_sel));
mux_nbit_2x1 #2       u_w_mux_ag_wr_seg_data_sel         (.a0(r_ag_wr_seg_data_sel ),     .a1(w_rseq_wr_seg_data_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_seg_data_sel));
mux_nbit_2x1 #1       u_w_mux_ag_wr_eip_alu_res_sel      (.a0(r_ag_wr_eip_alu_res_sel),   .a1(w_rseq_wr_eip_alu_res_sel), .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_eip_alu_res_sel));
mux_nbit_2x1 #2       u_w_mux_ag_wr_mem_data_sel         (.a0(r_ag_wr_mem_data_sel ),     .a1(w_rseq_wr_mem_data_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_mem_data_sel));
mux_nbit_2x1 #1       u_w_mux_ag_wr_mem_addr_sel         (.a0(r_ag_wr_mem_addr_sel ),     .a1(w_rseq_wr_mem_addr_sel),    .sel(w_rseq_mux_sel), .out(w_mux_ag_wr_mem_addr_sel));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_CF              (.a0(r_ag_ld_flag_CF      ),     .a1(w_rseq_ld_flag_CF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_CF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_PF              (.a0(r_ag_ld_flag_PF      ),     .a1(w_rseq_ld_flag_PF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_PF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_AF              (.a0(r_ag_ld_flag_AF      ),     .a1(w_rseq_ld_flag_AF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_AF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_ZF              (.a0(r_ag_ld_flag_ZF      ),     .a1(w_rseq_ld_flag_ZF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_ZF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_SF              (.a0(r_ag_ld_flag_SF      ),     .a1(w_rseq_ld_flag_SF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_SF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_DF              (.a0(r_ag_ld_flag_DF      ),     .a1(w_rseq_ld_flag_DF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_DF));
mux_nbit_2x1 #1       u_w_mux_ag_ld_flag_OF              (.a0(r_ag_ld_flag_OF      ),     .a1(w_rseq_ld_flag_OF),         .sel(w_rseq_mux_sel), .out(w_mux_ag_ld_flag_OF));

//Just getting passed to RO:
register #32        u_r_ro_EIP_curr            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(r_ag_EIP_curr),              .data_o(r_ro_EIP_curr));
register #16        u_r_ro_CS_curr             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(r_ag_CS_curr),               .data_o(r_ro_CS_curr));
register #32        u_r_ro_imm_rel_ptr32       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(r_ag_imm_rel_ptr32),         .data_o(r_ro_imm_rel_ptr32));

register #1         u_r_ro_in3_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_in3_needed),            .data_o(r_ro_in3_needed));
register #1         u_r_ro_in4_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_in4_needed),            .data_o(r_ro_in4_needed));
register #1         u_r_ro_eax_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_eax_needed),            .data_o(r_ro_eax_needed));
register #1         u_r_ro_ecx_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ecx_needed),            .data_o(r_ro_ecx_needed));
register #3         u_r_ro_in3                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_in3),                   .data_o(r_ro_in3));
register #3         u_r_ro_in4                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_in4),                   .data_o(r_ro_in4));
register #3         u_r_ro_dreg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_dreg1),                 .data_o(r_ro_dreg1));
register #3         u_r_ro_dreg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_dreg2),                 .data_o(r_ro_dreg2));
register #3         u_r_ro_dreg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_dreg3),                 .data_o(r_ro_dreg3));
register #1         u_r_ro_ld_reg1             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg1),               .data_o(r_ro_ld_reg1));
register #1         u_r_ro_ld_reg2             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg2),               .data_o(r_ro_ld_reg2));
register #1         u_r_ro_ld_reg3             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg3),               .data_o(r_ro_ld_reg3));
register #4         u_r_ro_ld_reg1_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg1_strb),          .data_o(r_ro_ld_reg1_strb));
register #4         u_r_ro_ld_reg2_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg2_strb),          .data_o(r_ro_ld_reg2_strb));
register #4         u_r_ro_ld_reg3_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_reg3_strb),          .data_o(r_ro_ld_reg3_strb));
register #1         u_r_ro_reg8_sr1_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_reg8_sr1_HL_sel),       .data_o(r_ro_reg8_sr1_HL_sel));
register #1         u_r_ro_reg8_sr2_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_reg8_sr2_HL_sel),       .data_o(r_ro_reg8_sr2_HL_sel));
register #1         u_r_ro_mm1_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm1_needed),            .data_o(r_ro_mm1_needed));
register #1         u_r_ro_mm2_needed          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm2_needed),            .data_o(r_ro_mm2_needed));
register #3         u_r_ro_mm1                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm1),                   .data_o(r_ro_mm1));
register #3         u_r_ro_mm2                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm2),                   .data_o(r_ro_mm2));
register #1         u_r_ro_ld_mm               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_mm),                 .data_o(r_ro_ld_mm));
register #3         u_r_ro_dmm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_dmm),                   .data_o(r_ro_dmm));
register #1         u_r_ro_mm_sr1_sel_H        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm_sr1_sel_H),          .data_o(r_ro_mm_sr1_sel_H));
register #1         u_r_ro_mm_sr1_sel_L        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm_sr1_sel_L),          .data_o(r_ro_mm_sr1_sel_L));
register #1         u_r_ro_mm_sr2_sel          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mm_sr2_sel),            .data_o(r_ro_mm_sr2_sel));
register #1         u_r_ro_seg3_needed         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_seg3_needed),           .data_o(r_ro_seg3_needed));
register #3         u_r_ro_seg3                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_seg3),                  .data_o(r_ro_seg3));
register #1         u_r_ro_ld_seg              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_seg),                .data_o(r_ro_ld_seg));
register #3         u_r_ro_dseg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_dseg),                  .data_o(r_ro_dseg));
register #1         u_r_ro_ld_mem              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_mem),                .data_o(r_ro_ld_mem));
register #1         u_r_ro_mem_read            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mem_read),              .data_o(r_ro_mem_read));
register #2         u_r_ro_mem_rd_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mem_rd_size),           .data_o(r_ro_mem_rd_size));
register #2         u_r_ro_mem_wr_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mem_wr_size),           .data_o(r_ro_mem_wr_size));
register #1         u_r_ro_mem_rd_addr_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_mem_rd_addr_sel),       .data_o(r_ro_mem_rd_addr_sel));
register #1         u_r_ro_eip_change          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_eip_change),            .data_o(r_ro_eip_change));
register #1         u_r_ro_cmps_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_cmps_op),               .data_o(r_ro_cmps_op));
register #1         u_r_ro_cxchg_op            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_cxchg_op),              .data_o(r_ro_cxchg_op));
register #1         u_r_ro_CF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_CF_needed),             .data_o(r_ro_CF_needed));
register #1         u_r_ro_DF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_DF_needed),             .data_o(r_ro_DF_needed));
register #1         u_r_ro_AF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_AF_needed),             .data_o(r_ro_AF_needed));
register #1         u_r_ro_pr_size_over        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_pr_size_over),          .data_o(r_ro_pr_size_over));
register #32        u_r_ro_EIP_next            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(r_ag_EIP_next),                  .data_o(r_ro_EIP_next));
register #4         u_r_ro_alu1_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_alu1_op),               .data_o(r_ro_alu1_op));
register #4         u_r_ro_alu2_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_alu2_op),               .data_o(r_ro_alu2_op));
register #5         u_r_ro_alu3_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_alu3_op),               .data_o(r_ro_alu3_op));
register #2         u_r_ro_alu1_op_size        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_alu1_op_size),          .data_o(r_ro_alu1_op_size));
register #1         u_r_ro_df_val              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_df_val),                .data_o(r_ro_df_val));
register #1         u_r_ro_CF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_CF_expected),           .data_o(r_ro_CF_expected));
register #1         u_r_ro_ZF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ZF_expected),           .data_o(r_ro_ZF_expected));
register #1         u_r_ro_cond_wr_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_cond_wr_CF),            .data_o(r_ro_cond_wr_CF));
register #1         u_r_ro_cond_wr_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_cond_wr_ZF),            .data_o(r_ro_cond_wr_ZF));
register #1         u_r_ro_wr_reg1_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_reg1_data_sel),      .data_o(r_ro_wr_reg1_data_sel));
register #1         u_r_ro_wr_reg2_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_reg2_data_sel),      .data_o(r_ro_wr_reg2_data_sel));
register #2         u_r_ro_wr_seg_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_seg_data_sel),       .data_o(r_ro_wr_seg_data_sel));
register #1         u_r_ro_wr_eip_alu_res_sel  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_eip_alu_res_sel),    .data_o(r_ro_wr_eip_alu_res_sel));
register #2         u_r_ro_wr_mem_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_mem_data_sel),       .data_o(r_ro_wr_mem_data_sel));
register #1         u_r_ro_wr_mem_addr_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_wr_mem_addr_sel),       .data_o(r_ro_wr_mem_addr_sel));
register #1         u_r_ro_ld_flag_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_CF),            .data_o(r_ro_ld_flag_CF));
register #1         u_r_ro_ld_flag_PF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_PF),            .data_o(r_ro_ld_flag_PF));
register #1         u_r_ro_ld_flag_AF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_AF),            .data_o(r_ro_ld_flag_AF));
register #1         u_r_ro_ld_flag_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_ZF),            .data_o(r_ro_ld_flag_ZF));
register #1         u_r_ro_ld_flag_SF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_SF),            .data_o(r_ro_ld_flag_SF));
register #1         u_r_ro_ld_flag_DF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_DF),            .data_o(r_ro_ld_flag_DF));
register #1         u_r_ro_ld_flag_OF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_ld_flag_OF),            .data_o(r_ro_ld_flag_OF));
register #16        u_r_ro_ptr_CS              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(r_ag_ptr_CS),                    .data_o(r_ro_ptr_CS));
register #2         u_r_ro_imm_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_imm_sel),               .data_o(r_ro_imm_sel));
register #1         u_r_ro_EIP_EFLAGS_sel      (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_EIP_EFLAGS_sel),        .data_o(r_ro_EIP_EFLAGS_sel));
register #2         u_r_ro_sr1_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_sr1_sel),               .data_o(r_ro_sr1_sel));
register #2         u_r_ro_sr2_sel             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_mux_ag_sr2_sel),               .data_o(r_ro_sr2_sel));

//AG dependency logic
ag_dep_v_ld_logic u_ag_dep_v_ld_logic(
  .V_ag               (r_V_ag),
  .eip_change         (r_ag_eip_change),
  .in1                (r_ag_in1),
  .in2                (r_ag_in2),
  .in1_needed         (r_ag_in1_needed),
  .in2_needed         (r_ag_in2_needed),
  .seg1               (r_ag_seg1),
  .seg2               (r_ag_seg2),
  .seg1_needed        (r_ag_seg1_needed),
  .seg2_needed        (r_ag_seg2_needed),
  .esp_needed         (r_ag_esp_needed),
  .ro_dreg1           (r_ro_dreg1),
  .ro_dreg2           (r_ro_dreg2),
  .ro_dreg3           (r_ro_dreg3),
  .v_ro_ld_reg1       (w_v_ro_ld_reg1),
  .v_ro_ld_reg2       (w_v_ro_ld_reg2),
  .v_ro_ld_reg3       (w_v_ro_ld_reg3),
  .ex_dreg1           (r_ex_dreg1),
  .ex_dreg2           (r_ex_dreg2),
  .ex_dreg3           (r_ex_dreg3),
  .v_ex_ld_reg1       (w_v_ex_ld_reg1),
  .v_ex_ld_reg2       (w_v_ex_ld_reg2),
  .v_ex_ld_reg3       (w_v_ex_ld_reg3),
  .wb_dreg1           (r_wb_dreg1),
  .wb_dreg2           (r_wb_dreg2),
  .wb_dreg3           (r_wb_dreg3),
  .v_wb_ld_reg1       (w_v_wb_ld_reg1),
  .v_wb_ld_reg2       (w_v_wb_ld_reg2),
  .v_wb_ld_reg3       (w_v_wb_ld_reg3),
  .ro_dseg            (r_ro_dseg),
  .v_ro_ld_seg        (w_v_ro_ld_seg),
  .ex_dseg            (r_ex_dseg),
  .v_ex_ld_seg        (w_v_ex_ld_seg),
  .wb_dseg            (r_wb_dseg),
  .v_wb_ld_seg        (w_v_wb_ld_seg),
  .stall_ro           (w_stall_ro),
  .ro_dep_stall       (w_ro_dep_stall),
  .ro_cmps_stall      (w_ro_cmps_stall),
  .mem_rd_busy        (w_mem_rd_busy),
  .dc_exp             (w_dc_exp),

  .ld_reg1            (r_ag_ld_reg1),
  .ld_reg2            (r_ag_ld_reg2),
  .ld_reg3            (r_ag_ld_reg3),
  .ld_flag_ZF         (r_ro_ld_flag_ZF),
  .v_ag_ld_reg1       (w_v_ag_ld_reg1),
  .v_ag_ld_reg2       (w_v_ag_ld_reg2),
  .v_ag_ld_reg3       (w_v_ag_ld_reg3),
  .v_ag_ld_flag_ZF    (w_v_ag_ld_flag_ZF),
  
  .dep_stall          (w_ag_dep_stall),
  .br_stall           (w_ag_br_stall),
  .stall_ag           (w_stall_ag),
  .V_ro               (w_V_ro_next),
  .ld_ro              (w_ld_ro)
);

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
  .r_reg_data4     (r_ro_reg_out4),
  .ESP             (w_ag_ESP),
  .ECX             (w_ro_ECX),
  .EAX             (w_ro_EAX)
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
  .r_seg_data3    (r_ro_seg_data3),
  .CS             (r_CS)
);

//Displacement select
wire [31:0] w_ag_disp_out;
wire t_disp;
assign t_disp = r_ag_disp32[7];
mux_nbit_4x1 #32 u_w_ag_disp_out (
  .a0(32'h0), 
  .a1({t_disp,t_disp,t_disp,t_disp,t_disp,
      t_disp,t_disp,t_disp,t_disp,t_disp,
      t_disp,t_disp,t_disp,t_disp,t_disp,
      t_disp,t_disp,t_disp,t_disp,t_disp,
      t_disp,t_disp,t_disp,t_disp,r_ag_disp32[7:0]}), 
  .a2(r_ag_disp32), 
  .a3(32'h0), 
  .sel(w_mux_ag_disp_sel), 
  .out(w_ag_disp_out)
);

//add disp and seg
wire [31:0] w_ag_disp_add_seg;
cond_sum32 u_w_ag_disp_add_seg ( .A(w_ag_disp_out), .B({r_ag_seg_data1,16'h0}), .CIN(1'b0), .S(w_ag_disp_add_seg), .COUT(/*Unused*/) );

//scaled index (and muxed)
wire [31:0] w_ag_scaled_index;
mux_nbit_4x1 #32 u_w_ag_scaled_index (
  .a0(r_ag_reg_out2), 
  .a1({r_ag_reg_out2[30:0],1'h0}),
  .a2({r_ag_reg_out2[29:0],2'h0}),
  .a3({r_ag_reg_out2[28:0],3'h0}),
  .sel(w_mux_ag_scale), 
  .out(w_ag_scaled_index)
);
wire [31:0] w_ag_scaled_index_muxed;
mux_nbit_2x1 u_w_ag_scaled_index_muxed (.a0(32'h0), .a1(w_ag_scaled_index), .sel(w_mux_ag_SIB_pr), .out(w_ag_scaled_index_muxed));

//addr_base
wire [31:0] w_ag_addr_base;
mux_nbit_2x1 u_w_ag_addr_base (.a0(32'h0), .a1(r_ag_reg_out1), .sel(w_mux_ag_base_sel), .out(w_ag_addr_base));

//Addr size in bytes -1
wire [31:0] w_ag_addr_end_pos_rd;
mux_nbit_4x1 #32 u_w_ag_addr_end_pos_rd (.a0(32'h0), .a1(32'h1), .a2(32'h3), .a3(32'h7), .sel(r_ag_mem_rd_size), .out(w_ag_addr_end_pos_rd));
wire [31:0] w_ag_addr_end_pos_wr;
mux_nbit_4x1 #32 u_w_ag_addr_end_pos_wr (.a0(32'h0), .a1(32'h1), .a2(32'h3), .a3(32'h7), .sel(r_ag_mem_wr_size), .out(w_ag_addr_end_pos_wr));

//addr1
wire [31:0] w_ag_addr1;
wallace_abc_adder u_w_ag_addr1( .A(w_ag_disp_add_seg), .B(w_ag_addr_base), .C(w_ag_scaled_index_muxed), .CIN(1'b0), .S(w_ag_addr1) ); 

wire [31:0] w_ag_addr1_end_rd;
cond_sum32 u_w_ag_addr1_end_rd  ( .A(w_ag_addr1), .B(w_ag_addr_end_pos_rd), .CIN(1'd0), .S(w_ag_addr1_end_rd), .COUT(/*unused*/)); 
wire [31:0] w_ag_addr1_end_wr;
cond_sum32 u_w_ag_addr1_end_wr  ( .A(w_ag_addr1), .B(w_ag_addr_end_pos_wr), .CIN(1'd0), .S(w_ag_addr1_end_wr), .COUT(/*unused*/)); 

//reg2 and ESP muxed
wire [31:0] w_ag_reg2_ESP_muxed;
mux_nbit_2x1 u_w_ag_reg2_ESP_muxed(.a0(w_ag_ESP), .a1(r_ag_reg_out2), .sel(w_mux_ag_cmps_op), .out(w_ag_reg2_ESP_muxed));

//stack offset
wire [31:0] w_ag_stack_off;
mux_nbit_4x1 u_w_ag_stack_off (.a0(32'h0), .a1(32'hfffe), .a2(32'hfffc), .a3(32'hfff8), .sel(w_mux_ag_stack_off_sel), .out(w_ag_stack_off));

//ISR
wire w_ag_ISR;
assign w_ag_ISR = w_rseq_mux_sel;

//addr2
wire [31:0] w_ag_addr2_temp;
wire [31:0] w_ag_addr2;
wallace_abc_adder u_w_ag_addr2_temp ( .A(w_ag_reg2_ESP_muxed), .B({r_ag_seg_data2,16'h0}), .C(w_ag_stack_off), .CIN(1'b0), .S(w_ag_addr2_temp) ); 

wire [31:0] w_ag_addr2_end_rd;
cond_sum32 u_w_ag_addr2_end_rd  ( .A(w_ag_addr2), .B(w_ag_addr_end_pos_rd), .CIN(1'd0), .S(w_ag_addr2_end_rd), .COUT(/*unused*/)); 
wire [31:0] w_ag_addr2_end_wr;
cond_sum32 u_w_ag_addr2_end_wr  ( .A(w_ag_addr2), .B(w_ag_addr_end_pos_wr), .CIN(1'd0), .S(w_ag_addr2_end_wr), .COUT(/*unused*/)); 

wire IDT_and_ISR;
and2$ u_IDT_and_ISR (.in0(w_ag_ISR), .in1(w_rseq_IDT_address_sel), .out(IDT_and_ISR));
mux_nbit_2x1 u_w_ag_addr2 (.a0(w_ag_addr2_temp), .a1(w_IDT_address), .sel(IDT_and_ISR), .out(w_ag_addr2));

//seg1_limit
wire [19:0] w_ag_seg1_limit;
mux_nbit_8x1 #20 u_w_ag_seg1_limit (
  .a0(ES_limit),
  .a1(CS_limit),
  .a2(SS_limit),
  .a3(DS_limit),
  .a4(FS_limit),
  .a5(GS_limit),
  .a6(/*Unused*/),
  .a7(/*Unused*/),
  .sel(w_mux_ag_seg1),
  .out(w_ag_seg1_limit)
);

//seg2_limit
wire [19:0] w_ag_seg2_limit;
mux_nbit_8x1 #20 u_w_ag_seg2_limit (
  .a0(ES_limit),
  .a1(CS_limit),
  .a2(SS_limit),
  .a3(DS_limit),
  .a4(FS_limit),
  .a5(GS_limit),
  .a6(/*Unused*/),
  .a7(/*Unused*/),
  .sel(w_mux_ag_seg2),
  .out(w_ag_seg2_limit)
);

//addr1_offset
wire [31:0] w_ag_addr1_offset;
wallace_abc_adder u_w_ag_addr1_offset ( .A(w_ag_disp_out), .B(w_ag_addr_base), .C(w_ag_scaled_index_muxed), .CIN(1'b0), .S(w_ag_addr1_offset) ); 

//addr2_offset
wire [31:0] w_ag_addr2_offset;
cond_sum32 u_w_ag_addr2_offset ( .A(w_ag_reg2_ESP_muxed), .B(w_ag_stack_off), .CIN(1'b0), .S(w_ag_addr2_offset), .COUT(/*Unused*/) );

//Newly generated AG to RO signals latching
register #32         u_r_ro_ESP                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_ESP         ),            .data_o(r_ro_ESP         ));
register #32         u_r_ro_addr1                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr1       ),            .data_o(r_ro_addr1       ));
register #32         u_r_ro_addr2                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr2       ),            .data_o(r_ro_addr2       ));
register #32         u_r_ro_addr1_end_rd          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr1_end_rd),            .data_o(r_ro_addr1_end_rd));
register #32         u_r_ro_addr2_end_rd          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr2_end_rd),            .data_o(r_ro_addr2_end_rd));
register #32         u_r_ro_addr1_end_wr          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr1_end_wr),            .data_o(r_ro_addr1_end_wr));
register #32         u_r_ro_addr2_end_wr          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr2_end_wr),            .data_o(r_ro_addr2_end_wr));
register #20         u_r_ro_seg1_limit            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_seg1_limit  ),            .data_o(r_ro_seg1_limit  ));
register #20         u_r_ro_seg2_limit            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_seg2_limit  ),            .data_o(r_ro_seg2_limit  ));
register #32         u_r_ro_addr1_offset          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr1_offset),            .data_o(r_ro_addr1_offset));
register #32         u_r_ro_addr2_offset          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_addr2_offset),            .data_o(r_ro_addr2_offset));
register #1          u_r_ro_ISR                   (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_ag_ISR         ),            .data_o(r_ro_ISR         ));
register #1          u_V_ro                       (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ro), .data_i(w_V_ro_next),                  .data_o(r_V_ro));

// ***************** READ OPERANDS STAGE ******************

//Just getting passed to EX:
register #3         u_r_ex_dreg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_dreg1),                 .data_o(r_ex_dreg1));
register #3         u_r_ex_dreg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_dreg2),                 .data_o(r_ex_dreg2));
register #3         u_r_ex_dreg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_dreg3),                 .data_o(r_ex_dreg3));
register #1         u_r_ex_ld_reg1             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg1),               .data_o(r_ex_ld_reg1));
register #1         u_r_ex_ld_reg2             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg2),               .data_o(r_ex_ld_reg2));
register #1         u_r_ex_ld_reg3             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg3),               .data_o(r_ex_ld_reg3));
register #4         u_r_ex_ld_reg1_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg1_strb),          .data_o(r_ex_ld_reg1_strb));
register #4         u_r_ex_ld_reg2_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg2_strb),          .data_o(r_ex_ld_reg2_strb));
register #4         u_r_ex_ld_reg3_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_reg3_strb),          .data_o(r_ex_ld_reg3_strb));
register #1         u_r_ex_reg8_sr1_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_reg8_sr1_HL_sel),       .data_o(r_ex_reg8_sr1_HL_sel));
register #1         u_r_ex_reg8_sr2_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_reg8_sr2_HL_sel),       .data_o(r_ex_reg8_sr2_HL_sel));
register #1         u_r_ex_ld_mm               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_mm),                 .data_o(r_ex_ld_mm));
register #3         u_r_ex_dmm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_dmm),                   .data_o(r_ex_dmm));
register #1         u_r_ex_ld_seg              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_seg),                .data_o(r_ex_ld_seg));
register #3         u_r_ex_dseg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_dseg),                  .data_o(r_ex_dseg));
register #1         u_r_ex_ld_mem              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_mem),                .data_o(r_ex_ld_mem));
register #2         u_r_ex_mem_rd_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_mem_rd_size),           .data_o(r_ex_mem_rd_size));
register #2         u_r_ex_mem_wr_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_mem_wr_size),           .data_o(r_ex_mem_wr_size));
register #1         u_r_ex_eip_change          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_eip_change),            .data_o(r_ex_eip_change));
register #1         u_r_ex_cmps_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_cmps_op),               .data_o(r_ex_cmps_op));
register #1         u_r_ex_cxchg_op            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_cxchg_op),              .data_o(r_ex_cxchg_op));
register #1         u_r_ex_CF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_CF_needed),             .data_o(r_ex_CF_needed));
register #1         u_r_ex_DF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_DF_needed),             .data_o(r_ex_DF_needed));
register #1         u_r_ex_AF_needed           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_AF_needed),             .data_o(r_ex_AF_needed));
register #1         u_r_ex_pr_size_over        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_pr_size_over),          .data_o(r_ex_pr_size_over));
register #32        u_r_ex_EIP_next            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_EIP_next),              .data_o(r_ex_EIP_next));
register #4         u_r_ex_alu1_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_alu1_op),               .data_o(r_ex_alu1_op));
register #4         u_r_ex_alu2_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_alu2_op),               .data_o(r_ex_alu2_op));
register #5         u_r_ex_alu3_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_alu3_op),               .data_o(r_ex_alu3_op));
register #2         u_r_ex_alu1_op_size        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_alu1_op_size),          .data_o(r_ex_alu1_op_size));
register #1         u_r_ex_df_val              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_df_val),                .data_o(r_ex_df_val));
register #1         u_r_ex_CF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_CF_expected),           .data_o(r_ex_CF_expected));
register #1         u_r_ex_ZF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ZF_expected),           .data_o(r_ex_ZF_expected));
register #1         u_r_ex_cond_wr_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_cond_wr_CF),            .data_o(r_ex_cond_wr_CF));
register #1         u_r_ex_cond_wr_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_cond_wr_ZF),            .data_o(r_ex_cond_wr_ZF));
register #1         u_r_ex_wr_reg1_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_wr_reg1_data_sel),      .data_o(r_ex_wr_reg1_data_sel));
register #1         u_r_ex_wr_reg2_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_wr_reg2_data_sel),      .data_o(r_ex_wr_reg2_data_sel));
register #2         u_r_ex_wr_seg_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_wr_seg_data_sel),       .data_o(r_ex_wr_seg_data_sel));
register #1         u_r_ex_wr_eip_alu_res_sel  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_wr_eip_alu_res_sel),    .data_o(r_ex_wr_eip_alu_res_sel));
register #2         u_r_ex_wr_mem_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_wr_mem_data_sel),       .data_o(r_ex_wr_mem_data_sel));
register #1         u_r_ex_ld_flag_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_CF),            .data_o(r_ex_ld_flag_CF));
register #1         u_r_ex_ld_flag_PF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_PF),            .data_o(r_ex_ld_flag_PF));
register #1         u_r_ex_ld_flag_AF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_AF),            .data_o(r_ex_ld_flag_AF));
register #1         u_r_ex_ld_flag_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_ZF),            .data_o(r_ex_ld_flag_ZF));
register #1         u_r_ex_ld_flag_SF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_SF),            .data_o(r_ex_ld_flag_SF));
register #1         u_r_ex_ld_flag_DF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_DF),            .data_o(r_ex_ld_flag_DF));
register #1         u_r_ex_ld_flag_OF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ld_flag_OF),            .data_o(r_ex_ld_flag_OF));
register #16        u_r_ex_ptr_CS              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ptr_CS),                .data_o(r_ex_ptr_CS));
register #32        u_r_ex_ESP                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ESP         ),          .data_o(r_ex_ESP         ));
register #1         u_r_ex_ISR                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(r_ro_ISR         ),          .data_o(r_ex_ISR         ));

//Internal signals:
wire [31:0] w_ro_mem_rd_addr;
wire [63:0] w_ro_mem_rd_data; 
wire w_dc_prot_exp;
wire w_dc_page_fault;
wire w_ro_rd_mem_addr_sel;
wire [19:0] w_ro_seg_wr_limit;
wire [31:0] w_ro_wr_addr_offset;
wire [19:0] w_ro_seg_rd_limit;
wire [31:0] w_ro_rd_addr_offset;
wire w_dc_rd_exp;

wire w_v_ro_mem_read;
wire w_v_ro_ld_mem;


//To out
wire [31:0]  w_ro_sr1;
wire [31:0]  w_ro_sr2;
wire [63:0]  w_ro_mm_sr1;
wire [63:0]  w_ro_mm_sr2;
wire [31:0]  w_ro_mem_out;
wire [31:0]  w_ro_mem_out_latched;
wire [31:0]  w_ro_mem_wr_addr;
wire [31:0]  w_ro_mem_wr_addr_end;
wire [31:0]  w_ro_mem_rd_addr_end;

//DCACHE
wire [31:0] w_fifo_mem_wr_addr;
wire [1:0] w_fifo_mem_wr_size;
wire [63:0] w_fifo_mem_wr_data;
wire w_ro_mem_conflict;
wire w_ro_mem_rd_ready;
wire w_mem_wr_busy;
wire w_dc_miss;
wire [31:0] w_dc_miss_addr;
wire [127:0] w_dc_data_fill;
wire w_dc_miss_ack;
wire w_io_access;
wire w_io_rw;
wire [31:0] w_io_addr;
wire [31:0] w_io_wr_data;
wire [31:0] w_io_rd_data;
wire w_io_ack;
wire w_dc_evict;
wire [31:0] w_dc_evict_addr;
wire [127:0] w_dc_evict_data;

//mem_conflict
wire [31:0] w_fifo_wr_addr0_start;
wire [31:0] w_fifo_wr_addr0_end;
wire [31:0] w_fifo_wr_addr1_start;
wire [31:0] w_fifo_wr_addr1_end;
wire [31:0] w_fifo_wr_addr2_start;
wire [31:0] w_fifo_wr_addr2_end;
wire [31:0] w_fifo_wr_addr3_start;
wire [31:0] w_fifo_wr_addr3_end;
wire [1:0] w_fifo_rd_ptr;

// assign w_ro_mem_conflict = 1'b0;
mem_conflict_gen u_w_ro_mem_conflict(
  .v_ro_mem_read            (w_v_ro_mem_read),
  .ro_mem_rd_addr_start     (w_ro_mem_rd_addr),
  .ro_mem_rd_addr_end       (w_ro_mem_rd_addr_end),
  .v_ex_ld_mem              (w_v_ex_ld_mem),
  .ex_mem_wr_addr_start     (r_ex_mem_wr_addr),
  .ex_mem_wr_addr_end       (r_ex_mem_wr_addr_end),
  .v_wb_ld_mem              (w_v_wb_ld_mem),
  .wb_mem_wr_addr_start     (r_wb_mem_wr_addr),
  .wb_mem_wr_addr_end       (r_wb_mem_wr_addr_end),
  .fifo_wr_addr0_start      (w_fifo_wr_addr0_start),
  .fifo_wr_addr0_end        (w_fifo_wr_addr0_end),
  .fifo_wr_addr1_start      (w_fifo_wr_addr1_start),
  .fifo_wr_addr1_end        (w_fifo_wr_addr1_end),
  .fifo_wr_addr2_start      (w_fifo_wr_addr2_start),
  .fifo_wr_addr2_end        (w_fifo_wr_addr2_end),
  .fifo_wr_addr3_start      (w_fifo_wr_addr3_start),
  .fifo_wr_addr3_end        (w_fifo_wr_addr3_end),
  .fifo_cnt                 (w_fifo_cnt),
  .fifo_rd_ptr              (w_fifo_rd_ptr),
  .mem_conflict             (w_ro_mem_conflict)
);

dcache u_dcache (
  .clk(clk), 
  .rst_n(rst_n), 
  .v_mem_read(w_v_ro_mem_read),
  .mem_conflict(w_ro_mem_conflict), 
  .wr_fifo_empty(w_fifo_empty), 
  .wr_fifo_to_be_full(w_fifo_to_be_full),
  .mem_rd_size(r_ro_mem_rd_size), 
  .mem_wr_size(w_fifo_mem_wr_size), 
  .mem_rd_addr(w_ro_mem_rd_addr), 
  .mem_wr_addr(w_fifo_mem_wr_addr), 
  .mem_rd_data(w_ro_mem_rd_data),
  .mem_wr_data(w_fifo_mem_wr_data), 
  .mem_rd_ready(w_ro_mem_rd_ready), 
  .mem_wr_done(w_mem_wr_done),
  .mem_rd_busy(w_mem_rd_busy), 
  .mem_wr_busy(w_mem_wr_busy), 
  .dc_miss(w_dc_miss), 
  .dc_miss_addr(w_dc_miss_addr), 
  .dc_data_fill(w_dc_data_fill), 
  .dc_miss_ack(w_dc_miss_ack), 
  .io_access(w_io_access), 
  .io_rw(w_io_rw), 
  .io_addr(w_io_addr), 
  .io_wr_data(w_io_wr_data), 
  .io_rd_data(w_io_rd_data), 
  .io_ack(w_io_ack), 
  .dc_evict(w_dc_evict), 
  .dc_evict_addr(w_dc_evict_addr), 
  .dc_evict_data(w_dc_evict_data), 
  .dc_rd_exp(w_dc_rd_exp), 
  .ld_ro(w_ld_ro)
  );

//MMU
mmu u_mmu( 
  .clk(clk), 
  .rst_n(rst_n), 
  .ic_miss(w_ic_miss), 
  .ic_miss_addr(w_ic_miss_addr), 
  .ic_data_fill(w_ic_data_fill), 
  .ic_miss_ack(w_ic_miss_ack), 
  .dc_miss(w_dc_miss), 
  .dc_miss_addr(w_dc_miss_addr), 
  .dc_data_fill(w_dc_data_fill), 
  .dc_miss_ack(w_dc_miss_ack), 
  .io_access(w_io_access), 
  .io_rw(w_io_rw), 
  .io_addr(w_io_addr), 
  .io_wr_data(w_io_wr_data), 
  .io_rd_data(w_io_rd_data), 
  .io_ack(w_io_ack), 
  .dc_evict(w_dc_evict), 
  .dc_evict_addr(w_dc_evict_addr), 
  .dc_evict_data(w_dc_evict_data), 
  .ld_ro(w_ld_ro), 
  .m_cyc(m_cyc), 
  .m_we(m_we), 
  .m_strb(m_strb), 
  .m_addr(m_addr), 
  .m_data_o(m_data_o), 
  .m_ack(m_ack), 
  .m_data_i(m_data_i)
  );

and2$ u_w_v_ro_mem_read ( .out(w_v_ro_mem_read), .in0(r_V_ro), .in1(r_ro_mem_read));
and2$ u_w_v_ro_ld_mem ( .out(w_v_ro_ld_mem),   .in0(r_V_ro), .in1(r_ro_ld_mem));

dc_exp_checker u_dc_exp_checker(
  .v_ro_mem_read       (w_v_ro_mem_read),
  .v_ro_ld_mem         (w_v_ro_ld_mem),
  .isr                 (r_ro_ISR),
  .mem_wr_addr         (w_ro_mem_wr_addr),
  .seg_wr_limit        ({12'h0,w_ro_seg_wr_limit}),
  .wr_addr_offset      (w_ro_wr_addr_offset),
  .mem_rd_addr         (w_ro_mem_rd_addr),
  .seg_rd_limit        ({12'h0,w_ro_seg_rd_limit}),
  .rd_addr_offset      (w_ro_rd_addr_offset),
  .dc_rd_exp           (w_dc_rd_exp),
  .dc_wr_exp           (/*Unused*/),
  .dc_exp              (w_dc_exp),
  .dc_prot_exp         (w_dc_prot_exp),
  .dc_page_fault       (w_dc_page_fault)
);

//RO dependency logic
ro_dep_v_ld_logic u_ro_dep_v_ld_logic(
  .V_ro               (r_V_ro),
  .eip_change         (r_ro_eip_change),
  .in3                (r_ro_in3),
  .in4                (r_ro_in4),
  .in3_needed         (r_ro_in3_needed),
  .in4_needed         (r_ro_in4_needed),
  .seg3               (r_ro_seg3),
  .seg3_needed        (r_ro_seg3_needed),
  .eax_needed         (r_ro_eax_needed),
  .ecx_needed         (r_ro_ecx_needed),
  .ex_dreg1           (r_ex_dreg1),
  .ex_dreg2           (r_ex_dreg2),
  .ex_dreg3           (r_ex_dreg3),
  .v_ex_ld_reg1       (w_v_ex_ld_reg1),
  .v_ex_ld_reg2       (w_v_ex_ld_reg2),
  .v_ex_ld_reg3       (w_v_ex_ld_reg3),
  .wb_dreg1           (r_wb_dreg1),
  .wb_dreg2           (r_wb_dreg2),
  .wb_dreg3           (r_wb_dreg3),
  .v_wb_ld_reg1       (w_v_wb_ld_reg1),
  .v_wb_ld_reg2       (w_v_wb_ld_reg2),
  .v_wb_ld_reg3       (w_v_wb_ld_reg3),
  .mm1                (r_ro_mm1),
  .mm2                (r_ro_mm2),
  .mm1_needed         (r_ro_mm1_needed),
  .mm2_needed         (r_ro_mm2_needed),
  .ex_dmm             (r_ex_dmm),
  .v_ex_ld_mm         (w_v_ex_ld_mm),
  .wb_dmm             (r_wb_dmm),
  .v_wb_ld_mm         (w_v_wb_ld_mm),
  .ex_dseg            (r_ex_dseg),
  .v_ex_ld_seg        (w_v_ex_ld_seg),
  .wb_dseg            (r_wb_dseg),
  .v_wb_ld_seg        (w_v_wb_ld_seg),
  .ex_dep_stall       (w_ex_dep_stall),
  .wb_mem_stall       (w_wb_mem_stall),
  .mem_rd_busy        (w_mem_rd_busy),
  .cmps_stall         (w_ro_cmps_stall),
  .dc_exp             (w_dc_exp),

  .ld_reg1            (r_ro_ld_reg1),
  .ld_reg2            (r_ro_ld_reg2),
  .ld_reg3            (r_ro_ld_reg3),
  .ld_flag_ZF         (r_ro_ld_flag_ZF),
  .ld_seg             (r_ro_ld_seg),
  .v_ro_ld_reg1       (w_v_ro_ld_reg1),
  .v_ro_ld_reg2       (w_v_ro_ld_reg2),
  .v_ro_ld_reg3       (w_v_ro_ld_reg3),
  .v_ro_ld_flag_ZF    (w_v_ro_ld_flag_ZF),
  .v_ro_ld_seg        (w_v_ro_ld_seg),

  .dep_stall          (w_ro_dep_stall),
  .br_stall           (w_ro_br_stall),
  .stall_ro           (w_stall_ro),
  .V_ex               (w_V_ex_next),
  .ld_ex              (w_ld_ex)
);

//w_fifo_to_be_full
wire [1:0] w_ro_add_ldmem_exwb;
xor2$  u_w_ro_add_ldmem_exwb0 (.out(w_ro_add_ldmem_exwb[0]), .in0(w_v_ex_ld_mem), .in1(w_v_wb_ld_mem));
and2$  u_w_ro_add_ldmem_exwb1 (.out(w_ro_add_ldmem_exwb[1]), .in0(w_v_ex_ld_mem), .in1(w_v_wb_ld_mem));
wire [2:0] w_ro_add_ldmem_exwbfifo;
adder3bit u_w_ro_add_ldmem_exwbfifo (.a({1'b0,w_ro_add_ldmem_exwb}), .b(w_fifo_cnt), .sum(w_ro_add_ldmem_exwbfifo));

assign w_fifo_to_be_full = w_ro_add_ldmem_exwbfifo[2];

//imm_out
wire [31:0] w_ro_imm_out;
wire t_imm8,t_imm16;
assign t_imm8 = r_ro_imm_rel_ptr32[7];
assign t_imm16 = r_ro_imm_rel_ptr32[15];
mux_nbit_4x1 u_w_ro_imm_out (
  .a0({t_imm8,t_imm8,t_imm8,t_imm8,t_imm8,
       t_imm8,t_imm8,t_imm8,t_imm8,t_imm8,
       t_imm8,t_imm8,t_imm8,t_imm8,t_imm8,
       t_imm8,t_imm8,t_imm8,t_imm8,t_imm8,
       t_imm8,t_imm8,t_imm8,t_imm8,r_ro_imm_rel_ptr32[7:0] }), 
  .a1({t_imm16,t_imm16,t_imm16,t_imm16,t_imm16,
       t_imm16,t_imm16,t_imm16,t_imm16,t_imm16,
       t_imm16,t_imm16,t_imm16,t_imm16,t_imm16,
       t_imm16,r_ro_imm_rel_ptr32[15:0] }), 
  .a2(r_ro_imm_rel_ptr32), 
  .a3(32'h1), .sel(r_ro_imm_sel), 
  .out(w_ro_imm_out)
);

//eip_eflag_out
wire [31:0] w_eip_eflag_out;
mux_nbit_2x1 u_w_eip_eflag_out (.a0(r_ro_EIP_next), .a1(r_EFLAGS), .sel(r_ro_EIP_EFLAGS_sel), .out(w_eip_eflag_out));


//SR1
wire [31:0] w_ro_out3_shift_muxed;
mux_nbit_2x1 u_w_ro_out3_shift_muxed (.a0(r_ro_reg_out3), .a1({8'h0,r_ro_reg_out3[31:8]}), .sel(r_ro_reg8_sr1_HL_sel), .out(w_ro_out3_shift_muxed));
mux_nbit_4x1 u_w_ro_sr1 (.a0(w_ro_out3_shift_muxed), .a1(w_eip_eflag_out), .a2(/*Unused*/), .a3(w_ro_mem_rd_data[31:0]), .sel(r_ro_sr1_sel), .out(w_ro_sr1));

//SR2
wire [31:0] w_ro_out4_shift_muxed;
mux_nbit_2x1 u_w_ro_out4_shift_muxed (.a0(r_ro_reg_out4), .a1({8'h0,r_ro_reg_out4[31:8]}), .sel(r_ro_reg8_sr2_HL_sel), .out(w_ro_out4_shift_muxed));
mux_nbit_4x1 u_w_ro_sr2 (.a0(w_ro_out4_shift_muxed), .a1({16'h0,r_ro_seg_data3}), .a2(w_ro_imm_out), .a3(w_ro_mem_rd_data[31:0]), .sel(r_ro_sr2_sel), .out(w_ro_sr2));

//MM_SR1
mux_nbit_4x1 #64 u_w_ro_mm_sr1 (.a0(r_ro_mm_data1), .a1(w_ro_mem_rd_data), .a2({16'h0,r_ro_CS_curr,r_ro_EIP_next}), .a3({16'h0,w_CS_saved,w_EIP_saved}), .sel({r_ro_mm_sr1_sel_H,r_ro_mm_sr1_sel_L}), .out(w_ro_mm_sr1));

//MM_SR2
mux_nbit_2x1 #64 u_w_ro_mm_sr2 (.a0(r_ro_mm_data2), .a1(w_ro_mem_rd_data), .sel(r_ro_mm_sr2_sel), .out(w_ro_mm_sr2));

//cmps_flag
wire w_cmps_flag_in1;
wire w_cmps_flag_in2;
wire w_cmps_flag_in;
wire r_cmps_flag;
wire r_cmps_flag_bar;

and2$ u_w_cmps_flag_in1 (.out(w_cmps_flag_in1), .in0(w_ro_mem_rd_ready), .in1(r_ro_cmps_op));
nand2$ u_w_cmps_flag_in2 (.out(w_cmps_flag_in2), .in0(w_ro_mem_rd_ready), .in1(w_ld_ro));      

mux2$ u_mux(.outb(w_cmps_flag_in),.in0(w_cmps_flag_in1),.in1(w_cmps_flag_in1),.s0(w_cmps_flag_in));
dff$  u_reg(.r(rst_n),.s(1'b1),.clk(clk),.d(w_cmps_flag_in),.q(r_cmps_flag),.qbar(r_cmps_flag_bar));

and4$ u_w_ro_cmps_stall (.out(w_ro_cmps_stall), .in0(r_ro_cmps_op), .in1(r_cmps_flag_bar), .in2(w_ro_mem_rd_ready), .in3(r_V_ro));

//mem_out and mem_out_latched
wire w_ro_ld_mem_latched;
and3$ u_w_ro_ld_mem_latched (.out(w_ro_ld_mem_latched), .in0(r_ro_cmps_op), .in1(r_cmps_flag_bar), .in2(w_ro_mem_rd_ready));

assign w_ro_mem_out = w_ro_mem_rd_data[31:0];
register #32 u_w_ro_mem_out_latched (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_ro_mem_rd_data[31:0]), .data_o(w_ro_mem_out_latched), .ld(w_ro_ld_mem_latched));

//mem wr addr/limit/offset
mux_nbit_2x1 u_w_ro_mem_wr_addr     (.a0(r_ro_addr1), .a1(r_ro_addr2), .sel(r_ro_wr_mem_addr_sel), .out(w_ro_mem_wr_addr));
mux_nbit_2x1 u_w_ro_mem_wr_addr_end (.a0(r_ro_addr1_end_wr), .a1(r_ro_addr2_end_wr), .sel(r_ro_wr_mem_addr_sel), .out(w_ro_mem_wr_addr_end));
mux_nbit_2x1 #20 u_w_ro_seg_wr_limit (.a0(r_ro_seg1_limit), .a1(r_ro_seg2_limit), .sel(r_ro_wr_mem_addr_sel), .out(w_ro_seg_wr_limit));
mux_nbit_2x1 u_w_ro_wr_addr_offset (.a0(r_ro_addr1_offset), .a1(r_ro_addr2_offset), .sel(r_ro_wr_mem_addr_sel), .out(w_ro_wr_addr_offset));

//mem rd addr/limit/offset
mux2$ u_w_ro_rd_mem_addr_sel (.outb(w_ro_rd_mem_addr_sel), .in0(r_ro_mem_rd_addr_sel), .in1(r_cmps_flag), .s0(r_ro_cmps_op));

mux_nbit_2x1 u_w_ro_mem_rd_addr     (.a0(r_ro_addr1), .a1(r_ro_addr2), .sel(w_ro_rd_mem_addr_sel), .out(w_ro_mem_rd_addr));
mux_nbit_2x1 u_w_ro_mem_rd_addr_end (.a0(r_ro_addr1_end_rd), .a1(r_ro_addr2_end_rd), .sel(w_ro_rd_mem_addr_sel), .out(w_ro_mem_rd_addr_end));
mux_nbit_2x1 #20 u_w_ro_seg_rd_limit (.a0(r_ro_seg1_limit), .a1(r_ro_seg2_limit), .sel(w_ro_rd_mem_addr_sel), .out(w_ro_seg_rd_limit));
mux_nbit_2x1 u_w_ro_rd_addr_offset (.a0(r_ro_addr1_offset), .a1(r_ro_addr2_offset), .sel(w_ro_rd_mem_addr_sel), .out(w_ro_rd_addr_offset));

//Newly generated RO to WB signals latching
register #32 u_r_ex_ECX             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_ECX            ), .data_o(r_ex_ECX            ));
register #32 u_r_ex_EAX             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_EAX            ), .data_o(r_ex_EAX            ));
register #32 u_r_ex_sr1             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_sr1            ), .data_o(r_ex_sr1            ));
register #32 u_r_ex_sr2             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_sr2            ), .data_o(r_ex_sr2            ));
register #64 u_r_ex_mm_sr1          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mm_sr1         ), .data_o(r_ex_mm_sr1         ));
register #64 u_r_ex_mm_sr2          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mm_sr2         ), .data_o(r_ex_mm_sr2         ));
register #32 u_r_ex_mem_out         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mem_out        ), .data_o(r_ex_mem_out        ));
register #32 u_r_ex_mem_out_latched (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mem_out_latched), .data_o(r_ex_mem_out_latched));
register #32 u_r_ex_mem_wr_addr     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mem_wr_addr    ), .data_o(r_ex_mem_wr_addr));
register #32 u_r_ex_mem_wr_addr_end (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_ro_mem_wr_addr_end), .data_o(r_ex_mem_wr_addr_end));
register #1  u_V_ex                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_ex), .data_i(w_V_ex_next),          .data_o(r_V_ex));

// ***************** EXECUTE STAGE ******************                          

//Just getting passed to WB:
register #3         u_r_wb_dreg1               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_dreg1),                 .data_o(r_wb_dreg1));
register #3         u_r_wb_dreg2               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_dreg2),                 .data_o(r_wb_dreg2));
register #3         u_r_wb_dreg3               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_dreg3),                 .data_o(r_wb_dreg3));
register #1         u_r_wb_ld_reg1             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg1),               .data_o(r_wb_ld_reg1));
register #1         u_r_wb_ld_reg2             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg2),               .data_o(r_wb_ld_reg2));
register #1         u_r_wb_ld_reg3             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg3),               .data_o(r_wb_ld_reg3));
register #4         u_r_wb_ld_reg1_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg1_strb),          .data_o(r_wb_ld_reg1_strb));
register #4         u_r_wb_ld_reg2_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg2_strb),          .data_o(r_wb_ld_reg2_strb));
register #4         u_r_wb_ld_reg3_strb        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_reg3_strb),          .data_o(r_wb_ld_reg3_strb));
register #1         u_r_wb_reg8_sr1_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_reg8_sr1_HL_sel),       .data_o(r_wb_reg8_sr1_HL_sel));
register #1         u_r_wb_reg8_sr2_HL_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_reg8_sr2_HL_sel),       .data_o(r_wb_reg8_sr2_HL_sel));
register #1         u_r_wb_ld_mm               (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_mm),                 .data_o(r_wb_ld_mm));
register #3         u_r_wb_dmm                 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_dmm),                   .data_o(r_wb_dmm));
register #1         u_r_wb_ld_seg              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_seg),                .data_o(r_wb_ld_seg));
register #3         u_r_wb_dseg                (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_dseg),                  .data_o(r_wb_dseg));
register #1         u_r_wb_ld_mem              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_mem),                .data_o(r_wb_ld_mem));
register #2         u_r_wb_mem_wr_size         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_mem_wr_size),           .data_o(r_wb_mem_wr_size));
register #1         u_r_wb_eip_change          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_eip_change),            .data_o(r_wb_eip_change));
register #1         u_r_wb_cmps_op             (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_cmps_op),               .data_o(r_wb_cmps_op));
register #1         u_r_wb_cxchg_op            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_cxchg_op),              .data_o(r_wb_cxchg_op));
register #1         u_r_wb_pr_size_over        (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_pr_size_over),          .data_o(r_wb_pr_size_over));
register #32        u_r_wb_EIP_next            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_EIP_next),              .data_o(r_wb_EIP_next));
register #1         u_r_wb_CF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_CF_expected),           .data_o(r_wb_CF_expected));
register #1         u_r_wb_ZF_expected         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ZF_expected),           .data_o(r_wb_ZF_expected));
register #1         u_r_wb_cond_wr_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_cond_wr_CF),            .data_o(r_wb_cond_wr_CF));
register #1         u_r_wb_cond_wr_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_cond_wr_ZF),            .data_o(r_wb_cond_wr_ZF));
register #1         u_r_wb_wr_reg1_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_wr_reg1_data_sel),      .data_o(r_wb_wr_reg1_data_sel));
register #1         u_r_wb_wr_reg2_data_sel    (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_wr_reg2_data_sel),      .data_o(r_wb_wr_reg2_data_sel));
register #2         u_r_wb_wr_seg_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_wr_seg_data_sel),       .data_o(r_wb_wr_seg_data_sel));
register #1         u_r_wb_wr_eip_alu_res_sel  (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_wr_eip_alu_res_sel),    .data_o(r_wb_wr_eip_alu_res_sel));
register #2         u_r_wb_wr_mem_data_sel     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_wr_mem_data_sel),       .data_o(r_wb_wr_mem_data_sel));
register #1         u_r_wb_ld_flag_DF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ld_flag_DF),            .data_o(r_wb_ld_flag_DF));
register #16        u_r_wb_ptr_CS              (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_ptr_CS),                .data_o(r_wb_ptr_CS));
register #32        u_r_wb_mem_wr_addr         (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_mem_wr_addr),           .data_o(r_wb_mem_wr_addr));
register #32        u_r_wb_mem_wr_addr_end     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(r_ex_mem_wr_addr_end),       .data_o(r_wb_mem_wr_addr_end));

//EX generates these:
wire [31:0] w_ex_alu_res1;
wire [31:0] w_ex_alu_res2;
wire [63:0] w_ex_alu_res3;
wire  [5:0] w_ex_alu1_flags;
wire  [5:0] w_ex_cmps_flags;
wire        w_ex_df_val_ex;
wire        w_ex_ld_flag_CF;
wire        w_ex_ld_flag_PF;
wire        w_ex_ld_flag_AF;
wire        w_ex_ld_flag_ZF;
wire        w_ex_ld_flag_SF;
wire        w_ex_ld_flag_OF;

alu1 u_alu1(
  .sr1                 (r_ex_sr1), 
  .sr2                 (r_ex_sr2), 
  .mem_out             (r_ex_mem_out), 
  .mem_out_latched     (r_ex_mem_out_latched), 
  .eax                 (r_ex_EAX), 
  .alu1_op             (r_ex_alu1_op),
  .alu1_op_size        (r_ex_alu1_op_size),
  .mem_rd_size         (r_ex_mem_rd_size),
  .CF_in               (r_EFLAGS[CF]),
  .AF_in               (r_EFLAGS[AF]),
  .DF_in               (r_EFLAGS[DF]),
  .df_val              (r_ex_df_val),
  .ISR                 (r_ex_ISR),
  .ld_flag_CF_in       (r_ex_ld_flag_CF),
  .ld_flag_PF_in       (r_ex_ld_flag_PF),
  .ld_flag_AF_in       (r_ex_ld_flag_AF),
  .ld_flag_ZF_in       (r_ex_ld_flag_ZF),
  .ld_flag_SF_in       (r_ex_ld_flag_SF),
  .ld_flag_OF_in       (r_ex_ld_flag_OF),

  .alu_res1            (w_ex_alu_res1), 
  .alu1_flags          (w_ex_alu1_flags),
  .cmps_flags          (w_ex_cmps_flags),
  .df_val_ex           (w_ex_df_val_ex),
  .ld_flag_CF          (w_ex_ld_flag_CF),
  .ld_flag_PF          (w_ex_ld_flag_PF),
  .ld_flag_AF          (w_ex_ld_flag_AF),
  .ld_flag_ZF          (w_ex_ld_flag_ZF),
  .ld_flag_SF          (w_ex_ld_flag_SF),
  .ld_flag_OF          (w_ex_ld_flag_OF)
);

alu2 u_alu2(
  .EIP_next     (r_ex_EIP_next),
  .sr1          (r_ex_sr1),
  .sr2          (r_ex_sr2),
  .esp          (r_ex_ESP),
  .mem_rd_size  (r_ex_mem_rd_size),
  .mem_wr_size  (r_ex_mem_wr_size),
  .alu2_op      (r_ex_alu2_op),
  .DF_in        (r_EFLAGS[DF]),
  .alu_res2     (w_ex_alu_res2)
);

alu3 u_alu_3(
  .mm1       (r_ex_mm_sr1),
  .mm2       (r_ex_mm_sr2),
  .sr2       (r_ex_sr2),
  .ecx       (r_ex_ECX),
  .alu3_op   (r_ex_alu3_op),
  .alu_res3  (w_ex_alu_res3)  
);

//EX dependency logic
ex_dep_v_ld_logic u_ex_dep_v_ld_logic(
  .V_ex               (r_V_ex),
  .eip_change         (r_ex_eip_change),
  .AF_needed          (r_ex_AF_needed),
  .DF_needed          (r_ex_DF_needed),
  .CF_needed          (r_ex_CF_needed),
  .v_wb_ld_flag_AF    (w_v_wb_ld_flag_AF),
  .v_wb_ld_flag_DF    (w_v_wb_ld_flag_DF),
  .v_wb_ld_flag_CF    (w_v_wb_ld_flag_CF),
  .wb_mem_stall       (w_wb_mem_stall),

  .ld_reg1            (r_ex_ld_reg1),
  .ld_reg2            (r_ex_ld_reg2),
  .ld_reg3            (r_ex_ld_reg3),
  .ld_flag_ZF         (r_ex_ld_flag_ZF),
  .ld_seg             (r_ex_ld_seg),
  .ld_mm              (r_ex_ld_mm),
  .ld_mem             (r_ex_ld_mem),
  .v_ro_ld_reg1       (w_v_ex_ld_reg1),
  .v_ro_ld_reg2       (w_v_ex_ld_reg2),
  .v_ro_ld_reg3       (w_v_ex_ld_reg3),
  .v_ro_ld_flag_ZF    (w_v_ex_ld_flag_ZF),
  .v_ro_ld_seg        (w_v_ex_ld_seg),
  .v_ro_ld_mm         (w_v_ex_ld_mm),
  .v_ro_ld_mem        (w_v_ex_ld_mem),

  .dep_stall          (w_ex_dep_stall),
  .br_stall           (w_ex_br_stall),
  .V_wb               (w_V_wb_next),
  .ld_wb              (w_ld_wb)
);

// FIXME
//Valid loads etc
assign w_v_ex_ld_mem = r_V_ex & r_ex_ld_mem;

//Newly generated EX to WB signals latching
register #32         u_r_wb_alu_res1            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_alu_res1  ),            .data_o(r_wb_alu_res1  ));
register #32         u_r_wb_alu_res2            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_alu_res2  ),            .data_o(r_wb_alu_res2  ));
register #64         u_r_wb_alu_res3            (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_alu_res3  ),            .data_o(r_wb_alu_res3  ));
register  #6         u_r_wb_alu1_flags          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_alu1_flags),            .data_o(r_wb_alu1_flags));
register  #6         u_r_wb_cmps_flags          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_cmps_flags),            .data_o(r_wb_cmps_flags));
register  #1         u_r_wb_df_val_ex           (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_df_val_ex ),            .data_o(r_wb_df_val_ex ));
register #1          u_r_wb_ld_flag_CF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_CF),            .data_o(r_wb_ld_flag_CF));
register #1          u_r_wb_ld_flag_PF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_PF),            .data_o(r_wb_ld_flag_PF));
register #1          u_r_wb_ld_flag_AF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_AF),            .data_o(r_wb_ld_flag_AF));
register #1          u_r_wb_ld_flag_ZF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_ZF),            .data_o(r_wb_ld_flag_ZF));
register #1          u_r_wb_ld_flag_SF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_SF),            .data_o(r_wb_ld_flag_SF));
register #1          u_r_wb_ld_flag_OF          (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_ex_ld_flag_OF),            .data_o(r_wb_ld_flag_OF));
register #1          u_V_wb                     (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .ld(w_ld_wb), .data_i(w_V_wb_next),                .data_o(r_V_wb));

// ***************** WRITEBACK STAGE ******************

//REGISTER WRITEBACK
//wr_reg_data
wire [31:0] w_wb_alu_res1_shift_muxed_sr1;
mux_nbit_2x1 u_w_wb_alu_res1_shift_muxed_sr1 (.a0(r_wb_alu_res1), .a1({r_wb_alu_res1[23:0],8'h0}), .sel(r_wb_reg8_sr1_HL_sel), .out(w_wb_alu_res1_shift_muxed_sr1));
mux_nbit_2x1 u_w_wb_wr_reg_data1 (.a0(w_wb_alu_res1_shift_muxed_sr1), .a1(r_wb_alu_res2), .sel(r_wb_wr_reg1_data_sel), .out(w_wb_wr_reg_data1));

wire [31:0] w_wb_alu_res1_shift_muxed_sr2;
mux_nbit_2x1 u_w_wb_alu_res1_shift_muxed_sr2 (.a0(r_wb_alu_res1), .a1({r_wb_alu_res1[23:0],8'h0}), .sel(r_wb_reg8_sr2_HL_sel), .out(w_wb_alu_res1_shift_muxed_sr2));
mux_nbit_2x1 u_w_wb_wr_reg_data2 (.a0(w_wb_alu_res1_shift_muxed_sr2), .a1(r_wb_alu_res2), .sel(r_wb_wr_reg2_data_sel), .out(w_wb_wr_reg_data2));

assign w_wb_wr_reg_data3 = r_wb_alu_res3[31:0];

//SEGMENT WRITEBACK
//wr_seg_data
wire [15:0] w_wb_segdata_alu_res3;
mux_nbit_2x1 #16 u_w_wb_segdata_alu_res3 (.a0(r_wb_alu_res3[47:32]), .a1(r_wb_alu_res3[31:16]), .sel(r_wb_pr_size_over), .out(w_wb_segdata_alu_res3));
mux_nbit_4x1 #16 u_w_wb_wr_seg_data (.a0(r_wb_alu_res1[15:0]), .a1(r_wb_alu_res2[15:0]), .a2(w_wb_segdata_alu_res3), .a3(r_wb_ptr_CS), .sel(r_wb_wr_seg_data_sel), .out(w_wb_wr_seg_data));

//MEMORY WRITEBACK
mux_nbit_4x1 #64 u_w_wb_mem_wr_data (.a0({32'h0,r_wb_alu_res1}), .a1({32'h0,r_wb_alu_res2}), .a2(r_wb_alu_res3), .a3(/*Unused*/), .sel(r_wb_wr_mem_data_sel), .out(w_wb_mem_wr_data));

//Flags
wire [5:0] w_wb_flags6;
mux_nbit_2x1 #6 u_w_wb_flags6 (.a0(r_wb_alu1_flags), .a1(r_wb_cmps_flags), .sel(r_wb_cmps_op), .out(w_wb_flags6));

register #1 u_r_CF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[0]), .data_o(r_EFLAGS[CF]), .ld(r_wb_ld_flag_CF));
register #1 u_r_PF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[1]), .data_o(r_EFLAGS[PF]), .ld(r_wb_ld_flag_PF));
register #1 u_r_AF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[2]), .data_o(r_EFLAGS[AF]), .ld(r_wb_ld_flag_AF));
register #1 u_r_ZF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[3]), .data_o(r_EFLAGS[ZF]), .ld(r_wb_ld_flag_ZF));
register #1 u_r_SF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[4]), .data_o(r_EFLAGS[SF]), .ld(r_wb_ld_flag_SF));
register #1 u_r_0F (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_wb_flags6[5]), .data_o(r_EFLAGS[OF]), .ld(r_wb_ld_flag_OF));
register #1 u_r_DF (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(r_wb_df_val_ex), .data_o(r_EFLAGS[DF]), .ld(r_wb_ld_flag_DF));

register #5 u_r_flag13589 (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(5'b0), .data_o({r_EFLAGS[9],r_EFLAGS[8],r_EFLAGS[5],r_EFLAGS[3],r_EFLAGS[1]}), .ld(1'b0));
register #20 u_r_flag_others (.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(20'h0), .data_o(r_EFLAGS[31:12]), .ld(1'b0));

writeback_loads_gen u_writeback_loads_gen (
  .V_wb                  (r_V_wb),
  .CF_expected           (r_wb_CF_expected),
  .cond_wr_CF            (r_wb_cond_wr_CF),
  .CF_flag               (r_EFLAGS[CF]),
  .cxchg_op              (r_wb_cxchg_op),
  .ZF_new                (w_wb_flags6[3]),
  .ld_mem                (r_wb_ld_mem),
  .ld_seg                (r_wb_ld_seg),
  .ld_mm                 (r_wb_ld_mm),
  .ld_reg1               (r_wb_ld_reg1),
  .ld_reg2               (r_wb_ld_reg2),
  .ld_reg3               (r_wb_ld_reg3),
  .ld_reg1_strb          (r_wb_ld_reg1_strb),
  .ld_reg2_strb          (r_wb_ld_reg2_strb),
  .ld_reg3_strb          (r_wb_ld_reg3_strb),
  .ld_flag_ZF            (r_wb_ld_flag_ZF),
  .ld_flag_AF            (r_wb_ld_flag_AF),
  .ld_flag_DF            (r_wb_ld_flag_DF),
  .ld_flag_CF            (r_wb_ld_flag_CF),
  .eip_change            (r_wb_eip_change),

  .br_stall              (w_wb_br_stall),
  .v_wb_ld_reg1_strb     (w_v_wb_ld_reg1_strb),
  .v_wb_ld_reg2_strb     (w_v_wb_ld_reg2_strb),
  .v_wb_ld_reg3_strb     (w_v_wb_ld_reg3_strb),
  .v_wb_ld_reg1          (w_v_wb_ld_reg1),
  .v_wb_ld_reg2          (w_v_wb_ld_reg2),
  .v_wb_ld_reg3          (w_v_wb_ld_reg3),
  .v_wb_ld_mm            (w_v_wb_ld_mm),
  .v_wb_ld_seg           (w_v_wb_ld_seg),
  .v_wb_ld_mem           (w_v_wb_ld_mem),
  .v_wb_ld_flag_ZF       (w_v_wb_ld_flag_ZF),
  .v_wb_ld_flag_AF       (w_v_wb_ld_flag_AF),
  .v_wb_ld_flag_DF       (w_v_wb_ld_flag_DF),
  .v_wb_ld_flag_CF       (w_v_wb_ld_flag_CF)
  
);

//wb_mem_stall
and2$ u_w_wb_mem_stall (.in0(r_V_wb), .in1(w_fifo_full), .out(w_wb_mem_stall)); 

//Wr FIFO
wr_fifo u_wr_fifo(
  .clk                (clk),
  .rst_n              (rst_n),
  .wr                 (w_v_wb_ld_mem),
  .rd                 (w_mem_wr_done),
  .wr_data            ({r_wb_mem_wr_size, r_wb_mem_wr_addr_end, r_wb_mem_wr_addr, w_wb_mem_wr_data}),// FIXME am i right? w_wb_mem_wr_addr replaced by r_wb_mem_wr_addr
  .rd_data            ({w_fifo_mem_wr_size, w_fifo_mem_wr_addr_end, w_fifo_mem_wr_addr, w_fifo_mem_wr_data}),
  .fifo_empty         (w_fifo_empty),
  .fifo_full          (w_fifo_full),
  .fifo_empty_bar     (w_fifo_empty_bar),
  .fifo_full_bar      (w_fifo_full_bar),
  .fifo_cnt           (w_fifo_cnt),
  .fifo_wr_addr0_start      (w_fifo_wr_addr0_start),
  .fifo_wr_addr0_end        (w_fifo_wr_addr0_end),
  .fifo_wr_addr1_start      (w_fifo_wr_addr1_start),
  .fifo_wr_addr1_end        (w_fifo_wr_addr1_end),
  .fifo_wr_addr2_start      (w_fifo_wr_addr2_start),
  .fifo_wr_addr2_end        (w_fifo_wr_addr2_end),
  .fifo_wr_addr3_start      (w_fifo_wr_addr3_start),
  .fifo_wr_addr3_end        (w_fifo_wr_addr3_end),
  .fifo_rd_ptr              (w_fifo_rd_ptr)
);

// ***************** INTERRUPT EXCEPTION FSM ******************
intexp u_int_exp (
  .clk               (clk),
  .rst_n             (rst_n),
  .iret_op           (w_de_iret_op),
  .int               (int),
  .ic_exp            (w_ic_exp),
  .dc_exp            (w_dc_exp),
  .end_bit           (w_rseq_end_bit),
  .v_de              (r_V_de),
  .v_ag              (r_V_ag),
  .v_ro              (r_V_ro),
  .v_ex              (r_V_ex),
  .v_wb              (r_V_wb),
  .fifo_empty_bar    (w_fifo_empty_bar),
  .ld_ro             (w_ld_ro),
  .dc_prot_exp       (w_dc_prot_exp),
  .dc_page_fault     (w_dc_page_fault),
  .ic_prot_exp       (w_ic_prot_exp),
  .ic_page_fault     (w_ic_page_fault),
  .eip_reg           (r_EIP),
  .cs_reg            (r_CS),
  .eip_ro_reg        (r_ro_EIP_curr),
  .cs_ro_reg         (r_ro_CS_curr),
  .idt_addr          (w_IDT_address),
  .int_clear         (int_clear),
  .rseq_addr         (w_rseq_addr),
  .eip_saved         (w_EIP_saved),
  .cs_saved          (w_CS_saved),
  .block_ic_ren      (w_block_ic_ren),
  .rseq_mux_sel      (w_rseq_mux_sel)
);

endmodule
