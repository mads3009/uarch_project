/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Memory management unit state machine         */
/* Arbitrates between icache miss, dcache miss, dcache  */
/* evict and IO access.                                 */
/********************************************************/

module mmu_fsm( clk, rst_n, ld_ro, io_access, io_rw, ic_miss, dc_miss, 
                dc_evict_flag, mmu_ack, curr_st, next_st, count_eq3, count_eq7);

input        clk;
input        rst_n;
input        ld_ro;
input        io_access;
input        io_rw;
input        ic_miss;
input        dc_miss;
input        dc_evict_flag;
input        mmu_ack;
input        count_eq3;
input        count_eq7;

output [2:0] curr_st;
output [2:0] next_st;

reg [2:0] curr_st, next_st;

// Internal variables

localparam IO_SEL         = 3'b000;
localparam IO_ACK_WAIT    = 3'b001;
localparam DC_MEM_RD      = 3'b010;
localparam DC_MISS_ACK    = 3'b011;
localparam IC_MEM_RD      = 3'b100;
localparam IC_MISS_ACK    = 3'b101;
localparam DC_MEM_WR      = 3'b110;
localparam DC_CLEAR_EVICT = 3'b111;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n)
    curr_st <= IO_SEL;
  else
    curr_st <= next_st;
end

always @(*) begin
  case(curr_st)
  IO_SEL: begin
    if(io_access & !mmu_ack)
      next_st = IO_SEL;
    else if(io_access  & mmu_ack & (io_rw | ld_ro))
      next_st = IO_SEL;
    else if(io_access & mmu_ack)
      next_st = IO_ACK_WAIT;
    else if(dc_miss)
      next_st = DC_MEM_RD;
    else if(ic_miss)
      next_st = IC_MEM_RD;
    else
      next_st = IO_SEL;
  end
  IO_ACK_WAIT: begin
    if(ld_ro)
      next_st = IO_SEL;
    else
      next_st = IO_ACK_WAIT;
  end
  DC_MEM_RD: begin
    if(count_eq3 & mmu_ack)
      next_st = DC_MISS_ACK;
    else
      next_st = DC_MEM_RD;
  end
  DC_MISS_ACK: begin
    if(dc_evict_flag)
      next_st = DC_MEM_WR;
    else if(ic_miss)
      next_st = IC_MEM_RD;
    else
      next_st = IO_SEL;
  end
  DC_MEM_WR: begin
    if(count_eq3 & mmu_ack)
      next_st = DC_CLEAR_EVICT;
    else
      next_st = DC_MEM_WR;
  end
  DC_CLEAR_EVICT: begin
    if(dc_miss)
      next_st = DC_MEM_RD;
    else if(ic_miss)
      next_st = IC_MEM_RD;
    else
      next_st = IO_SEL;
  end
  IC_MEM_RD: begin
    if(count_eq7 & mmu_ack)
      next_st = IC_MISS_ACK;
    else
      next_st = IC_MEM_RD;    
  end
  IC_MISS_ACK: begin
    if(dc_miss)
      next_st = DC_MEM_RD;
    else
      next_st = IO_SEL;
  end
  endcase
end

endmodule

