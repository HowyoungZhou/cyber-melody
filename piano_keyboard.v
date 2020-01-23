module piano_keyboard(
    input clk,
    input keypress,
    input [7:0] keycode,
    output reg [3:0] note = 0,
    output reg [3:0] octave = 4
    );

    parameter rest = 0;
    parameter C = 1;
    parameter CS = 2;
    parameter D = 3;
    parameter DS = 4;
    parameter E = 5;
    parameter F = 6;
    parameter FS = 7;
    parameter G = 8;
    parameter GS = 9;
    parameter A = 10;
    parameter AS = 11;
    parameter B = 12;

    reg last_state = 0;
    reg [3:0] cur_octave = 4;

    wire [3:0] higher_octave  = (cur_octave == 8 ? 0 : cur_octave + 1);
    wire [3:0] lower_octave = (cur_octave == 0 ? 8 : cur_octave - 1);

    always@(posedge clk)begin
        last_state <= keypress;
        if(keypress)begin
            // keycode mapping
            case (keycode)
                8'h0D: begin note <= C; octave <= cur_octave; end
                8'h16: begin note <= CS; octave <= cur_octave; end

                8'h15: begin note <= D; octave <= cur_octave; end
                8'h1E: begin note <= DS; octave <= cur_octave; end

                8'h1D: begin note <= E; octave <= cur_octave; end
                8'h24: begin note <= F; octave <= cur_octave; end
                8'h25: begin note <= FS; octave <= cur_octave; end

                8'h2D: begin note <= G; octave <= cur_octave; end
                8'h2E: begin note <= GS; octave <= cur_octave; end
                
                8'h2C: begin note <= A; octave <= cur_octave; end
                8'h36: begin note <= AS; octave <= cur_octave; end
                8'h35: begin note <= B; octave <= cur_octave; end

                // Next octave
                8'h3C: begin note <= C; octave <= cur_octave + 1; end
                8'h3E: begin note <= CS; octave <= cur_octave + 1; end

                8'h43: begin note <= D; octave <= cur_octave + 1; end
                8'h46: begin note <= DS; octave <= cur_octave + 1; end

                8'h44: begin note <= E; octave <= cur_octave + 1; end
                8'h4D: begin note <= F; octave <= cur_octave + 1; end
                8'h4E: begin note <= FS; octave <= cur_octave + 1; end

                8'h54: begin note <= G; octave <= cur_octave + 1; end
                8'h55: begin note <= GS; octave <= cur_octave + 1; end
                
                8'h5B: begin note <= A; octave <= cur_octave + 1; end
                8'h66: begin note <= AS; octave <= cur_octave + 1; end
                8'h5D: begin note <= B; octave <= cur_octave + 1; end

                8'h5A: if (!last_state) {octave, cur_octave} <= {higher_octave, higher_octave};
                8'h59: if (!last_state) {octave, cur_octave} <= {lower_octave, lower_octave};
                default: note <= rest;
            endcase
        end
        else begin
            note <= rest;
        end
    end
endmodule