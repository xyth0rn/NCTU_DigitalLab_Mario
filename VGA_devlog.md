# VGA Development Log
## Literature Review
- CRT-based VGA
- 640 x 480 pixels, 60Hz refresh rate
- RGB color code (4-bit per color) -> 12-bit per pixel
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/e290ee12-5a12-47b2-b087-7c2ac70071b1)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/553f7410-d597-47a2-9914-54d34c107768)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/cd3da4d0-a0d1-44a3-a51e-2841099a94de)
![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/a09fb9c4-110b-41d8-9d36-061e1a5e5836)

## VGA from ROM
- Prepare ROM file
  - Convert `.jpg` file to 24-bit `.bmp` file (online converter)
    - 24-bit means RGB color code, 8-bit per color (ex. red = ff0000)
  - Convert `.bmp` file to `.coe` file (BMP2Mif desktop app)
    ![image](https://github.com/xyth0rn/NCTU_DigitalLab_PicoPark/assets/49625757/610959de-cc4f-4f75-9921-567c72baf535)

  - Convert `.coe` file from 24-bit to 12-bit using regex (8-bit per color to 4-bit per color)
    - *Under ubuntu command line*
    - run command `sed 's/.//6' filename.coe > newFile_1.coe`      (ex. ff0000 -> ff000)
    - run command `sed 's/.//4' newFile_1.coe > newFile_2.coe`     (ex. ff000  ->  ff00)
    - run command `sed 's/.//2' newFile_2.coe > finalFileName.coe` (ex. ff00   ->   f00)
    - replace first two rows with
      ```
      memory_initialization_radix = 16;
      memory_initialization_vector =
      
      ```

- 100MHz to 25MHz using Xilinx IP Clocking Wizard
  - _Don't use homemade counter-based frequency divider or may cause severe clock jittering_
  - `CLK_IN1` = `sys clock `
  - Primitive = `PLL`
  - output frequency request = `25MHz`
  - disable `reset`, `power_down`, and `locked`

- VRAM using Xilinx IP Block Memory Generator
  - interface type = `Native`
  - memory type = `Single Port ROM`
  - Port A width = `12`  (∵ 4-bit per color)
  - Port A depth = `307200 (∵ 680 x 480 pixels)
  - Load init file = `.coe file location`

- top module: `VGA`
  - links modules together
  - feeds .coe file to `VGA_output` module

- VGA driving module: `VGA_output`
  - reads data from data input and scan-prints onto VGA screen

## VGA from RAM

## Reference
[1] https://stackoverflow.com/questions/54592202/24-bit-rgb-to-12-bit-conversion
