# Background Music Development Log
## calculate how long each note should last
 - In general, we can mainly categorize the notes in this sheet music into `quarter notes` and `eighth notes`.
 - This music's BPM is 180, which means it plays 180 quarter notes per minute, so every quarter notes lasts for 60s/180 = 0.33s. For convenience, we let it be 0.3s. Therefore the eighth note should last for 0.3s/2 = 0.15s. 
 - We must insert a break between the two notes, otherwise two consecutive eighth notes of the same pitch will sound like a quarter note. Thus we add a additional 0.05s break to distinguish two consecutive notes of the same pitch.
 - To sum up, every `quarter note` would last for 0.3s, followed by 0.05s break. Every `eighth note` would last for 0.15s, followed by 0.05s break.
![image](https://github.com/xyth0rn/NCTU_DigitalLab_Mario/assets/167954410/852b3ee5-d846-442b-abe8-6c2203a4c951)
## calculate every pitch's correspond counter number
- Every pitch come from a frequency divider whose input clock signal is 100MHz, so we must calculate the counter number to get the accurate frequency.
- Formula: 100M / `pitch's frequency` / 2
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

