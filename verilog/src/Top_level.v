`timescale 1ns / 1ps
module Top_level(
                input wire             clk,
                input wire             rst,
                input wire  [7 : 0]    i_rx_data,
                input wire             is_rx_done,
                input wire             is_tx_done,
                output wire [7 : 0]    o_tx_data,
                output wire            os_tx_start
                //output wire [2559:0] o_test
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
    
    FSM_Top u_FSM_Top(
                     .rst(rst),
                     .clk(clk),
                     .i_rx_data(i_rx_data),      
                     .i_data_from_pipe(bus_data_mips),
                     .is_rx_done(is_rx_done),     
                     .is_tx_done(is_tx_done),     
                     .is_stop_pipe(stop_signal),   
                     .o_step(step),         
                     .o_address(address),      
                     .o_instruction(instruction),  
                     .o_tx_data(o_tx_data),       
                     .os_tx_start(os_tx_start),     
                     .os_MemWrite(MemWrite)      
                     );
    //assign o_test = {{2{1'b0}},bus_data_mips};
endmodule
