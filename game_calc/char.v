module char(
	input sys_clk,
	input [3:0] mov, //from keypad //u d l r
	
	output reg [9:0] char_X,
	output reg [9:0] char_Y,
	output block
);

parameter map_r_lim=10'd960, map_l_lim=10'd0, map_u_lim=10'd0, map_d_lim=10'd400;

//reg [9:0] blk_map_X=10'd0;
//reg [9:0] blk_map_Y=10'd0;
reg [29:0] counter=30'd0;
reg clk_2hz=1'd0;

reg forward=1'b1, backward=1'b1, upward=1'b1, downward=1'b1;
//reg next_mov=1'b0; //the flag for the checking process

initial begin 
	char_X=10'd244;
	char_Y=10'd300;
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


always @(posedge clk_2hz) begin
	//next_mov<=1'b1;
	
    if(char_X==map_l_lim) begin
        //char_X<=char_X; //cannot move anymore
    end
	else if(mov[1]==1'b1 && backward) begin
		char_X<=char_X-10'd1; //char_Y<=char_Y;
	end
	if(char_X>=map_r_lim) begin
	   //char_X<=char_X;
	end
	else if(mov[0]==1'b1&& forward) begin
		char_X<=char_X+10'd1; //char_Y<=char_Y;
	end
end

//jump/fall
parameter IDLE = 2'b00, FALLING = 2'b01, JUMPING = 2'b10;
reg [1:0] state=2'd0;
reg [9:0] counter_jump=10'd0;

always@(posedge clk_2hz) begin //next state logic
    case (state)
		IDLE: begin
			if(downward && char_Y<=map_d_lim) state<=FALLING;
			
			if(mov[3]==1'b1 && upward) begin
				//counter_jump<=4'd0;
				state<=JUMPING;
			end

		end
	
		FALLING: begin
            if(downward && char_Y<=map_d_lim) state<=FALLING;
			else state<=IDLE;
        end
		
		JUMPING: begin
			if(counter_jump==10'd48) begin
				counter_jump<=10'd0;
				state<=FALLING;
			end
			else begin
				counter_jump<=counter_jump+10'd1;
			end
		end

    endcase
end

always@(posedge clk_2hz) begin
    case (state)
		IDLE: begin
			char_Y<=char_Y;
		end
	
        FALLING: begin
            char_Y<=char_Y+10'b1;
        end
		
		JUMPING: begin
			char_Y<=char_Y-10'b1;
		end

    endcase
end

//blocking
parameter REST = 3'd0, U = 3'd1, D = 3'd2, L = 3'd3, R = 3'd4;
//wire block; //the information of current location
reg [2:0] state_check_blocking=3'd0;
reg [9:0] check_X;
reg [9:0] check_Y;

 
	blk_mem_gen_2 blocking_ram (
        .clka(sys_clk),
        
        .addra({check_Y[4:0], check_X[4:0]}), 
        .douta(block)
    );

always@(posedge clk_2hz) begin //next state logic //debug, might have timing problem
    case (state_check_blocking)
		REST: begin
			//if(next_mov==1'b1) begin
			//	next_mov<=1'b0;
				state_check_blocking<=U;
			//end
			//else state_check_blocking<=IDLE;
		end
	
		U: begin
            state_check_blocking<=D;
        end
		
		D: begin
			state_check_blocking<=L;
		end
		
		L: begin
			state_check_blocking<=R;
		end
		
		R: begin
			state_check_blocking<=IDLE;
		end

    endcase
end

always@(posedge clk_2hz) begin
    case (state_check_blocking)
		REST: begin
			//do nothing
		end
        U: begin
			if((char_Y-10'b1)>=map_u_lim) begin
			    check_X<=char_X;
				check_Y<=char_Y-10'b1;
				if(block) upward<=1'b0;
				else upward<=1'b1;
			end
        end
		
		D: begin
			if((char_Y+10'b1)<=map_d_lim) begin
			    check_X<=char_X;
				check_Y<=char_Y+10'b1;
				if(block) downward<=1'b0;
				else downward<=1'b1;
			end
		end
		
		L: begin
			if((char_X-10'b1)>=map_l_lim) begin
				check_X<=char_X-10'b1;
				check_Y<=char_Y;
				if(~block) backward<=1'b0; //debug
				else backward<=1'b1;
			end
		end
		
		R: begin
			if((char_X+10'b1)<=map_r_lim) begin
				check_X<=char_X+10'b1;
				check_Y<=char_Y;
				if(~block) forward<=1'b0; //debug
				else forward<=1'b1; 
			end
		end

    endcase
end
endmodule