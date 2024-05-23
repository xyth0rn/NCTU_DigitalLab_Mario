module char(
	input sys_clk,
	input [3:0] mov, //from keypad //u d l r
	input RST_N,
	
	input death_in,
	input poison_mushroom_in,
	input star_in1,
	input star_in2,
	input star_in3,
	input star_in4,
	input star_in5,
	input flying_mushroom_in,
	input fire_flower_in,
	
	
	
	output reg [9:0] char_X,
	output reg [9:0] char_Y,
	output block,
	output reg dead=1'b0,
	output reg flying_mushroom=1'b0,
	output reg fire_flower=1'b0,
	output reg poison_mushroom=1'b0,
	output reg [3:0] star_cnt=4'd0,
	output WIN
);

parameter map_r_lim=10'd960, map_l_lim=10'd0, map_u_lim=10'd0, map_d_lim=10'd500;
parameter start_X=10'd220, start_Y=10'd360;
parameter F_X=10'd372, F_Y=10'd260;
parameter goomba_room_X=10'd100, goomba_room_Y=10'd430;
parameter G_X=10'd450, G_Y=10'd200;
parameter door_A_X=10'd350, door_A_Y=10'd50, door_B_X=10'd55, door_B_Y=10'd25, door_C_X=10'd50, door_C_Y=10'd205;
parameter door_D_X=10'd150, door_D_Y=10'd200, door_E_X=10'd30, door_E_Y=10'd345;
parameter stage_two_X=10'd600, stage_two_Y=10'd10;
parameter pipe_A_X=10'd590, pipe_A_Y=10'd110, pipe_B_X=10'd590, pipe_B_Y=10'd250, pipe_C_X=10'd590, pipe_C_Y=10'd365;
parameter pipe_D_X=10'd715, pipe_D_Y=10'd110, pipe_E_X=10'd750, pipe_E_Y=10'd110, pipe_F_X=10'd750, pipe_F_Y=10'd250;
parameter pipe_G_X=10'd750, pipe_G_Y=10'd365, pipe_H_X=10'd900, pipe_H_Y=10'd125;

reg [9:0] last_X=start_X;
reg [9:0] last_Y=start_Y;

reg [29:0] counter=30'd0;
reg clk_2hz=1'd0;

reg forward=1'b1, backward=1'b1, upward=1'b1, downward=1'b1;
//reg last_forward=1'b1, last_backward=1'b1, last_upward=1'b1, last_downward=1'b1;

//reg [1:0] last_mov=2'd0; //record the last movement of backward and forward
reg send_back_lr=1'b0;
reg transmit=1'b0;
reg win;
assign WIN = win;

//interaction object
reg [3:0] star1 = 0;
reg [3:0] star2 = 0;
reg [3:0] star3 = 0;
reg [3:0] star4 = 0;
reg [3:0] star5 = 0;
assign WIN = (star_cnt == 4'd5)? 1 : 0;
always@(*)
  begin
    star_cnt = star1 + star2 + star3 + star4 + star5;
  end


always @(posedge star_in1 or negedge RST_N) 
  begin 
    if(!RST_N)
      star1 <= 0;
    else
      star1 <= star1 + 1;
  end
 always @(posedge star_in2 or negedge RST_N) 
  begin 
    if(!RST_N)
      star2 <= 0;
    else
      star2 <= star2 + 1;
  end
  always @(posedge star_in3 or negedge RST_N) 
  begin 
    if(!RST_N)
      star3 <= 0;
    else
      star3 <= star3 + 1;
  end
  always @(posedge star_in4 or negedge RST_N) 
  begin 
    if(!RST_N)
      star4 <= 0;
    else
      star4 <= star4 + 1;
  end
  always @(posedge star_in5 or negedge RST_N) 
  begin 
    if(!RST_N)
      star5 <= 0;
    else
      star5 <= star5 + 1;
  end
  
/*always @(flying_mushroom_in) begin
	if(flying_mushroom_in) flying_mushroom<=1'b1;
	//if(~RST_N) flying_mushroom<=1'b0;
end*/

always @(poison_mushroom_in) begin
	if(poison_mushroom_in) poison_mushroom<=1'b1;
	//if(~RST_N) poison_mushroom<=1'b0;
end

always @(fire_flower_in) begin
	if(fire_flower_in) fire_flower<=1'b1;
	//if(~RST_N) fire_flower<=1'b0;
end

always @(death_in or poison_mushroom_in) begin
	if(death_in) dead<=1'b1;
	if(poison_mushroom_in && !fire_flower) dead<=1'b1;
	//if(~RST_N) dead<=1'b0;
end


//movement control
initial begin 
	char_X=start_X;
	char_Y=start_Y;
end

always @(posedge sys_clk) begin
    if(counter==30'd99999)begin
        counter<=30'd0;
        clk_2hz<=~clk_2hz;
    end
    else begin
        counter<=counter+30'd1;
    end
end


always @(posedge clk_2hz or negedge RST_N) begin
	//transmit
	if(!RST_N || dead)begin
		char_X<=start_X;
		transmit<=1'b1;
	end
	else if(char_X==F_X && (char_Y>=F_Y && char_Y<F_Y+10'd24)) begin
		transmit<=1'b1;
		if(flying_mushroom_in) char_X<=G_X;
		else char_X<=goomba_room_X;
	end
	else if((char_X>=door_A_X && char_X<door_A_X+10'd24) && char_Y==door_A_Y) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==door_B_X && (char_Y>=door_B_Y && char_Y<door_B_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==door_C_X && (char_Y>=door_C_Y && char_Y<door_C_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=door_D_X;
	end
	else if(char_X==door_E_X && (char_Y>=door_E_Y && char_Y<door_E_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=stage_two_X;
	end
	else if(char_X==pipe_A_X && (char_Y>=pipe_A_Y && char_Y<pipe_A_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==pipe_C_X && (char_Y>=pipe_C_Y && char_Y<pipe_C_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==pipe_B_X && (char_Y>=pipe_B_Y && char_Y<pipe_B_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=pipe_D_X;
	end
	else if(char_X==pipe_E_X && (char_Y>=pipe_E_Y && char_Y<pipe_E_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==pipe_F_X && (char_Y>=pipe_F_Y && char_Y<pipe_F_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=goomba_room_X;
	end
	else if(char_X==pipe_G_X && (char_Y>=pipe_G_Y && char_Y<pipe_G_Y+10'd24)) begin
		transmit<=1'b1;
		char_X<=pipe_H_X;
	end
	//move left/right
	else begin	
		if(char_X==map_l_lim) begin
			//char_X<=char_X; //cannot move anymore
		end
		else if(mov[1]==1'b1 && backward) begin
			if(block & ~transmit) begin
				char_X<=last_X;
				send_back_lr<=1'b1;
			end
			else begin
				transmit<=1'b0;
				last_X<=char_X; //record previous X
				char_X<=char_X-10'd1; 
			end
			//last_mov[1]<=1'b1;
			//last_mov[0]<=1'b0;
		end
		else begin
			//last_mov[1]<=1'b0;
			
			if(block) begin
				//char_X<=last_X;
				send_back_lr<=1'b1;
			end
			else begin
				send_back_lr<=1'b0;
			end
		end
		
		if(char_X>=map_r_lim) begin
		   //char_X<=char_X;
		end
		else if(mov[0]==1'b1&& forward) begin
			if(block & ~transmit) begin
				char_X<=last_X;
				send_back_lr<=1'b1;
			end
			else begin
				transmit<=1'b0;
				last_X<=char_X; //record previous X
				char_X<=char_X+10'd1; 
			end
			//last_mov[0]<=1'b1;
			//last_mov[1]<=1'b0;
		end
		else begin
			//last_mov[0]<=1'b0;
			if(block & ~transmit) begin
				//char_X<=last_X;
				send_back_lr<=1'b1;
			end
			else begin
				send_back_lr<=1'b0;
			end
		end
	end
end

//jump/fall
parameter IDLE = 2'b00, FALLING = 2'b01, JUMPING = 2'b10;
reg [1:0] state=FALLING;
reg [9:0] counter_jump=10'd0;

always@(posedge clk_2hz) begin //next state logic
    case (state)
		IDLE: begin
			if(block) state<=IDLE;
			else if(downward && char_Y<=map_d_lim) state<=FALLING;
			
			if(mov[3]==1'b1 && upward) begin
				//counter_jump<=4'd0;
				state<=JUMPING;
			end

		end
	
		FALLING: begin
			if(block && ~transmit) state<=IDLE;
            else if(downward && char_Y<=map_d_lim && ~transmit) state<=FALLING;
			else state<=IDLE;
        end
		
		JUMPING: begin
			//if(block) state<=FALLING;
			if(counter_jump==10'd64) begin
				counter_jump<=10'd0;
				state<=FALLING;
			end
			else begin
				counter_jump<=counter_jump+10'd1;
			end
		end

    endcase
end

always@(posedge clk_2hz or negedge RST_N) begin
	//reset and transmit
	if(!RST_N || dead)begin
		char_Y<=start_Y;
	end
	else if(char_X==F_X && (char_Y>=F_Y && char_Y<F_Y+10'd24)) begin
		if(flying_mushroom_in) char_Y<=G_Y;
		else char_Y<=goomba_room_Y;
	end
	else if((char_X>=door_A_X && char_X<door_A_X+10'd24) && char_Y==door_A_Y) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==door_B_X && (char_Y>=door_B_Y && char_Y<door_B_Y+10'd24)) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==door_C_X && (char_Y>=door_C_Y && char_Y<door_C_Y+10'd24)) begin
		char_Y<=door_D_Y;
	end
	else if(char_X==door_E_X && (char_Y>=door_E_Y && char_Y<door_E_Y+10'd24)) begin
		char_Y<=stage_two_Y;
	end
	else if(char_X==pipe_A_X && (char_Y>=pipe_A_Y && char_Y<pipe_A_Y+10'd24)) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==pipe_C_X && (char_Y>=pipe_C_Y && char_Y<pipe_C_Y+10'd24)) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==pipe_B_X && (char_Y>=pipe_B_Y && char_Y<pipe_B_Y+10'd24)) begin
		char_Y<=pipe_D_Y;
	end
	else if(char_X==pipe_E_X && (char_Y>=pipe_E_Y && char_Y<pipe_E_Y+10'd24)) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==pipe_F_X && (char_Y>=pipe_F_Y && char_Y<pipe_F_Y+10'd24)) begin
		char_Y<=goomba_room_Y;
	end
	else if(char_X==pipe_G_X && (char_Y>=pipe_G_Y && char_Y<pipe_G_Y+10'd24)) begin
		char_Y<=pipe_H_Y;
	end
	//jump/fall
	else begin		
		case (state)
			IDLE: begin
				if(block && ~transmit) char_Y<=last_Y;
				else char_Y<=char_Y;
				
				if(char_X!=last_X && ~transmit) downward<=1'b1;
				else if(send_back_lr) downward<=1'b1;
			end
		
			FALLING: begin
				if(block && ~transmit) begin
					char_Y<=last_Y;
					downward<=1'b0;
				end
				else begin
					last_Y<=char_Y;
					char_Y<=char_Y+10'b1;
				end
				//last_mov[2]<=1'b1;
				//last_mov[3]<=1'b0;
			end
			
			JUMPING: begin
				if(block && ~transmit) begin
					char_Y<=last_Y;
				end
				else begin
					downward<=1'b1;
					last_Y<=char_Y;
					char_Y<=char_Y-10'b1;
				end
				//last_mov[3]<=1'b1;
				//last_mov[2]<=1'b0;
			end

		endcase
	end
end

//blocking
 
	blk_mem_gen_2 blocking_ram (
        .clka(sys_clk),
        
        .addra({10'b0, char_X}+{10'b0, char_Y}*20'd960),  //char_X, char_Y will work 
        .douta(block)
    );

endmodule