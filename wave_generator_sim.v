`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:33:07 12/20/2019
// Design Name:   wave_generator
// Module Name:   F:/Coding/cyber_melody/wave_generator_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: wave_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module wave_generator_sim;

	// Inputs
	reg clk;
	reg [31:0] period;
	reg en;

	// Outputs
	wire wave;

	// Instantiate the Unit Under Test (UUT)
	wave_generator uut (
		.clk(clk), 
		.period(period), 
		.wave(wave),
		.en(en)
	);

	initial begin
		// Initialize Inputs
		en = 1;
		clk = 0;
		period = 3_822_192;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #10 clk <= ~clk;
	end
      
endmodule

