`timescale 1ns / 1ps
// print to VGA screen
module VGA_SPR_VRAM(
    CLK100M,    // 100mhz system clock
    RST_N,      // reset button
    mov,
    VGA_RGB,    // VGA RGB output
    VGA_HS,     // VGA horizontal sync
    VGA_VS,      // VGA vertical sync
    block
    );

    // inputs
    input CLK100M;
    input RST_N;
    input [3:0] mov;

    // outputs
    output [11:0] VGA_RGB;
    output        VGA_HS;
    output        VGA_VS;
    
    output block;
    
    // local registers
    reg [8:0] spr_xy;

    // local wires
    wire [18:0] vram_adr;   // VRAM address
    wire [8:0]  vram_dat;   // vram 9-bit color data
    wire        clk_25mhz;

    wire [9:0]  pixel_x;    // VGA horizontal scan
    wire [9:0]  pixel_y;    // VGA vertical scan
    wire        vga_block;  // flag to check if is within screen boundary
    wire        vga_end;    // output a pulse signal when finish printing screen
    wire [8:0]  vga_dat;    // 9-bit RGB color data (3-bit R + 3-bit G + 3-bit B)
    
    wire [9:0] char_X;
    wire [9:0] char_Y;
    wire [9:0] bg_pos;
    

    clk_wiz_0 vga_pll(
        .clk_in1(CLK100M),
        .clk_25mhz(clk_25mhz)
    );
    
    blk_mem_gen_0 vram(
        .clka(clk_25mhz),
        .addra(vram_adr),
        .dina(9'b000000000),  
        .douta(vram_dat),
        .wea(1'b0),
        .clkb(clk_25mhz),
        .addrb(18'b000000000000000000),
        .dinb(9'b000000000),  
        .doutb(),
        .web(1'b0)
    );
    
    //character
    char c1(
        .sys_clk(clk_25mhz), 
        .mov(mov), //from keypad //u d l r
        
        .char_X(char_X),
        .char_Y(char_Y),
        .block(block)
    );
    
    //scrolling
    scroll sc(
        .sys_clk(clk_25mhz), //vga_end
        .char_X(char_X),
        .char_Y(char_Y),
        
        .bg_pos(bg_pos)
    );

    VGA_CTRL VGA_CTRL(
        .clk_25mhz(clk_25mhz),
        .RST_N(RST_N),

        .vram_adr(vram_adr),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .vga_block(vga_block),
        .vga_end(vga_end),
        .bg_pos(bg_pos),
        
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
    );
    
    SPR_CTRL SPR_CTRL(
        .clk_25mhz(clk_25mhz),
        .RST_N(RST_N),
        .bg_pos(bg_pos),
        
        .pixel_x(pixel_x), //the relative position of the character
        .pixel_y(pixel_y),
        .vga_block(vga_block),
        .vram_dat(vram_dat),
        .spr_en(1'b1),
        .spr_x(char_X-bg_pos),
        .spr_y(char_Y),
        
        .vga_dat(vga_dat)
    );

    assign VGA_RGB = {vga_dat[8:6], 1'b0, vga_dat[5:3], 1'b0, vga_dat[2:0], 1'b0};
    
    /*always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
           spr_xy <= 9'b000000000;
        else if (vga_end)
           spr_xy <= spr_xy + 9'b000000001;
        else
           spr_xy <= spr_xy;
    end*/
endmodule


// write background into VRAM + generate VGA control signals
module VGA_CTRL(
    // input
    clk_25mhz,  // input clock 25mhz
    RST_N,      // reset
    bg_pos,         // bg right limit

    // output
    vram_adr,   // vram address
    pixel_x,    // VGA horizontal scan
    pixel_y,    // VGA vertical scan
    vga_block,  // flag to check if is within screen boundary
    vga_end,    // output a pulse signal when finish printing screen
    
    // IO output (is register due to wire assignment flashing issues)
    VGA_HS,     // VGA horizontal sync
    VGA_VS      // VGA??vertical sync  
    );
    
    // inputs
    input  clk_25mhz;
    input  RST_N;
    input  [9:0] bg_pos;

    // outputs
    output [18:0] vram_adr; // VRAM address
    output [9:0] pixel_x;   // VGA horizontal scan 
    output [9:0] pixel_y;   // VGA vertical scan
    output       VGA_HS;    // VGA horizontal sync
    output       VGA_VS;    // VGA horizontal sync
    output       vga_block; // flag to check if is within screen boundary
    output       vga_end;   // output a pulse signal when finish printing screen

    // local registers
    reg [18:0] vram_adr;    // VRAM address
    reg [9:0]  hcount_r;    // horizontal count
    reg [9:0]  vcount_r;    // vertical count
    reg VGA_HS;             // VGA horizontal sync
    reg VGA_VS;             // VGA vertical sync

    reg [9:0] pixel_x_r;
    reg [9:0] pixel_y_r;

    // local wires
    wire hcount_ov;         // check if finish horizontal scan-print
    wire vcount_ov;         // check if finish vertical scan-print

    // parameters
    parameter   VRAM_WIDTH = 10'd960;  // width of background (960x480)

    parameter   VGA_HS_end = 10'd95,   // Tpw
                hdat_begin = 10'd143,  // Tpw + Tbp
                hdat_end   = 10'd783,  // Tpw + Tbp + Tdisp
                hpixel_end = 10'd799;  // Ts
                 
    parameter   VGA_VS_end = 10'd1,    // Tpw
                vdat_begin = 10'd34,   // Tpw + Tbp
                vdat_end   = 10'd514,  // Tpw + Tbp + Tdisp
                vline_end  = 10'd524;  // Ts


    // assign pixel_x = vga_block? (hcount_r-hdat_begin) : 10'd0;
    // assign pixel_y = vga_block? (vcount_r-vdat_begin) : 10'd0;

    // -------- pixel coordinates --------
    always @(posedge clk_25mhz or negedge RST_N) begin
        if ( !RST_N || !vga_block ) begin
            pixel_x_r <= 10'd0;
            pixel_y_r <= 10'd0;
        end else begin
            pixel_x_r <= hcount_r-hdat_begin;
            pixel_y_r <= vcount_r-vdat_begin;
        end
    end

    assign pixel_x = pixel_x_r;
    assign pixel_y = pixel_y_r;


    // -------- read each pixel from vram --------
    always@(posedge clk_25mhz or negedge RST_N) begin
        if (!RST_N)
            vram_adr <= 10'd0;
        else if(vga_end)
            vram_adr <= bg_pos;
        else if(vga_block) begin
            vram_adr <= vram_adr + 18'd1;
            // vram_adr <= bg_pos + pixel_x + pixel_y * 19'd960;
          
        // next row
        end else if(hcount_r == hdat_end && vcount_r >= vdat_begin && vcount_r < vdat_end) begin
            vram_adr <= vram_adr + 18'd320;

        end else
            vram_adr <= vram_adr;
    end


    // -------- horizontal scan-print --------
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
            hcount_r <= 10'd0;
        else if(hcount_ov)
            hcount_r <= 10'd0;
        else
            hcount_r <= hcount_r + 10'd1;
    end

    assign hcount_ov = (hcount_r == hpixel_end);

    // -------- vertical scan-print --------
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N) begin
            vcount_r <= 10'd0;
        end else if(hcount_ov) begin    // finish row
            if(vcount_ov) begin         // finish whole screen
                vcount_r <= 10'd0;
            end else begin
                vcount_r <= vcount_r + 10'd1;
            end
                
        end else 
            vcount_r <= vcount_r;
    end

    assign vcount_ov = (vcount_r == vline_end);


    // -------- sync data and output --------
    assign vga_block = ( (hcount_r >= hdat_begin) && (hcount_r < hdat_end) )
                        &&( (vcount_r >= vdat_begin) && (vcount_r < vdat_end) );

    assign vga_end = (hcount_r == hdat_end) && (vcount_r == vdat_end);
                                
    // assign VGA_HS=(hcount_r>VGA_HS_end);
    // assign VGA_VS=(vcount_r>VGA_VS_end);
    
    // update VGA_HS on clock
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
            VGA_HS <= 1'd1;
        else
            VGA_HS <= (hcount_r > VGA_HS_end);
    end

    // update VGA_VS on clock
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
            VGA_VS <= 1'd1;
        else
            VGA_VS <= (vcount_r > VGA_VS_end);
    end
endmodule


// sprite control
module SPR_CTRL(
    // input
    clk_25mhz,
    RST_N,      // reset
    
    pixel_x,    // vga scan-print current x 
    pixel_y,    // vga scan-print current y
    vga_block,  // flag to check if is within screen boundary
    vram_dat,   // vram 9-bit color data
    spr_en,     // flag for sprite enable
    spr_x,      // sprite position x relative to screen
    spr_y,      // sprite position y relative to screen
    
    bg_pos,
    
    // output
    vga_dat     // 9-bit RGB color data (3-bit R + 3-bit G + 3-bit B)
    );

    // inputs
    input clk_25mhz;
    input RST_N;
    input [9:0] pixel_x;    // vga scan-print current x 
    input [9:0] pixel_y;    // vga scan-print current y
    input       vga_block;  // flag to check if is within screen boundary
    input [8:0] vram_dat;   // vram 9-bit color data
    input       spr_en;     // flag for sprite enable
    input [9:0] spr_x;      // sprite position x relative to screen
    input [9:0] spr_y;      // sprite position y relative to screen
    input  [9:0] bg_pos;
    
    // outputs
    output [8:0] vga_dat;   // 9-bit RGB color data (3-bit R + 3-bit G + 3-bit B)

    // local registers
    reg  [8:0] vga_dat;

    // local wires
    wire [9:0] spram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] spram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] spram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] spram_dat;   // color data
    wire       spr_block;

    // limit sprite size to 30x30 (encircle with a blank pixel)
    parameter   SPR_W=10'd32,
                SPR_H=10'd32;

    // generate block memory (RAM) for sprite
    blk_mem_gen_1 sprite_ram (
        .clka( clk_25mhz),
        
        .addra(spram_adr), 
        .douta(spram_dat)
        );

    // -------- check if sprite is within screen(aka block) --------
    assign spr_block = ( (pixel_x >= spr_x) && (pixel_x < (spr_x + SPR_W) ) )
                        && ( (pixel_y >= spr_y) && (pixel_y < (spr_y + SPR_H) ) )
                        && spr_en;


    // -- for debug: move sprite from (0,0) to (20,20) and repeat
    assign spram_adrx = (spr_block)? (pixel_x - spr_x): 20'd0;
    assign spram_adry = (spr_block)? (pixel_y - spr_y): 20'd0;
    // --

    assign spram_adr[4:0] = spram_adrx[4:0];    // fetch sprite x address in RAM
    assign spram_adr[9:5] = spram_adry[4:0];    // fetch sprite y address in RAM
    

    // -------- compare sprite with vram to decide which to print --------
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
           vga_dat <= 9'd0;

        else if (vga_block) begin
            if ( spr_block && (spram_dat!=9'd0) )
                vga_dat <= spram_dat;    // spram_dat available on next clock (spram_adr)
            else
                vga_dat <= vram_dat;
        end
        else
            vga_dat <= 9'd0;


    end
endmodule


module scroll(
    input sys_clk,
    input [9:0] char_X, 
    input [9:0] char_Y,
    //output reg [3:0] update_pos_scroll,
    output reg [9:0] bg_pos 
);

initial begin
    bg_pos=10'd0;
end

always @(posedge sys_clk) begin
    if(bg_pos<10'd480 && char_X>=bg_pos+10'd270) begin
        bg_pos<=bg_pos+10'd1;
    end
    if(bg_pos>10'd0 && char_X<=bg_pos+10'd90) begin
        bg_pos<=bg_pos-10'd1;
    end
    
end

endmodule

module char(
    input sys_clk,
    input [3:0] mov, //from keypad //u d l r
    
    output reg [9:0] char_X,
    output reg [9:0] char_Y,
    output block
    );

    parameter map_r_lim=10'd960, map_l_lim=10'd0, map_u_lim=10'd0, map_d_lim=10'd400;

    //reg [9:0] blk_map_X=10'd0;
    //reg [9:0] blk_map_Y=10'd0;
    reg [29:0] counter=30'd0;
    reg clk_2hz=1'd0;

    reg forward=1'b1, backward=1'b1, upward=1'b1, downward=1'b1;
    reg last_forward=1'b1, last_backward=1'b1, last_upward=1'b1, last_downward=1'b1;

    reg [3:0] last_mov=4'd0; //record the last movement

    initial begin 
        char_X=10'd244;
        char_Y=10'd400;
    end

    always @(posedge sys_clk) begin
        if(counter==30'd99999)begin
            counter<=30'd0;
            clk_2hz<=~clk_2hz;
        end
        else begin
            counter<=counter+30'd1;
        end
    end


    always @(posedge clk_2hz) begin

        if(char_X==map_l_lim) begin
            //char_X<=char_X; //cannot move anymore
        end
        else if(mov[1]==1'b1 && backward) begin
            char_X<=char_X-10'd1; //char_Y<=char_Y;
            last_mov[1]<=1'b1;
            last_mov[0]<=1'b0;
        end
        else if(backward==1'b0 && last_backward==1'b1) begin
            char_X<=char_X+10'd1;
        end
        
        if(char_X>=map_r_lim) begin
           //char_X<=char_X;
        end
        else if(mov[0]==1'b1&& forward) begin
            char_X<=char_X+10'd1; //char_Y<=char_Y;
            last_mov[0]<=1'b1;
            last_mov[1]<=1'b0;
        end
        else if(forward==1'b0 && last_forward==1'b1) begin
            char_X<=char_X-10'd1;
        end
    end

    //jump/fall
    parameter IDLE = 2'b00, FALLING = 2'b01, JUMPING = 2'b10;
    reg [1:0] state=2'd0;
    reg [9:0] counter_jump=10'd0;

    always@(posedge clk_2hz) begin //next state logic
        case (state)
            IDLE: begin
                if(downward && char_Y<=map_d_lim) state<=FALLING;
                
                if(mov[3]==1'b1 && upward) begin
                    //counter_jump<=4'd0;
                    state<=JUMPING;
                end

            end
        
            FALLING: begin
                if(downward && char_Y<=map_d_lim) state<=FALLING;
                else state<=IDLE;
            end
            
            JUMPING: begin
                if(counter_jump==10'd48) begin
                    counter_jump<=10'd0;
                    state<=FALLING;
                end
                else begin
                    counter_jump<=counter_jump+10'd1;
                end
            end

        endcase
    end

    always@(posedge clk_2hz) begin
        case (state)
            IDLE: begin
                if(last_downward==1'b1 && downward==1'b0) char_Y<=char_Y-10'd1;
                else if(last_upward==1'b1 && upward==1'b0) char_Y<=char_Y+10'd1;
                else char_Y<=char_Y;
                //char_Y<=char_Y;
            end
        
            FALLING: begin
                char_Y<=char_Y+10'b1;
                last_mov[2]<=1'b1;
                last_mov[3]<=1'b0;
            end
            
            JUMPING: begin
                char_Y<=char_Y-10'b1;
                last_mov[3]<=1'b1;
                last_mov[2]<=1'b0;
            end

        endcase
    end

    //blocking
     
        blk_mem_gen_2 blocking_ram (
            .clka(sys_clk),
            
            .addra({10'b0, char_X}+{10'b0, char_Y}*19'd960),  //char_X, char_Y will work
            .douta(block)
        );

    always @(posedge clk_2hz) begin
        last_upward=upward;
        last_downward=downward;
        last_backward=backward;
        last_forward=forward;
        // if(block) begin //lock
        //     if(last_mov[3]) upward=1'b0;
        //     if(last_mov[2]) downward=1'b0;
        //     if(last_mov[1]) backward=1'b0;
        //     if(last_mov[0]) forward=1'b0;
        // end
        // else begin //"unlock"
            if(last_mov[3]) downward=1'b1;
            if(last_mov[2]) upward=1'b1;
            if(last_mov[1]) forward=1'b1;
            if(last_mov[0]) backward=1'b1;
        // end
    end 

endmodule
