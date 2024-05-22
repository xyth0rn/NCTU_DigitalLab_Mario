# Game Calculation Development Log
Internal calculations of game mechanics and controls.

## Character Movement and Control
Use buttons on Nexys4 DDR to control character movement.

- Pin mappings (using 2hz to check the input):
  - Up (jump) = `M18`
  - Left = `P17`
  - Right = `M17`
- Coordinates (upper-right corner of character) are *absolute coordinates* (stored in the format of x and y relative of the whole background)
- Gravity mechanism
  - Character will fall if there's no blocking object (ex. floor or bricks) below it
  - Realized through finite state machine
  - state graph:
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/blob/main/game_calc/pictures/gravity%20system%20FSM.png)
  - there's some additional mechanisms to ensure the correctness of transmit and blocking, which will be explained later
 
-dealing with blocking 

-transmit mechanism

## Screen Scroll
Scroll screen as the character moves on the screen to prevent character from leaving the screen, and to access extensive areas of the map.

- Keep character within the center 1/3 area of the screen
- Update frame coordinates on full map (60hz) depending on character x position
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

      
## Blocking Map
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
