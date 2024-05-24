`timescale 1ns / 1ps

module POISON_STAR(input sys_clk,
	               input  [9:0] char_X,
	               input  [9:0] char_Y,
	                input  [9:0] bg_pos,
	                input RST_N,
                    output wire [9:0] poison_star_x,
                    output wire [9:0] poison_star_y,
                    output death,
                    output en
);
  reg [9:0] poison_star_x_r = 10'd192;
  reg [9:0] poison_star_y_r = 10'd56;
  reg enable = 1'b1;


  
  assign poison_star_x = poison_star_x_r - bg_pos;
  assign poison_star_y = poison_star_y_r;
 
 assign death =  ((((char_X >= poison_star_x_r) && (char_X <= poison_star_x_r + 10'd12)) || ((char_X + 10'd12 >= poison_star_x_r) && (char_X + 10'd12 <= poison_star_x_r + 10'd12)))) & ((((char_Y >= poison_star_y_r) && (char_Y <= poison_star_y_r + 10'd12)) || ((char_Y + 10'd12 >= poison_star_y_r) && (char_Y + 10'd12 <= poison_star_y_r + 10'd12))));
 assign en = enable;


endmodule
