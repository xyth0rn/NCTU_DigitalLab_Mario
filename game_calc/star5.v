`timescale 1ns / 1ps

module STAR5(input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] star5_x,
    output wire [9:0] star5_y,
    output touch_star5,
    output  en
);
  reg [9:0] star5_x_r = 10'd900;
  reg [9:0] star5_y_r = 10'd306;
  reg enable = 1'b1;
  reg touch;
  assign star5_x = star5_x_r - bg_pos;
  assign star5_y = star5_y_r;
  assign touch_star5 = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= star5_x_r) && (char_X <= star5_x_r + 10'd12)) || ((char_X + 10'd12 >= star5_x_r) && (char_X + 10'd12 <= star5_x_r + 10'd12)))) & ((((char_Y >= star5_y_r) && (char_Y <= star5_y_r + 10'd12)) || ((char_Y + 10'd12 >= star5_y_r) && (char_Y + 10'd12 <= star5_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end
    
endmodule