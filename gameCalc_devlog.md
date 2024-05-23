# Game Calculation Development Log
Internal calculations of game mechanics and controls.

## Character Movement and Control
Use buttons on Nexys4 DDR to control character movement.

- Pin mappings (using 2hz to check the input):
  - Up (jump) = `M18`
  - Left = `P17`
  - Right = `M17`
- Coordinates (upper-right corner of character) are *absolute coordinates* (stored in the format of x and y relative of the whole background)
- the operation of X coordinate and Y coordinate is written seperately because there's a huge difference between moving vertically and horizontally due to the presence of gravity, also to avoid multi-driven problem
## Gravity mechanism
  - Character will fall if there's no blocking object (ex. floor or bricks) below it
  - Realized through finite state machine
  - state graph:
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/blob/main/game_calc/pictures/gravity%20system%20FSM.png)
  - there's some additional mechanisms to ensure the correctness of transport and blocking, which will be explained later
  - corresponding action of each state (if no additional mechanisms were triggered):
      - IDLE: do nothing
      - FALLING: fall by one pixel each clock cycle, if it doesn't encounter any blocking object, it will keep falling because of the presence of gravity
      - JUMPING: rise by one pixel each clock cycle, the total height of one jump is controled by a counter
      
```
	if(counter_jump==10'd64) begin //control the height of each jump
		counter_jump<=10'd0;
	state<=FALLING; //if the jumping action is ended, it should fall due to gravity
		end
	else begin
		counter_jump<=counter_jump+10'd1;
	end
```
 
## dealing with blocking 
  - goal: unable mario from passing through some blocking objects (ground, wall...)
  - read the "blocking map" from RAM, for each pixel, there's a bit indicates whether it's a legal location where mario can access (0 = character can walk through; 1 = character cannot walk through)
```
    blk_mem_gen_2 blocking_ram (
        .clka(sys_clk),
        
        .addra({10'b0, char_X}+{10'b0, char_Y}*20'd960),  //the current location of mario
        .douta(block)
    );
```
  - I have tried some different methods and thoughts during the development
 -  1. try to "pre-read", i.e. try to get the status of next pixel in four direction to determine if mario can pass through those pixel before it move
  - I try to use FSM to transfer between check up/down/left/right pixel of current location
```
parameter REST = 3'd0, U = 3'd1, D = 3'd2, L = 3'd3, R = 3'd4;
reg [2:0] state_check_blocking=3'd0;
reg [9:0] check_X;
reg [9:0] check_Y;

    blk_mem_gen_2 blocking_ram (
        .clka(sys_clk),

        .addra({10'b0, check_X}+{10'b0, check_Y}*20'd960), //read the pixel we want to check
        .douta(block)
    );
```
```
    //take the "check upper" for example, rest of the four directions is written in a same fashion
    U: begin 
	if((char_Y-10'b1)>=map_u_lim) begin
		check_X<=char_X;
		check_Y<=char_Y-10'b1; //check the pixel: (current_char_X, current_char_Y-1)
		if(block) upward<=1'b0;  //if encounter blocking object, lock the ability to go upward
		else upward<=1'b1;
	end
    end
```
- result: failed, it won't move at all. Maybe there's some clock issue in my implementation.
    
  - 2. I decided to design the mechanism base on the fact that I can only get the information of "the current pixel", I adopted a method which is "record the last movement, once encounter block, cannot go further"
    - for example: if mario move forward and the next pixel is a blocking object, once it arrives the pixel, it cannot move forward again until it move backward
```
        if(block) begin //"lock"
		if(last_mov[3]) upward=1'b0;
		if(last_mov[2]) downward=1'b0;
		if(last_mov[1]) backward=1'b0;
		if(last_mov[0]) forward=1'b0;
	end
	else begin //"unlock"
		if(last_mov[3]) downward=1'b1;
		if(last_mov[2]) upward=1'b1;
		if(last_mov[1]) forward=1'b1;
		if(last_mov[0]) backward=1'b1;
	end
```
```
        //need to check if the direction is lock or not before every movement
        if(char_X==map_l_lim) begin
            char_X<=char_X; //cannot move anymore
        end
	else if(mov[1]==1'b1 && backward) begin
		char_X<=char_X-10'd1;
		last_mov[1]<=1'b1; 
		last_mov[0]<=1'b0;
	end
	else if(backward==1'b0 && last_backward==1'b1) begin
		char_X<=char_X+10'd1;
	end
```
  - result: failed, mario will stuck in the ground due to the presence of gravity system (if we are standing on a ground and want to move forward and backward, we can only move one pixel and it will be locked)
 (示意圖)

- final method
  - to solve the problem of method 2, I decided to add a "send back" mechanism, which is adding a "send back" mechanism and alter the record of past information from "record the last movement" to "record the last location (absolute coordinate)". If it encounter a blocking pixel, it will be sent back to the last position.
```
```
  - but there's a small problem: "if mario was sent back horizontally, the vertical movement's status will remain IDLE, so the gravity system is invalid, it will float on the air"
  - to solve this problem, I design a bit call "send_back_lr" to record if there's some "horizontally send back" takes place. If there's some "horizontally send back", I will open the gravity system, i.e. change the FSM to FALLING state.
```
```
  - result: succeed
    
## transport mechanism
  - store all absolute coordinate of each portal (door and pipe) by parameters
```
parameter door_A_X=10'd350, door_A_Y=10'd50, door_B_X=10'd55, door_B_Y=10'd25, door_C_X=10'd50, door_C_Y=10'd205;
```
  - using a "line" instead of a "point" to detect if mario triggered a portal
```
        else if((char_X>=door_A_X && char_X<door_A_X+10'd24) && char_Y==door_A_Y) begin //if mario is within the range, the transportation will take place
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
```

  - why I designed a "transmit" bit in our implementation?
    
    - I encountered a problem: mario will be send back and forth repeatedly
    - but why?
    - It seems that when mario was transported to the target, my gravity system will make it fall immediately. And when it first touch a blocking object (the ground), my blocking mechanism will send it back to "last location". But in this moment, the value of the register which store "the X coordinate of mario's last location" remains the coordinate of the portal, so the tragedy happens
    - solution:
    - simply turn off the "send back" mechanism of my blocking system until some horizontal movements happen
```
	else if(mov[0]==1'b1&& forward) begin
	        if(block & ~transmit) begin //after transmit, the "send back mechanism" will be turned off temporary
		        char_X<=last_X;
			send_back_lr<=1'b1;
		end
		else begin
                        transmit<=1'b0; //turn on the "send back mechanism" again because there's some movement
			last_X<=char_X;
			char_X<=char_X+10'd1; 
		end
	end
```

## Screen Scroll
Scroll screen as the character moves on the screen to prevent character from leaving the screen, and to access extensive areas of the map.

- Keep character within the center 1/3 area of the screen
- Update frame coordinates (bg_pos) on full map (60hz) depending on character's x position (get it from char.v)
```
	if(bg_pos<10'd325 && char_X>=bg_pos+10'd270) begin
		bg_pos<=bg_pos+10'd1;
	end
	if(bg_pos>10'd0 && char_X<=bg_pos+10'd90) begin
		bg_pos<=bg_pos-10'd1;
	end
```
- Implement `bg_pos` into VGA_CTRL
  - Method 1: Direct vram address calculation via coordinate multiplication 
    - `vram_adr <= bg_pos + pixel_x + pixel_y * 19'd960` (at clock speed of 25mhz)
    > Interesting observation note:
    > It is known that the calculation of multiplication take more than one clock cycle to due its complexity.
    > Thus originally this method was expected to malfunction and was only tested out of pure curiosity when debugging.
    > However, it is observed that this method was able to achieve the same result as Method 2.
    > After discussing with the teaching assistant, the speculated explaination of this phenomenom is that:
    > 1. All main functions are run and 25mhz while the system clock is 100mhz, overclocking creates a range of "buffer clock cycles" so that even though it takes multiple 100mhz clock cycles to perform multiplication, it still remains under 1 25mhz clock cycle.
    > 2. When implementing multiplication, Xilinx Vivado sacrifices circuit area of multiplication for efficiency to accelerate the number of clock cycles required
      
  - Method 2: Add 320 at every end-of-line (This method was chosen)
    - `if(hcount_r == hdat_end && vcount_r >= vdat_begin && vcount_r < vdat_end)   vram_adr <= vram_adr + 18'd320;`

      
## Creating Blocking Map
Create a RAM to record where the character are not allowed to enter.
0 = character can walk through; 1 = character cannot walk through.
- Landscape
  - Background map
- Obstacles
  - Locations of other npcs (ex. goombas)

### Creating Landscape
Convert the 32-bit PNG background file into a 1-bit COE file by reading the RGBA value of each pixel. If pixel is transparent (`A` == 0), set the pixel to be 0 (character allowed), othewise set to 0 (character not allowed).
- Save PNG file in the same directory as `32bitpng_to_1bit_landscape.py` (the converter)
- At windows cmd, run `$ python 32bitpng_to_1bit_landscape.py`
- Type in the filename of the PNG file
- Receive COE file under the same directory named `<in_filename>_1bitcoe_landscape.coe`
