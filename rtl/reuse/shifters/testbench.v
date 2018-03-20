module testbench();

// Paramters
parameter WIDTH = 32;
parameter AMT_W = $clog2(WIDTH);

// Input and Output ports
reg  [AMT_W-1:0] amt;
reg  [WIDTH-1:0] in;

wire [WIDTH-1:0] out_sar;
wire             sout_sar;
wire [WIDTH-1:0] out_slr;
wire             sout_slr;

wire [WIDTH-1:0] out_sll;

// Module instantiation
shift_right #(.WIDTH(WIDTH)) u_SAR(.amt(amt),.sin(in[WIDTH-1]),.in(in),.out(out_sar),.sout(sout_sar));
shift_right #(.WIDTH(WIDTH)) u_SLR(.amt(amt),.sin(1'b0),.in(in),.out(out_slr),.sout(sout_slr));

shift_left #(.WIDTH(WIDTH)) u_SLL(.amt(amt),.sin(1'b0),.in(in),.out(out_sll));

// Testbench

initial begin

amt = 5'd0;
in = 32'd0;

#10;

amt = 5'd10;
in = 32'hFFFF_FFFF;


#10;

amt = 5'd1;
in = 32'hAAAA_AAAA;


#10;

amt = 5'd2;
in = 32'hAAAA_AAAA;

#10;

amt = 5'd3;
in = 32'hAAAA_AAAA;

#10;

amt = 5'd4;
in = 32'hAAAA_AAAA;

#10;

end

endmodule

