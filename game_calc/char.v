module char(
	input sys_clk,
	//input [9:0] blk_map_X, //the size is wrong, should be 480
	//input [9:0] blk_map_Y,
	input [3:0] mov, //from keypad //u d l r
	//input jump, fall,
	output reg [9:0] char_X,
	output reg [9:0] char_Y
);
reg [9:0] blk_map_X=10'd0;
reg [9:0] blk_map_Y=10'd0;

initial begin 
	char_X=10'd143;
	char_Y=10'd34;
end

reg [29:0] counter=30'd0;
reg clk_2hz=1'd0;
always @(posedge sys_clk) begin
    if(counter==30'd4999999)begin
        counter<=30'd0;
        clk_2hz<=~clk_2hz;
    end
    else begin
        counter<=counter+30'd1;
    end
end

always @(posedge sys_clk) begin
    if(char_X==10'd640) begin
        char_X=10'd0;
    end
	else if(mov[3]==1'b1 && ~(blk_map_X[char_X] & blk_map_Y[char_Y+10'b1])) begin
		char_X<=char_X; char_Y<=char_Y+10'b1;
	end
	else if(mov[2]==1'b1 && ~(blk_map_X[char_X] & blk_map_Y[char_Y-10'b1])) begin
		char_X<=char_X; char_Y<=char_Y-10'b1;
	end
	else if(mov[1]==1'b1 && ~(blk_map_X[char_X-10'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X-10'b1; char_Y<=char_Y;
	end
	else if(mov[0]==1'b1&& ~(blk_map_X[char_X+10'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X+10'b1; char_Y<=char_Y;
	end
end

//jump/ fall

endmodule