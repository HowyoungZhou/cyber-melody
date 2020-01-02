`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:59:26 01/02/2020
// Design Name:   clk_div
// Module Name:   F:/Coding/cyber_melody/clk_div_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clk_div_sim;

	// Inputs
	reg clk;
	wire clk_div;
	wire clk_1ms;

	// Instantiate the Unit Under Test (UUT)
	clk_div uut (
		.clk(clk),
		.div(clk_div),
		.clk_1ms(clk_1ms)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #5 clk <= ~clk;
	end
      
endmodule

