/******* Microarchiture Project********/
/* Module: mem_fsm                    */
/* Description: Memory controller fsm */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module mem_fsm (clk, rst_n, cyc, we, addr, ack, ce, oe, wr, rd);
// Input and Output ports
input         clk;
input         rst_n;
input         cyc;
input         we;
input  [31:0] addr;

output        ack;
output        ce;
output        oe;
output        wr;
output        rd;

// Parameters

localparam IDLE        = 3'b000;
localparam WR_EN       = 3'b001;
localparam WR_ACK      = 3'b100;
localparam WR_ADDR_CHK = 3'b010;
localparam WR_WAIT_N   = 3'b011;
localparam WR_WAIT_2N  = 3'b110;
localparam RD_EN       = 3'b101;
localparam RD_ACK      = 3'b111;

parameter N_CYC = 3; // Assuming 7ns clock period: floor(25ns/7ns)

// Internal variables
reg [3:0] curr_st, next_st;
wire w_cyc, w_start, w_wr_done, w_addr_ch, w_wr_wait_n_done, w_wr_wait_2n_done, w_rd_done;

// logic
assign w_cyc = cyc & (addr[31:15]==17'd0);
assign ce    = ~w_cyc;
assign oe    = ~w_cyc | we;
assign ack   = (curr_st == RD_ACK) | (curr_st == WR_ACK);
assign rd    = ~((curr_st == RD_EN) | (curr_st == RD_ACK));
assign wr    = ~((curr_st == WR_EN) | (curr_st == WR_ACK));

// addr_ch generation
addr_ch_logic u_addr_ch_logic (.clk(clk), .rst_n(rst_n), .addr(addr), .addr_ch(w_addr_ch));

// w_start generation
counter #(.CNT_LMT(N_CYC)) u_start_gen (.clk(clk), .rst_n(rst_n), .cond((curr_st == IDLE) & w_cyc), .done(w_start));

// w_wr_done generation
counter #(.CNT_LMT(N_CYC-1)) u_wr_done_gen (.clk(clk), .rst_n(rst_n), .cond(curr_st == WR_EN), .done(w_wr_done));

// w_wr_wait_n_done generation
counter #(.CNT_LMT(N_CYC-1)) u_wr_wait_n_done_gen (.clk(clk), .rst_n(rst_n), .cond(curr_st == WR_WAIT_N), .done(w_wr_wait_n_done));

// w_wr_wait_2n_done generation
counter #(.CNT_LMT(2*N_CYC-2)) u_wr_wait_2n_done_gen (.clk(clk), .rst_n(rst_n), .cond(curr_st == WR_WAIT_2N), .done(w_wr_wait_2n_done));

// w_rd_done generation
counter #(.CNT_LMT(N_CYC+1)) u_rd_done_gen (.clk(clk), .rst_n(rst_n), .cond(curr_st == RD_EN), .done(w_rd_done));

// mem_fsm

always @(*) begin
  case(curr_st)
  IDLE : begin
    if(w_cyc & ~we)
      next_st = RD_EN;
    else if(w_start & we)
      next_st = WR_EN;
    else
      next_st = IDLE;
  end

  WR_EN : begin
    if(w_wr_done)
      next_st = WR_ACK;
    else
      next_st = WR_EN;
  end

  WR_ACK : begin
    next_st = WR_ADDR_CHK;
  end

  WR_ADDR_CHK : begin
    if(!w_cyc | !we)
      next_st = IDLE;
    else if(w_addr_ch)
      next_st = WR_WAIT_2N;
    else
      next_st = WR_WAIT_N;
  end

  WR_WAIT_N: begin
    if(w_wr_wait_n_done)
      next_st = WR_EN;
    else
      next_st = WR_WAIT_N;
  end

  WR_WAIT_2N: begin
    if(w_wr_wait_2n_done)
      next_st = WR_EN;
    else
      next_st = WR_WAIT_2N;
  end

  RD_EN: begin
    if(w_rd_done)
      next_st = RD_ACK;
    else
      next_st = RD_EN;
  end

  RD_ACK: begin
    if(w_cyc & ~we)
      next_st = RD_ACK;
    else
      next_st = IDLE;
  end

  endcase
end

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    curr_st <= IDLE;
    end
  else begin
    curr_st <= next_st;
    end
end

endmodule

module addr_ch_logic(clk, rst_n, addr, addr_ch);

input        clk;
input        rst_n;
input [31:0] addr;
output       addr_ch;

reg [31:0] r_addr_del;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    r_addr_del <= 32'd0;
  else
    r_addr_del <= addr;
end

assign addr_ch = ~(addr[14:5] == r_addr_del[14:5]);

endmodule

module counter #(parameter CNT_LMT = 3) (clk, rst_n, cond, done);

input  clk;
input  rst_n;
input  cond;
output done;

reg [2:0] count;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    count <= 3'd0;
  else if(cond)
    count <= count + 1'b1;
  else
    count <= 3'd0;
end
assign done = (count == CNT_LMT);

endmodule
