`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:56:31 01/07/2020
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
	reg ps2_clk;
	reg ps2_data;
	reg [3:0] btn_col = 4'b1111;
	reg [4:0] btn_row = 5'b11111;

	// Outputs
	wire [3:0] vga_red;
	wire [3:0] vga_green;
	wire [3:0] vga_blue;
	wire vga_h_sync;
	wire vga_v_sync;
	wire buzzer;
	wire seg_clk;
	wire seg_do;
	wire seg_pen;
	wire seg_clr;

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
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.vga_red(vga_red), 
		.vga_green(vga_green), 
		.vga_blue(vga_blue), 
		.vga_h_sync(vga_h_sync), 
		.vga_v_sync(vga_v_sync), 
		.buzzer(buzzer), 
		.seg_clk(seg_clk), 
		.seg_do(seg_do), 
		.seg_pen(seg_pen), 
		.seg_clr(seg_clr)
	);

	assign btn_y = btn_col;
	assign btn_x = btn_row;

	initial begin
		// Initialize Inputs
		clk = 0;
		rst_n = 0;
		raw_switches = 0;
		ps2_clk = 0;
		ps2_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		fork
			forever #1 clk = ~clk;
			begin
				#2000;
				btn_row = 5'b11101;
				btn_col = 4'b1110;
				// #2000;
				// btn_row = 5'b11111;
				// btn_col = 4'b1111;
			end
		join
	end
      
endmodule

