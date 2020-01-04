`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:42 12/28/2019 
// Design Name: 
// Module Name:    game_controller 
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
module game_controller(
    input clk,
    input repaint_clk,
    input keypress,
    input [4:0] keycode,
    input [7:0] note_pointer,
    input [15:0] cur_note_length,
    input [3:0] keypad_octave,
    input gp_finish,
    output reg gp_en = 0,
    output reg gp_opcode,
    output reg [9:0] gp_tl_x,
    output reg [8:0] gp_tl_y,
    output reg [9:0] gp_br_x,
    output reg [8:0] gp_br_y,
    output reg [11:0] gp_arg,
    output reg music_score_con_en = 0
    );

    parameter splash = 0;
    parameter erase_splash = 1;
    parameter paint_main = 2;
    parameter main = 3;
    parameter erase_main = 4;
    parameter pre_draw_cur_note = 5;
    parameter draw_cur_note = 6;
    parameter pre_draw_notes = 7;
    parameter draw_notes = 8;

    parameter length_coef = 4;
    parameter bar_height = 15;
    parameter repaint_freq = 50;

    reg [3:0] state = splash;
    reg [9:0] cur_x = 352;
    reg [7:0] cur_np;
    reg timer_en = 0;

    wire [8:0] tl_y;
    wire [8:0] br_y;
    wire [11:0] color;

    wire [23:0] lenoc;
    wire [15:0] note_length;
    wire [3:0] note;
    wire [3:0] octave;
    wire repaint_sig;

    assign note_length = lenoc[23:8];
    assign note = lenoc[7:4];
    assign octave = lenoc[3:0];

    always@(posedge clk)begin
        case(state)
            splash: if(keypress) state <= erase_splash;
            erase_splash:begin
                if (~gp_finish) begin
                    gp_opcode <= 0;
                    gp_tl_x <= 0;
                    gp_tl_y <= 0;
                    gp_br_x <= 639;
                    gp_br_y <= 479;
                    gp_arg <= 12'hFFF; // White
                    gp_en <= 1;
                end
                else begin
                    gp_en <= 0;
                    state <= paint_main;
                end
            end
            paint_main: begin
                if (~gp_finish) begin
                    gp_opcode <= 1;
                    gp_tl_x <= 0;
                    gp_tl_y <= 0;
                    gp_br_x <= 350;
                    gp_br_y <= 479;
                    gp_arg <= 0;
                    gp_en <= 1;
                end
                else begin
                    gp_en <= 0;
                    music_score_con_en <= 1;
                    state <= main;
                end
            end
            main:begin
                timer_en <= 1;
                if(repaint_sig)begin
                    state <= erase_main;
                    timer_en <= 0;
                end
            end
            erase_main:begin
                if (~gp_finish) begin
                    gp_opcode <= 0;
                    gp_tl_x <= 351;
                    gp_tl_y <= 0;
                    gp_br_x <= 639;
                    gp_br_y <= 479;
                    gp_arg <= 12'hFFF; // White
                    gp_en <= 1;
                end
                else begin
                    gp_en <= 0;
                    state <= pre_draw_cur_note;
                end
            end
            pre_draw_cur_note:begin
                cur_np <= note_pointer + 1;
                gp_opcode <= 0;
                gp_tl_x <= 351;
                gp_tl_y <= tl_y;
                gp_br_x <= (351 + cur_note_length / length_coef - 1) >= 639 ? 639 : (351 + cur_note_length / length_coef - 1);
                gp_br_y <= br_y;
                gp_arg <= color;
                gp_en <= 1;
                state <= draw_cur_note;
            end
            draw_cur_note:begin
                if(gp_finish)begin
                    gp_en <= 0;
                    state <= pre_draw_notes;
                end
            end
            pre_draw_notes:begin
                if (gp_br_x + 1 <= 639) begin
                    cur_np <= cur_np + 1;
                    gp_en <= 0;
                    gp_tl_x <= gp_br_x + 1;
                    gp_tl_y <= tl_y;
                    gp_br_x <= (gp_br_x + note_length / length_coef) >= 639 ? 639 : (gp_br_x + note_length / length_coef);
                    gp_br_y <= br_y;
                    gp_arg <= color;
                    gp_en <= 1;
                    state <= draw_notes;
                end
                else begin
                    gp_en <= 0;
                    state <= main;
                end
            end
            draw_notes:begin
                if(gp_finish)begin
                    gp_en <= 0;
                    state <= pre_draw_notes;
                end
            end
            // draw_notes:begin
            //     if (gp_finish) begin
            //         if (tl_y <= 639) begin
            //             cur_np <= cur_np + 1;
            //             gp_en <= 0;
            //             gp_tl_x <= gp_br_x + 1;
            //             gp_tl_y <= tl_y;
            //             gp_br_x <= gp_br_x + note_length;
            //             gp_br_y <= (br_y <= 639 ? br_y : 639);
            //             gp_arg <= color;
            //             gp_en <= 1;
            //             state <= draw_notes;
            //         end
            //         else begin
            //             gp_en <= 0;
            //             state <= main;
            //         end
            //     end
            // end
        endcase
    end

    music_score music_score (
        .a(state == pre_draw_cur_note ? note_pointer : cur_np), // input [7 : 0] a
        .spo(lenoc) // output [23 : 0] spo
    );

    graphics_param_lut graphics_param_lut (
        .note(note),
        .cur_octave(octave),
        .keypad_octave(keypad_octave),
        .tl_y(tl_y),
        .br_y(br_y),
        .color(color)
    );

    timer timer(
        .clk(clk),
        .en(timer_en),
        .timer(1_000_000_000 / repaint_freq),
        .timeup(repaint_sig)
    );
endmodule

module graphics_param_lut(
    input [3:0] note,
    input [3:0] cur_octave,
    input [3:0] keypad_octave,
    output reg [8:0] tl_y,
    output reg [8:0] br_y,
    output reg [11:0] color
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

    parameter white = 12'hFFF;

    parameter pink = 12'hF9C;
    parameter light_pink = 12'hFCC;
    parameter dark_pink = 12'hF6C;

    parameter yellow = 12'hFC3;
    parameter light_yellow = 12'hFF9;
    parameter dark_yellow = 12'hF93;

    parameter green = 12'h3C9;
    parameter light_green = 12'h6F9;
    parameter dark_green = 12'h396;

    parameter blue = 12'h3CF;
    parameter light_blue = 12'h3FF;
    parameter dark_blue = 12'h39F;

    always@(note)begin
        case(note)
            rest: begin
                tl_y <= 150;
                br_y <= 402 + 14;
                color <= white;
            end
            C: begin
                tl_y <= 150;
                br_y <= 150 + 14;
                color <= cur_octave == keypad_octave ? pink : (cur_octave < keypad_octave ? dark_pink : light_pink);
            end
            D: begin
                tl_y <= 150;
                br_y <= 150 + 14;
                color <= cur_octave == keypad_octave ? yellow : (cur_octave < keypad_octave ? dark_yellow : light_yellow);
            end
            E: begin
                tl_y <= 150;
                br_y <= 150 + 14;
                color <= cur_octave == keypad_octave ? green : (cur_octave < keypad_octave ? dark_green : light_green);
            end
            F: begin
                tl_y <= 150;
                br_y <= 150 + 14;
                color <= cur_octave == keypad_octave ? blue : (cur_octave < keypad_octave ? dark_blue : light_blue);
            end
            CS: begin
                tl_y <= 234;
                br_y <= 234 + 14;
                color <= cur_octave == keypad_octave ? pink : (cur_octave < keypad_octave ? dark_pink : light_pink);
            end
            DS: begin
                tl_y <= 234;
                br_y <= 234 + 14;
                color <= cur_octave == keypad_octave ? yellow : (cur_octave < keypad_octave ? dark_yellow : light_yellow);
            end
            FS: begin
                tl_y <= 234;
                br_y <= 234 + 14;
                color <= cur_octave == keypad_octave ? blue : (cur_octave < keypad_octave ? dark_blue : light_blue);
            end
            G: begin
                tl_y <= 318;
                br_y <= 318 + 14;
                color <= cur_octave == keypad_octave ? pink : (cur_octave < keypad_octave ? dark_pink : light_pink);
            end
            A: begin
                tl_y <= 318;
                br_y <= 318 + 14;
                color <= cur_octave == keypad_octave ? yellow : (cur_octave < keypad_octave ? dark_yellow : light_yellow);
            end
            B: begin
                tl_y <= 318;
                br_y <= 318 + 14;
                color <= cur_octave == keypad_octave ? green : (cur_octave < keypad_octave ? dark_green : light_green);
            end
            GS: begin
                tl_y <= 402;
                br_y <= 402 + 14;
                color <= cur_octave == keypad_octave ? pink : (cur_octave < keypad_octave ? dark_pink : light_pink);
            end
            AS: begin
                tl_y <= 402;
                br_y <= 402 + 14;
                color <= cur_octave == keypad_octave ? yellow : (cur_octave < keypad_octave ? dark_yellow : light_yellow);
            end
        endcase
    end
endmodule

module timer(
    input clk,
    input en,
    input [31:0] timer,
    output reg timeup
    );

    reg [31:0] counter = 0;

    always@(posedge clk) begin
        if (en)
            if(counter < timer) begin 
                counter <= counter + 10;
                timeup <= 0;
            end
            else begin
                timeup <= 1;
            end
        else begin
            counter <= 0;
            timeup <= 0;
        end
    end
endmodule