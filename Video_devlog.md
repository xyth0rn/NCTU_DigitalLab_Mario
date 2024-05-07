# Video Processor Development Log
## Literature Review
- CRT-based VGA
- 640 x 480 pixels, 60Hz refresh rate
- RGB color code (4-bit per color) -> 12-bit per pixel
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/e290ee12-5a12-47b2-b087-7c2ac70071b1)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/553f7410-d597-47a2-9914-54d34c107768)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/cd3da4d0-a0d1-44a3-a51e-2841099a94de)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/a09fb9c4-110b-41d8-9d36-061e1a5e5836)

## Convert image files from JPG/JPEG/PNG to COE
### 24-bit RGB JPG to 12-bit RGB COE
- Convert `.jpg` file to 24-bit `.bmp` file (online converter)
  - 24-bit means RGB color code, 8-bit per color (ex. red = ff0000)
  
- Convert `.bmp` file to `.coe` file (BMP2Mif desktop app)<br>
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/610959de-cc4f-4f75-9921-567c72baf535)

- Convert `.coe` file from 24-bit to 12-bit using regex (8-bit * 3  ->  4-bit * 3)
  - *Under ubuntu command line*
  - run command `sed 's/.//6' filename.coe > newFile_1.coe`      (ex. ff0000 -> ff000)
  - run command `sed 's/.//4' newFile_1.coe > newFile_2.coe`     (ex. ff000  ->  ff00)
  - run command `sed 's/.//2' newFile_2.coe > finalFileName.coe` (ex. ff00   ->   f00)
  - replace first two rows with
    ```
    memory_initialization_radix = 16;
    memory_initialization_vector =
    ```

However, a single 12-bit RGB COE file of a 640x480 picture fills the block memory of the Nexys4 DDR up to approximately 70%.
This means we would have to compress the size of pictures if we want to achieve horizontal scrolling background.

### 32-bit PNG to 9-bit COE
  > 32-bit is RGBA color coding, 8-bit for each variable. <br>
Using the Python library Image (from PIL), extract the RGBA value (`A` = opacity) of each pixel from the `.png` file. Convert the 8-bit R/G/B values to 3-bit binary values (abort value of `A`), then concatenate the three into a 9-bit value. Write the 9-bit value of each pixel into an output `.coe` file.

#### Reference
[1] https://stackoverflow.com/questions/12807669/how-to-convert-an-rgb-color-to-the-closest-matching-8-bit-color?fbclid=IwZXh0bgNhZW0CMTAAAR2quU1vXapxB_7i4PH6pAtKHepgDO9oD6pAL2jqr80RxePaxBntHD00WGc_aem_ATH-CjI_HFjCCoazRLQmv4BbaiWMK8Nxit4m6MyYDwNAJm2gAfIcPWPK-v-Pvxw9WEGhIZ2T_s7TtT72Q-HeeF6N <br>
[2] https://stackoverflow.com/questions/138250/how-to-read-the-rgb-value-of-a-given-pixel-in-python <br>
[3] https://www.browserstack.com/guide/how-to-use-css-rgba <br>
[4] https://stackoverflow.com/questions/5676646/how-can-i-fill-out-a-python-string-with-spaces <br>

## VGA from ROM
Create a VGA driver prototype that is able to print a image (saved in ROM) onto the screen.

- 100MHz to 25MHz using Xilinx IP Clocking Wizard
  - _Don't use homemade counter-based frequency divider or may cause severe clock jittering_
  - change `CLK_IN1` board interface from `custom` to `sys clock `
  - rename `clk_out1` to `clk_25mhz`
  - Primitive = `PLL`
  - output frequency request = `25MHz`
  - disable `reset`, `power_down`, and `locked`

- VRAM using Xilinx IP Block Memory Generator
  - interface type = `Native`
  - memory type = `Single Port ROM`
  - Enable Port Type = `always enabled`
  - Port A width = `12`  (∵ 4-bit per color)
  - Port A depth = `307200 (∵ 680 x 480 pixels)
  - Load init file = `.coe file location`

- top module: `VGA`
  - links modules together
  - feeds .coe file to `VGA_output` module

- VGA driving module: `VGA_output`
  - reads data from data input and scan-prints onto VGA screen


## VGA from VRAM (Video RAM)
In order to show sprites and other objects above the ROM background, a read-and-write VRAM should be constructed.
A VRAM is a *video buffer* that saves the rendered image ready to be shown on-screen.
This means that the `VRAM_ctrl` module should compare the positions and transparency of sprites to the background and
determine either the color of the sprite or the background should be saved to the VRAM at each pixel. <br>

- 100MHz to 25MHz using Xilinx IP Clocking Wizard
  - _Don't use homemade counter-based frequency divider or may cause severe clock jittering_
  - change `CLK_IN1` board interface from `custom` to `sys clock `
  - Primitive = `PLL`
  - output frequency request = `25MHz`
  - disable `reset`, `power_down`, and `locked`

- VRAM using Xilinx IP Block Memory Generator
  - interface type = `Native` 
  - memory type = `True Dual Port RAM`
    > True Dual Port RAM: allows simultaneous read and write (4 data buses) <br>
    > Simple Dual Port RAM: can only read or write at the moment (2 data buses)
  - Enable Port Type = `always enabled`
  - Load init file = `.coe file location`
  - *Additional output* `vga_end`: outputs a pulse signal when finish printing whole screen


### Sprite
Overlays movable sprites on top of VRAM.

- Reads the current VGA printing coordinates, sprite on-screen coordinates, sprite enable, and sprite RAM.
- Checks if the sprite is within screen boundary (aka `block`)
- Sprite RAM using Xilinx IP Block Memory Generator
  - interface type = `Native` 
  - memory type = `Single Port RAM`
  - Enable Port Type = `always enabled`
  - Load init file = `.coe file location`
  - *Additional output* `vga_end`: outputs a pulse signal when finish printing whole screen
- Compares sprite with vram to decide which color data to print onto screen


### Background Scrolling

## Reference
[1] https://stackoverflow.com/questions/54592202/24-bit-rgb-to-12-bit-conversion <br>
[2] http://www.tinyvga.com/vga-timing <br>
[3] https://projectf.io/posts/video-timings-vga-720p-1080p/ <br>
[4] http://ca.olin.edu/2005/fpga_sprites/new_plan.htm <br>
[5] http://ca.olin.edu/2005/fpga_sprites/results.htm <br>
[6] https://support.xilinx.com/s/question/0D52E00006hpaYzSAI/difference-between-bram-configurations-tdp-vs-sdp?language=en_US <br>
