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

    always@(posedge ready)begin
        case (keycode)
            4: note <= C;
            8: note <= CS;

            5: note <= D;
            9: note <= DS;

            6: note <= E;
            7: note <= F;
            11: note <= FS;

            12: note <= G;
            16: note <= GS;
            
            13: note <= A;
            17: note <= AS;
            14: note <= B;

            15: octave <= (octave + 1 > 9 ? 9 : octave + 1);
            19: octave <= (octave - 1 < 0 ? 0 : octave - 1);
            default: note <= rest;
        endcase
    end
endmodule
