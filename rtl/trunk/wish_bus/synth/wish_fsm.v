/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: bus crossbar                                 */
/* Description: Bus interconnect crossbar between DMA   */
/* master port & MMU master port and DMA slave port,    */
/* Keyboard (Simple IO) & Main memory.                  */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module wish_fsm ( clk, rst_n, m_mmu_cyc, m_mmu_ack, m_dma_cyc, m_dma_ack, curr_st );

input  clk;
input  rst_n;
input  m_mmu_cyc;
input  m_mmu_ack;
input  m_dma_cyc;
input  m_dma_ack;

output [2:0] curr_st;

reg    [2:0] curr_st;

// Internal variables

reg [2:0] next_st;

localparam IDLE     = 3'b000;
localparam MMU_WAIT = 3'b001;
localparam MMU_ACK  = 3'b010; 
localparam DMA_SEL  = 3'b100;
localparam DMA_WAIT = 3'b101;
localparam DMA_ACK  = 3'b110;


always @(*) begin
  case(curr_st)
    IDLE: begin
      if(m_mmu_cyc & m_mmu_ack)
        next_st = MMU_ACK;
      else if(m_mmu_cyc & !m_mmu_ack)
        next_st = MMU_WAIT;
      else if(m_dma_cyc)
        next_st = DMA_SEL;
      else
        next_st = IDLE;
    end
    MMU_WAIT: begin
      if(m_mmu_cyc & m_mmu_ack)
        next_st = MMU_ACK;
      else
        next_st = MMU_WAIT;
    end  
    MMU_ACK: begin
      if(m_mmu_cyc & m_mmu_ack)
        next_st = MMU_ACK;
      else if(m_mmu_cyc & !m_mmu_ack)
        next_st = MMU_WAIT;
      else
        next_st = IDLE;
    end  
    DMA_SEL: begin
      if(m_dma_cyc & m_dma_ack)
        next_st = DMA_ACK;
      else
        next_st = DMA_WAIT;
    end
    DMA_WAIT: begin
      if(m_mmu_cyc & m_dma_cyc & m_dma_ack)
        next_st = IDLE;
      else if(!m_mmu_cyc & m_dma_cyc & m_dma_ack)
        next_st = DMA_ACK;
      else
        next_st = DMA_WAIT;
    end
    DMA_ACK: begin
      if(m_dma_cyc & m_dma_ack)
        next_st = DMA_ACK;
      else if(m_dma_cyc & !m_dma_ack)
        next_st = DMA_WAIT;
      else
        next_st = IDLE;
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

