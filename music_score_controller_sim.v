`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:41:38 01/01/2020
// Design Name:   music_score_controller
// Module Name:   F:/Coding/cyber_melody/music_score_controller_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: music_score_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module music_score_controller_sim;

	// Inputs
	reg clk_1ms;
	reg en;
	reg rst;

	// Outputs
	wire [7:0] note_pointer;
	wire [15:0] cur_length;
	wire [3:0] cur_note;
	wire [3:0] cur_octave;

	// Instantiate the Unit Under Test (UUT)
	music_score_controller uut (
		.clk_1ms(clk_1ms), 
		.en(en), 
		.rst(rst), 
		.note_pointer(note_pointer), 
		.cur_length(cur_length), 
		.cur_note(cur_note), 
		.cur_octave(cur_octave)
	);

	initial begin
		// Initialize Inputs
		clk_1ms = 0;
		en = 1;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		forever #50 clk_1ms <= ~clk_1ms;
	end
      
endmodule

