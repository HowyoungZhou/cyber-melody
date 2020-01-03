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
    parameter paint_main = 1;
    parameter main = 2;
    parameter erase_main = 3;
    parameter repaint_main = 4;

    reg [2:0] state = splash;

    always@(posedge clk)begin
        case(state)
            splash: if(keypress) state <= paint_main;
            paint_main: begin
                if (~gp_finish) begin
                    gp_opcode <= 1;
                    gp_tl_x <= 0;
                    gp_tl_y <= 0;
                    gp_br_x <= 639;
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
                // if (repaint_clk) begin
                //     state <= repaint_main;
                // end
            end
            repaint_main:begin
                
            end
        endcase
    end
endmodule
