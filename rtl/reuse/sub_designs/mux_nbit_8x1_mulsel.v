module mux_nbit_8x1_mulsel (a0,a1,a2,a3,a4,a5,a6,a7, s0, s1, s2, s3, s4, s5, s6, s7, out);
    parameter N = 32; 
    input [N-1:0] a0;
    input [N-1:0] a1;
    input [N-1:0] a2;
    input [N-1:0] a3;
    input [N-1:0] a4;
    input [N-1:0] a5;
    input [N-1:0] a6;
    input [N-1:0] a7;
    input s0;
    input s1;
    input s2;
    input s3;
    input s4;
    input s5;
    input s6;
    input s7;
    output [N-1:0] out;

    //FIXME: may need buffers for fanout > 4
    wire [N-1:0] w0,w1,w2,w3,w4,w5,w6,w7;
    wire [N-1:0] x0,x1;

    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin
        nand2$ u_andwithsel0 (a0[i], s0, w0[i]);
        nand2$ u_andwithsel1 (a1[i], s1, w1[i]);
        nand2$ u_andwithsel2 (a2[i], s2, w2[i]);
        nand2$ u_andwithsel3 (a3[i], s3, w3[i]);
        nand2$ u_andwithsel4 (a4[i], s4, w4[i]);
        nand2$ u_andwithsel5 (a5[i], s5, w5[i]);
        nand2$ u_andwithsel6 (a6[i], s6, w6[i]);
        nand2$ u_andwithsel7 (a7[i], s7, w7[i]);

        and4$ u_l1_0 (x0[i], w0[i], w1[i], w2[i], w3[i]);
        and4$ u_l1_1 (x1[i], w4[i], w5[i], w6[i], w7[i]);
        nand2$ u_out (out[i], x0[i], x1[i]);

    end
    end
    endgenerate

endmodule
