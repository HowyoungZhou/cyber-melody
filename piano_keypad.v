`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:20 12/24/2019 
// Design Name: 
// Module Name:    piano_keypad
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
module piano_keypad(
    input clk,
    input ready,
    input [4:0] keycode,
    output reg [3:0] note = 0,
    output reg [3:0] octave = 4
    );

    parameter rest = 0;
    parameter C = 1;
    parameter CS = 2;
    parameter D = 3;
    parameter DS = 4;
    parameter E = 5;
    parameter F = 6;
    parameter FS = 7;
    parameter G = 8;
    parameter GS = 9;
    parameter A = 10;
    parameter AS = 11;
    parameter B = 12;

    reg last_state = 0;

    always@(posedge clk)begin
        last_state <= ready;
        if(ready)begin
            case (keycode)
                5'd4: note <= C;
                5'd8: note <= CS;

                5'd5: note <= D;
                5'd9: note <= DS;

                5'd6: note <= E;
                5'd7: note <= F;
                5'd11: note <= FS;

                5'd12: note <= G;
                5'd16: note <= GS;
                
                5'd13: note <= A;
                5'd17: note <= AS;
                5'd14: note <= B;

                5'd15: if (!last_state) octave <= (octave == 9 ? 0 : octave + 1);
                5'd19: if (!last_state) octave <= (octave == 0 ? 9 : octave - 1);
                default: note <= rest;
            endcase
        end
        else begin
            note <= rest;
        end
    end
endmodule
