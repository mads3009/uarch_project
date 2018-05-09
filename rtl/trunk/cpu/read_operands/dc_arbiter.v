/*************** Microarchiture Project*********************/
/***********************************************************/
/* Module: dcache arbiter                                  */
/* Description: Arbitrates between read and write requests */
/***********************************************************/

module dc_arbiter( clk, rst_n, v_mem_read,  mem_conflict, wr_fifo_empty, 
                   wr_fifo_to_be_full, ld_ro, mem_wr_done, wen, ren);

input  clk;
input  rst_n;
input  v_mem_read;
input  mem_conflict;
input  wr_fifo_empty;
input  wr_fifo_to_be_full;
input  ld_ro;
input  mem_wr_done;
output ren;
output wen;
wire r_ren, r_wen, r_ld_ro_bar, r_mem_wr_done_bar;
wire w_mux_in_ren, w_mux_in_wen, w_v_mem_read_bar;

// w_mux_in_ren = v_mem_read & !mem_conflict & !wr_fifo_to_be_full
// w_mux_in_wen = !w_mux_in_ren & !wr_fifo_empty
inv1$ u_inv1_1(.in(v_mem_read), .out(w_v_mem_read_bar));
nor3$ u_nor3_1(.in0(w_v_mem_read_bar), .in1(mem_conflict), .in2(wr_fifo_to_be_full), .out(w_mux_in_ren));
nor2$ u_nor2_1(.in0(w_mux_in_ren), .in1(wr_fifo_empty), .out(w_mux_in_wen));

// w_retain_arb = (r_ren & !r_ld_ro & !mem_conflict) | (r_wen & !r_mem_wr_done)
inv1$ u_mem_conf_inv(.in(mem_conflict), .out(mem_conflict_bar));
nand3$ u_nand2_1(.in0(r_ren), .in1(r_ld_ro_bar), .in2(mem_conflict_bar), .out(n_001));
nand2$ u_nand2_2(.in0(r_wen), .in1(r_mem_wr_done_bar), .out(n_002));
nand2$ u_nand2_3(.in0(n_001), .in1(n_002), .out(w_retain_arb));

muxNbit_2x1 #(.N(2)) u_muxNbit_2x1_1(.IN0({w_mux_in_ren, w_mux_in_wen}), .IN1({r_ren, r_wen}), .S0(w_retain_arb), .Y({ren, wen}));

dff$ u_ren_reg (.r(rst_n), .s(1'b1), .clk(clk), .d(ren), .q (r_ren), .qbar (/*Unused*/));
dff$ u_wen_reg (.r(rst_n), .s(1'b1), .clk(clk), .d(wen), .q (r_wen), .qbar (/*Unused*/));

dff$ u_ld_ro_del (.r(rst_n), .s(1'b1), .clk(clk), .d(ld_ro), .q (/*Unused*/), .qbar (r_ld_ro_bar));
dff$ u_mem_wr_done_del (.r(rst_n), .s(1'b1), .clk(clk), .d(mem_wr_done), .q (/*Unused*/), .qbar (r_mem_wr_done_bar));

endmodule

