`timescale 1ns / 1ps
module Top_level(
                input wire             clk,
                input wire             rst,
                input wire             i_rx_done,
                input wire             i_tx_done,
                input wire  [7 : 0]    i_data,
                output wire [7 : 0]    o_data_send,
                output wire            o_tx_start
                );

    
    wire          step;
    wire          MemWrite;
    wire [31 : 0] instruction;
    wire [7  : 0] address;
    wire [2557 : 0] bus_data_mips;
    wire          stop_signal;
    MIPS u_MIPS(
               .clk(clk), 
               .rst(rst),
               .i_step(step),
               .i_program_memory_write(MemWrite),
               .i_instruction_write(instruction),
               .i_address_write(address),
               .o_to_debug(bus_data_mips),
               .o_stop_signal(stop_signal)
               );
    debugger u_debugger(
               .rst(rst),        
               .clk(clk),
               .i_rx_done(i_rx_done),
               .i_tx_done(i_tx_done),
               .i_data(i_data),
               .is_stop_pipe(stop_signal),
               .i_data_from_mips({{2{1'b0}},bus_data_mips}),
               .o_step(step),
               .o_MemWrite(MemWrite),
               .o_instruction(instruction),
               .o_address(address),
               .o_data_send(o_data_send),
               .o_tx_start(o_tx_start)
               );
endmodule
