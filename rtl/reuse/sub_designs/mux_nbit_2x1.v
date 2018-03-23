module mux_nbit_2x1 (a0,a1,sel,out);
    parameter N = 32; 
    input [N-1:0] a0;
    input [N-1:0] a1;
    input sel;
    output [N-1:0] out;

    //FIXME: may need buffers for fanout > 4

    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin
        mux_2x1 u_mux_2x1 (a0[i], a1[i], sel, out[i]);
    end
    end
    endgenerate

endmodule
