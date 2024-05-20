`timescale 1ns / 1ps

module G_MS(input sys_clk,
	input  [9:0] char_X,
	input  [9:0] char_Y,
	input  [9:0] bg_pos,
	input RST_N,
    output wire [9:0] g_ms_x,
    output wire [9:0] g_ms_y,
    output touch_g_ms,
    output  en
);
  reg [9:0] g_ms_x_r = 10'd305;
  reg [9:0] g_ms_y_r = 10'd115;
  reg enable = 1'b1;
  reg touch;
  assign g_ms_x = g_ms_x_r - bg_pos;
  assign g_ms_y = g_ms_y_r;
  assign touch_g_ms = touch & enable;
  assign en = enable;
  
  always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= g_ms_x_r) && (char_X <= g_ms_x_r + 10'd12)) || ((char_X + 10'd12 >= g_ms_x_r) && (char_X + 10'd12 <= g_ms_x_r + 10'd12)))) & ((((char_Y >= g_ms_y_r) && (char_Y <= g_ms_y_r + 10'd12)) || ((char_Y + 10'd12 >= g_ms_y_r) && (char_Y + 10'd12 <= g_ms_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= 1'b0;
    end
    
endmodule