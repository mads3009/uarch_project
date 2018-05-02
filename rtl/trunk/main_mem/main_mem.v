/******* Microarchiture Project********/
/* Module: main_mem                   */
/* Description: 32kB main memory with */
/* memory array controller fsm.       */
/* Author: Sharukh S. Shaikh          */
/**************************************/

module main_mem (clk, rst_n, s_cyc, s_we, s_strb, s_addr, s_data_i, s_data_o, s_ack);
// Input and Output ports
input         clk;
input         rst_n;
input         s_cyc;
input         s_we;
input  [3:0]  s_strb;
input  [31:0] s_addr;
input  [31:0] s_data_i;

output        s_ack;
output [31:0] s_data_o;

// Internal variables
wire        w_ce, w_oe, w_wr, w_rd;

// memory array instantiation
wire  [31:0] s_addr_del;
assign #1 s_addr_del = s_addr;

mem_array u_mem_array(.ce(1'b0), .oe(w_oe), .wr(w_wr), .rd(w_rd), .strb(s_strb), .addr(s_addr_del[14:0]), .data_i(s_data_i), .data_o(s_data_o));

// memory array controller fsm
mem_fsm u_mem_fsm(.clk(clk), .rst_n(rst_n), .cyc(s_cyc), .we(s_we), .addr(s_addr), .ack(s_ack), .ce(w_ce), .oe(w_oe), .wr(w_wr), .rd(w_rd));

endmodule

