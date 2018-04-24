module mem_conflict_gen(mem_conflict, v_ro_mem_read, ro_mem_rd_addr_start, ro_mem_rd_addr_end,
                        v_ex_ld_mem, ex_mem_wr_addr_start, ex_mem_wr_addr_end, 
                        v_wb_ld_mem, wb_mem_wr_addr_start, wb_mem_wr_addr_end,
                        fifo_wr_addr0_start, fifo_wr_addr0_end, fifo_wr_addr1_start,
                        fifo_wr_addr1_end, fifo_wr_addr2_start, fifo_wr_addr2_end,
                        fifo_wr_addr3_start, fifo_wr_addr3_end, fifo_cnt, fifo_rd_ptr);

input        v_ro_mem_read;
input [31:0] ro_mem_rd_addr_start;
input [31:0] ro_mem_rd_addr_end;

input        v_ex_ld_mem;
input [31:0] ex_mem_wr_addr_start;
input [31:0] ex_mem_wr_addr_end;

input        v_wb_ld_mem;
input [31:0] wb_mem_wr_addr_start;
input [31:0] wb_mem_wr_addr_end;

input [31:0] fifo_wr_addr0_start;
input [31:0] fifo_wr_addr0_end;
input [31:0] fifo_wr_addr1_start;
input [31:0] fifo_wr_addr1_end;
input [31:0] fifo_wr_addr2_start;
input [31:0] fifo_wr_addr2_end;
input [31:0] fifo_wr_addr3_start;
input [31:0] fifo_wr_addr3_end;

input [2:0]  fifo_cnt;
input [1:0]  fifo_rd_ptr;

output       mem_conflict;

assign mem_conflict = 

endmodule

