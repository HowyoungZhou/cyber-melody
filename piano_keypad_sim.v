`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:02:25 12/27/2019
// Design Name:   piano_keypad
// Module Name:   F:/Coding/cyber_melody/piano_keypad_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: piano_keypad
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module piano_keypad_sim;

	// Inputs
	reg clk;
	reg ready;
	reg [4:0] keycode;

	// Outputs
	wire [3:0] note;
	wire [3:0] octave;

	// Instantiate the Unit Under Test (UUT)
	piano_keypad uut (
		.clk(clk), 
		.ready(ready), 
		.keycode(keycode), 
		.note(note), 
		.octave(octave)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		ready = 0;
		keycode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		fork
			forever #10 clk <= ~clk;
			begin
				#150;
				ready = 1;
				keycode = 5;
			end
		join
	end
      
endmodule

