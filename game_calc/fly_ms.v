`timescale 1ns / 1ps

module FLY_MS(input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] fly_ms_x,
    output wire [9:0] fly_ms_y,
    output touch_fly_ms,
    output  en
);
  reg [9:0] fly_ms_x_r = 10'd180;
  reg [9:0] fly_ms_y_r = 10'd290;
  reg enable = 1'b1;
  reg touch;
  assign fly_ms_x = fly_ms_x_r - bg_pos;
  assign fly_ms_y = fly_ms_y_r;
  assign touch_fly_ms = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= fly_ms_x_r) && (char_X <= fly_ms_x_r + 10'd12)) || ((char_X + 10'd12 >= fly_ms_x_r) && (char_X + 10'd12 <= fly_ms_x_r + 10'd12)))) & ((((char_Y >= fly_ms_y_r) && (char_Y <= fly_ms_y_r + 10'd12)) || ((char_Y + 10'd12 >= fly_ms_y_r) && (char_Y + 10'd12 <= fly_ms_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end


endmodule