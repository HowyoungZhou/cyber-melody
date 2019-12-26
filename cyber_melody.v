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
    input rst_n,
    inout [3:0] btn_y,
    inout [4:0] btn_x,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_h_sync,
    output vga_v_sync,
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
        .row(btn_y), 
        .col(btn_x), 
        .ready(ready),
        .keycode(keycode)
        );

    piano_keypad piano_keypad (
        .clk(clk),
        .ready(ready), 
        .keycode(keycode), 
        .note(note), 
        .octave(octave)
        );

    vga vga (
        .vram_clk(clk), 
        .vga_clk(div[1]), 
        .clrn(rst_n), 
        .we(0), 
        .addr(0), 
        .data(0), 
        .r(vga_red), 
        .g(vga_green), 
        .b(vga_blue), 
        .hs(vga_h_sync), 
        .vs(vga_v_sync)
        );
endmodule
