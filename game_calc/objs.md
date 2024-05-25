# Objects Development Log
- All Objects can be classified into two categories: those that can kill the player and those that cannot kill the player.
  - Those can kill the player: `Goomba`, `Goomba tower`, `koopa troopa` and `poison star`.
  - Those cannot kill the player: `Fire flower`, `Ice mashroom`, `flying mashroom` and `star1~5`.
- In every objects module, the inputs are `sys_clk`, `char_X` and `char_Y`. outputs are `objects_X`, `objects_Y` and `en`, and some special signals.
  - `objects_X`, `objects_Y` and `en` would be inputs of `SPR_CTRL`, special signal would be inputs of `Char`.
  - !!! remember to output RELATIVE X_COORDINATE to `SPR_CTRL` !!! or objects will moving with screen scrolling.
## The game mechanics of objects
 ### Goomba Tower
  - Automatically moving back and forth in the Goomba room
    - moving range: 100 pixels
  - whenever touching the Goomba tower, send a `death` signal to `char`.
```
assign death = ((char_X + 10'd12 == goomba_tower_x_r) | (char_X == goomba_tower_x_r + 10'd12)) & (char_Y > goomba_tower_y_r) ;
```
(Either one side of character touch the Goomba tower and character is below the Goomba tower)
### Goomba and Koopa Troopa
 - standing statically, wait for Mario to step on or touch them.
   - send a death signal if Mario touching them from to sides.
   - If Mario step on their head, they will dead and then disappear.
```
assign death = ((char_X + 10'd12 == goomba_x_r) | (char_X == goomba_x_r + 10'd12)) & (char_Y == goomba_y_r) & enable;
```
(Either one side of character is touched, the objects and character are in the same height)
```
else if( (((char_X >= goomba_x_r) && (char_X <= goomba_x_r + 10'd12)) || ((char_X + 10'd12 >= goomba_x_r) && (char_X + 10'd12 <= goomba_x_r + 10'd12))) && (char_Y + 10'd12 == goomba_y_r) )
       enable <= 1'b0;
```
(char_X is within the range of objects and character's bottom is equal to the objects' top)
### poison star
- kill the player no matter which side the player touch it.
```
 assign death =  ((((char_X >= poison_star_x_r) && (char_X <= poison_star_x_r + 10'd12)) || ((char_X + 10'd12 >= poison_star_x_r) && (char_X + 10'd12 <= poison_star_x_r + 10'd12)))) & ((((char_Y >= poison_star_y_r) && (char_Y <= poison_star_y_r + 10'd12)) || ((char_Y + 10'd12 >= poison_star_y_r) && (char_Y + 10'd12 <= poison_star_y_r + 10'd12))));
```
### stars, fire flower, flying mashroom and ice mashroom
- `touch` is initialize to 0. when Mario touch these objects, toggle `touch` to 1, and keep output 1 until detect negedge `RST_N`.
```
always@(posedge sys_clk or negedge RST_N)
    begin
      if(!RST_N)
        begin
          enable <= 1'b1;
          touch <= 1'b0;
        end
      else if( ((((char_X >= star1_x_r) && (char_X <= star1_x_r + 10'd12)) || ((char_X + 10'd12 >= star1_x_r) && (char_X + 10'd12 <= star1_x_r + 10'd12)))) & ((((char_Y >= star1_y_r) && (char_Y <= star1_y_r + 10'd12)) || ((char_Y + 10'd12 >= star1_y_r) && (char_Y + 10'd12 <= star1_y_r + 10'd12)))) ) 
        begin 
          enable <= 1'b0;
          touch <= 1'b1;
        end
      else
        touch <= touch;
    end
```
