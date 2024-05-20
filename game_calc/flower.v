`timescale 1ns / 1ps


module FLOWER(input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] flower_x,
    output wire [9:0] flower_y,
    output touch_flower,
    output  en
);
  reg [9:0] flower_x_r = 10'd260;
  reg [9:0] flower_y_r = 10'd115;
  reg enable = 1'b1;
  reg touch;
  assign flower_x = flower_x_r - bg_pos;
  assign flower_y = flower_y_r;
  assign touch_flower = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= flower_x_r) && (char_X <= flower_x_r + 10'd12)) || ((char_X + 10'd12 >= flower_x_r) && (char_X + 10'd12 <= flower_x_r + 10'd12)))) & ((((char_Y >= flower_y_r) && (char_Y <= flower_y_r + 10'd12)) || ((char_Y + 10'd12 >= flower_y_r) && (char_Y + 10'd12 <= flower_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end
    
endmodule
