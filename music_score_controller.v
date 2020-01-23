`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:19:59 01/01/2020 
// Design Name: 
// Module Name:    music_score_controller 
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
module music_score_controller(
    input clk_1ms,
    input en,
    input rst,
    output reg [7:0] note_pointer = 0,
    output reg [15:0] cur_length = 0,
    output [3:0] cur_note,
    output [3:0] cur_octave
    );

    parameter eof = 15;

    wire [23:0] lenoc;
    wire [15:0] orig_length;

    reg init = 1;
    reg [7:0] music_score_addr = 0;

    assign orig_length = lenoc[23:8];
    assign cur_note = lenoc[7:4];
    assign cur_octave = lenoc[3:0];
    
    always@(posedge clk_1ms)begin
        if(rst)begin
            // go back to the first note
            note_pointer <= 0;
            music_score_addr <= 0;
            init <= 1;
        end
        else if(en)begin
            if (init)begin
                // load length to the counter
                cur_length <= orig_length;
                init <= 0;
            end
            else begin
                if (cur_note != eof) begin
                    if (cur_length == 2)begin
                        // pre-load the address in the ROM here to ensure the length is available in the next state
                        cur_length <= cur_length - 1;
                        music_score_addr <= music_score_addr + 1;
                    end 
                    else if (cur_length == 1)begin
                        cur_length <= orig_length;
                        // delay the change of the note pointer to avoid the invalid state
                        note_pointer <= music_score_addr;
                    end
                    else begin
                        // update counter
                        cur_length <= cur_length - 1;
                    end
                end
            end 
        end
    end

    music_score music_score (
        .a(music_score_addr), // input [7 : 0] a
        .spo(lenoc) // output [23 : 0] spo
    );
endmodule
