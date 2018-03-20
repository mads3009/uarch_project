module tb();

reg [6:0] A;
wire [7:0] DIO;
reg WR,OE;
reg CE;

reg [7:0] r_Din;

assign DIO = WR ? 8'hzz : r_Din;

sram128x8$ u_sram128x8$ (A,DIO,OE,WR, CE);

initial
begin

OE = 1'b1;
CE = 1'b1;
WR = 1'b1;
u_sram128x8$.mem[127] = 8'h12;
u_sram128x8$.mem[126] = 8'h34;
u_sram128x8$.mem[125] = 8'h56;
u_sram128x8$.mem[124] = 8'h78;

#100
CE = 1'b0;
WR = 1'b1;
OE = 1'b0;

#100;

A = 7'h7F;
#36;
A = 7'h7E;
#36;
A = 7'h7D;

/*
#100;

A = 7'h7D;
WR = 1'b0;
r_Din = 8'hzz;
OE = 1'b0;
CE = 1'b0;

#100;

A = 7'h7C;
WR = 1'b0;
r_Din = 8'h00;
OE = 1'b0;
CE = 1'b0;

#100;

A = 7'h7B;
WR = 1'b0;
r_Din = 8'hx1;
OE = 1'b0;
CE = 1'b0;

#100;

A = 7'h7A;
WR = 1'b0;
r_Din = 8'h0x;
OE = 1'b0;
CE = 1'b0;
*/
#1000;
$finish;

end

endmodule
