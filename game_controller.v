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
    input gp_finish,
    output reg gp_en,
    output reg gp_opcode,
    output reg [9:0] gp_tl_x,
    output reg [8:0] gp_tl_y,
    output reg [9:0] gp_br_x,
    output reg [8:0] gp_br_y,
    output reg [11:0] gp_arg
    );

    parameter splash = 0;
    parameter erase_splash = 1;
    parameter paint_main = 2;
    parameter main = 3;
    parameter erase_main = 4;
    parameter draw_cur_note = 5;
    parameter draw_notes = 6;

    parameter length_coef = 4;

    reg [2:0] state = splash;

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
                    state <= main;
                end
            end
            main:begin
                state <= repaint_clk ? erase_main : main;
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
                    state <= draw_cur_note;
                end
            end
            draw_cur_note:begin
                
            end
        endcase
    end
endmodule

// module bar_y_lut()
