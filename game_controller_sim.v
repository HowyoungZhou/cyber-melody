`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:31:17 01/03/2020
// Design Name:   game_controller
// Module Name:   F:/Coding/cyber_melody/game_controller_sim.v
// Project Name:  cyber_melody
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: game_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module game_controller_sim;

	// Inputs
	reg clk;
	reg repaint_clk;
	reg keypress;
	reg [4:0] keycode;
	reg [7:0] note_pointer;
	reg [15:0] cur_note_length;
	reg gp_finish;

	// Outputs
	wire gp_en;
	wire gp_opcode;
	wire [9:0] gp_tl_x;
	wire [8:0] gp_tl_y;
	wire [9:0] gp_br_x;
	wire [8:0] gp_br_y;
	wire [11:0] gp_arg;

	// Instantiate the Unit Under Test (UUT)
	game_controller uut (
		.clk(clk), 
		.repaint_clk(repaint_clk), 
		.keypress(keypress), 
		.keycode(keycode), 
		.note_pointer(note_pointer), 
		.cur_note_length(cur_note_length), 
		.gp_finish(gp_finish), 
		.gp_en(gp_en), 
		.gp_opcode(gp_opcode), 
		.gp_tl_x(gp_tl_x), 
		.gp_tl_y(gp_tl_y), 
		.gp_br_x(gp_br_x), 
		.gp_br_y(gp_br_y), 
		.gp_arg(gp_arg)
	);

	graphics_processor gp (
		.clk(clk), 
		.en(gp_en), 
		.opcode(gp_opcode), 
		.tl_x(gp_tl_x), 
		.tl_y(gp_tl_y), 
		.br_x(gp_br_x), 
		.br_y(gp_br_y), 
		.arg(gp_arg), 
		.rom_data(rom_data), 
		.vram_we(vram_we), 
		.vram_addr(vram_addr), 
		.vram_data(vram_data), 
		.rom_addr(rom_addr), 
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

	image_rom img_rom (
        .clka(clk), // input clka
        .addra(rom_addr), // input [17 : 0] addra
        .douta(rom_data) // output [11 : 0] douta
        );

	initial begin
		// Initialize Inputs
		clk = 0;
		repaint_clk = 0;
		keypress = 0;
		keycode = 0;
		note_pointer = 0;
		cur_note_length = 0;
		gp_finish = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

