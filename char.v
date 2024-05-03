module char(
	input sys_clk,
	input [8:0] blk_map_X, //the size is wrong, should be 480
	input [8:0] blk_map_Y,
	input [3:0] update_pos_scroll, //up down left right
	input jump, fall,
	output reg [8:0] char_X,
	output reg [8:0] char_Y
);

initial begin 
	char_X=9'd0;
	char_Y=9'd0;
end

always @(posedge sys_clk) begin
	if(update_pos_scroll[3]==1'b1 && ~(blk_map_X[char_X] & blk_map_Y[char_Y+9'b1])) begin
		char_X<=char_X; char_Y<=char_Y+9'b1;
	end
	if(update_pos_scroll[2]==1'b1 && ~(blk_map_X[char_X] & blk_map_Y[char_Y-9'b1])) begin
		char_X<=char_X; char_Y<=char_Y-9'b1;
	end
	if(update_pos_scroll[1]==1'b1 && ~(blk_map_X[char_X-9'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X-9'b1; char_Y<=char_Y;
	end
	if(update_pos_scroll[0]==1'b1&& ~(blk_map_X[char_X+9'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X+9'b1; char_Y<=char_Y;
	end
end

//jump/ fall

endmodule