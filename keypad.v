`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:24 12/24/2019 
// Design Name: 
// Module Name:    keypad 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module keypad(
    input clk,
    inout [3:0] row,
    inout [4:0] col,
    output ready,
    output reg [4:0] keycode
    );

    reg state = 1'b0;
    reg [3:0] keyLineX;
    reg [4:0] keyLineY;
    assign row = state? 4'h0: 4'bzzzz;
    assign col = state? 5'bzzzzz: 5'h0;
    
    always @ (posedge clk)
    begin
        if(state)
            keyLineY <= col;
        else
            keyLineX <= row;
        state <= ~state;
    end

    wire raw_row = (keyLineX == 4'b1110) | (keyLineX == 4'b1101) | (keyLineX == 4'b1011) | (keyLineX == 4'b0111);
    wire raw_col = (keyLineY == 5'b11110) | (keyLineY == 5'b11101) | (keyLineY == 5'b11011) | (keyLineY == 5'b10111) | (keyLineY == 5'b01111);
    wire raw = raw_row & raw_col;
    
    always @*
    begin
        case(keyLineX)
        4'b1110: keycode[1:0] <= 2'h0;
        4'b1101: keycode[1:0] <= 2'h1;
        4'b1011: keycode[1:0] <= 2'h2;
        default: keycode[1:0] <= 2'h3;
        endcase
        case(keyLineY)
        5'b11110: keycode[4:2] <= 3'h0;
        5'b11101: keycode[4:2] <= 3'h1;
        5'b11011: keycode[4:2] <= 3'h2;
        5'b10111: keycode[4:2] <= 3'h3;
        5'b01111: keycode[4:2] <= 3'h4;
        default: keycode[4:2] <= 3'h7;
        endcase
    end
    
    anti_jitter #(4) anti_jitter(.clk(clk), .I(raw), .O(ready));

endmodule
