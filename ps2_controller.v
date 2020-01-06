module ps2_controller(
    input clk,
    input ps2_clk,
    input ps2_data,
    output reg [7:0] keycode,
    output reg keypress = 0
    );

    reg [3:0] state = 0, key_break = 0;
    reg [7:0] data = 0;

    reg	ps2_clk_r0 = 1'b1, ps2_clk_r1 = 1'b1; 
    reg	ps2_data_r0 = 1'b1, ps2_data_r1 = 1'b1;

    wire ps2_clk_neg = ps2_clk_r1 & (~ps2_clk_r0); 

    // sample ps2 clock and data
    always@(posedge clk) begin
        ps2_clk_r0 <= ps2_clk;
        ps2_clk_r1 <= ps2_clk_r0;
        ps2_data_r0 <= ps2_data;
        ps2_data_r1 <= ps2_data_r0;
    end
    
    always@(posedge clk)begin
        if(ps2_clk_neg) begin
            case(state)
                0: ; // start
                1: data[0] <= ps2_data_r1;
                2: data[1] <= ps2_data_r1;
                3: data[2] <= ps2_data_r1;
                4: data[3] <= ps2_data_r1;
                5: data[4] <= ps2_data_r1;
                6: data[5] <= ps2_data_r1;
                7: data[6] <= ps2_data_r1;
                8: data[7] <= ps2_data_r1;
                9: ; // parity
                10: ; // stop
            endcase

            if(state >= 4'd10) state <= 4'd0;
            else state <= state + 1'b1;
        end
    end

    always@(posedge clk) begin 
        if(state==4'd10 && ps2_clk_neg) begin 
            if(data == 8'hf0) key_break <= 1'b1; // break received
            else if(!key_break) begin 	// key pressed
                keypress <= 1'b1;
                keycode <= data; 
            end
            else begin	// key released
                keypress <= 1'b0;
                key_break <= 1'b0;
            end
        end
    end
endmodule