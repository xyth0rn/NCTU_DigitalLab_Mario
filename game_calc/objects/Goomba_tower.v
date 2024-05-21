`timescale 1ns / 1ps


module GOOMBA_TOWER(input sys_clk,
	                input  [9:0] char_X,
	                input  [9:0] char_Y,
	                input  [9:0] bg_pos,
	                input RST_N,
                    output wire [9:0] goomba_tower_x,
                    output wire [9:0] goomba_tower_y,
                    output death,
                    output en
);
  reg [9:0] goomba_tower_x_r = 10'd124;
  reg [9:0] goomba_tower_y_r = 10'd390;
  reg state = 0;
  reg [9:0] mov_counter = 0;
  reg clk_10Hz = 1;
  reg [25:0] clk_counter = 0;
  reg enable = 1'b1;
 assign death = ((char_X + 10'd12 == goomba_tower_x_r) | (char_X == goomba_tower_x_r + 10'd12)) & (char_Y > goomba_tower_y_r) ;
 assign en = enable;
  always@(posedge clk_10Hz or negedge RST_N)
    begin
      if(!RST_N)
        begin
          goomba_tower_x_r <= 10'd112;
          goomba_tower_y_r <= 10'd366;
          state <= 0;
          mov_counter <= 0;
        end
      else if(!state)
        begin
          if(mov_counter == 100)
            begin
              mov_counter <= 0;
              state <= ~state;
            end
          else
            begin
              goomba_tower_x_r <= goomba_tower_x_r - 1;
              mov_counter <= mov_counter + 1;
            end
        end      
      else
        begin
          if(mov_counter == 100)
            begin
              mov_counter <= 0;
              state <= ~state;
            end
          else
            begin
              goomba_tower_x_r <= goomba_tower_x_r + 1;
              mov_counter <= mov_counter + 1;
            end
        end
    end
 
  assign goomba_tower_x = goomba_tower_x_r - bg_pos;
  assign goomba_tower_y = goomba_tower_y_r;
  
  
  always@(posedge sys_clk)
    begin
      if(clk_counter  == 1000000)
        begin
          clk_counter <= 0;
          clk_10Hz <= ~clk_10Hz;
        end
      else
        clk_counter <= clk_counter + 1;
    end

endmodule
