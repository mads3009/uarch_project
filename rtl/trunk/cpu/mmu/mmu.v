/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Memory management unit                       */
/* Description: Handles cpu - main mem & IO interaction */
/********************************************************/

module mmu( clk, rst_n, ic_miss, ic_miss_addr, ic_data_fill, ic_miss_ack, dc_miss, dc_miss_addr, 
            dc_data_fill, dc_miss_ack, io_access, io_rw, io_addr, io_wr_data, io_rd_data, 
            io_ack, dc_evict, dc_evict_addr, dc_evict_data, ld_ro, m_cyc, m_we, m_strb, m_addr, 
            m_data_o, m_ack, m_data_i, ld_ro);

localparam DC_LINE_W = 16*8; // 16 Bytes
localparam IC_LINE_W = 32*8; // 32 Bytes

input                  clk;
input                  rst_n;
input                  ld_ro;

// MMU - IO access interface
input                  io_access;
input                  io_rw;
input  [31:0]          io_addr;
input  [31:0]          io_wr_data;

output [31:0]          io_rd_data;
output                 io_ack;

// MMU - instruction cache miss handling interface
input                  ic_miss;
input  [31:0]          ic_miss_addr;
output [IC_LINE_W-1:0] ic_data_fill;
output                 ic_miss_ack;

// MMU - data cache miss handling interface
input                  dc_miss;
input [31:0]           dc_miss_addr;
input                  dc_evict;
input  [31:0]          dc_evict_addr;
input  [DC_LINE_W-1:0] dc_evict_data;
output [DC_LINE_W-1:0] dc_data_fill;
output                 dc_miss_ack;

// MMU master interfce
output                 m_cyc;
output                 m_we;
output [3:0]           m_strb;
output [31:0]          m_addr;
output [31:0]          m_data_o;

input                  m_ack;
input  [31:0]          m_data_i;

// Internal Variables
wire [31:0] r_io_m_data_i;

// IO read data and ack generation

// io_rd_data = w_curr_st_eq_IO_ACK_WAIT ? r_io_m_data_i : m_data_i
register #(.N(32)) u_io_m_data_i_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(m_data_i), .data_o(r_io_m_data_i), .ld(w_curr_st_eq_IO_SEL));
mux32bit_2x1 u_mux32bit_2x1_1(.Y(io_rd_data), .IN0(r_io_m_data_i), .IN1(m_data_i), .S0(w_curr_st_eq_IO_SEL));

// io_ack = (io_access & m_ack) | w_curr_st_eq_IO_ACK_WAIT
nand2$ u_nand2_1(.out(n_001), .in0(io_access), .in1(m_ack));
nand2$ u_nand2_2(.out(io_ack), .in0(n_001), .in1(w_curr_st_eq_IO_ACK_WAIT_bar));

// i-cache miss handling
wire [IC_LINE_W-1:0] r_cache_line_rd_buff;
genvar i;
generate
  for(i=0;i<8;i=i+1) begin: cache_line_rd_buff_gen
    and2$ u_and2_i(.out(w_ld_buff[i]), .in0(w_count_eq[i]), .in1(m_ack));
    register #(.N(32)) u_cache_line_rd_buff(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(m_data_i), .data_o(r_cache_line_rd_buff[i*32+31 -: 32]), .ld(w_ld_buff[i]));
  end
endgenerate

assign ic_data_fill = r_cache_line_rd_buff[IC_LINE_W-1:0];
assign dc_data_fill = r_cache_line_rd_buff[DC_LINE_W-1:0];

assign ic_miss ack = w_curr_st_eq_IC_MISS_ACK;
assign dc_miss_ack = w_curr_st_eq_DC_MISS_ACK;

// MMU master interface signal generation

// m_cyc = (w_curr_st_eq_IO_SEL & io_access) | w_curr_st_eq_DC_MEM_RD | w_curr_st_eq_IC_MEM_RD | w_curr_st_eq_DC_MEM_WR
nand2$ u_nand2_3(.out(n_101), .in0(w_curr_st_eq_IO_SEL), .in1(io_access));
nand4$ u_nand4_1(.out(m_cyc), .in0(n_101), .in1(w_curr_st_eq_DC_MEM_RD_bar), .in2(w_curr_st_eq_IC_MEM_RD_bar), .in3(w_curr_st_eq_DC_MEM_WR_bar));

// m_we = w_curr_st_eq_DC_MEM_WR | (w_curr_st_eq_IO_SEL & io_access & io_rw)
nand3$ u_nand3_1(.out(n_102), .in0(w_curr_st_eq_IO_SEL), .in1(io_access), .in2(io_rw));
nand2$ u_nand2_4(.out(m_we), .in0(n_102), .in1(w_curr_st_eq_DC_MEM_WR_bar));

// m_strb = 4'b1111;
assign m_strb = 4'b1111;

//////////////////////////////////////////////////
// m_addr and count generation
//////////////////////////////////////////////////

wire [31:0] w_temp_addr, r_temp_addr, w_temp_addr_inc;
wire        w_mux_sel0, w_mux_sel1, w_ld_temp_addr;

// m_addr generation
mux32bit_4x1 u_mux32bit_4x1_2(.Y(w_temp_addr), .IN0(r_dc_evict_addr), .IN1(dc_miss_addr), .IN2(ic_miss_addr), .IN3(w_temp_addr_inc), .S0(w_mux_sel0), .S1(w_mux_sel0);

cond_sum32 u_cond_sum32(.A(r_temp_addr), .B(32'd4), .CIN(1'b0), .S(w_temp_addr_inc), .COUT(/*unused*/));

register #(.N(32)) u_temp_addr_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_temp_addr), .data_o(r_temp_addr), .ld(w_ld_temp_addr));

mux32bit_2x1 u_mux32bit_2x1_3(.Y(m_addr), .IN0(r_temp_addr), .IN1(io_addr), .S0(w_curr_st_eq_IO_SEL));

// ld_temp_addr generation
nor3$ u_nor3_1(.out(n_301), .in0(w_curr_st_eq_DC_MEM_WR), .in1(w_curr_st_eq_DC_MEM_RD), .in2(w_curr_st_eq_IC_MEM_RW));
or2$ u_or2_1(.out(w_ld_temp_addr), .in0(n_301), .in1(m_ack));

// mux_sel0 & mux_sel1 generation

or3$ u_or3_1(.out(w_count_mux_sel), .in0(w_curr_st_eq_DC_MEM_WR), .in1(w_curr_st_eq_DC_MEM_RD), .in2(w_curr_st_eq_IC_MEM_RW));

and2$ u_and2_1(.out(w_temp2), .in0(w_next_st_eq_DC_MEM_RD), .in1(w_curr_st_eq_DC_MEM_RD_bar));
and2$ u_and2_2(.out(w_temp3), .in0(w_next_st_eq_IC_MEM_RD), .in1(w_curr_st_eq_IC_MEM_RD_bar));

and2$ u_and2_3(.out(w_temp4), .in0(w_next_st_eq_DC_MEM_WR), .in1(w_curr_st_eq_DC_MEM_WR_bar));

mux2$ u_mux2_1(.outb(w_temp0), .in0(w_temp2), .in1(1'b0), .s0(w_temp4));
mux2$ u_mux2_2(.outb(w_temp1), .in0(w_temp3), .in1(1'b0), .s0(w_temp4));

mux2$ u_mux2_3(.outb(w_mux_sel0), .in0(w_temp0), .in1(1'b1), .s0(w_count_mux_sel));
mux2$ u_mux2_4(.outb(w_mux_sel1), .in0(w_temp1), .in1(1'b1), .s0(w_count_mux_sel));

// count generation
wire [2:0] w_count, w_count_inc, r_count;

muxNbit_2x1 #(.N(3)) u_muxNbit_2x1_1(.IN0(3'd0), .IN1(w_count_inc), .S0(w_count_mux_sel), .Y(w_count));

register #(.N(3)) u_count_reg(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(w_count), .data_o(r_count), .ld(w_ld_temp_addr));

nibble_low u_nibble_low (.a({1'b0,r_count}), .b(4'd1), .cin(1'b0), .s({n_701,w_count_inc}), .cout(/*Unused*/) );

////////////////////////////////////////////////////////////////////////////////
// m_data_o = w_curr_st_eq_DC_MEM_WR ? w_data_evict_buff_muxout : io_wr_data;
////////////////////////////////////////////////////////////////////////////////
wire [31:0] w_data_temp;
wire [DC_LINE_W-1:0] r_dc_evict_data;
wire [31:0] r_dc_evict_addr;

mux32bit_4x1 u_mux32bit_4x1_1(.Y(w_data_temp), .IN0(r_dc_evict_data[0*32+31 -: 32]), .IN1(r_dc_evict_data[1*32+31 -: 32]), .IN2(r_dc_evict_data[2*32+31 -: 32]), .IN3(r_dc_evict_data[3*32+31 -: 32]), .S0(r_count[0]), .S1(r_count[1]));

mux32bit_2x1 u_mux32bit_2x1_2(.Y(m_data_o), .IN0(io_wr_data), .IN1(w_data_temp), .S0(w_curr_st_eq_DC_MEM_WR));

// Generate dc_evict_pulse
// w_gate_evict_sig = w_curr_st_eq_DC_MEM_WR | w_curr_st_eq_DC_CLEAR_EVICT
nand2$ u_nand2_5(.out(w_gate_evict_sig), .in0(w_curr_st_eq_DC_MEM_WR_bar), .in1(w_curr_st_eq_DC_CLEAR_EVICT_bar));

mux2$  u_mux2_7(.outb(w_dc_evict_gated), .in0(dc_evict), .in1(1'b0), .s0(w_gate_evict_sig));
dff$  u_dc_evict_gated_reg(.clk(clk), .r(rst_n), .s(1'b1), .d(w_dc_evict_gated),.q(/*Unused*/),.qbar(r_dc_evict_gated_del_bar));
and2$ u_and2_1(.out(w_dc_evict_pulse), .in0(r_dc_evict_gated_del_bar), .in1(w_dc_evict_gated));

// latch dc_evict_data with the dc_evict_pulse
register #(.N(DC_LINE_W)) u_dc_evict_data_buff(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(dc_evict_data), .data_o(r_dc_evict_data), .ld(w_dc_evict_pulse));

// latch dc_evict_addr with the dc_evict_pulse
register #(.N(32)) u_dc_evict_data_buff(.clk(clk), .rst_n(rst_n), .set_n(1'b1), .data_i(dc_evict_addr), .data_o(r_dc_evict_addr), .ld(w_dc_evict_pulse));

// dc_evict_flag generation
mux2$  u_mux2_8(.outb(w_dc_evict_flag), .in0(w_dc_evict_pulse), .in1(w_curr_st_eq_DC_CLEAR_EVICT_bar), .s0(r_dc_evict_flag));
dff$  u_dc_evict_flag_reg(.clk(clk), .r(rst_n), .s(1'b1), .d(w_dc_evict_flag),.q(r_dc_evict_flag),.qbar(/*Unused*/));

// State equality checker
st_eq_checker u_st_eq_checker(
  .curr_st(w_curr_st),
  .next_st(w_next_st),
  .count(r_count),
  .curr_st_eq_IO_SEL(w_curr_st_eq_IO_SEL),
  .curr_st_eq_IO_ACK_WAIT(w_curr_st_eq_IO_ACK_WAIT),
  .curr_st_eq_DC_MEM_RD(w_curr_st_eq_DC_MEM_RD),
  .curr_st_eq_DC_MISS_ACK(w_curr_st_eq_DC_MISS_ACK),
  .curr_st_eq_IC_MEM_RD(w_curr_st_eq_IC_MEM_RD),
  .curr_st_eq_IC_MISS_ACK(w_curr_st_eq_IC_MISS_ACK),
  .curr_st_eq_DC_MEM_WR(w_curr_st_eq_DC_MEM_WR),
  .curr_st_eq_DC_CLEAR_EVICT(w_curr_st_eq_DC_CLEAR_EVICT),
  .next_st_eq_IO_SEL(w_next_st_eq_IO_SEL),
  .next_st_eq_IO_ACK_WAIT(w_next_st_eq_IO_ACK_WAIT),
  .next_st_eq_DC_MEM_RD(w_next_st_eq_DC_MEM_RD),
  .next_st_eq_DC_MISS_ACK(w_next_st_eq_DC_MISS_ACK),
  .next_st_eq_IC_MEM_RD(w_next_st_eq_IC_MEM_RD),
  .next_st_eq_IC_MISS_ACK(w_next_st_eq_IC_MISS_ACK),
  .next_st_eq_DC_MEM_WR(w_next_st_eq_DC_MEM_WR),
  .next_st_eq_DC_CLEAR_EVICT(w_next_st_eq_DC_CLEAR_EVICT),
  .curr_st_eq_IO_SEL_bar(w_curr_st_eq_IO_SEL_bar),
  .curr_st_eq_IO_ACK_WAIT_bar(w_curr_st_eq_IO_ACK_WAIT_bar),
  .curr_st_eq_DC_MEM_RD_bar(w_curr_st_eq_DC_MEM_RD_bar),
  .curr_st_eq_DC_MISS_ACK_bar(w_curr_st_eq_DC_MISS_ACK_bar),
  .curr_st_eq_IC_MEM_RD_bar(w_curr_st_eq_IC_MEM_RD_bar),
  .curr_st_eq_IC_MISS_ACK_bar(w_curr_st_eq_IC_MISS_ACK_bar),
  .curr_st_eq_DC_MEM_WR_bar(w_curr_st_eq_DC_MEM_WR_bar),
  .curr_st_eq_DC_CLEAR_EVICT_bar(w_curr_st_eq_DC_CLEAR_EVICT_bar),
  .count_eq0(w_count_eq[0]),
  .count_eq1(w_count_eq[1]),
  .count_eq2(w_count_eq[2]),
  .count_eq3(w_count_eq[3]),
  .count_eq4(w_count_eq[4]),
  .count_eq5(w_count_eq[5]),
  .count_eq6(w_count_eq[6]),
  .count_eq7(w_count_eq[7]),
  );

// MMU fsm
mmu_fsm u_mmu_fsm(
  .clk(clk),
  .rst_n(rst_n),
  .io_access(io_access),
  .io_rw(io_rw),
  .ld_ro(ld_ro),
  .mmu_ack(m_ack),
  .ic_miss(ic_miss),
  .dc_miss(dc_miss),
  .dc_evict_flag(r_dc_evict_flag),
  .curr_st(w_curr_st),
  .next_st(w_next_st),
  .count_eq3(w_count_eq[3]),
  .count_eq7(w_count_eq[7])
  );

endmodule

