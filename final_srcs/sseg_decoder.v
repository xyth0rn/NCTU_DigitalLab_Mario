`timescale 1ns / 1ps

module BCD_to_7seg( input [3:0] BCD,
                    output [7:0] A_G
);
  reg [7:0] a_g;
  always@(*)
    begin
      case(BCD)
        4'b0000: a_g = 8'b00000011;
        4'b0001: a_g = 8'b10011111;
        4'b0010: a_g = 8'b00100101;
        4'b0011: a_g = 8'b00001101;
        4'b0100: a_g = 8'b10011001;
        4'b0101: a_g = 8'b01001001;
        4'b0110: a_g = 8'b01000001;
        4'b0111: a_g = 8'b00011111;
        4'b1000: a_g = 8'b00000001;
        4'b1001: a_g = 8'b00001001;
        default: a_g = 8'b11111111;        
      endcase
    end
  assign A_G = a_g;
endmodule
