`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:16 12/24/2019 
// Design Name: 
// Module Name:    cyber_melody 
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
module cyber_melody(
    input clk,
    inout [3:0] button_row,
    inout [4:0] button_col,
    output buzzer
    );

    wire [31:0] div;
    wire [3:0] octave;
    wire [3:0] note;
    wire [4:0] keycode;
    wire ready;

    clk_div clk_div (.clk(clk), .div(div));

    pitch_generator pitch_generator (
        .note(note), 
        .octave(octave), 
        .clk(clk), 
        .wave(buzzer)
        );

    keypad keypad (
        .clk(div[15]), 
        .row(button_row), 
        .col(button_col), 
        .ready(ready),
        .keycode(keycode)
        );

    piano_keypad piano_keypad (
        .ready(ready), 
        .keycode(keycode), 
        .note(note), 
        .octave(octave)
        );
endmodule
