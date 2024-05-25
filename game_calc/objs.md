# Objects Development Log
- All Objects can be classified into two categories: those that can kill the player and those that cannot kill the player.
  - Those can kill the player: `Goomba`, `Goomba tower`, `koopa troopa` and `poison star`.
  - Those cannot kill the player: `Fire flower`, `Ice mashroom`, `flying mashroom` and `star1~5`.
- In every objects module, the inputs are `sys_clk`, `char_X` and `char_Y`. outputs are `objects_X`, `objects_Y`, and some special signals.
  - `objects_X` and `objects_Y` would be inputs of `SPR_CTRL`, special signal would be inputs of `Char`. 
## The game mechanics of objects
- Goomba Tower
  - Automatically moving back and forth in the Goomba room

  - Kill the player whenever touching it. 
```
assign death = ((char_X + 10'd12 == goomba_tower_x_r) | (char_X == goomba_tower_x_r + 10'd12)) & (char_Y > goomba_tower_y_r) ;
```
