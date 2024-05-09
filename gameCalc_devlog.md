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
  - ////////////insert fsm state graph here////////////////

## Screen Scroll
Scroll screen as the character moves on the screen to prevent character from leaving the screen, and to access extensive areas of the map.

- Keep character within the center 1/3 area of the screen
- Update frame coordinates on full map (60hz) depending on character x position

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
