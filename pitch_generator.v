`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:07:39 12/20/2019 
// Design Name: 
// Module Name:    pitch_generator 
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
module pitch_generator(
    input [3:0] note,
    input [3:0] octave,
    input clk,
    output wave
    );

    wire [7:0] period_addr = (note - 1) * 10 + octave;
    wire [31:0] period;
    wire en;

    assign en = note == 0;

    pitch_period_table pitch_period_table_rom (
        .a(period_addr), // input [7 : 0] a
        .spo(period) // output [31 : 0] spo
    );

    wave_generator wave_gen (
        .clk(clk),
        .en(en),
        .period(period),
        .wave(wave)
    );
endmodule
