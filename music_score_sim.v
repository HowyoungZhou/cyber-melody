`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:04:48 01/01/2020
// Design Name:   music_score
// Module Name:   F:/Coding/cyber_melody/music_score_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: music_score
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module music_score_sim;

	// Inputs
	reg [7:0] a;
	reg [15:0] length;
	reg [3:0] note;
	reg [3:0] octave;

	// Outputs
	wire [23:0] spo;

	// Instantiate the Unit Under Test (UUT)
	music_score uut (
		.a(a), 
		.spo(spo)
	);

	integer i;
	initial begin
		// Initialize Inputs
		a = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for(i = 0;i<256;i = i + 1)begin
			#20 a = i;
			{length, note, octave} = spo;
		end
	end
      
endmodule

