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
    output vram_we, // VRAM write enable
    output reg [18:0] vram_addr, // VRAM address
    output [11:0] vram_data, // VRAM data
    output reg [17:0] rom_addr,
    output finish
    );

    parameter width = 640;
    parameter height = 480;

    parameter init = 0;
    parameter fill_set_addr = 1;
    parameter fill_write_ram = 2;
    parameter draw_set_addr = 3;
    parameter draw_read_rom = 4;
    parameter draw_write_ram = 5;
    parameter fin = 6;

    parameter fill = 1'b0;
    parameter draw = 1'b1;

    reg [9:0] cur_x;
    reg [8:0] cur_y;
    reg [2:0] state;

    assign finish = en && (state == fin);
    assign vram_we = state == fill_write_ram || state == draw_write_ram;
    assign vram_data = opcode == fill ? arg : rom_data;

    always@(posedge clk)begin
        if(en)begin
            case(state)
                init:begin
                    cur_x <= tl_x;
                    cur_y <= tl_y;
                    vram_addr <= tl_y * width + tl_x;
                    if(opcode == fill)begin
                        state <= fill_set_addr;
                    end
                    else begin
                        rom_addr <= {6'b0, arg};
                        state <= draw_set_addr;
                    end
                end
                fill_set_addr:begin
                    if(cur_x < br_x) begin
                        cur_x <= cur_x + 1;
                    end
                    else begin 
                        cur_x <= tl_x;
                        cur_y <= cur_y + 1;
                    end
                    state <= fill_write_ram;
                end
                fill_write_ram:begin
                    if(cur_y > br_y) begin
                        state <= fin;
                    end
                    else begin
                        vram_addr <= cur_y * width + cur_x;
                        state <= fill_set_addr;
                    end
                end
                draw_set_addr:begin
                    state <= draw_read_rom;
                    vram_addr <= cur_y * width + cur_x;
                end
                draw_read_rom:begin
                    if(cur_x < br_x) begin
                        cur_x <= cur_x + 1;
                    end
                    else begin 
                        cur_x <= tl_x;
                        cur_y <= cur_y + 1;
                    end
                    state <= draw_write_ram;
                end
                draw_write_ram:begin
                    if(cur_y > br_y) begin
                        state <= fin;
                    end
                    else begin
                        rom_addr <= rom_addr + 1;
                        state <= draw_set_addr;
                    end
                end
            endcase
        end
        else begin
            state <= init;
        end

    end
endmodule