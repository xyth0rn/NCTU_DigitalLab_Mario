module scroll(
	input sys_clk,
	input [9:0] char_X, 
	input [9:0] char_Y,
	//output reg [3:0] update_pos_scroll,
	output reg [9:0] bg_pos=10'd0 
);

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

always @(posedge clk_2hz) begin
	if(bg_pos==10'd640) begin 
		bg_pos<=10'd0;
	end
	else if(char_X<=bg_pos+10'd90) begin
		bg_pos<=bg_pos-10'd1;
	end
	else if(char_X>=bg_pos+10'd270) begin
		bg_pos<=bg_pos+10'd1;
	end
end

/*reg [29:0] counter=30'd0;
always @(posedge sys_clk) begin
    if(counter>=30'd9999999)begin
        counter<=30'd0;
        bg_pos<=bg_pos+10'd10;
    end
    else begin
        counter<=counter+30'd1;
    end

end*/


endmodule