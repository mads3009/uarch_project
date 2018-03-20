/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: DMA slave interface   */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module dma_slave_if( clk, rst_n, s_cyc, s_we, s_strb, s_addr, s_data_i, s_ack, s_data_o,
                     disk_addr, mem_addr, transfer_size, init_transfer);
// Input and Output ports
input         clk;
input         rst_n;
input         s_cyc;
input         s_we;
input  [3:0]  s_strb; // unused port: DMA slave write to all bytes in a 32-bit reg (default)
input  [31:0] s_addr;
input  [31:0] s_data_i;

output        s_ack;
output [31:0] s_data_o;

output [31:0] disk_addr;
output [31:0] mem_addr;
output [31:0] transfer_size;
output [31:0] init_transfer;

// Internal variables
wire w_addr_eq;
wire w_ld0, w_ld1, w_ld2, w_l3;
wire w_s_cyc;

// DMA slave write: Logic to generate the register load signals
eq_checker32 u_addr_chk(.in1({s_addr[31:4],4'd0}), .in2(32'h8000_0000), .eq_out(w_addr_eq));
and2$ u_and5(.in0(w_addr_eq), .in1(s_cyc), .out(w_s_cyc));
buffer$ u_buffer1(.in(w_s_cyc), .out(s_ack));

inv1$ u_inv1(.in(s_addr[3]), .out (w_addr3_bar));
inv1$ u_inv2(.in(s_addr[2]), .out (w_addr2_bar));

and4$ u_and1(.in0(w_s_cyc), .in1(w_addr3_bar), .in2(w_addr2_bar), .in3(s_we), .out(w_ld0));
and4$ u_and2(.in0(w_s_cyc), .in1(w_addr3_bar), .in2(s_addr[2]), .in3(s_we), .out(w_ld1));
and4$ u_and3(.in0(w_s_cyc), .in1(s_addr[3]), .in2(w_addr2_bar), .in3(s_we), .out(w_ld2));
and4$ u_and4(.in0(w_s_cyc), .in1(s_addr[3]), .in2(s_addr[2]), .in3(s_we), .out(w_ld3));

// DMA slave interface register instantiation
register #(.N(32)) u_reg0(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(s_data_i), .data_o(disk_addr), .ld(w_ld0));
register #(.N(32)) u_reg1(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(s_data_i), .data_o(mem_addr), .ld(w_ld1));
register #(.N(32)) u_reg2(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(s_data_i), .data_o(transfer_size), .ld(w_ld2));
register #(.N(32)) u_reg3(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(s_data_i), .data_o(init_transfer), .ld(w_ld3));

// DMA slave read
mux32bit_4x1 u_mux32bit_4x1(.Y(s_data_o), .IN0(disk_addr), .IN1(mem_addr), .IN2(transfer_size), .IN3(init_transfer), .S0(s_addr[2]), .S1(s_addr[3]));

endmodule

