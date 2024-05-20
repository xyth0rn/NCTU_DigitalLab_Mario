**Yander 2024/05/03 08:23AM**

**char.v (tested using testbench)**

notes: 
  1. the output of the character location is a absolute coordinate.
  2. all IO with coordinate system is written in two reg, X and Y.
  3. the input map is incomplete (it should be embedded in ROM).
  4. jump/fall function is incomplete.

**Yander 2024/05/06 11:59PM**

(idea demo diagram here)

**scroll.v**

  1. control the movement of bg by the position of our character.
  2. the bg_pos output indicate the left boundary of memory accessing. (also absolute coordinate)
  3. we need to find out the capacity limitation of ROM. 

**VGA.v**

modified the VGA module, change the starting point of ROM reading by bg position

test for circulum scrolling:

test video using button input:

fixed the clock issue and the coordinate bug:

unfinished parts:

  1. modulize the freqency divider
  2. blocking
  3. jump/fall of the main character
  4. all the objects' behavior

**Yander 2024/05/08 05:33PM**

connected the character and scrolling module to the new VGA output module with sprite.

(video)

*note: the upper-left corner is (0,0), not the lower-left corner

fixed the freqency problem:

  -the character module: using 2Hz to check the input from keypad
  
  -the scrolling module: using 60Hz to update the background's coordinate.
  
  -the ROM accessing part: 25MHz.
  
**the jump and fall(gravity system) function:**

  1.written in finite state machine.
   (draw the state graph)
  2. gravity system means that the character will fall if there's no blocking object below it.

more things to do:

  1.change the constant in my code to parameter.
  2.handle the blocking area.

**Yander 2024/05/09 00:43AM**

**The blocking area develop:**

add another block memory which store the same .coe file as the map. Because I'm not sure if two modules can access one memory at the same time.

read the memory of four direction every time and update the "mobility status" of this current block. The status will help the following code to decide whether the move request is successful or not.
(unfinished)

*note: need to put the character in a block that can move horizontally.

*can't change the address directly(need to operate in sequence?)??
```
[Opt 31-67] Problem: A LUT5 cell in the design is missing a connection on input pin I1, which is used by the LUT equation. This pin has either been left unconnected in the design or the connection was removed due to the trimming of unused logic. The LUT cell name is: c1/vram_map/U0/inst_blk_mem_gen/gnbram.gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[67].ram.r/prim_init.ram/DEVICE_7SERIES.NO_BMM_INFO.SP.SIMPLE_PRIM36.ram_i_2__1.
```

to do: reset, precise coordinate, blocking still acting weird(why the input from rom is always 1?)

**Yander 2024/05/12 10:01PM**

part of blocking succeed, based on the thought: "record the last movement, once encounter block, cannot go further"

problems 

1st edition: multi-driven & weird input from ROM. (based on the thought "scanning the up/down/left/right block")

2nd edition: "embedded in" floor. (based on the thought: "record the last movement, once encounter block, cannot go further")

3rd edition: record the last-blocking status to help us "bounce back" to avoid the problem I faced in 2nd edition. but if the gravity module exists, mario will be "stuck in floor".

to do: reset, precise coordinate, the overall gameCalc devLog, fixed the gravity module(w/ blocking)

**Yander 2024/05/14 11:23PM**

alter the blocking to "record the last coordinate".

still need to figure out the proper way to deal with gravity module

need to fix the deviation of coordinate. 

**Yander 2024/05/15 10:03PM**

gravity module succeed

need to fix: 1. why mario will stuck in some particular point? 2. the "stick in the wall" bug

**Yander 2024/05/20 08:17PM**

transmit function development, set precise coordinate, interactive objects character part 
