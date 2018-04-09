module ram_nB_8w(A, DIN, WR, OE, DOUT);
    parameter N = 32;
    input [2:0] A;
    input [8*N-1:0] DIN ;
    input WR, OE;
    output [8*N-1:0] DOUT ;
    
    genvar i;
    generate begin : loop
    for (i=0; i<N; i=i+1) begin: mem_gen
        ram8b8w$ ram_forcache (.A(A), .DIN(DIN[8*i+7:8*i]), .OE(OE), .WR(WR), .DOUT(DOUT[8*i+7:8*i]));
    end
    end
    endgenerate
endmodule
