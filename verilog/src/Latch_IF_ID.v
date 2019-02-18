`timescale 1ns / 1ps

module Latch_IF_ID(
    input wire clk,
    input wire rst,
    input wire [31 : 0] i_pc,
    input wire [31 : 0] i_instruction,
    input wire          is_write_IF_ID,
    output reg [31 : 0] o_pc,
    output reg [31 : 0] o_instruction
    );
    
    always@(posedge clk)
    begin
        if(~rst)begin
            o_instruction <= 0;
            o_pc          <= 0;
        end
        else begin
            if(is_write_IF_ID)begin
                o_pc          <= i_pc;
                o_instruction <= i_instruction;
            end
        end
    end

endmodule
