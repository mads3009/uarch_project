/*************** Microarchiture Project******************/
/********************************************************/
/* Module: Access2 combinational signal generation      */
/* Description: Detect if 2nd access is required        */
/********************************************************/

module access2_combo_gen(access2_combo, offset, size);

input  [3:0] offset;
input  [1:0] size;
output       access2_combo;

wire n_1, n_4, n_5, n_6, n_7, n_8, n_10, n_11, n_19;

nand3$ g699(.in0 (n_10), .in1 (n_11), .in2 (n_7), .out(access2_combo));
nand3$ g700(.in0 (n_5), .in1 (n_8), .in2 (offset[0]), .out (n_11));
nand2$ g701(.in0 (n_6), .in1 (n_19), .out (n_10));
nand2$ g702(.in0 (n_4), .in1 (n_1), .out (n_8));
nand4$ g705(.in0 (offset[1]), .in1 (offset[2]), .in2 (offset[3]), .in3 (size[1]), .out (n_7));
and3$ g703(.in0 (offset[3]), .in1 (size[1]), .in2 (size[0]), .out (n_6));
and2$ g706(.in0 (offset[3]), .in1 (offset[2]), .out (n_5));
nand2$ g707(.in0 (offset[1]), .in1 (size[0]), .out (n_4));
inv1$ g708(.in (size[1]), .out (n_1));
or3$ g2(.in0 (offset[2]), .in1 (offset[1]), .in2 (offset[0]), .out (n_19));

/*
assign w_offset_gt8 = offset > 4'd8;
assign w_offset_gt12 = offset > 4'd12;
assign w_offset_eq15 = offset == 4'd15;

assign w_size_eq8 = size == 2'b11;
assign w_size_eq4 = size == 2'b10;
assign w_size_eq2 = size == 2'b01;

assign access2_combo = (w_size_eq2 & w_offset_eq15) | (w_size_eq4 & w_offset_gt12) | (w_size_eq8 & w_offset_gt8);
*/
endmodule

