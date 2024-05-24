# FPGA Mario: Except Everything is Annoying
NYCU 2024 Spring Digital Lab EEEC10005 final project <br>
Group members: 黃仲璿、嚴得睿、張閔傑

This is an attempt to create an Mario-inspired 2D platformer game using the Nexys4 DDR FPGA board. The game level is homemade and carefully designed to convey the annoyance and irritation we've confronted during the development process of this project. 

Demonstration Video: https://www.youtube.com/watch?v=juEwY00mkc4 <br>

## System Specification
- FPGA Board: Nexys4 DDR
- VGA Screen
- Speaker

## System Architecture
![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/blob/main/game_calc/pictures/system%20architecture%20update.png)

- Input Controls
  - buttons
- Game Calculations
  - Character
    > Reads button input to update `ch_pos` (move character position)
    > Checks if movement is legal with `blocking_map`
  - Scroll<br>
    > Determine `frame_pos` (current location on the full background) based on `ch_pos` to keep character always on screen
  - Blocking
    > Combines locations of interactive objects with `background_landscape` (RAM) to determine where characters are not allowed to enter (e.g. walls, floor, and blocks)<br>
    > Saves result as `blocking_map`
  - Interactive Objects
- Frame Rendering
  - Frame
    > Capture the current frame from the full background picture using `frame_pos`
  - Sprite
    > Bitwise compare `ch_pos` with current frame. If current bit is a character and current bit is not transparent, output pixel of character; otherwise output pixel of background.<br>
    > Does the same for interactive objects.<br>
  - Video Buffer
    > Render sprites and frame together to generate final `image`
- VGA output
  > print `image` onto screen

## Development and Method
[Video Output Development](videoOutput_devlog.md) <br>
[Game Calculations Development](gameCalc_devlog.md) <br>
[Level Design Development](levelDesign.md) <br>
[Background Music Development](bgm_devlog.md) <br>

## Reference
[1] https://projectf.io/posts/hardware-sprites/

[2] https://github.com/toivoh/rastrgrafx

[3] soundtracks https://downloads.khinsider.com/game-soundtracks/album/pico-park-soundtrack-2021

[4] https://picoparkteco.comic.studio/

[5] jpg to bmp converter https://cloudconvert.com/
