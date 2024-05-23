`timescale 1ns / 1ps

module win_LED( input clk_25mhz,
                input win,
                output [15:0] LED
    );

  reg [15:0] led = 16'b1010101010101010;
  reg clk_10Hz = 0;
  reg [25:0] clk_counter = 0;
  always@(posedge clk_10Hz)
    begin
        led <= {led[0], led[15:1]};
    end

assign LED = win? led : 16'd0;


always@(posedge clk_25mhz)
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
