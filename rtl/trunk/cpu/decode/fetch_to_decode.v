module fetch_to_decode (de_lower_16bytes,
                        w_pr_repne,
                        w_pr_cs_over,
                        w_pr_ss_over,
                        w_pr_ds_over,
                        w_pr_es_over,
                        w_pr_fs_over,
                        w_pr_gs_over,
                        w_pr_size_over,
                        w_pr_0f,
                        w_pr_pos,
                        w_mux_sel);

input  [31:0] de_lower_16bytes;
output [3:0]  w_pr_repne;
output [3:0]  w_pr_cs_over;
output [3:0]  w_pr_ss_over;
output [3:0]  w_pr_ds_over;
output [3:0]  w_pr_es_over;
output [3:0]  w_pr_fs_over;
output [3:0]  w_pr_gs_over;
output [3:0]  w_pr_size_over;
output [3:0]  w_pr_0f;
output [3:0]  w_pr_pos;
output [2:0]  w_mux_sel;

genvar i;
generate
  for (i=0; i<4; i=i+1) begin : pref_comp_gen
eq_checker8 u_eq_checker8_1(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'hF2), .eq_out(w_pr_repne[i]));
eq_checker8 u_eq_checker8_2(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h2E), .eq_out(w_pr_cs_over[i]));
eq_checker8 u_eq_checker8_3(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h36), .eq_out(w_pr_ss_over[i]));
eq_checker8 u_eq_checker8_4(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h3E), .eq_out(w_pr_ds_over[i]));
eq_checker8 u_eq_checker8_5(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h26), .eq_out(w_pr_es_over[i]));
eq_checker8 u_eq_checker8_6(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h64), .eq_out(w_pr_fs_over[i]));
eq_checker8 u_eq_checker8_7(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h65), .eq_out(w_pr_gs_over[i]));
eq_checker8 u_eq_checker8_8(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h66), .eq_out(w_pr_size_over[i]));
eq_checker8 u_eq_checker8_9(.in1(de_lower_16bytes[(i*8)+7:i*8]), .in2(8'h0F), .eq_out(w_pr_0f[i]));
or9 u_or9_1 (.in0(w_pr_repne[i]), .in1(w_pr_cs_over[i]), .in2(w_pr_ss_over[i]), .in3(w_pr_ds_over[i]), 
             .in4(w_pr_es_over[i]), .in5(w_pr_fs_over[i]), .in6(w_pr_gs_over[i]), .in7(w_pr_size_over[i]), .in8(w_pr_0f[i]), .out(w_pr_pos[i]) );
  end
endgenerate

//Prefix Counter
wire pr_pos_0_bar;
wire pr_pos_1_bar;
wire pr_pos_2_bar;
wire and_temp1;
wire nand_temp1;
wire nand_temp2;
wire nand_temp3;

inv1$ inv1 (.in(w_pr_pos[3]), .out(pr_pos_0_bar));
inv1$ inv3 (.in(w_pr_pos[1]), .out(pr_pos_2_bar));

and4$ and4_1 (.in0(w_pr_pos[0]), .in1(w_pr_pos[1]), .in2(w_pr_pos[2]), .in3(w_pr_pos[3]), .out(w_mux_sel[2]));

and2$ and2_1 (.in0(w_pr_pos[0]), .in1(w_pr_pos[1]), .out(and_temp1)); 
nand2$ nand2_1   (.in0(w_pr_pos[2]), .in1(w_pr_pos[3]), .out(nand_temp1)); 
and2$ and2_2 (.in0(and_temp1), .in1(nand_temp1), .out(w_mux_sel[1])); 

nand2$ nand2_2 (.in0(w_pr_pos[0]), .in1(pr_pos_2_bar), .out(nand_temp2)); 
nand3$ nand3_1 (.in0(w_pr_pos[0]), .in1(w_pr_pos[2]), .in2(pr_pos_0_bar), .out(nand_temp3)); 
nand2$ nand2_3   (.in0(nand_temp2), .in1(nand_temp3), .out(w_mux_sel[0])); 

endmodule
