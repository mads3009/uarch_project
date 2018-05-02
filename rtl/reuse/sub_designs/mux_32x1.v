module mux_32x1 (
   input a0,
   input a1,
   input a2,
   input a3,
   input a4,
   input a5,
   input a6,
   input a7,
   input a8,
   input a9,
   input a10,
   input a11,
   input a12,
   input a13,
   input a14,
   input a15,
   input a16,
   input a17,
   input a18,
   input a19,
   input a20,
   input a21,
   input a22,
   input a23,
   input a24,
   input a25,
   input a26,
   input a27,
   input a28,
   input a29,
   input a30,
   input a31,
   input [4:0] sel,
   output out
);

wire [15:0] a_1;
wire [15:0] a_2;

assign a_1 = {a15,a14,a13,a12,a11,a10,a9,a8,a7,a6,a5,a4,a3,a2,a1,a0};
assign a_2 = {a31,a30,a29,a28,a27,a26,a25,a24,a23,a22,a21,a20,a19,a18,a17,a16};

mux_16x1 u_mux_16x1_1(.a(a_1), .sel(sel[3:0]), .out(out0));
mux_16x1 u_mux_16x1_2(.a(a_2), .sel(sel[3:0]), .out(out1));
mux2$ mux2 (.in0(out0), .in1(out1), .s0(sel[4]), .outb(out));

endmodule


