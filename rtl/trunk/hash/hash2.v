module hash2 ( byte_in, nibble_out);

input [7:0] byte_in;

output [4:0] nibble_out;

reg [4:0] nibble_out;

always @(*) begin
  case(byte_in)
    8'h80: nibble_out = 5'd0;
    8'h81: nibble_out = 5'd1;
    8'h82: nibble_out = 5'd2;
    8'h83: nibble_out = 5'd3;
    8'h87: nibble_out = 5'd4;
    8'hB0: nibble_out = 5'd5;
    8'hC0: nibble_out = 5'd6;
    8'hC1: nibble_out = 5'd7;
    8'hD0: nibble_out = 5'd8;
    8'hD1: nibble_out = 5'd9;
    8'hD2: nibble_out = 5'd10;
    8'hD3: nibble_out = 5'd11;
    8'hFD: nibble_out = 5'd12;
    8'hFE: nibble_out = 5'd13;
    8'hFF: nibble_out = 5'd14;
    default: nibble_out = 5'd15;
  endcase
end

endmodule
