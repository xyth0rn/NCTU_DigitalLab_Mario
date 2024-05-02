# NCTU_DigitalLab_PicoPark

## System Architecture
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/4d50980a-25b9-4fd3-a09b-60937b95c67d)


## Module Development and Method
- Input Controls
  - 12-key Keypad
- Game Calculations
  - Character
    > Reads keypad input to update `ch_pos` (move character position)
    > Checks if movement is legal with `blocking_map`
  - Scroll<br>
    > Determine `frame_pos` (current location on the full background) based on `ch_pos` to keep character always on screen
  - Blocking
    > Combines locations of interactive objects with `background_landscape` (ROM) to determine where characters are not allowed to enter (e.g. walls, floor, and blocks)<br>
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


## Reference
[1] https://projectf.io/posts/hardware-sprites/

[2] https://github.com/toivoh/rastrgrafx

[3] soundtracks https://downloads.khinsider.com/game-soundtracks/album/pico-park-soundtrack-2021

[4]https://picoparkteco.comic.studio/
