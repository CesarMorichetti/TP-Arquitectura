`timescale 1ns / 1ps
module stop_pipe(
                input wire [31 : 0] i_instruction,
                output reg          os_stop_pipe
                );

    always@(*)begin
        if(i_instruction == 'hffffffff) begin
            os_stop_pipe = 1;
        end
        else begin
            os_stop_pipe = 0;
        end
    end
endmodule