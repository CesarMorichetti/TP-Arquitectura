`timescale 1ns / 1ps

module Latch_IF_ID(
    input wire clk,
    input wire rst,
    input wire i_step,
    input wire          is_jump_taken,//Señal que limpia si se toma un salto
    input wire [31 : 0] i_pc,
    input wire [31 : 0] i_instruction,
    input wire          is_write_IF_ID,//en caso deun load este se tiene que 
                                       //detener un ciclo
    output reg [31 : 0] o_pc,
    output reg [31 : 0] o_instruction
    );
    
    always@(posedge clk)
    begin
        if(~rst || is_jump_taken)begin
            o_instruction <= 0;
            o_pc          <= 0;
        end
        else begin
            if(is_write_IF_ID && i_step)begin
                o_pc          <= i_pc;
                o_instruction <= i_instruction;
            end
        end
    end

endmodule
