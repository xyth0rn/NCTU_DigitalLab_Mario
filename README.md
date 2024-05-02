# NCTU_DigitalLab_PicoPark

## System Architecture
![image](https://imgur.com/a/nPSAwhY)

## Module Development and Method
- Input Controls
  - 12-key Keypad
- Game Calculations
  - Character
    > Reads keypad input to update `ch_pos` (move character position)
    > Checks if movement is legal with `blocking_map`
  - Scroll
    > Determine `frame_pos` (current location on the full background) based on `ch_pos` to keep character always on screen
  - Blocking
    > Combines locations of interactive objects with `background_landscape` (ROM) to determine where characters are not allowed to enter (e.g. walls, floor, and blocks)
    > Saves result as `blocking_map`
  - Interactive Objects
- Frame Rendering
  - Frame
    > Capture the current frame from the full background picture using `frame_pos`
  - Sprite
    > Bitwise compare `ch_pos` with current frame. If current bit is a character and current bit is not transparent, output pixel of character; otherwise output pixel of background. Does the same for interactive objects.
    > Output result `image` to video buffer
  - Video Buffer
    > saves final output `image`
- VGA output
  > print `image` onto screen


## Reference
[1] https://projectf.io/posts/hardware-sprites/

[2] https://github.com/toivoh/rastrgrafx

[3] soundtracks https://downloads.khinsider.com/game-soundtracks/album/pico-park-soundtrack-2021

[4]https://picoparkteco.comic.studio/
