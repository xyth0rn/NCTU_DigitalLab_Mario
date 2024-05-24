`timescale 1ns / 1ps


module KOOPA(input sys_clk, 
	         input  [9:0] char_X,
	         input  [9:0] char_Y,
	         input  [9:0] bg_pos,
	         input RST_N,
             output wire [9:0] koopa_x,
             output wire [9:0] koopa_y,
             output death,
             output en
);
  reg [9:0] koopa_x_r = 10'd480;
  reg [9:0] koopa_y_r = 10'd100;
  reg enable = 1'b1;


  
  assign koopa_x = koopa_x_r - bg_pos;
  assign koopa_y = koopa_y_r;
 
 assign death = ((char_X + 10'd12 == koopa_x_r) | (char_X == koopa_x_r + 10'd12)) & (char_Y == koopa_y_r) & enable;
 assign en = enable;
 
 always@(posedge sys_clk or negedge RST_N)
   begin 
     if(!RST_N)
       enable <= 1'b1;
     else if( (((char_X >= koopa_x_r) && (char_X <= koopa_x_r + 10'd12)) || ((char_X + 10'd12 >= koopa_x_r) && (char_X + 10'd12 <= koopa_x_r + 10'd12))) && (char_Y + 10'd12 == koopa_y_r) )
       enable <= 1'b0;
     else
      enable <= enable;
    end

endmodule