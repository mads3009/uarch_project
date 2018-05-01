module mux_nbit_32x1 #(parameter N = 32) ( 
    input [N-1:0] a0,
    input [N-1:0] a1,
    input [N-1:0] a2,
    input [N-1:0] a3,
    input [N-1:0] a4,
    input [N-1:0] a5,
    input [N-1:0] a6,
    input [N-1:0] a7,
    input [N-1:0] a8,
    input [N-1:0] a9,
    input [N-1:0] a10,
    input [N-1:0] a11,
    input [N-1:0] a12,
    input [N-1:0] a13,
    input [N-1:0] a14,
    input [N-1:0] a15,
    input [N-1:0] a16,
    input [N-1:0] a17,
    input [N-1:0] a18,
    input [N-1:0] a19,
    input [N-1:0] a20,
    input [N-1:0] a21,
    input [N-1:0] a22,
    input [N-1:0] a23,
    input [N-1:0] a24,
    input [N-1:0] a25,
    input [N-1:0] a26,
    input [N-1:0] a27,
    input [N-1:0] a28,
    input [N-1:0] a29,
    input [N-1:0] a30,
    input [N-1:0] a31,

    input [4:0] sel,
    output [N-1:0] out
  );
    //FIXME: may need buffers for fanout > 4

    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin : mux_gen
        mux_32x1 u_mux_32x1 ( .a0  ( a0 [i]),  
                              .a1  ( a1 [i]),
                              .a2  ( a2 [i]),
                              .a3  ( a3 [i]),
                              .a4  ( a4 [i]),
                              .a5  ( a5 [i]),
                              .a6  ( a6 [i]),
                              .a7  ( a7 [i]),
                              .a8  ( a8 [i]),
                              .a9  ( a9 [i]),
                              .a10 ( a10[i]),
                              .a11 ( a11[i]),
                              .a12 ( a12[i]),
                              .a13 ( a13[i]),
                              .a14 ( a14[i]),
                              .a15 ( a15[i]),
                              .a16 ( a16[i]),
                              .a17 ( a17[i]),
                              .a18 ( a18[i]),
                              .a19 ( a19[i]),
                              .a20 ( a20[i]),
                              .a21 ( a21[i]),
                              .a22 ( a22[i]),
                              .a23 ( a23[i]),
                              .a24 ( a24[i]),
                              .a25 ( a25[i]),
                              .a26 ( a26[i]),
                              .a27 ( a27[i]),
                              .a28 ( a28[i]),
                              .a29 ( a29[i]),
                              .a30 ( a30[i]),
                              .a31 ( a31[i]),
                              .sel (  sel  ),
                              .out ( out[i]));
                
    end
    end
    endgenerate

endmodule
