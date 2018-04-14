module pencoder_3_2 (
  input a0,
  input a1,
  input a2,
  output reg [1:0] out
);

always @(*) begin
  case({a2,a1,a0})
    3'b001 : out = 2'b01;
    3'b011 : out = 2'b01;
    3'b101 : out = 2'b01;
    3'b111 : out = 2'b01;

    3'b010 : out = 2'b10;
    3'b110 : out = 2'b10;

    3'b100 : out = 2'b11;

    3'b000 : out = 2'b00;
  endcase
end

endmodule
