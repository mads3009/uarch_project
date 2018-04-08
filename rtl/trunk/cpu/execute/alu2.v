module alu2(EIP_next, sr1, sr2, esp, DF_in, mem_rd_size, mem_wr_size, alu2_op, alu_res2);
input  [31:0] EIP_next;
input  [31:0] sr1;
input  [31:0] sr2;
input  [31:0] esp;
input  [1:0]  mem_rd_size;
input  [1:0]  mem_wr_size;
input  [3:0]  alu2_op;
input         DF_in;
output [31:0] alu_res2;

//mux0
wire [31:0] mux0_res;
mux_nbit_4x1 #32 mux0  (.a0(sr1), .a1(sr2), .a2(EIP_next), .a3(32'd0), .sel(alu2_op[1:0]), .out(mux0_res));

//esp 
wire [31:0] esp_inc;
wire [31:0] esp_dec;
wire [31:0] esp_change;
wire [31:0] w_esp_ch_res;
mux_nbit_4x1 #32 esp_size0  (.a0(32'd1), .a1(32'd2), .a2(32'd4), .a3(32'd8), .sel(mem_rd_size), .out(esp_inc));
mux_nbit_4x1 #32 esp_size1  (.a0(32'hFFFF), .a1(32'hFFFE), .a2(32'hFFFC), .a3(32'hFFF8), .sel(mem_wr_size), .out(esp_dec));

mux_nbit_2x1 #32 esp_ch  (.a0(esp_inc), .a1(esp_dec), .sel(alu2_op[1]), .out(esp_change));
cond_sum32 u_esp_ch( .A(esp), .B(esp_change), .CIN(1'd0), .S(w_esp_ch_res), .COUT(/*unused*/));

//sr2
wire [31:0] sr2_inc;
wire [31:0] sr2_dec;
wire [31:0] sr2_change;
wire [31:0] mux1_res;
wire [31:0] w_sr2_ch_res;
mux_nbit_4x1 #32 sr2_size0  (.a0(32'd1), .a1(32'd2), .a2(32'd4), .a3(32'd8), .sel(mem_rd_size), .out(sr2_inc));
mux_nbit_4x1 #32 sr2_size1  (.a0(32'hFFFF), .a1(32'hFFFE), .a2(32'hFFFC), .a3(32'hFFF8), .sel(mem_rd_size), .out(sr2_dec));

mux_nbit_2x1 #32 sr2_ch  (.a0(sr2_inc), .a1(sr2_dec), .sel(DF_in), .out(sr2_change));
cond_sum32 u_sr2_ch( .A(sr2), .B(sr2_change), .CIN(1'd0), .S(w_sr2_ch_res), .COUT(/*unused*/));


mux_nbit_2x1 #32 mux1  (.a0(w_esp_ch_res), .a1(w_sr2_ch_res), .sel(alu2_op[0]), .out(mux1_res));

//mux2

wire [31:0] mux2_res;
mux_nbit_2x1 #32 mux2  (.a0(mux0_res), .a1(mux1_res), .sel(alu2_op[2]), .out(mux2_res));

//esp_with_imm
wire [31:0] w_esp_imm;
wallace_abc_adder wal_e ( .A(esp), .B(esp_inc), .C(sr2), .CIN(1'b0), .S(w_esp_imm) );

//Final mux
mux_nbit_2x1 #32 mux3  (.a0(mux2_res), .a1(w_esp_imm), .sel(alu2_op[3]), .out(alu_res2));

endmodule






