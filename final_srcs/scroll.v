module scroll(
	input sys_clk,
	input [9:0] char_X, 
	input [9:0] char_Y,
	//output reg [3:0] update_pos_scroll,
	output reg [9:0] bg_pos 
);

initial begin
    bg_pos=10'd0;
end

always @(posedge sys_clk) begin
	if(bg_pos<10'd325 && char_X>=bg_pos+10'd270) begin
		bg_pos<=bg_pos+10'd1;
	end
	if(bg_pos>10'd0 && char_X<=bg_pos+10'd90) begin
		bg_pos<=bg_pos-10'd1;
	end
	
end

endmodule