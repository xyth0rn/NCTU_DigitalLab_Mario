`timescale 1ns / 1ps

module spring( input sys_clk,
               input [8:0] char_X,
               input [8:0] char_Y,
               input [8:0] scroll_left_border,
               input [8:0] scroll_right_border,
               output reg [8:0] spring_pos_X,
               output reg [8:0] spring_pos_Y,
               output jump
    );
  //character size: 16x16
  //spring size: 16x16
  parameter [8:0] spring_size = 9'd16;
  parameter [8:0] char_size = 9'd16;
  
  wire enable; 
  reg contact;
  
  initial 
    begin
      spring_pos_X = 9'dX; //absolute X-coordinate 
      spring_pos_Y = 9'dX; //absolute Y-coordinate
    end
  assign enable = ((spring_pos_X <= scroll_right_border) && (spring_pos_X + spring_size >= scroll_left_border));
  
  always@(posedge sys_clk)
    begin
      if(enable)
        begin
          if((((char_X + char_size <= spring_pos_X + spring_size) && (char_X + char_size >= spring_pos_X)) || ((char_X >= spring_pos_X) && (char_X <= spring_pos_X + spring_size))) && (char_Y + char_size == spring_pos_Y))
            contact <= 1'b1;
          else
            contact <= 1'b0;
        end
      else
        contact <= 1'b0;
    end    
  
  assign jump = contact;    

endmodule
