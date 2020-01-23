module game_statistics(
    input clk,
    input [3:0] cur_octave,
    input [3:0] keypad_octave,
    input [3:0] cur_note,
    input [3:0] keypad_note,
    output reg [19:0] score = 0
);

    parameter rest = 0;
    parameter eof = 15;

    always@(posedge clk)begin
        // if the note and octave are correct
        if(cur_note == keypad_note && cur_octave == keypad_octave)begin
            // if the note is not rest or EOF, increase the score
            if(cur_note != rest && cur_note != eof)begin
                score <= score + 1;
            end
        end
    end

endmodule