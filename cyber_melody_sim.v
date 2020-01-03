`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:28:44 01/02/2020
// Design Name:   cyber_melody
// Module Name:   F:/Coding/cyber_melody/cyber_melody_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cyber_melody
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cyber_melody_sim;

	// Inputs
	reg clk;
	reg rst_n;
	reg [15:0] raw_switches;
	reg [3:0] btn_col = 0;
	reg [4:0] btn_row = 0;

	// Outputs
	wire [3:0] vga_red;
	wire [3:0] vga_green;
	wire [3:0] vga_blue;
	wire vga_h_sync;
	wire vga_v_sync;
	wire buzzer;

	// Bidirs
	wire [3:0] btn_y;
	wire [4:0] btn_x;

	// Instantiate the Unit Under Test (UUT)
	cyber_melody uut (
		.clk(clk), 
		.rst_n(rst_n), 
		.btn_y(btn_y), 
		.btn_x(btn_x), 
		.raw_switches(raw_switches), 
		.vga_red(vga_red), 
		.vga_green(vga_green), 
		.vga_blue(vga_blue), 
		.vga_h_sync(vga_h_sync), 
		.vga_v_sync(vga_v_sync), 
		.buzzer(buzzer)
	);

	assign btn_y = btn_col;
	assign btn_x = btn_row;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 1;
		raw_switches = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		fork
			forever #5 clk = ~clk;
			begin
				raw_switches[0] = 1;
				raw_switches[1] = 1;
			end
		join
	end
endmodule

