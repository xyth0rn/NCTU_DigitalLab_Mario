# Objects Development Log
- All Objects can be classified into two categories: those that can kill the player and those that cannot kill the player.
  - Those can kill the player: `Goomba`, `Goomba tower`, `koopa troopa` and `poison star`.
  - Those cannot kill the player: `Fire flower`, `Ice mashroom`, `flying mashroom` and `star1~5`.
- In every objects module, the inputs are `sys_clk`, `char_X` and `char_Y`. outputs are `objects_X`, `objects_Y` and `en`, and some special signals.
  - `objects_X`, `objects_Y` and `en` would be inputs of `SPR_CTRL`, special signal would be inputs of `Char`. 
## The game mechanics of objects
 ### Goomba Tower
  - Automatically moving back and forth in the Goomba room
    - moving range: 100 pixels
  - whenever touching the Goomba tower, send a `death` signal to `char`.
```
assign death = ((char_X + 10'd12 == goomba_tower_x_r) | (char_X == goomba_tower_x_r + 10'd12)) & (char_Y > goomba_tower_y_r) ;
```
### Goomba and Koopa Troopa
 - standing statically, wait for Mario to step on or touch them.
   - send a death signal if Mario touching them from to sides.
   - If Mario step on their head, they will dead and then disappear.
```
assign death = ((char_X + 10'd12 == goomba_x_r) | (char_X == goomba_x_r + 10'd12)) & (char_Y == goomba_y_r) & enable;
```
```
else if( (((char_X >= goomba_x_r) && (char_X <= goomba_x_r + 10'd12)) || ((char_X + 10'd12 >= goomba_x_r) && (char_X + 10'd12 <= goomba_x_r + 10'd12))) && (char_Y + 10'd12 == goomba_y_r) )
       enable <= 1'b0;
```  
