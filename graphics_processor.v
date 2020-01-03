`timescale 1ns / 1ps

module graphics_processor(
    input clk,
    input en,
    input opcode,
    input [9:0] tl_x,
    input [8:0] tl_y,
    input [9:0] br_x,
    input [8:0] br_y,
    input [11:0] arg,
    input [11:0] rom_data,
    output reg vram_we, // VRAM write enable
    output reg [18:0] vram_addr, // VRAM address
    output reg [11:0] vram_data, // VRAM data
    output reg [17:0] rom_addr,
    output reg finish = 0
    );

    parameter width = 640;
    parameter height = 480;

    parameter init = 0;
    parameter fill = 1;
    parameter draw = 2;
    parameter fin = 3;

    reg [9:0] cur_x;
    reg [8:0] cur_y;
    reg [1:0] state;
    reg [17:0] rom_pointer;

    always@(posedge clk)begin
        if(en)begin
            case(state)
                init:begin
                    cur_x <= tl_x;
                    cur_y <= tl_y;
                    rom_pointer <= {6'b0, arg};
                    state <= opcode ? draw : fill;
                    vram_we <= 0;
                end
                fill:begin
                    vram_we <= 1;
                    vram_addr <= cur_y * width + cur_x;
                    finish <= 0;
                    vram_data <= arg;
                    if(cur_x < br_x) begin
                        cur_x <= cur_x + 1;
                    end
                    else if(cur_y < br_y) begin 
                        cur_x <= tl_x;
                        cur_y <= cur_y + 1;
                    end
                    else begin
                        state <= fin;
                    end
                end
                draw:begin
                    rom_addr <= rom_pointer;
                    rom_pointer <= rom_pointer + 1;
                    vram_data <= rom_data;
                    vram_we <= 1;
                    vram_addr <= cur_y * width + cur_x;
                    finish <= 0;
                    
                    if(cur_x < br_x) begin
                        cur_x <= cur_x + 1;
                    end
                    else if(cur_y < br_y) begin 
                        cur_x <= tl_x;
                        cur_y <= cur_y + 1;
                    end
                    else begin
                        state <= fin;
                    end
                end
                fin:begin
                    finish <= 1;
                    vram_we <= 0;
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