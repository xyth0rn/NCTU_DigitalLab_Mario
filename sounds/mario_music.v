`timescale 1ns / 1ps


module BGM(input clk,
           output out                
 );
reg [17:0] counter; //frequency
reg [9:0] state = 10'd0; //note
reg rest;
reg eight; //eighth note or fourth note
wire next_note;
wire sound_output;

   

note a1(.clk_100MHz (clk),
        .counter (counter),
        .rest (rest),
        .eight (eight),
        .next_note (next_note),
        .note (sound_output)
);
always@(posedge next_note)
  begin
    if(state == 188)
      state <= 0;
    else
      state <= state + 1;
  end

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
      10'd2: begin  //eighth rest
               counter = 0;
               rest = 1;
               eight = 1;
             end  
      10'd3: begin  //eighth E5
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end  
      10'd4: begin  //eighth rest
               counter = 0;
               rest = 1;
               eight = 1;
             end
      10'd5: begin  //eighth C5
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd6: begin  //fourth E5
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //second section
      10'd7: begin  //fourth G5
               counter = 18'd63776;
               rest = 0;
               eight = 0;
             end
      10'd8: begin  //fourth rest
               counter = 0;
               rest = 1;
               eight = 0;
             end
      10'd9: begin  //fourth G4
               counter = 18'd127551;
               rest = 0;
               eight = 0;
             end  
      10'd10: begin  //fourth rest
               counter = 0;
               rest = 1;
               eight = 0;
             end
      
      //third section
      10'd11: begin  //fourth C5
               counter = 18'd95602;
               rest = 0;
               eight = 0;
             end
      10'd12: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd13: begin  //fourth G4 
               counter = 18'd127551;
               rest = 0;
               eight = 0;
             end
      10'd14: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd15: begin  //fourth E4 
               counter = 18'd151515;
               rest = 0;
               eight = 0;
             end
      //fourth section
      10'd16: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd17: begin  //fourth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 0;
             end
      10'd18: begin  //fourth B4
               counter = 18'd101215;
               rest = 0;
               eight = 0;
             end
      10'd19: begin  //eighth A4#
               counter = 18'd107296;
               rest = 0;
               eight = 1;
             end
      10'd20: begin  //fourth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 0;
             end
      //fifth section
      10'd21: begin  //eigtht G4 
               counter = 18'd127551;
               rest = 0;
               eight = 1;
             end
      10'd22: begin  //eighth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end
      10'd23: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd24: begin  //fourth A5 
               counter = 18'd56818;
               rest = 0;
               eight = 0;
             end
      10'd25: begin  //eighth F5
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd26: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      //sixth section
      10'd27: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd28: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      10'd29: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd30: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      10'd31: begin  //fourth B4
               counter = 18'd101215;
               rest = 0;
               eight = 0;
             end
      10'd32: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      //seventh section
      10'd33: begin  //fourth C5
               counter = 18'd95602;
               rest = 0;
               eight = 0;
             end
      10'd34: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd35: begin  //fourth G4 
               counter = 18'd127551;
               rest = 0;
               eight = 0;
             end
      10'd36: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd37: begin  //fourth E4 
               counter = 18'd151515;
               rest = 0;
               eight = 0;
             end
      //eighth section
      10'd38: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd39: begin  //fourth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 0;
             end
      10'd40: begin  //fourth B4
               counter = 18'd101215;
               rest = 0;
               eight = 0;
             end
      10'd41: begin  //eighth A4#
               counter = 18'd107296;
               rest = 0;
               eight = 1;
             end
      10'd42: begin  //fourth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 0;
             end
      //ninth section
      10'd43: begin  //eigtht G4 
               counter = 18'd127551;
               rest = 0;
               eight = 1;
             end
      10'd44: begin  //eighth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end
      10'd45: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd46: begin  //fourth A5 
               counter = 18'd56818;
               rest = 0;
               eight = 0;
             end
      10'd47: begin  //eighth D5
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      10'd48: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      //tenth section
      10'd49: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd50: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      10'd51: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd52: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      10'd53: begin  //fourth B4
               counter = 18'd101215;
               rest = 0;
               eight = 0;
             end
      10'd54: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      //eleventh section
      10'd55: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd56: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd57: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd58: begin  //eighth F5 
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd59: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd60: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //twelfth section
      10'd61: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd62: begin  //eighth G4# 
               counter = 18'd120481;
               rest = 0;
               eight = 1;
             end
      10'd63: begin  //eighth A4
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd64: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd65: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd66: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd67: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd68: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      //Thirteenth section
      10'd69: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd70: begin  //eighth G5
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd71: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd72: begin  //eighth F5
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd73: begin  //foruth D5#
               counter = 18'd80385;
               rest = 0; 
               eight = 0;
             end
      10'd74: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //fourteenth section
      10'd75: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd76: begin  //fourth C6 
               counter = 18'd47801;
               rest = 0;
               eight = 0;
             end
      10'd77: begin  //eighth C6
               counter = 18'd47801;
               rest = 0;
               eight = 1;
             end
      10'd78: begin  //fourth C6 
               counter = 18'd47801;
               rest = 0;
               eight = 0;
             end
      10'd79: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      //fifteenth section
      10'd80: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd81: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd82: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd83: begin  //eighth F5 
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd84: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd85: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //Sixteenth section
      10'd86: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd87: begin  //eighth G4# 
               counter = 18'd120481;
               rest = 0;
               eight = 1;
             end
      10'd88: begin  //eighth A4
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd89: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd90: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd91: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd92: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd93: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      //Seventeenth section
      10'd94: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd95: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd96: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd97: begin  //fourth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 0;
             end
      10'd98: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      //Eighteenth section
      10'd99: begin  //fourth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 0;
             end
      10'd100: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd101: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd102: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      //Nineteenth section
      10'd103: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd104: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd105: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd106: begin  //eighth F5 
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd107: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd108: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //Twentieth section
      10'd109: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd110: begin  //eighth G4# 
               counter = 18'd120481;
               rest = 0;
               eight = 1;
             end
      10'd111: begin  //eighth A4
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd112: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd113: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd114: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd115: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd116: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      //Twenty-First section
      10'd117: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd118: begin  //eighth G5
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd119: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd120: begin  //eighth F5
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd121: begin  //foruth D5#
               counter = 18'd80385;
               rest = 0; 
               eight = 0;
             end
      10'd122: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //Twenty-Second section
      10'd123: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd124: begin  //fourth C6 
               counter = 18'd47801;
               rest = 0;
               eight = 0;
             end
      10'd125: begin  //eighth C6
               counter = 18'd47801;
               rest = 0;
               eight = 1;
             end
      10'd126: begin  //fourth C6 
               counter = 18'd47801;
               rest = 0;
               eight = 0;
             end
      10'd127: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      //Twenty-Third section
      10'd128: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd129: begin  //eighth G5 
               counter = 18'd63776;
               rest = 0;
               eight = 1;
             end
      10'd130: begin  //eighth F5# 
               counter = 18'd67658;
               rest = 0;
               eight = 1;
             end
      10'd131: begin  //eighth F5 
               counter = 18'd71633;
               rest = 0;
               eight = 1;
             end
      10'd132: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd133: begin  //fourth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 0;
             end
      //Twenty-Fourth section
      10'd134: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd135: begin  //eighth G4# 
               counter = 18'd120481;
               rest = 0;
               eight = 1;
             end
      10'd136: begin  //eighth A4
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd137: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd138: begin  //eighth rest
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd139: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
      10'd140: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd141: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      //Twenty-Fifth section
      10'd142: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd143: begin  //fourth D5# 
               counter = 18'd80385;
               rest = 0;
               eight = 0;
             end
      10'd144: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd145: begin  //fourth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 0;
             end
      10'd146: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      //Twenty-Sixth section
      10'd147: begin  //fourth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 0;
             end
      10'd148: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd149: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      10'd150: begin  //fourth rest 
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
      //Twenty-Seventh section
      10'd151: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd152: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd153: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd154: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd155: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd156: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd157: begin  //fourth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 0;
             end
      //Twenty-Eighth section
     10'd158: begin  //eighth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end
     10'd159: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
     10'd160: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end         
     10'd161: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
     10'd162: begin  //eighth G4
               counter = 18'd127551;
               rest = 0;
               eight = 1;
             end
     10'd163: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
     //Twenty-Ninth section
      10'd164: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd165: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd166: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd167: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd168: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd169: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd170: begin  //eighth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 1;
             end
      10'd171: begin  //eighth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end
      //Thirtieth section
      10'd172: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
       10'd173: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
        10'd174: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end      
         10'd175: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end     
         //Thirty-first section
       10'd176: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd177: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd178: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd179: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd180: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end
      10'd181: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
      10'd182: begin  //fourth D5 
               counter = 18'd85178;
               rest = 0;
               eight = 0;
             end
      //Thirty-Second section
     10'd183: begin  //eighth E5 
               counter = 18'd75873;
               rest = 0;
               eight = 1;
             end
     10'd184: begin  //eighth C5 
               counter = 18'd95602;
               rest = 0;
               eight = 1;
             end
     10'd185: begin  //eighth rest 
               counter = 18'd0;
               rest = 1;
               eight = 1;
             end         
     10'd186: begin  //eighth A4 
               counter = 18'd113636;
               rest = 0;
               eight = 1;
             end
     10'd187: begin  //eighth G4
               counter = 18'd127551;
               rest = 0;
               eight = 1;
             end
     10'd188: begin  //fourth rest
               counter = 18'd0;
               rest = 1;
               eight = 0;
             end
    endcase
  end

assign out = sound_output;


endmodule

module note (input clk_100MHz,
              input [17:0] counter,
              input rest,
              input eight,
              output next_note,
              output note
);
reg [17:0] count = 18'd0;
reg clk_out = 0;
wire clk_1000Hz;
reg [9:0] beat_counter = 10'd0;
reg change = 0;

always@(posedge clk_100MHz)
  begin
    if(count == counter)
      begin
        count <= 18'd0;
        clk_out <= ~clk_out;
      end
    else
      count <= count + 1;
  end 
assign note = clk_out & ~rest & ((eight & (beat_counter <= 150)) | (~eight & (beat_counter <= 300)));

always@(posedge clk_1000Hz)
  begin
    if(eight)
      begin
        if(beat_counter == 200)
          begin
            beat_counter <= 0;
            change <= 1;
          end
        else
          begin
            beat_counter <= beat_counter + 1;
            change <= 0;
          end
      end
    else
      if(beat_counter == 350)
        begin
          beat_counter <= 0;
          change <= 1;
        end
      else
        begin
          beat_counter <= beat_counter + 1;
          change <= 0;
        end  
  end
assign next_note = change;  

clk_1000Hz a1(.clk_100MHz (clk_100MHz),
             .clk_1000Hz (clk_1000Hz)
);         


endmodule

module clk_1000Hz(input clk_100MHz,
                  output clk_1000Hz
    );
reg [26:0] count = 26'd0;
reg clk_out = 0;
always@(posedge clk_100MHz)
  begin
    if(count == 49999)
      begin
        count <= 26'd0;
        clk_out <= ~clk_out;
      end
    else
      count <= count + 1;
  end
  assign clk_1000Hz = clk_out;
endmodule






