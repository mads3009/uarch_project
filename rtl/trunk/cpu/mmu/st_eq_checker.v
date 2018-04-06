/*************** Microarchiture Project******************/
/********************************************************/
/* Module: state equality checker                       */
/* Description: Combinational block generates 1-bit eq  */
/* signals, required for other building logic.          */
/********************************************************/

module st_eq_checker (
  curr_st,
  next_st,
  count,
  curr_st_eq_IO_SEL,
  curr_st_eq_IO_ACK_WAIT,
  curr_st_eq_DC_MEM_RD,
  curr_st_eq_DC_MISS_ACK,
  curr_st_eq_IC_MEM_RD,
  curr_st_eq_IC_MISS_ACK,
  curr_st_eq_DC_MEM_WR,
  curr_st_eq_DC_CLEAR_EVICT,
  next_st_eq_IO_SEL,
  next_st_eq_IO_ACK_WAIT,
  next_st_eq_DC_MEM_RD,
  next_st_eq_DC_MISS_ACK,
  next_st_eq_IC_MEM_RD,
  next_st_eq_IC_MISS_ACK,
  next_st_eq_DC_MEM_WR,
  next_st_eq_DC_CLEAR_EVICT,
  curr_st_eq_IO_SEL_bar,
  curr_st_eq_IO_ACK_WAIT_bar,
  curr_st_eq_DC_MEM_RD_bar,
  curr_st_eq_DC_MISS_ACK_bar,
  curr_st_eq_IC_MEM_RD_bar,
  curr_st_eq_IC_MISS_ACK_bar,
  curr_st_eq_DC_MEM_WR_bar,
  curr_st_eq_DC_CLEAR_EVICT_bar,
  count_eq0,
  count_eq1,
  count_eq2,
  count_eq3,
  count_eq4,
  count_eq5,
  count_eq6,
  count_eq7
  );

localparam IO_SEL         = 3'b000;
localparam IO_ACK_WAIT    = 3'b001;
localparam DC_MEM_RD      = 3'b010;
localparam DC_MISS_ACK    = 3'b011;
localparam IC_MEM_RD      = 3'b100;
localparam IC_MISS_ACK    = 3'b101;
localparam DC_MEM_WR      = 3'b110;
localparam DC_CLEAR_EVICT = 3'b111;

input [2:0] curr_st;
input [2:0] next_st;
input [2:0] count;

output curr_st_eq_IO_SEL;
output curr_st_eq_IO_ACK_WAIT;
output curr_st_eq_DC_MEM_RD;
output curr_st_eq_DC_MISS_ACK;
output curr_st_eq_IC_MEM_RD;
output curr_st_eq_IC_MISS_ACK;
output curr_st_eq_DC_MEM_WR;
output curr_st_eq_DC_CLEAR_EVICT;

output next_st_eq_IO_SEL;
output next_st_eq_IO_ACK_WAIT;
output next_st_eq_DC_MEM_RD;
output next_st_eq_DC_MISS_ACK;
output next_st_eq_IC_MEM_RD;
output next_st_eq_IC_MISS_ACK;
output next_st_eq_DC_MEM_WR;
output next_st_eq_DC_CLEAR_EVICT;

output curr_st_eq_IO_SEL_bar;
output curr_st_eq_IO_ACK_WAIT_bar;
output curr_st_eq_DC_MEM_RD_bar;
output curr_st_eq_DC_MISS_ACK_bar;
output curr_st_eq_IC_MEM_RD_bar;
output curr_st_eq_IC_MISS_ACK_bar;
output curr_st_eq_DC_MEM_WR_bar;
output curr_st_eq_DC_CLEAR_EVICT_bar;
output count_eq0;
output count_eq1;
output count_eq2;
output count_eq3;
output count_eq4;
output count_eq5;
output count_eq6;
output count_eq7;

assign curr_st_eq_IO_SEL = curr_st == IO_SEL;
assign curr_st_eq_IO_ACK_WAIT = curr_st == IO_ACK_WAIT;
assign curr_st_eq_DC_MEM_RD = curr_st == DC_MEM_RD;
assign curr_st_eq_DC_MISS_ACK = curr_st == DC_MISS_ACK;
assign curr_st_eq_IC_MEM_RD = curr_st == IC_MEM_RD;
assign curr_st_eq_IC_MISS_ACK = curr_st == IC_MISS_ACK;
assign curr_st_eq_DC_MEM_WR = curr_st == DC_MEM_WR;
assign curr_st_eq_DC_CLEAR_EVICT = curr_st == DC_CLEAR_EVICT;

assign next_st_eq_IO_SEL = next_st == IO_SEL;
assign next_st_eq_IO_ACK_WAIT = next_st == IO_ACK_WAIT;
assign next_st_eq_DC_MEM_RD = next_st == DC_MEM_RD;
assign next_st_eq_DC_MISS_ACK = next_st == DC_MISS_ACK;
assign next_st_eq_IC_MEM_RD = next_st == IC_MEM_RD;
assign next_st_eq_IC_MISS_ACK = next_st == IC_MISS_ACK;
assign next_st_eq_DC_MEM_WR = next_st == DC_MEM_WR;
assign next_st_eq_DC_CLEAR_EVICT = next_st == DC_CLEAR_EVICT;

assign curr_st_eq_IO_SEL_bar = curr_st != IO_SEL;
assign curr_st_eq_IO_ACK_WAIT_bar = curr_st != IO_ACK_WAIT;
assign curr_st_eq_DC_MEM_RD_bar = curr_st != DC_MEM_RD;
assign curr_st_eq_DC_MISS_ACK_bar = curr_st != DC_MISS_ACK;
assign curr_st_eq_IC_MEM_RD_bar = curr_st != IC_MEM_RD;
assign curr_st_eq_IC_MISS_ACK_bar = curr_st != IC_MISS_ACK;
assign curr_st_eq_DC_MEM_WR_bar = curr_st != DC_MEM_WR;
assign curr_st_eq_DC_CLEAR_EVICT_bar = curr_st != DC_CLEAR_EVICT;

assign count_eq0 = count == 3'd0;
assign count_eq1 = count == 3'd1;
assign count_eq2 = count == 3'd2;
assign count_eq3 = count == 3'd3;
assign count_eq4 = count == 3'd4;
assign count_eq5 = count == 3'd5;
assign count_eq6 = count == 3'd6;
assign count_eq7 = count == 3'd7;

endmodule

