`timescale 1ns / 1ps
module Top_level(
                input wire             clk,
                input wire             rst,
                input wire             i_rx_done,
                input wire  [7 : 0]    i_data,
                output wire [2553 : 0] o_output_mips,
                output wire [7 : 0]    o_data_send,
                output wire            o_tx_start
                );

    
    wire          step;
    wire          MemWrite;
    wire [31 : 0] instruction;
    wire [7  : 0] address;
    MIPS u_MIPS(
               .clk(clk), 
               .rst(rst),
               .i_step(step),
               .i_program_memory_write(MemWrite),
               .i_instruction_write(instruction),
               .i_address_write(address),
               .o_to_debug(o_output_mips)
               );
    debugger u_debugger(
               .rst(rst),        
               .clk(clk),
               .i_rx_done(i_rx_done),
               .i_data(i_data),
               .o_step(step),
               .o_MemWrite(MemWrite),
               .o_instruction(instruction),
               .o_address(address),
               .o_data_send(o_data_send),
               .o_tx_start(o_tx_start)
               );
endmodule
