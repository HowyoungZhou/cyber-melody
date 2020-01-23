`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:16 12/24/2019 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(
    input clk,
    output reg [31:0] div = 0,
    output reg clk_1ms = 0
    );

    reg [15:0] clk_1ms_counter = 0;

    always@(posedge clk) begin
      div <= div + 1'b1;
      // generate 1 ms clock signal
      // count to 49999
      if(clk_1ms_counter == 49_999)begin
        clk_1ms <= ~clk_1ms;
        clk_1ms_counter <= 0;
      end
      else begin
        clk_1ms_counter <= clk_1ms_counter + 1;
      end
    end

endmodule
