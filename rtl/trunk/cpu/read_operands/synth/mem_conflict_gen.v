module mem_conflict_gen(mem_conflict, v_ro_mem_read, ro_mem_rd_addr_start, ro_mem_rd_addr_end, 
                        v_wb_ld_mem, wb_mem_wr_addr_start, wb_mem_wr_addr_end,
                        fifo_wr_addr0_start, fifo_wr_addr0_end, fifo_wr_addr1_start,
                        fifo_wr_addr1_end, fifo_wr_addr2_start, fifo_wr_addr2_end,
                        fifo_wr_addr3_start, fifo_wr_addr3_end, fifo_cnt, fifo_rd_ptr);

input        v_ro_mem_read;
input [14:0] ro_mem_rd_addr_start;
input [14:0] ro_mem_rd_addr_end;

input        v_wb_ld_mem;
input [14:0] wb_mem_wr_addr_start;
input [14:0] wb_mem_wr_addr_end;

input [14:0] fifo_wr_addr0_start;
input [14:0] fifo_wr_addr0_end;
input [14:0] fifo_wr_addr1_start;
input [14:0] fifo_wr_addr1_end;
input [14:0] fifo_wr_addr2_start;
input [14:0] fifo_wr_addr2_end;
input [14:0] fifo_wr_addr3_start;
input [14:0] fifo_wr_addr3_end;

input [2:0]  fifo_cnt;
input [1:0]  fifo_rd_ptr;

output       mem_conflict;

reg [3:0] V_fifo_entry;
assign mem_conflict = v_ro_mem_read && ( (v_wb_ld_mem && ((ro_mem_rd_addr_start>=wb_mem_wr_addr_start && ro_mem_rd_addr_start<=wb_mem_wr_addr_end) ||
                                                         (ro_mem_rd_addr_end  >=wb_mem_wr_addr_start && ro_mem_rd_addr_end  <=wb_mem_wr_addr_end) ||
                                                         (ro_mem_rd_addr_start<=wb_mem_wr_addr_start && ro_mem_rd_addr_end  >=wb_mem_wr_addr_end))) ||
                                         (V_fifo_entry[0] && ((ro_mem_rd_addr_start>=fifo_wr_addr0_start && ro_mem_rd_addr_start<=fifo_wr_addr0_end) ||
                                                             (ro_mem_rd_addr_end  >=fifo_wr_addr0_start && ro_mem_rd_addr_end  <=fifo_wr_addr0_end) ||
                                                             (ro_mem_rd_addr_start<=fifo_wr_addr0_start && ro_mem_rd_addr_end  >=fifo_wr_addr0_end))) ||
                                         (V_fifo_entry[1] && ((ro_mem_rd_addr_start>=fifo_wr_addr1_start && ro_mem_rd_addr_start<=fifo_wr_addr1_end) ||
                                                             (ro_mem_rd_addr_end  >=fifo_wr_addr1_start && ro_mem_rd_addr_end  <=fifo_wr_addr1_end) ||
                                                             (ro_mem_rd_addr_start<=fifo_wr_addr1_start && ro_mem_rd_addr_end  >=fifo_wr_addr1_end))) ||
                                         (V_fifo_entry[2] && ((ro_mem_rd_addr_start>=fifo_wr_addr2_start && ro_mem_rd_addr_start<=fifo_wr_addr2_end) ||
                                                             (ro_mem_rd_addr_end  >=fifo_wr_addr2_start && ro_mem_rd_addr_end  <=fifo_wr_addr2_end) ||
                                                             (ro_mem_rd_addr_start<=fifo_wr_addr2_start && ro_mem_rd_addr_end  >=fifo_wr_addr2_end))) ||
                                         (V_fifo_entry[3] && ((ro_mem_rd_addr_start>=fifo_wr_addr3_start && ro_mem_rd_addr_start<=fifo_wr_addr3_end) ||
                                                             (ro_mem_rd_addr_end  >=fifo_wr_addr3_start && ro_mem_rd_addr_end  <=fifo_wr_addr3_end) ||
                                                             (ro_mem_rd_addr_start<=fifo_wr_addr3_start && ro_mem_rd_addr_end  >=fifo_wr_addr3_end)))   );

always@(*) begin

  if(fifo_cnt == 3'h0)
    V_fifo_entry <= 4'b0000;

  else if(fifo_cnt == 3'h1) begin
    if(fifo_rd_ptr == 2'h0)
      V_fifo_entry <= 4'b0001;
    else if(fifo_rd_ptr == 2'h1)
      V_fifo_entry <= 4'b0010;
    else if(fifo_rd_ptr == 2'h2)
      V_fifo_entry <= 4'b0100;
    else 
      V_fifo_entry <= 4'b1000;
  end

  else if(fifo_cnt == 3'h2) begin
    if(fifo_rd_ptr == 2'h0)
      V_fifo_entry <= 4'b0011;
    else if(fifo_rd_ptr == 2'h1)
      V_fifo_entry <= 4'b0110;
    else if(fifo_rd_ptr == 2'h2)
      V_fifo_entry <= 4'b1100;
    else 
      V_fifo_entry <= 4'b1001;
  end

  else if(fifo_cnt == 3'h3) begin
    if(fifo_rd_ptr == 2'h0)
      V_fifo_entry <= 4'b0111;
    else if(fifo_rd_ptr == 2'h1)
      V_fifo_entry <= 4'b1110;
    else if(fifo_rd_ptr == 2'h2)
      V_fifo_entry <= 4'b1101;
    else 
      V_fifo_entry <= 4'b1011;
  end

  else
      V_fifo_entry <= 4'b1111;

end

endmodule

