/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Interrupt and exception handler              */
/* Description: FSM saves generates int or exp vector,  */
/* saves consistent state, loads IP & handles IRET.     */
/********************************************************/

module intexp (clk, rst_n, iret_op, int, ic_exp, dc_exp, end_bit, v_de, v_ag, v_ro, 
               v_ex, v_wb, fifo_empty_bar, ld_ag, dc_prot_exp, dc_page_fault, 
               ic_prot_exp, ic_page_fault, eip_reg, cs_reg, eip_ro_reg, cs_ro_reg, idt_addr,
               int_clear, rseq_addr, eip_saved, cs_saved, block_ic_ren, rseq_mux_sel);

input         clk;
input         rst_n;
input         iret_op;
input         int;
input         ic_exp;
input         dc_exp;
input         end_bit;
input         v_de;
input         v_ag;
input         v_ro;
input         v_ex;
input         v_wb;
input         fifo_empty_bar;
input         ld_ag;
input         dc_prot_exp;
input         dc_page_fault;
input         ic_prot_exp;
input         ic_page_fault;
input  [31:0] eip_reg;
input  [15:0] cs_reg;
input  [31:0] eip_ro_reg;
input  [15:0] cs_ro_reg;
output [31:0]  idt_addr;
output        int_clear;
output [2:0]  rseq_addr;
output [31:0] eip_saved;
output [15:0] cs_saved;
output        block_ic_ren;
output        rseq_mux_sel;

// Internal Variables

wire [31:0] w_temp0, w_temp1, w_temp2, w_temp3;
wire [47:0] w_cs_eip_temp;
wire [1:0] r_rseq_addr, w_rseq_addr_inc;
wire [2:0] w_curr_st;
wire       w_curr_st_eq_rseq, w_ld_rseq_addr;

// Generate IDT addr and ld_vec

muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_1(.IN0(32'h0000_2010), .IN1(32'h0000_2070), .S0(ic_page_fault), .Y(w_temp0));
muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_2(.IN0(w_temp0), .IN1(32'h0000_2068), .S0(ic_prot_exp), .Y(w_temp1));
muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_3(.IN0(w_temp1), .IN1(32'h0000_2070), .S0(dc_page_fault), .Y(w_temp2));
muxNbit_2x1 #(.N(32)) u_muxNbit_2x1_4(.IN0(w_temp2), .IN1(32'h0000_2068), .S0(dc_prot_exp), .Y(w_temp3));
register #(.N(32)) u_idt_addr_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_temp3), .data_o(idt_addr), .ld(w_ld_vec));

or3$ u_or3_1(.out(n_101), .in0(dc_page_fault), .in1(ic_page_fault), .in2(int));
or3$ u_or3_2(.out(w_ld_vec), .in0(n_101), .in1(dc_prot_exp), .in2(ic_prot_exp));

// Save CS and EIP from the pipeline stage where exception occurs

muxNbit_2x1 #(.N(32+16)) u_muxNbit_2x1_5(.IN0({cs_reg,eip_reg}), .IN1({cs_ro_reg,eip_ro_reg}), .S0(dc_exp), .Y(w_cs_eip_temp));
register #(.N(32+16)) u_cs_eip_saved_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_cs_eip_temp), .data_o({cs_saved,eip_saved}), .ld(w_ld_vec));

// rseq_addr generation

assign rseq_addr = {w_curr_st[0],r_rseq_addr};

and2$ u_and2_1(.out(w_curr_st_eq_rseq), .in0(w_curr_st[2]), .in1(w_curr_st[1]));
and2$ u_and2_2(.out(w_ld_rseq_addr), .in0(ld_ag), .in1(w_curr_st_eq_rseq));

register #(.N(2)) u_rseq_addr_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_rseq_addr_inc), .data_o(r_rseq_addr), .ld(w_ld_rseq_addr));

adder2bit u_rseq_addr_adder(.a(r_rseq_addr), .b(2'd1), .sum(w_rseq_addr_inc));

// Interrupt and exception handling fsm
intexp_fsm u_int_exp(
  .clk(clk),
  .rst_n(rst_n),
  .int_clear(int_clear),
  .block_ic_ren(block_ic_ren),
  .rseq_mux_sel(rseq_mux_sel),
  .iret_op(iret_op),
  .int(int), 
  .ic_exp(ic_exp), 
  .dc_exp(dc_exp), 
  .end_bit(end_bit), 
  .v_de(v_de), 
  .v_ag(v_ag), 
  .v_ro(v_ro),
  .v_ex(v_ex), 
  .v_wb(v_wb), 
  .fifo_empty_bar(fifo_empty_bar),
  .curr_st(w_curr_st)
  );

endmodule

