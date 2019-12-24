`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:29:20 12/24/2019 
// Design Name: 
// Module Name:    vga 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga(
    input vram_clk,
    input vga_clk,
    input clrn,
    input we, // VRAM write enable
    input [18:0] addr, // VRAM address
    input [11:0] data, // VRAM data
    output [3:0] r, g, b,
    output hs,
    output vs
    );

    parameter width = 640, height = 480;

    wire [11:0] vout_data;
    wire [8:0] row_addr;
    wire [9:0] col_addr;
    wire [18:0] vout_addr = col_addr * width + row_addr;
    wire rdn;

    vram ram (
        .clka(vram_clk), // input clka
        .wea(we), // input [0 : 0] wea
        .addra(addr), // input [18 : 0] addra
        .dina(data), // input [11 : 0] dina
        .clkb(vga_clk), // input clkb
        .enb(~rdn), // input enb
        .addrb(vout_addr), // input [18 : 0] addrb
        .doutb(vout_data) // output [11 : 0] doutb
        );

    vga_controller vgac (
        .vga_clk(vga_clk), 
        .clrn(clrn), 
        .d_in(vout_data), 
        .row_addr(row_addr), 
        .col_addr(col_addr), 
        .rdn(rdn), 
        .r(r), 
        .g(g), 
        .b(b), 
        .hs(hs), 
        .vs(vs)
        );
endmodule
