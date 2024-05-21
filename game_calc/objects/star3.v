`timescale 1ns / 1ps

module STAR3(input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] star3_x,
    output wire [9:0] star3_y,
    output touch_star3,
    output  en
);
  reg [9:0] star3_x_r = 10'd347;
  reg [9:0] star3_y_r = 10'd56;
  reg enable = 1'b1;
  reg touch;
  assign star3_x = star3_x_r - bg_pos;
  assign star3_y = star3_y_r;
  assign touch_star3 = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= star3_x_r) && (char_X <= star3_x_r + 10'd12)) || ((char_X + 10'd12 >= star3_x_r) && (char_X + 10'd12 <= star3_x_r + 10'd12)))) & ((((char_Y >= star3_y_r) && (char_Y <= star3_y_r + 10'd12)) || ((char_Y + 10'd12 >= star3_y_r) && (char_Y + 10'd12 <= star3_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end
    
endmodule