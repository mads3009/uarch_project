module mux_nbit_4x1 (a0,a1,a2,a3,sel,out);
    parameter N = 32; 
    input [N-1:0] a0;
    input [N-1:0] a1;
    input [N-1:0] a2;
    input [N-1:0] a3;
    input [1:0] sel;
    output [N-1:0] out;

    //FIXME: may need buffers for fanout > 4

    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin : mux_gen
        mux4$ u_mux_4x1 (.in0(a0[i]), .in1(a1[i]), .in2(a2[i]), .in3(a3[i]), .s0(sel[0]), .s1(sel[1]), .outb(out[i]));
    end
    end
    endgenerate

endmodule
