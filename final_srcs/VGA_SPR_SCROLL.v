`timescale 1ns / 1ps
// print to VGA screen
module VGA_SPR_VRAM(
    CLK100M,    // 100mhz system clock
    RST_N,      // reset button
    mov,
    VGA_RGB,    // VGA RGB output
    VGA_HS,     // VGA horizontal sync
    VGA_VS,      // VGA vertical sync
    sounds,
    sseg_en,
    sseg,
    LED
    );
 
    // inputs
    input CLK100M;
    input RST_N;
    input [3:0] mov;
 
    // outputs
    output [11:0] VGA_RGB;
    output        VGA_HS;
    output        VGA_VS;
    

    output sounds;
    output reg [7:0] sseg_en;
    output [7:0] sseg;
    output [15:0] LED;
    // local registers
    reg [8:0] spr_xy;
    wire win;
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
    
    wire [3:0] star_cnt;
    
    wire death_goomba;
    wire death_goomba_tower;
    wire death_poison_star;
    wire death_koopa;
    
    wire touch_star1;
    wire touch_star2;
    wire touch_star3;
    wire touch_star4;
    wire touch_star5;
    wire touch_fly_ms;
    wire touch_g_ms;
    wire touch_flower;
    
    initial sseg_en = 8'b11111110;
    
    BCD_to_7seg decoder(.BCD (star_cnt),
                         .A_G (sseg)
    );
    
    BGM bgm(.clk (CLK100M),
            .RST_N (RST_N),
            .out (sounds)
    );
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
    wire death;

    assign death = death_goomba | death_goomba_tower | death_poison_star | death_koopa;
    
    //character
    char c1(
        .sys_clk(clk_25mhz), 
        .mov(mov), //from keypad //u d l r
        .RST_N(RST_N),
        .death_in (death),
        .poison_mushroom_in (touch_g_ms),
        .star_in1 (touch_star1),
        .star_in2 (touch_star2),
        .star_in3 (touch_star3),
        .star_in4 (touch_star4),
        .star_in5 (touch_star5),
        .flying_mushroom_in (touch_fly_ms),
        .fire_flower_in (touch_flower),
      
        .char_X(char_X),
        .char_Y(char_Y),
        .block(block),
        .star_cnt (star_cnt),
        .WIN (win)
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
    //win
    win_LED win_led(.clk_25mhz (clk_25mhz),
                    .win (win),
                    .LED (LED) 
    );
    
    
    wire [9:0] star1_x;
    wire [9:0] star1_y;
    wire [9:0] goomba_x;
    wire [9:0] goomba_y;
    wire [9:0] goomba_tower_x;
    wire [9:0] goomba_tower_y;
    wire [9:0] poison_star_x;
    wire [9:0] poison_star_y;
    wire [9:0] star2_x;
    wire [9:0] star2_y;
    wire [9:0] star3_x;
    wire [9:0] star3_y;
    wire [9:0] star4_x;
    wire [9:0] star4_y;
    wire [9:0] star5_x;
    wire [9:0] star5_y;
    wire [9:0] koopa_x;
    wire [9:0] koopa_y;
    wire [9:0] fly_ms_x;
    wire [9:0] fly_ms_y;
    wire [9:0] g_ms_x;
    wire [9:0] g_ms_y;
    wire [9:0] flower_x;
    wire [9:0] flower_y;
    
    
    
    wire goomba_en;
    wire goomba_tower_en;
    wire poison_star_en;
    wire star1_en;
    wire srat2_en;
    wire srat3_en;
    wire srat4_en;
    wire srat5_en;
    wire koopa_en;
    wire fly_ms_en;
    wire g_ms_en;
    wire flower_en;

    
  
   
    SPR_CTRL SPR_CTRL(
        .clk_25mhz(clk_25mhz),
        .RST_N(RST_N),
        .bg_pos(bg_pos),
        
        .pixel_x(pixel_x+10'd12), //the relative position of the character
        .pixel_y(pixel_y+10'd20),
        .vga_block(vga_block),
        .vram_dat(vram_dat),
 
        .spr_en(1'b1),
        .spr_x(char_X-bg_pos),
        .spr_y(char_Y+10'd7),
        
        .star_en(star1_en),
        .star_x(star1_x),
        .star_y(star1_y),
        
        .goomba_en (goomba_en),
        .goomba_x (goomba_x),
        .goomba_y (goomba_y),
        
        .goomba_tower_en (goomba_tower_en),
        .goomba_tower_x (goomba_tower_x),
        .goomba_tower_y (goomba_tower_y),
        
        .poison_star_en (poison_star_en),
        .poison_star_x (poison_star_x),
        .poison_star_y (poison_star_y),
        
        .star2_en(star2_en),
        .star2_x(star2_x),
        .star2_y(star2_y),
        
        .star3_en(star3_en),
        .star3_x(star3_x),
        .star3_y(star3_y),
        
        .star4_en(star4_en),
        .star4_x(star4_x),
        .star4_y(star4_y),
        
        .star5_en(star5_en),
        .star5_x(star5_x),
        .star5_y(star5_y),
        
        .koopa_en(koopa_en),
        .koopa_x(koopa_x),
        .koopa_y(koopa_y),
        
        .fly_ms_en(fly_ms_en),
        .fly_ms_x(fly_ms_x),
        .fly_ms_y(fly_ms_y),
        
        .g_ms_en(g_ms_en),
        .g_ms_x(g_ms_x),
        .g_ms_y(g_ms_y),
        
        .flower_en(flower_en),
        .flower_x(flower_x),
        .flower_y(flower_y),
        
        .vga_dat(vga_dat)
    );
    // -------- star1 --------
    
    
    // import star module
    STAR1 star1(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .star1_x (star1_x),
                .star1_y (star1_y),
                .touch_star1 (touch_star1),
                .en (star1_en)    
    );  
     GOOMBA goomba(.sys_clk (clk_25mhz),
                  .char_X (char_X),
                  .char_Y (char_Y),
                  .bg_pos (bg_pos),
                  .RST_N (RST_N),
                  .goomba_x (goomba_x),
                  .goomba_y (goomba_y),
                  .death (death_goomba),
                  .en (goomba_en)    
    );  
     GOOMBA_TOWER goomba_tower(.sys_clk (clk_25mhz),
                               .char_X (char_X),
                               .char_Y (char_Y),
                               .bg_pos (bg_pos),
                               .RST_N (RST_N),
                               .goomba_tower_x (goomba_tower_x),
                               .goomba_tower_y (goomba_tower_y),
                               .death (death_goomba_tower),                            
                               .en (goomba_tower_en)    
    );
    POISON_STAR poison_star(.sys_clk (clk_25mhz),
                               .char_X (char_X),
                               .char_Y (char_Y),
                               .bg_pos (bg_pos),
                               .RST_N (RST_N),
                               .poison_star_x (poison_star_x),
                               .poison_star_y (poison_star_y),
                               .death (death_poison_star),                            
                               .en (poison_star_en)    
    );
    STAR2 star2(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .star2_x (star2_x),
                .star2_y (star2_y),
                .touch_star2 (touch_star2),
                .en (star2_en)    
    
    );
    STAR3 star3(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .star3_x (star3_x),
                .star3_y (star3_y),
                .touch_star3 (touch_star3),
                .en (star3_en)    
    
    );
     STAR4 star4(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .star4_x (star4_x),
                .star4_y (star4_y),
                .touch_star4 (touch_star4),
                .en (star4_en)    
    
    );
    
    STAR5 star5(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .star5_x (star5_x),
                .star5_y (star5_y),
                .touch_star5 (touch_star5),
                .en (star5_en)    
    
    );
    KOOPA koopa(.sys_clk (clk_25mhz),
                  .char_X (char_X),
                  .char_Y (char_Y),
                  .bg_pos (bg_pos),
                  .RST_N (RST_N),
                  .koopa_x (koopa_x),
                  .koopa_y (koopa_y),
                  .death (death_koopa),
                  .en (koopa_en)    
    );  
    
    FLY_MS fly_ms(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .fly_ms_x (fly_ms_x),
                .fly_ms_y (fly_ms_y),
                .touch_fly_ms (touch_fly_ms),
                .en (fly_ms_en)    
    
    );
    
     G_MS g_ms(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .g_ms_x (g_ms_x),
                .g_ms_y (g_ms_y),
                .touch_g_ms (touch_g_ms),
                .en (g_ms_en)    
    
    );
    
    FLOWER flower(.sys_clk (clk_25mhz),
                .char_X (char_X),
                .char_Y (char_Y),
                .bg_pos (bg_pos),
                .RST_N (RST_N),
                .flower_x (flower_x),
                .flower_y (flower_y),
                .touch_flower (touch_flower),
                .en (flower_en)    
    
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
            /*
            if(hcount_r - hdat_end == 1)
                vram_adr <= vram_adr + 18'd320;
            */
 
            // vram_adr <= bg_pos + pixel_x + pixel_y * 19'd960;
        // debug
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
    bg_pos,
 
    // char
    spr_en,     // flag for sprite enable
    spr_x,      // sprite position x relative to screen
    spr_y,      // sprite position y relative to screen
    
    // star
    star_en,    // flag for star enable
    star_x,     // star position x relative to screen
    star_y,     // star position y relative to screen 
    
    //goomba
    goomba_en,
    goomba_x,
    goomba_y,
    
    //goomba_tower
    goomba_tower_en,
    goomba_tower_x,
    goomba_tower_y,
    
    //poison star
    poison_star_en,
    poison_star_x,
    poison_star_y,
    
    //star2
    star2_en,    // flag for star enable
    star2_x,     // star position x relative to screen
    star2_y,     // star position y relative to screen 
    
    //star3
    star3_en,    // flag for star enable
    star3_x,     // star position x relative to screen
    star3_y,     // star position y relative to screen 
    
      //star4
    star4_en,    // flag for star enable
    star4_x,     // star position x relative to screen
    star4_y,     // star position y relative to screen 
    
      //star5
    star5_en,    // flag for star enable
    star5_x,     // star position x relative to screen
    star5_y,     // star position y relative to screen 
    
       //koopa
    koopa_en,    // flag for star enable
    koopa_x,     // star position x relative to screen
    koopa_y,     // star position y relative to screen 
    
     //fly_ms
    fly_ms_en,    // flag for star enable
    fly_ms_x,     // star position x relative to screen
    fly_ms_y,     // star position y relative to screen
    
      //g_ms
    g_ms_en,    // flag for star enable
    g_ms_x,     // star position x relative to screen
    g_ms_y,     // star position y relative to screen 
    
       //flower_ms
    flower_en,    // flag for star enable
    flower_x,     // star position x relative to screen
    flower_y,     // star position y relative to screen 
    
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
    input  [9:0] bg_pos;
 
    // char
    input       spr_en;     // flag for sprite enable
    input [9:0] spr_x;      // sprite position x relative to screen
    input [9:0] spr_y;      // sprite position y relative to screen
 
    // star
    input       star_en;    // flag for star enable
    input [9:0] star_x;     // star position x relative to screen
    input [9:0] star_y;     // star position y relative to screen
    
    //goomba
    input       goomba_en;
    input [9:0] goomba_x;
    input [9:0] goomba_y;
    
    //goomba_tower
    input       goomba_tower_en;
    input [9:0] goomba_tower_x;
    input [9:0] goomba_tower_y;
    
    //poison_star
    input       poison_star_en;
    input [9:0] poison_star_x;
    input [9:0] poison_star_y;
    
     // star2
    input       star2_en;    // flag for star enable
    input [9:0] star2_x;     // star position x relative to screen
    input [9:0] star2_y;     // star position y relative to screen
    
      // star3
    input       star3_en;    // flag for star enable
    input [9:0] star3_x;     // star position x relative to screen
    input [9:0] star3_y;     // star position y relative to screen
    
     // star4
    input       star4_en;    // flag for star enable
    input [9:0] star4_x;     // star position x relative to screen
    input [9:0] star4_y;     // star position y relative to screen
    
     // star5
    input       star5_en;    // flag for star enable
    input [9:0] star5_x;     // star position x relative to screen
    input [9:0] star5_y;     // star position y relative to screen
    
      // koopa
    input       koopa_en;    // flag for star enable
    input [9:0] koopa_x;     // star position x relative to screen
    input [9:0] koopa_y;     // star position y relative to screen
    
      // fly_ms
    input       fly_ms_en;    // flag for star enable
    input [9:0] fly_ms_x;     // star position x relative to screen
    input [9:0] fly_ms_y;     // star position y relative to screen
    
      // g_ms
    input       g_ms_en;    // flag for star enable
    input [9:0] g_ms_x;     // star position x relative to screen
    input [9:0] g_ms_y;     // star position y relative to screen
    
      // flower_ms
    input       flower_en;    // flag for star enable
    input [9:0] flower_x;     // star position x relative to screen
    input [9:0] flower_y;     // star position y relative to screen
    
    // outputs
    output [8:0] vga_dat;   // 9-bit RGB color data (3-bit R + 3-bit G + 3-bit B)
 
    // local registers
    reg  [8:0] vga_dat;
 
    // ---------------- char sprite ----------------
    // local wires
    wire [9:0] spram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] spram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] spram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] spram_dat;   // color data
    wire       spr_block;
 
    // limit sprite size to 30x30 (encircle with a blank pixel)
    parameter   SPR_W=10'd16,
                SPR_H=10'd16;
 
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
 
    assign spram_adrx = (spr_block)? (pixel_x - spr_x): 20'd0;
    assign spram_adry = (spr_block)? (pixel_y - spr_y): 20'd0;
 
    assign spram_adr[3:0] = spram_adrx[3:0];    // fetch sprite x address in RAM
    assign spram_adr[7:4] = spram_adry[3:0];    // fetch sprite y address in RAM
    // ---------------- char sprite ----------------
 
 
    // ---------------- star sprite ----------------
    // local wires
    wire [9:0] star_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] star_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] star_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] star_ram_dat;   // color data
    wire       star_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   STAR_W=10'd16,
                STAR_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_3 star_ram (
        .clka( clk_25mhz),
        
        .addra(star_ram_adr), 
        .douta(star_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign star_block = ( (pixel_x >= star_x) && (pixel_x < (star_x + STAR_W) ) )
                        && ( (pixel_y >= star_y) && (pixel_y < (star_y + STAR_H) ) )
                        && star_en;
 
    assign star_ram_adrx = (star_block)? (pixel_x - star_x): 20'd0;
    assign star_ram_adry = (star_block)? (pixel_y - star_y): 20'd0;
 
    assign star_ram_adr[3:0] = star_ram_adrx[3:0];    // fetch star x address in RAM
    assign star_ram_adr[7:4] = star_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- star sprite ----------------
    
    // ---------------- goomba sprite ----------------
    // local wires
    wire [9:0] goomba_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] goomba_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] goomba_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] goomba_ram_dat;   // color data
    wire       goomba_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   GOOMBA_W=10'd16,
               GOOMBA_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_4 goomba_ram (
        .clka( clk_25mhz),
        
        .addra(goomba_ram_adr), 
        .douta(goomba_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign goomba_block = ( (pixel_x >= goomba_x) && (pixel_x < (goomba_x + GOOMBA_W) ) )
                        && ( (pixel_y >= goomba_y) && (pixel_y < (goomba_y + GOOMBA_H) ) )
                        && goomba_en;
 
    assign goomba_ram_adrx = (goomba_block)? (pixel_x - goomba_x): 20'd0;
    assign goomba_ram_adry = (goomba_block)? (pixel_y - goomba_y): 20'd0;
 
    assign goomba_ram_adr[3:0] = goomba_ram_adrx[3:0];    // fetch star x address in RAM
    assign goomba_ram_adr[7:4] = goomba_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- goomba sprite ----------------
 
     // ---------------- goomba_tower sprite ----------------
    // local wires
    wire [9:0] goomba_tower_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] goomba_tower_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] goomba_tower_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] goomba_tower_ram_dat;   // color data
    wire       goomba_tower_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   GOOMBA_TOWER_W=10'd16,
               GOOMBA_TOWER_H=10'd64;
 
    // generate block memory (RAM) for star
    blk_mem_gen_5 goomba_tower_ram (
        .clka( clk_25mhz),
        
        .addra(goomba_tower_ram_adr), 
        .douta(goomba_tower_ram_dat)
        );
    
    // -------- check if star is within screen(aka block) --------
    assign goomba_tower_block = ( (pixel_x >= goomba_tower_x) && (pixel_x < (goomba_tower_x + GOOMBA_TOWER_W) ) )
                        && ( (pixel_y >= goomba_tower_y) && (pixel_y < (goomba_tower_y + GOOMBA_TOWER_H) ) )
                        && goomba_tower_en;
 
    assign goomba_tower_ram_adrx = (goomba_tower_block)? (pixel_x - goomba_tower_x): 20'd0;
    assign goomba_tower_ram_adry = (goomba_tower_block)? (pixel_y - goomba_tower_y): 20'd0;
 
    assign goomba_tower_ram_adr[3:0] = goomba_tower_ram_adrx[3:0];    // fetch star x address in RAM
    assign goomba_tower_ram_adr[7:4] = goomba_tower_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- goomba_tower sprite ----------------
    
    // ---------------- poison_star sprite ----------------
    // local wires
    wire [9:0]  poison_star_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0]  poison_star_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0]  poison_star_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0]  poison_star_ram_dat;   // color data
    wire        poison_star_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter  POISON_STAR_W=10'd16,
               POISON_STAR_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_6 poison_star_ram (
        .clka( clk_25mhz),
        
        .addra(poison_star_ram_adr), 
        .douta(poison_star_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign poison_star_block = ( (pixel_x >= poison_star_x) && (pixel_x < (poison_star_x + POISON_STAR_W) ) )
                        && ( (pixel_y >= poison_star_y) && (pixel_y < (poison_star_y + POISON_STAR_H) ) )
                        && poison_star_en;
 
    assign poison_star_ram_adrx = (poison_star_block)? (pixel_x - poison_star_x): 20'd0;
    assign poison_star_ram_adry = (poison_star_block)? (pixel_y - poison_star_y): 20'd0;
 
    assign poison_star_ram_adr[3:0] = poison_star_ram_adrx[3:0];    // fetch star x address in RAM
    assign poison_star_ram_adr[7:4] = poison_star_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- poison_star sprite ----------------
    
     // ---------------- star2 sprite ----------------
    // local wires
    wire [9:0] star2_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] star2_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] star2_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] star2_ram_dat;   // color data
    wire       star2_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   STAR2_W=10'd16,
                STAR2_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_7 star2_ram (
        .clka( clk_25mhz),
        
        .addra(star2_ram_adr), 
        .douta(star2_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign star2_block = ( (pixel_x >= star2_x) && (pixel_x < (star2_x + STAR2_W) ) )
                        && ( (pixel_y >= star2_y) && (pixel_y < (star2_y + STAR2_H) ) )
                        && star2_en;
 
    assign star2_ram_adrx = (star2_block)? (pixel_x - star2_x): 20'd0;
    assign star2_ram_adry = (star2_block)? (pixel_y - star2_y): 20'd0;
 
    assign star2_ram_adr[3:0] = star2_ram_adrx[3:0];    // fetch star x address in RAM
    assign star2_ram_adr[7:4] = star2_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- star2 sprite ----------------
    
     // ---------------- star3 sprite ----------------
    // local wires
    wire [9:0] star3_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] star3_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] star3_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] star3_ram_dat;   // color data
    wire       star3_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   STAR3_W=10'd16,
                STAR3_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_8 star3_ram (
        .clka( clk_25mhz),
        
        .addra(star3_ram_adr), 
        .douta(star3_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign star3_block = ( (pixel_x >= star3_x) && (pixel_x < (star3_x + STAR3_W) ) )
                        && ( (pixel_y >= star3_y) && (pixel_y < (star3_y + STAR3_H) ) )
                        && star3_en;
 
    assign star3_ram_adrx = (star3_block)? (pixel_x - star3_x): 20'd0;
    assign star3_ram_adry = (star3_block)? (pixel_y - star3_y): 20'd0;
 
    assign star3_ram_adr[3:0] = star3_ram_adrx[3:0];    // fetch star x address in RAM
    assign star3_ram_adr[7:4] = star3_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- star3 sprite ----------------
    
     // ---------------- star4 sprite ----------------
    // local wires
    wire [9:0] star4_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] star4_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] star4_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] star4_ram_dat;   // color data
    wire       star4_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   STAR4_W=10'd16,
                STAR4_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_9 star4_ram (
        .clka( clk_25mhz),
        
        .addra(star4_ram_adr), 
        .douta(star4_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign star4_block = ( (pixel_x >= star4_x) && (pixel_x < (star4_x + STAR4_W) ) )
                        && ( (pixel_y >= star4_y) && (pixel_y < (star4_y + STAR4_H) ) )
                        && star4_en;
 
    assign star4_ram_adrx = (star4_block)? (pixel_x - star4_x): 20'd0;
    assign star4_ram_adry = (star4_block)? (pixel_y - star4_y): 20'd0;
 
    assign star4_ram_adr[3:0] = star4_ram_adrx[3:0];    // fetch star x address in RAM
    assign star4_ram_adr[7:4] = star4_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- star4 sprite ----------------
    
      // ---------------- star5 sprite ----------------
    // local wires
    wire [9:0] star5_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] star5_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] star5_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] star5_ram_dat;   // color data
    wire       star5_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   STAR5_W=10'd16,
               STAR5_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_10 star5_ram (
        .clka( clk_25mhz),
        
        .addra(star5_ram_adr), 
        .douta(star5_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign star5_block = ( (pixel_x >= star5_x) && (pixel_x < (star5_x + STAR5_W) ) )
                        && ( (pixel_y >= star5_y) && (pixel_y < (star5_y + STAR5_H) ) )
                        && star5_en;
 
    assign star5_ram_adrx = (star5_block)? (pixel_x - star5_x): 20'd0;
    assign star5_ram_adry = (star5_block)? (pixel_y - star5_y): 20'd0;
 
    assign star5_ram_adr[3:0] = star5_ram_adrx[3:0];    // fetch star x address in RAM
    assign star5_ram_adr[7:4] = star5_ram_adry[3:0];    // fetch star y address in RAM
    // ---------------- star5 sprite ----------------
    
        // ---------------- koopa sprite ----------------
    // local wires
    wire [9:0] koopa_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] koopa_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] koopa_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] koopa_ram_dat;   // color data
    wire       koopa_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   KOOPA_W=10'd16,
               KOOPA_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_11 koopa_ram (
        .clka( clk_25mhz),
        
        .addra(koopa_ram_adr), 
        .douta(koopa_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign koopa_block = ( (pixel_x >= koopa_x) && (pixel_x < (koopa_x + KOOPA_W) ) )
                        && ( (pixel_y >= koopa_y) && (pixel_y < (koopa_y + KOOPA_H) ) )
                        && koopa_en;
 
    assign koopa_ram_adrx = (koopa_block)? (pixel_x - koopa_x): 20'd0;
    assign koopa_ram_adry = (koopa_block)? (pixel_y - koopa_y): 20'd0;
 
    assign koopa_ram_adr[3:0] = koopa_ram_adrx[3:0];    // fetch star x address in RAM
    assign koopa_ram_adr[7:4] = koopa_ram_adry[3:0];    // fetch star y address in RAM
    // ----------------koopa sprite ----------------
    
        // ---------------- fly_ms sprite ----------------
    // local wires
    wire [9:0] fly_ms_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] fly_ms_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] fly_ms_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] fly_ms_ram_dat;   // color data
    wire       fly_ms_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   FLY_MS_W=10'd16,
               FLY_MS_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_12 fly_ms_ram (
        .clka( clk_25mhz),
        
        .addra(fly_ms_ram_adr), 
        .douta(fly_ms_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign fly_ms_block = ( (pixel_x >= fly_ms_x) && (pixel_x < (fly_ms_x + FLY_MS_W) ) )
                        && ( (pixel_y >= fly_ms_y) && (pixel_y < (fly_ms_y + FLY_MS_H) ) )
                        && fly_ms_en;
 
    assign fly_ms_ram_adrx = (fly_ms_block)? (pixel_x - fly_ms_x): 20'd0;
    assign fly_ms_ram_adry = (fly_ms_block)? (pixel_y - fly_ms_y): 20'd0;
 
    assign fly_ms_ram_adr[3:0] = fly_ms_ram_adrx[3:0];    // fetch star x address in RAM
    assign fly_ms_ram_adr[7:4] = fly_ms_ram_adry[3:0];    // fetch star y address in RAM
    // ----------------fly_ms sprite ----------------
    
         // ----------------g_ms sprite ----------------
    // local wires
    wire [9:0] g_ms_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] g_ms_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] g_ms_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] g_ms_ram_dat;   // color data
    wire       g_ms_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   G_MS_W=10'd16,
               G_MS_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_13 g_ms_ram (
        .clka( clk_25mhz),
        
        .addra(g_ms_ram_adr), 
        .douta(g_ms_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign g_ms_block = ( (pixel_x >= g_ms_x) && (pixel_x < (g_ms_x + G_MS_W) ) )
                        && ( (pixel_y >= g_ms_y) && (pixel_y < (g_ms_y + G_MS_H) ) )
                        && g_ms_en;
 
    assign g_ms_ram_adrx = (g_ms_block)? (pixel_x - g_ms_x): 20'd0;
    assign g_ms_ram_adry = (g_ms_block)? (pixel_y - g_ms_y): 20'd0;
 
    assign g_ms_ram_adr[3:0] = g_ms_ram_adrx[3:0];    // fetch star x address in RAM
    assign g_ms_ram_adr[7:4] = g_ms_ram_adry[3:0];    // fetch star y address in RAM
    // ----------------g_ms sprite ----------------
    
          // ----------------flower_ms sprite ----------------
    // local wires
    wire [9:0] flower_ram_adrx;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [9:0] flower_ram_adry;  // actually only needs [4:0] but has 10 for arithmetic reasons
    wire [7:0] flower_ram_adr;   // current pixel position under sprite file RAM address
    wire [8:0] flower_ram_dat;   // color data
    wire       flower_block;
 
    // limit star size to 30x30 (encircle with a blank pixel)
    parameter   FLOWER_W=10'd16,
               FLOWER_H=10'd16;
 
    // generate block memory (RAM) for star
    blk_mem_gen_14 flower_ram (
        .clka( clk_25mhz),
        
        .addra(flower_ram_adr), 
        .douta(flower_ram_dat)
        );
 
    // -------- check if star is within screen(aka block) --------
    assign flower_block = ( (pixel_x >= flower_x) && (pixel_x < (flower_x + FLOWER_W) ) )
                        && ( (pixel_y >= flower_y) && (pixel_y < (flower_y + FLOWER_H) ) )
                        && flower_en;
 
    assign flower_ram_adrx = (flower_block)? (pixel_x - flower_x): 20'd0;
    assign flower_ram_adry = (flower_block)? (pixel_y - flower_y): 20'd0;
 
    assign flower_ram_adr[3:0] = flower_ram_adrx[3:0];    // fetch star x address in RAM
    assign flower_ram_adr[7:4] = flower_ram_adry[3:0];    // fetch star y address in RAM
    // ----------------flower sprite ----------------
    
    // -------- compare sprite with vram to decide which to print --------
    always@(posedge clk_25mhz or negedge RST_N) begin
        if(!RST_N)
           vga_dat <= 9'd0;
 
        else if (vga_block) begin
            if ( spr_block && (spram_dat!=9'd0) )
                vga_dat <= spram_dat;    // spram_dat available on next clock (spram_adr)
            else if ( star_block && (star_ram_dat!=9'd0) )
                vga_dat <= star_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( goomba_block && (goomba_ram_dat!=9'd0) )
                vga_dat <= goomba_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( goomba_tower_block && (goomba_tower_ram_dat!=9'd0) )
                vga_dat <= goomba_tower_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( poison_star_block && (poison_star_ram_dat!=9'd0) )
                vga_dat <= poison_star_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( star2_block && (star2_ram_dat!=9'd0) )
                vga_dat <= star2_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( star3_block && (star3_ram_dat!=9'd0) )
                vga_dat <= star3_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( star4_block && (star4_ram_dat!=9'd0) )
                vga_dat <= star4_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( star5_block && (star5_ram_dat!=9'd0) )
                vga_dat <= star5_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( koopa_block && (koopa_ram_dat!=9'd0) )
                vga_dat <= koopa_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( fly_ms_block && (fly_ms_ram_dat!=9'd0) )
                vga_dat <= fly_ms_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( g_ms_block && (g_ms_ram_dat!=9'd0) )
                vga_dat <= g_ms_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else if ( flower_block && (flower_ram_dat!=9'd0) )
                vga_dat <= flower_ram_dat;    // star_ram_dat available on next clock (star_ram_dat)
            else
                vga_dat <= vram_dat;
        end
        else
            vga_dat <= 9'd0;
 
 
    end
endmodule