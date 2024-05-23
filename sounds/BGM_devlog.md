# sheet music
## calculate how long each note should last
 - In general, we can mainly categorize the notes in this sheet music into `quarter notes` and `eighth notes`.
 - This music's BPM is 180, which means it plays 180 quarter notes per minute, so every quarter notes lasts for 60s/180 = 0.33s. For convenience, we let it be 0.3s. Therefore the eighth note should last for 0.3s/2 = 0.15s. 
 - We must insert a break between the two notes, otherwise two consecutive eighth notes of the same pitch will sound like a quarter note. Thus we add a additional 0.05s break to distinguish two consecutive notes of the same pitch.
 - To sum up, every `quarter note` would last for 0.3s, followed by 0.05s break. Every `eighth note` would last for 0.15s, followed by 0.05s break.
![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/167954410/852b3ee5-d846-442b-abe8-6c2203a4c951)
## calculate every pitch's correspond counter number

- C4: 190839
- D4: 170068
- E4: 151515
- F4: 143266
- G4: 127551
- G4#: 120481
- A4: 113636
- A4#: 107296
- B4: 101215
- C5: 95602
- D5: 85178
- D5#: 80385
- E5: 75873
- F5: 71633
- F5#: 67658
- G5: 63776
- A5: 56818
- B5: 50658
# I/O
- Input: 100MHz clock
- Output: JA1
