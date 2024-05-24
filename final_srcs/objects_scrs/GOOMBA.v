`timescale 1ns / 1ps

module GOOMBA(input sys_clk, 
	         input  [9:0] char_X,
	         input  [9:0] char_Y,
	         input  [9:0] bg_pos,
	         input RST_N,
             output wire [9:0] goomba_x,
             output wire [9:0] goomba_y,
             output death,
             output en
);
  reg [9:0] goomba_x_r = 10'd172;
  reg [9:0] goomba_y_r = 10'd56;
  reg enable = 1'b1;


  
  assign goomba_x = goomba_x_r - bg_pos;
  assign goomba_y = goomba_y_r;
 
 assign death = ((char_X + 10'd12 == goomba_x_r) | (char_X == goomba_x_r + 10'd12)) & (char_Y == goomba_y_r) & enable;
 assign en = enable;
 
 always@(posedge sys_clk or negedge RST_N)
   begin 
     if(!RST_N)
       enable <= 1'b1;
     else if( (((char_X >= goomba_x_r) && (char_X <= goomba_x_r + 10'd12)) || ((char_X + 10'd12 >= goomba_x_r) && (char_X + 10'd12 <= goomba_x_r + 10'd12))) && (char_Y + 10'd12 == goomba_y_r) )
       enable <= 1'b0;
     else
      enable <= enable;
    end

endmodule
