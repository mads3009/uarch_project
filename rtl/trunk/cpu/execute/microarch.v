module nand2$ ( in0, in1, out );
input in0, in1;
output out;

assign out = ~(in0&in1);

endmodule

module or2$ ( in0, in1, out );
input in0, in1;
output out;

assign out = in0|in1;

endmodule

module or3$ ( in0, in1, in2, out );
input in0, in1, in2;
output out;

assign out = in0|in1|in2;

endmodule

module or4$ ( in0, in1, in2, in3, out );
input in0, in1, in2, in3;
output out;

assign out = in0|in1|in2|in3;

endmodule

module mux2$ ( in0, in1, s0, outb );
input in0, in1, s0;
output outb;

assign outb = s0? in1: in0;

endmodule

module nand3$ ( in0, in1, in2, out );
input in0, in1, in2;
output out;

assign out = ~(in0&in1&in2);

endmodule

module xor2$ ( in0, in1, out );
input in0, in1;
output out;

assign out = in0^in1;

endmodule


module inv1$ ( in, out );
input in;
output out;

assign out = ~in;

endmodule


module  tristate16H$(enbar, in, out);
input         enbar;
input  [15:0] in;
output [15:0] out;

assign out = enbar ? 16'hzzzz : in;
 
endmodule

module decoder3_8$(SEL,Y,YBAR);
  input [2:0] SEL;
  output [7:0] Y;
  output [7:0] YBAR;

  reg [7:0] Y_temp;
  reg [7:0] YBAR_temp;
  integer i;

  assign Y = Y_temp;
  assign YBAR = YBAR_temp;

  always
    @(SEL)
      begin
      for(i = 0;(i <= 7);i = (i + 1))
        if(i == SEL)
	begin
          Y_temp[i] = 1'b1;
          YBAR_temp[i] = 1'b0;
	end
        else
	begin
          Y_temp[i] = 1'b0;
          YBAR_temp[i] = 1'b1;
	end
      end

endmodule

module mux2_16$(Y,IN0,IN1,S0);
  input [15:0] IN0;
  input [15:0] IN1;
  input  S0;
  output [15:0] Y;

assign Y = S0? IN1 : IN0;

endmodule

module mux4_16$(Y,IN0,IN1,IN2,IN3,S0,S1);
input [15:0] IN0;
input [15:0] IN1;
input [15:0] IN2;
input [15:0] IN3;
input  S0;
input  S1;
output [15:0] Y;

reg [15:0] temp;

always @(*) begin
  case({S1,S0})
    2'b00: temp = IN0;
    2'b01: temp = IN1;
    2'b10: temp = IN2;
    2'b11: temp = IN3;
  endcase
end

assign Y = temp;

endmodule

