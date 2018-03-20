/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: DMA master controller */
/*              fsm.                  */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module dma_master_controller_fsm ( clk, rst_n, curr_st, start_transfer, d_ready, num_trans_eq1,
                                   num_trans_eq2, trans_cnt_eq2, m_ack, int_clear );
// Input and Output ports
input        clk;
input        rst_n;
output [2:0] curr_st;
input        start_transfer;
input        d_ready;
input        num_trans_eq1;
input        num_trans_eq2;
input        trans_cnt_eq2;
input        m_ack;
input        int_clear;

// Internal variables
reg  [2:0] curr_st, next_st;

localparam IDLE    = 3'b000;
localparam WAIT    = 3'b001;
localparam INT     = 3'b010; 
localparam ACCESS1 = 3'b100;
localparam ACCESS2 = 3'b110;
localparam ACCESS3 = 3'b101;

always @(*) begin
  case(curr_st)
    IDLE: begin
      if(start_transfer)
        next_st = WAIT;
      else
        next_st = IDLE;
    end
    WAIT: begin
      if(d_ready)
        next_st = ACCESS1;
      else
        next_st = WAIT;
    end  
    ACCESS1: begin
      if(m_ack & num_trans_eq1)
        next_st = INT;
      else if(m_ack & num_trans_eq2)
        next_st = ACCESS3;
      else if(m_ack)
        next_st = ACCESS2;
      else
        next_st = ACCESS1;
    end  
    ACCESS2: begin
      if(m_ack & trans_cnt_eq2)
        next_st = ACCESS3;
      else
        next_st = ACCESS2;
    end
    ACCESS3: begin
      if(m_ack)
        next_st = INT;
      else
        next_st = ACCESS3;
    end
    INT: begin
      if(int_clear)
        next_st = IDLE;
      else
        next_st = INT;
    end
    default: next_st = IDLE;
  endcase
end

always @(posedge clk, negedge rst_n) begin
  if(~rst_n)
    curr_st <= IDLE;
  else
    curr_st <= next_st;
end

endmodule

