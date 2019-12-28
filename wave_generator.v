`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:55 12/20/2019 
// Design Name: 
// Module Name:    wave_generator 
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
module wave_generator(
    input clk,
    input en,
    input [31:0] period,
    output wave
    );

    parameter clk_period = 20;

    reg [31:0] counter = 0;

    assign wave = counter > period / 2;

    always@(posedge clk)begin
        if (en) begin
            counter <= counter + clk_period;
            if(counter >= period) counter <= 0;
        end
        else begin
            counter <= 0;
        end
    end
endmodule
