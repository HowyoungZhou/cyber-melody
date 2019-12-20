`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:27:44 12/20/2019
// Design Name:   pitch_generator
// Module Name:   F:/Coding/cyber_melody/pitch_generator_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pitch_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module pitch_generator_sim;

	// Inputs
	reg [3:0] note;
	reg [3:0] octave;
	reg clk;

	// Outputs
	wire wave;

	// Instantiate the Unit Under Test (UUT)
	pitch_generator uut (
		.note(note), 
		.octave(octave), 
		.clk(clk), 
		.wave(wave)
	);

	initial begin
		// Initialize Inputs
		note = 9;
		octave = 7;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #10 clk <= ~clk;
	end
      
endmodule

