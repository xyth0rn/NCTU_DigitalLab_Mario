module keypad_to_bcd(
    input  wire [6:0] key,   // dcbaefg
    output wire [3:0] num    // outputs 4-bit number
    );
  
    reg [3:0] num_r;
    assign num = num_r;
    
    always @* begin
        case( key )
            7'b0001100: num_r <= 4'd1;
            7'b0001010: num_r <= 4'd2;
            7'b0001001: num_r <= 4'd3;
            7'b0010100: num_r <= 4'd4;
            7'b0010010: num_r <= 4'd5;
            7'b0010001: num_r <= 4'd6;
            7'b0100100: num_r <= 4'd7;
            7'b0100010: num_r <= 4'd8;
            7'b0100001: num_r <= 4'd9;
            7'b1000100: num_r <= 4'd10;   // .
            7'b1000010: num_r <= 4'd0;
            7'b1000001: num_r <= 4'd11;   // U
            default: num_r <= 4'd12;      // nothing
        endcase
    end
endmodule
