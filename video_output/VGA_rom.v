`timescale 1ns / 1ps
/*
Reads a ROM file picture (`.coe` file) and prints screen via VGA
*/


module VGA(
    // input
    sys_clk,    //100MHZ
    Rst_n,

    // output
    VGA_RGB,
    VGA_HSYNC, 
    VGA_VSYNC 
);
    // inputs
    input sys_clk;
    input Rst_n;

    // outputs
    output [11:0] VGA_RGB;
    output VGA_HSYNC;
    output VGA_VSYNC;
    
    // local wires
    wire [18:0] vram_address;
    wire [11:0] vram_dat;
    wire [9:0] x_pixel;
    wire [9:0] y_pixel;
    wire clk_25mhz;
    wire VGA_BLOCK;

    // system clock (100mhz) to 25mhz
    clk_wiz_0 clk_100mhz_to_25mhz (
        .clk_in1(sys_clk),

        .clk_25mhz(clk_25mhz)
    );
    
    // generate block memory (ROM) of static picture
    blk_mem_gen_0 vram(
        .clka(clk_25mhz),
        .addra(vram_address),

        .douta(vram_dat)
    );

    // print onto screen via VGA
    VGA_output VGA_output(
        .clk_25mhz(clk_25mhz),
        .Rst_n(Rst_n),
        .data_in(vram_dat),

        .vram_address(vram_address),
        .x_pixel(x_pixel),
        .y_pixel(y_pixel),
        .VGA_RGB(VGA_RGB),
        .VGA_HSYNC(VGA_HSYNC),
        .VGA_VSYNC(VGA_VSYNC),
        .VGA_BLOCK(VGA_BLOCK)
    );
        
endmodule

module VGA_output(
    // input
    clk_25mhz,      // input clock 25mhz
    Rst_n,          // reset
    data_in,        // data to print onto screen

    // output
    vram_address,   // vram address
    x_pixel,        // VGA horizontal scan
    y_pixel,        // VGA vertical scan
    VGA_RGB,        // VGA color output
    VGA_HSYNC,      // VGA horizontal sync
    VGA_VSYNC,      // VGA vertical sync
    VGA_BLOCK       // flag to check if is within screen boundary
);
    // inputs
    input  clk_25mhz;
    input  Rst_n;
    input  [11:0] data_in;

    // outputs
    output [18:0] vram_address;
    output [9:0]  x_pixel;
    output [9:0]  y_pixel;
    output [11:0] VGA_RGB;
    output VGA_HSYNC;
    output VGA_VSYNC;
    output VGA_BLOCK;

    // local registers
    reg [18:0] vram_address;
    reg [9:0]  hcount_r;        // VGA horizontal counter
    reg [9:0]  vcount_r;        // VGA vertical counter

    // local wires
    wire hcount_over;           // check if finish horizontal scan-print
    wire vcount_over;           // check if finish vertical scan-print
    wire dat_act;               // flag for active area of data

    
    parameter   VGA_HS_end = 10'd95,      // Tpw
                hdat_begin = 10'd143,     // Tpw + Tbp
                hdat_end   = 10'd783,     // Tpw + Tbp + Tdisp
                hpixel_end = 10'd799,     // Ts
                VGA_VS_end = 10'd1,       // Tpw
                vdat_begin = 10'd34,      // Tpw + Tbp
                vdat_end   = 10'd514,     // Tpw + Tbp + Tdisp
                vline_end  = 10'd524;     // Ts

    assign x_pixel = dat_act? (hcount_r-hdat_begin) : 10'd0;
    assign y_pixel = dat_act? (vcount_r-vdat_begin) : 10'd0;


    // -------- read each pixel from vram --------
    always@(posedge clk_25mhz or negedge Rst_n)
        if (!Rst_n)
            vram_address <= 10'd0;
        else if((hcount_r == hdat_end) && (vcount_r == vdat_end))
            // finish reading whole screen -> read from start again
            vram_address <= 10'd0;
        else if(VGA_BLOCK)
            // read next pixel
            vram_address <= vram_address+10'd1;
        else
            vram_address <= vram_address;
    

    // -------- horizontal scan-print --------
    always@(posedge clk_25mhz or negedge Rst_n)
        if(!Rst_n)
            hcount_r <= 10'd0;
        else if(hcount_over)
            hcount_r <= 10'd0;
        else
            hcount_r <= hcount_r+10'd1;

    assign hcount_over = (hcount_r == hpixel_end);


    // -------- vertical scan-print --------
    always@(posedge clk_25mhz or negedge Rst_n)
    if(!Rst_n)
        vcount_r <= 10'd0;
    else if(hcount_over) begin
        if(vcount_over)
            vcount_r <= 10'd0;
        else
            vcount_r <= vcount_r + 10'd1;
    end
    else 
        vcount_r <= vcount_r;
        
    assign  vcount_over = (vcount_r == vline_end);


    // -------- sync data and output --------
    assign dat_act  =  ((hcount_r >= hdat_begin) && (hcount_r < hdat_end))
                    && ((vcount_r >= vdat_begin) && (vcount_r < vdat_end));
                    
    assign VGA_BLOCK = dat_act;
                    
    assign VGA_HSYNC = (hcount_r > VGA_HS_end);
    assign VGA_VSYNC = (vcount_r > VGA_VS_end);
    assign VGA_RGB = (dat_act) ? data_in : 12'b000000000000;
        
endmodule
