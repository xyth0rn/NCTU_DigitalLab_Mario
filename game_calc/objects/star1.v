`timescale 1ns / 1ps

module STAR1(
	input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] star1_x,
    output wire [9:0] star1_y,
    output touch_star1,
    output  en
);
  reg [9:0] star1_x_r = 10'd236;
  reg [9:0] star1_y_r = 10'd200;
  reg enable = 1'b1;
  reg touch;
  assign star1_x = star1_x_r - bg_pos;
  assign star1_y = star1_y_r;
  assign touch_star1 = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= star1_x_r) && (char_X <= star1_x_r + 10'd12)) || ((char_X + 10'd12 >= star1_x_r) && (char_X + 10'd12 <= star1_x_r + 10'd12)))) & ((((char_Y >= star1_y_r) && (char_Y <= star1_y_r + 10'd12)) || ((char_Y + 10'd12 >= star1_y_r) && (char_Y + 10'd12 <= star1_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end
endmodule


