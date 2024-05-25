# Background Music Development Log
## calculate how long each note should last
 - In general, we can mainly categorize the notes in this sheet music into `quarter notes` and `eighth notes`.
 - This music's BPM is 180, which means it plays 180 quarter notes per minute, so every quarter notes lasts for 60s/180 = 0.33s. For convenience, we let it be 0.3s. Therefore the eighth note should last for 0.3s/2 = 0.15s. 
 - We must insert a break between the two notes, otherwise two consecutive eighth notes of the same pitch will sound like a quarter note. Thus we add a additional 0.05s break to distinguish two consecutive notes of the same pitch.
 - To sum up, every `quarter note` would last for 0.3s, followed by 0.05s break. Every `eighth note` would last for 0.15s, followed by 0.05s break.

![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/167954410/852b3ee5-d846-442b-abe8-6c2203a4c951)
## calculate every pitch's correspond counter number
- Every pitch come from a frequency divider whose input clock signal is 100MHz, so we must calculate the counter number to get the accurate frequency.
- Formula: 100M / pitch's frequency / 2
  - C4(261Hz):  `190839`
  - D4(293Hz):  `170068`
  - E4(329Hz):  `151515`
  - F4(349Hz):  `143266`
  - G4(391Hz):  `127551`
  - G4#(415Hz): `120481`
  - A4(440Hz):  `113636`
  - A4#(466Hz): `107296`
  - B4(493Hz):  `101215`
  - C5(523Hz):  `95602`
  - D5(587Hz):  `85178`
  - D5#(622Hz): `80385`
  - E5(659Hz):  `75873`
  - F5(698Hz):  `71633`
  - F5#(739Hz): `67658`
  - G5(783Hz):  `63776`
  - A5(880Hz):  `56818`
  - B5(987Hz):  `50658`
## pitch generator
- There're three important inputs
  - `counter`: Decide which pitch we want to play
  - `rest`: 1 for rest notes, 0 for regular notes
  - `eight`: 1 for eighth notes, 0 for quarter notes
- Two outputs
  - `next_note`: When a note is played to its full duration, `next_note` would toggle to 1, telling the top module proceed to the next note
  - `note`: the pitch we want to play
```
module note (input clk_100MHz,
              input [17:0] counter,
              input rest,
              input eight,
              output next_note,
              output note
);
```
- we set up a `beat_counter` which will increment by 1 whenever recieve a posedge clk_1000Hz signal. So, if the `eight` is 1, the `beat_counter` will count to 200 and return to 0 (0.15s sound output and 0.05s break). On the other hand, if the `eight` is 0, it will count to 350 and return to 0 (0.3s sound output and 0.05s break).
- sound output logic
```
assign note = clk_out & ~rest & ((eight & (beat_counter <= 150)) | (~eight & (beat_counter <= 300)));
```
## Top module: A Finite State Machine
- A note is a state. In every state, we input different `counter`, `rest` and `eight` to generate the specific pitch.
  - Totally 188 states...
```
always@(*)
  begin
    case(state)
      //first section
      10'd0: begin //eighth E5
               counter = 18'd75873;
               rest = 0;
               eight = 1;             
             end
      10'd1: begin  //eighth E5
               counter = 18'd75873;
               rest = 0;
               eight = 1;     
             end
            .
            .
            .
            .
      10'd187: begin  //eighth G4
                 counter = 18'd127551;
                 rest = 0;
                 eight = 1;
               end
      10'd188: begin  //quarter rest
                 counter = 18'd0;
                 rest = 1;
                 eight = 0;
               end
    endcase
  end
```

- Next State Logic
  ```
  always@(posedge next_note)
  begin
    if(state == 188)
      state <= 0;
    else
      state <= state + 1;
  end
  ```