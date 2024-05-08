Yander 2024/05/03 08:23AM
char.v (tested using testbench)
notes: 
  1. the output of the character location is a absolute coordinate.
  2. all IO with coordinate system is written in two reg, X and Y.
  3. the input map is incomplete (it should be embedded in ROM).
  4. jump/fall function is incomplete.

Yander 2024/05/06 11:59PM

(idea demo diagram here)

scroll.v

  1. control the movement of bg by the position of our character.
  2. the bg_pos output indicate the left boundary of memory accessing. (also absolute coordinate)
  3. we need to find out the capacity limitation of ROM. 

VGA.v

modified the VGA module, change the starting point of ROM reading by bg position

test for circulum scrolling:

test video using button input:

fixed the clock issue and the coordinate bug:

unfinished parts:
  1. modulize the freqency divider
  2. blocking
  3. jump/fall of the main character
  4. all the objects' behavior

Yander 2024/05/08 05:33PM

connected the character and scrolling module to the new VGA output module with sprite.
(video)

fixed the freqency problem:

  -the character module: using 2Hz to check the input from keypad
  
  -the scrolling module: using 60Hz to update the background's coordinate.
  
  -the ROM accessing part: 25MHz.
  
the jump and fall function:

   1.written in finite state machine.
