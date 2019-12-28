`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:58:23 12/28/2019
// Design Name:   graphics_processor
// Module Name:   F:/Coding/cyber_melody/graphics_processor_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: graphics_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module graphics_processor_sim;

	// Inputs
	reg clk;
	reg en;
	reg opcode;
	reg [9:0] tl_x;
	reg [8:0] tl_y;
	reg [9:0] br_x;
	reg [8:0] br_y;
	reg [11:0] arg;
	reg [18:0] rom_addr;
	reg [11:0] rom_data;

	// Outputs
	wire vram_we;
	wire [18:0] vram_addr;
	wire [11:0] vram_data;
	wire finish;

	// Instantiate the Unit Under Test (UUT)
	graphics_processor uut (
		.clk(clk), 
		.en(en), 
		.opcode(opcode), 
		.tl_x(tl_x), 
		.tl_y(tl_y), 
		.br_x(br_x), 
		.br_y(br_y), 
		.arg(arg), 
		.rom_addr(rom_addr), 
		.rom_data(rom_data), 
		.vram_we(vram_we), 
		.vram_addr(vram_addr), 
		.vram_data(vram_data), 
		.finish(finish)
	);

    vram ram (
        .clka(clk), // input clka
        .wea(vram_we), // input [0 : 0] wea
        .addra(vram_addr), // input [18 : 0] addra
        .dina(vram_data), // input [11 : 0] dina
        .clkb(clk), // input clkb
        .addrb(), // input [18 : 0] addrb
        .doutb() // output [11 : 0] doutb
        );

	initial begin
		// Initialize Inputs
		clk = 0;
		en = 0;
		opcode = 0;
		tl_x = 0;
		tl_y = 0;
		br_x = 0;
		br_y = 0;
		arg = 0;
		rom_addr = 0;
		rom_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		fork
			forever #10 clk <= ~clk;
			begin
				opcode = 0;
				tl_x = 0;
				tl_y = 0;
				br_x = 639;
				br_y = 479;
				arg = 12'h555;
				rom_addr = 0;
				rom_data = 0;
				#100
				en = 1;
				#3100000
				en = 0;
				#100
				opcode = 1;
				en = 1;
			end
		join
	end
      
endmodule

