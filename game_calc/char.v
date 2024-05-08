module char(
	input sys_clk,
	input [3:0] mov, //from keypad //u d l r
	
	output reg [9:0] char_X,
	output reg [9:0] char_Y
);
reg [9:0] blk_map_X=10'd0;
reg [9:0] blk_map_Y=10'd0;

initial begin 
	char_X=10'd1;
	char_Y=10'd0;
end

reg [29:0] counter=30'd0;
reg clk_2hz=1'd0;
always @(posedge sys_clk) begin
    if(counter==30'd499999)begin
        counter<=30'd0;
        clk_2hz<=~clk_2hz;
    end
    else begin
        counter<=counter+30'd1;
    end
end

always @(posedge clk_2hz) begin
    if(char_X==10'd0) begin
        //char_X<=char_X; //cannot move anymore
    end
	else if(mov[1]==1'b1 && ~(blk_map_X[char_X-10'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X-10'd1; char_Y<=char_Y;
	end
	if(char_X>=10'd480) begin
	   //char_X<=char_X;
	end
	else if(mov[0]==1'b1&& ~(blk_map_X[char_X+10'b1] & blk_map_Y[char_Y])) begin
		char_X<=char_X+10'd1; char_Y<=char_Y;
	end
end

//jump/ fall

endmodule