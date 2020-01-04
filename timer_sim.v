`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:07:59 01/04/2020
// Design Name:   timer
// Module Name:   F:/Coding/cyber_melody/timer_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: timer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module timer_sim;

	// Inputs
	reg clk;
	reg en;
	reg [31:0] timer;

	// Outputs
	wire timeup;

	// Instantiate the Unit Under Test (UUT)
	timer uut (
		.clk(clk), 
		.en(en), 
		.timer(timer), 
		.timeup(timeup)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		en = 0;
		timer = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		fork
			forever #5 clk <= ~clk;
			begin
				#105;
				timer = 2000;
				en = 1;
				#2110;
				en = 0;
				#10;
				en = 1;
			end
		join
	end
      
endmodule

