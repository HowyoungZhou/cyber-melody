`timescale 1ns / 1ps

module graphics_processor(
    input clk,
    input en,
    input [50:0] instruction,
    output reg vram_we, // VRAM write enable
    output reg [18:0] vram_addr, // VRAM address
    output reg [11:0] vram_data, // VRAM data
    output reg finish
    );

    parameter width = 640;
    parameter height = 480;

    parameter init = 0;
    parameter fill = 1;
    parameter draw = 2;
    parameter fin = 3;

    reg [9:0] x;
    reg [8:0] y;
    reg [1:0] state;
    wire opcode = instruction[50];
    wire [9:0] x1 = instruction[49:40];
    wire [8:0] y1 = instruction[39:31];
    wire [9:0] x2 = instruction[30:21];
    wire [8:0] y2 = instruction[20:12];
    wire [11:0] arg = instruction[11:0];

    always@(clk)begin
        if(en)begin
            case(state)
                init:begin
                    x <= x1;
                    y <= y1;
                    finish <= 0;
                    vram_we <= 0;
                    state <= opcode ? draw : fill;
                end
                fill:begin
                    vram_addr <= y * width + x;
                    vram_data <= arg;
                    vram_we <= 1;
                    finish <= 0;
                    if(x < x2) x <= x + 1;
                    else begin 
                        x <= x1;
                        y <= y + 1;
                    end
                    state <= y < y2 ? fin : fill;
                end
                fin:begin
                    vram_we <= 0;
                    finish <= 1;
                end
            endcase
        end
        else begin
            finish <= 0;
            vram_we <= 0;
            state <= init;
        end

    end
endmodule