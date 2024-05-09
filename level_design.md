# Level Design

## Extract Sprites

## Designing Level Map
### WiiBaFu: Extract New Super Mario Wii Game Data
https://github.com/larsenv/Wii-Backup-Fusion <br>
_Disclaimer: pirating games are *NOT* encouraged. This project only uses decoded game level files as reference data for sprite images and level map designing._

- Download WBFS file (wii game file format) of New Super Mario Wii Game
- Extracted result is a folder of all game datas

### Reggie!: Edit Level Map
https://horizon.miraheze.org/wiki/Reggie_Level_Editor <br>
Wii game level data reader and editor. Allows customizations using sprites and tiles from the game.

- Design our own level
- Take level screenshot (PNG)
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/49625757/92daaf20-79b5-4b11-a9ad-35c7ae8b5386)
- For background file, don't hide background (sky color)
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/49625757/04d5aee6-82cd-4449-ae96-3fa2fe974165)
- For landscape file, hide background (sky color becomes transparent
  ![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/49625757/ba29b5d0-e404-4651-9595-5670bdab34d0)

Reggie screenshot crops an extra 20 pixels on each side, and Windows automatically zooms any screenshot files to 1.5x of its original resolution. So we need to crop and resize the screenshot PNG file before converting into COE. <br>

https://www.iloveimg.com/crop-image/crop-png

### Convert from PNG to COE
see Video DevLog and Game Calculation Devlog


![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/167954410/a6f61039-2531-48ce-83e5-7b3a2339e74d)
