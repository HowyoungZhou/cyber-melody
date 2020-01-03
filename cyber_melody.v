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
    input [15:0] raw_switches,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_h_sync,
    output vga_v_sync,
    output buzzer,
    output ready
    );

    wire [31:0] div;
    wire [3:0] cur_octave, keypad_octave, octave;
    wire [3:0] cur_note, keypad_note, note;
    wire [15:0] cur_length;
    wire [4:0] keycode;
    wire [15:0] switches;
    wire [7:0] note_pointer;
    wire ready, rst, clk_1ms;

    // Graphics Processor
    wire gp_finish; 
    wire gp_en; 
    wire gp_opcode; 
    wire [9:0] gp_tl_x; 
    wire [8:0] gp_tl_y; 
    wire [9:0] gp_br_x; 
    wire [8:0] gp_br_y; 
    wire [11:0] gp_arg;

    // VRAM
    wire vram_we;
    wire [18:0] vram_addr;
    wire [11:0] vram_data;

    // Image ROM
    wire [18:0] img_rom_addr;
    wire [11:0] img_rom_data;

    assign rst = ~rst_n;

    clk_div clk_div (.clk(clk), .div(div), .clk_1ms(clk_1ms));

    anti_jitter #(4) sw_aj [15:0](.clk(div[15]), .I(raw_switches), .O(switches));

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

    music_score_controller music_sco_control (
        .clk_1ms(clk_1ms), 
        .en(switches[1]), // TODO: change en signal
        .rst(rst), 
        .note_pointer(note_pointer), 
        .cur_length(cur_length), 
        .cur_note(cur_note), 
        .cur_octave(cur_octave)
        );

    piano_keypad piano_keypad (
        .clk(clk),
        .ready(ready), 
        .keycode(keycode), 
        .note(keypad_note), 
        .octave(keypad_octave)
        );

    mux2t1_4 note_mux(
        .s(switches[0]),
        .in0(keypad_note),
        .in1(cur_note),
        .out(note)
        );

    mux2t1_4 octave_mux(
        .s(switches[0]),
        .in0(keypad_octave),
        .in1(cur_octave),
        .out(octave)
        );

    vga vga (
        .vram_clk(clk), 
        .vga_clk(div[1]), 
        .clrn(rst_n), 
        .we(vram_we),
        .addr(vram_addr), 
        .data(vram_data), 
        .r(vga_red), 
        .g(vga_green), 
        .b(vga_blue), 
        .hs(vga_h_sync), 
        .vs(vga_v_sync)
        );

    game_controller game_control (
        .clk(clk), 
        .repaint_clk(1'b0), // TODO
        .keypress(ready), 
        .keycode(keycode), 
        .gp_finish(gp_finish), 
        .gp_en(gp_en), 
        .gp_opcode(gp_opcode), 
        .gp_tl_x(gp_tl_x), 
        .gp_tl_y(gp_tl_y), 
        .gp_br_x(gp_br_x), 
        .gp_br_y(gp_br_y), 
        .gp_arg(gp_arg)
        );

    main_scene_image_rom img_rom (
        .clka(clk), // input clka
        .addra(img_rom_addr), // input [18 : 0] addra
        .douta(img_rom_data) // output [11 : 0] douta
        );

    graphics_processor gp (
        .clk(clk), 
        .en(gp_en), 
        .opcode(gp_opcode), 
        .tl_x(gp_tl_x), 
        .tl_y(gp_tl_y), 
        .br_x(gp_br_x), 
        .br_y(gp_br_y), 
        .arg(gp_arg), 
        .rom_data(img_rom_data), 
        .vram_we(vram_we), 
        .vram_addr(vram_addr), 
        .vram_data(vram_data), 
        .rom_addr(img_rom_addr), 
        .finish(gp_finish)
        );
endmodule
