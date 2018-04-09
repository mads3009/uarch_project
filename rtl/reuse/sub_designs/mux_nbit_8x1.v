module mux_nbit_8x1 #(parameter N = 32) ( 
    input [N-1:0] a0,
    input [N-1:0] a1,
    input [N-1:0] a2,
    input [N-1:0] a3,
    input [N-1:0] a4,
    input [N-1:0] a5,
    input [N-1:0] a6,
    input [N-1:0] a7,
    input [2:0] sel,
    output [N-1:0] out
  );
    //FIXME: may need buffers for fanout > 4

    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin : mux_gen
        mux_8x1 u_mux_8x1 (.a0(a0[i]), .a1(a1[i]), .a2(a2[i]), .a3(a3[i]), .a4(a4[i]), .a5(a5[i]), .a6(a6[i]), .a7(a7[i]), .sel(sel), .out(out[i]));
    end
    end
    endgenerate

endmodule
