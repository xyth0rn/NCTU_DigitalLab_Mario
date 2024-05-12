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
reg last_forward=1'b1, last_backward=1'b1, last_upward=1'b1, last_downward=1'b1;

reg [3:0] last_mov=4'd0; //record the last movement

initial begin 
	char_X=10'd244;
	char_Y=10'd400;
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

    if(char_X==map_l_lim) begin
        //char_X<=char_X; //cannot move anymore
    end
	else if(mov[1]==1'b1 && backward) begin
		char_X<=char_X-10'd1; //char_Y<=char_Y;
		last_mov[1]<=1'b1;
		last_mov[0]<=1'b0;
	end
	else if(backward==1'b0 && last_backward==1'b1) begin
		char_X<=char_X+10'd1;
	end
	
	if(char_X>=map_r_lim) begin
	   //char_X<=char_X;
	end
	else if(mov[0]==1'b1&& forward) begin
		char_X<=char_X+10'd1; //char_Y<=char_Y;
		last_mov[0]<=1'b1;
		last_mov[1]<=1'b0;
	end
	else if(forward==1'b0 && last_forward==1'b1) begin
		char_X<=char_X-10'd1;
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
			if(last_downward==1'b1 && downward==1'b0) char_Y<=char_Y-10'd1;
			else if(last_upward==1'b1 && upward==1'b0) char_Y<=char_Y+10'd1;
			else char_Y<=char_Y;
			//char_Y<=char_Y;
		end
	
        FALLING: begin
            char_Y<=char_Y+10'b1;
			last_mov[2]<=1'b1;
			last_mov[3]<=1'b0;
        end
		
		JUMPING: begin
			char_Y<=char_Y-10'b1;
			last_mov[3]<=1'b1;
			last_mov[2]<=1'b0;
		end

    endcase
end

//blocking
 
	blk_mem_gen_2 blocking_ram (
        .clka(sys_clk),
        
        .addra({10'b0, char_X}+{10'b0, char_Y}*19'd960),  //char_X, char_Y will work
        .douta(block)
    );

always @(posedge clk_2hz) begin
	last_upward=upward;
	last_downward=downward;
	last_backward=backward;
	last_forward=forward;
	if(block) begin //lock
		if(last_mov[3]) upward=1'b0;
		if(last_mov[2]) downward=1'b0;
		if(last_mov[1]) backward=1'b0;
		if(last_mov[0]) forward=1'b0;
	end
	else begin //"unlock"
		if(last_mov[3]) downward=1'b1;
		if(last_mov[2]) upward=1'b1;
		if(last_mov[1]) forward=1'b1;
		if(last_mov[0]) backward=1'b1;
	end
end	

endmodule