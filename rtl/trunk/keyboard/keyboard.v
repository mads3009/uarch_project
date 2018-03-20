/********************************************************/
/*************** Microarchiture Project******************/
/********************************************************/
/* Module: keyboard                                     */
/* Description: Simple IO device: keyboard              */
/* Author: Sharukh S. Shaikh                            */
/********************************************************/

module keyboard( clk, rst_n, s_cyc, s_we, s_strb, s_addr, s_data_i, s_ack, s_data_o);

// Input and Output ports
input         clk;
input         rst_n;
input         s_cyc;
input         s_we;
input  [3:0]  s_strb; // unused port: Write operation to all bytes in a 32-bit reg (default)
input  [31:0] s_addr;
input  [31:0] s_data_i;

output        s_ack;
output [31:0] s_data_o;

// Internal variables
wire w_addr_eq;
wire w_ld0, w_ld1, w_ld2, w_l3;
wire w_s_cyc;

reg  [31:0] key_val, pol_stat;
reg  [7:0]  temp;

// DMA slave write: Logic to generate the register load signals
eq_checker32 u_addr_chk(.in1({s_addr[31:4],4'd0}), .in2(32'hC000_0000), .eq_out(w_addr_eq));
and2$ u_and5(.in0(w_addr_eq), .in1(s_cyc), .out(w_s_cyc));
buffer$ u_buffer1(.in(w_s_cyc), .out(s_ack));

inv1$ u_inv1(.in(s_addr[3]), .out (w_addr3_bar));
inv1$ u_inv2(.in(s_addr[2]), .out (w_addr2_bar));

and4$ u_and1(.in0(w_s_cyc), .in1(w_addr3_bar), .in2(w_addr2_bar), .in3(s_we), .out(w_ld0));
and4$ u_and2(.in0(w_s_cyc), .in1(w_addr3_bar), .in2(s_addr[2]), .in3(s_we), .out(w_ld1));

// DMA slave interface register instantiation

always @(posedge clk, negedge rst_n) begin
  if(~rst_n) begin
    pol_stat <= 32'd0;
    key_val  <= 32'd0;
  end
  else begin
    if(w_ld0) pol_stat <= s_data_i;
    if(w_ld1) key_val  <= s_data_i;
  end
end

// DMA slave read
mux32bit_2x1 u_mux32bit_2x1(.Y(s_data_o), .IN0(pol_stat), .IN1(key_val), .S0(s_addr[2]));

initial begin
  forever begin
     repeat (10) begin
       @(posedge clk);
     end
     pol_stat = 32'd1;
     temp  = $random();
     key_val = {24'd0,temp};
     wait(~pol_stat);
     repeat (5) begin
       @(posedge clk);
     end
  end
end

endmodule

