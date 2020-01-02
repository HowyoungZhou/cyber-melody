`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:47:31 01/02/2020 
// Design Name: 
// Module Name:    mux2t1_4 
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
module mux2t1_4(
    input s,
    input [3:0] in0,
    input [3:0] in1,
    output [3:0] out
    );

    assign out = s ? in1 : in0;
    
endmodule
