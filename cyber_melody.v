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
    input ps2_clk,
    input ps2_data,
    output [3:0] vga_red,
    output [3:0] vga_green,
    output [3:0] vga_blue,
    output vga_h_sync,
    output vga_v_sync,
    output buzzer,
    output seg_clk,
    output seg_do,
    output seg_pen,
    output seg_clr
    );

    wire [31:0] div;
    wire music_score_con_en;
    wire [3:0] cur_octave, keypad_octave, keyboard_octave, high_keyboard_octave;
    reg [3:0] octave, input_octave;
    wire [3:0] cur_note, keypad_note, keyboard_note;
    reg [3:0] note, input_note;
    wire [15:0] cur_length;
    wire [4:0] keycode;
    wire [15:0] switches;
    wire [7:0] note_pointer;
    wire ready, rst, clk_1ms;
    wire [1:0] mode;
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
    wire [17:0] img_rom_addr;
    wire [11:0] img_rom_data;

    // Game statistics
    wire [19:0] score;
    wire [23:0] score_bcd;
    wire [3:0] seg_out;
    reg [7:0] octave_display;

    // Keyboard
    wire [7:0] kb_keycode;
    wire keypress;

    assign rst = ~rst_n;
    assign {seg_clk, seg_do, seg_pen, seg_clr} = seg_out;
    assign mode = switches[1:0];
    assign high_keyboard_octave = keyboard_octave + 1;
    
    clk_div clk_div (.clk(clk), .div(div), .clk_1ms(clk_1ms));

    anti_jitter #(4) sw_aj [15:0](.clk(div[15]), .I(raw_switches), .O(switches));

    always@(mode)begin
        case(mode)
            0: // keypad mode
            begin
                note <= keypad_note;
                octave <= keypad_octave;
                input_note <= keypad_note;
                input_octave <= keypad_octave;
                octave_display <= {4'h0, keypad_octave};
            end
            1: // keyboard mode
            begin
                note <= keyboard_note;
                octave <= keyboard_octave;
                input_note <= keyboard_note;
                input_octave <= keyboard_octave;
                octave_display <= {keyboard_octave, high_keyboard_octave};
            end
            2: // auto mode
            begin
                note <= cur_note;
                octave <= cur_octave;
                input_note <= 0;
                input_octave <= 4;
                octave_display <= {4'h0, cur_octave};
            end
            3: // mute mode
            begin
                note <= 0;
                octave <= 4;
                input_note <= 0;
                input_octave <= 4;
                octave_display <= 8'h0;
            end
        endcase
    end

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
        .note(keypad_note), 
        .octave(keypad_octave)
        );

    ps2_controller ps2 (
        .clk(clk),
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data), 
        .keycode(kb_keycode), 
        .keypress(keypress)
        );

    piano_keyboard piano_keyboard (
        .clk(clk), 
        .keypress(keypress), 
        .keycode(kb_keycode), 
        .note(keyboard_note), 
        .octave(keyboard_octave)
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

    music_score_controller music_sco_control (
        .clk_1ms(clk_1ms), 
        .en(music_score_con_en),
        .rst(rst), 
        .note_pointer(note_pointer), 
        .cur_length(cur_length), 
        .cur_note(cur_note), 
        .cur_octave(cur_octave)
        );

    game_controller game_control (
        .clk(clk), 
        .keypress(ready | keypress),
        .note_pointer(note_pointer),
        .cur_note_length(cur_length),
        .keypad_octave(input_octave),
        .gp_finish(gp_finish), 
        .gp_en(gp_en), 
        .gp_opcode(gp_opcode), 
        .gp_tl_x(gp_tl_x), 
        .gp_tl_y(gp_tl_y), 
        .gp_br_x(gp_br_x), 
        .gp_br_y(gp_br_y), 
        .gp_arg(gp_arg),
        .music_score_con_en(music_score_con_en)
        );

    image_rom img_rom (
        .clka(clk), // input clka
        .addra(img_rom_addr), // input [17 : 0] addra
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

    game_statistics game_stat (
        .clk(div[25]), 
        .cur_octave(cur_octave), 
        .keypad_octave(input_octave), 
        .cur_note(cur_note), 
        .keypad_note(input_note), 
        .score(score)
        );

    bcd_encoder bcd_enc (
        .in(score),
        .out(score_bcd)
        );

    Seg7Device seg (
        .clkIO(div[3]),
        .clkScan(div[15:14]),
        .clkBlink(div[25]),
		.data({score_bcd, octave_display}),
        .point(8'h0),
        .LES(8'b00000011),
		.sout(seg_out)
        );
endmodule
