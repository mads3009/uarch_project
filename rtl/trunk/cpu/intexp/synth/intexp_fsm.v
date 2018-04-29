/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Interrupt and exception fsm                  */
/********************************************************/

module intexp_fsm (clk, rst_n, ld_ag, iret_op, int, ic_exp, dc_exp, end_bit, v_de, v_ag, v_ro, 
                   v_ex, v_wb, fifo_empty_bar, int_clear, block_ic_ren, rseq_mux_sel, curr_st);

input        clk;
input        rst_n;
input        ld_ag;
input        iret_op;
input        int;
input        ic_exp;
input        dc_exp;
input        end_bit;
input        v_de;
input        v_ag;
input        v_ro;
input        v_ex;
input        v_wb;
input        fifo_empty_bar;
output       int_clear;
output       block_ic_ren;
output       rseq_mux_sel;
output [2:0] curr_st;

// Internal Variables
localparam IDLE        = 3'd0;
localparam WAIT_INTEXP = 3'd1;
localparam WAIT_IRET   = 3'd2;
localparam RSEQ1       = 3'd6;
localparam RSEQ2       = 3'd7;
localparam DONE        = 3'd3;

wire w_all_valids_zero;
reg [2:0] curr_st, next_st;

// output assign statements
assign int_clear = int & (curr_st == DONE);
assign rseq_mux_sel = curr_st[2] & curr_st[1];
assign block_ic_ren = curr_st != IDLE;

assign w_all_valids_zero = !(v_de | v_ag | v_ro | v_ex | v_wb | fifo_empty_bar);

// fsm
always @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    curr_st <= IDLE;
  else
    curr_st <= next_st; 
end

always @(*) begin
  case(curr_st)
  IDLE: begin
    if(iret_op)
      next_st = WAIT_IRET;
    else if(ic_exp | dc_exp | int)
      next_st = WAIT_INTEXP;
    else
      next_st = IDLE;
  end
  WAIT_INTEXP: begin
    if(w_all_valids_zero)
      next_st = RSEQ1;
    else
      next_st = WAIT_INTEXP;
  end
  WAIT_IRET: begin
    if(w_all_valids_zero)
      next_st = RSEQ2;
    else
      next_st = WAIT_IRET;
  end
  RSEQ1: begin
    if(end_bit & ld_ag)
      next_st = DONE;
    else
      next_st = RSEQ1;
  end
  RSEQ2: begin
    if(end_bit & ld_ag)
      next_st = DONE;
    else
      next_st = RSEQ2;
  end
  DONE: begin
    if(w_all_valids_zero)
      next_st = IDLE;
    else
      next_st = DONE;
  end
  default: next_st = IDLE;
  endcase
end

endmodule

