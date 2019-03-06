`timescale 1ns / 1ps
module debug_unit(
                 input wire rst,
                 input wire clk,
                 input wire [2557 : 0] i_data_from_pipe,
                 input wire            is_stop_pipe,
                 input wire            i_rx_bit,
                 output wire           os_step,
                 output wire [7   : 0] o_address,
                 output wire [31  : 0] o_instruction,
                 output wire           os_MemWrite,
                 output wire           o_tx_bit,
                 output wire           o_led
                 );


    wire tick; 
    wire [7 : 0] tx;
    wire         tx_start;
    wire         tx_done;
    wire [7 : 0] rx;
    wire         rx_done;
    FSM_Top u_FSM_Top(
                    .rst(rst),
                    .clk(clk),
                    .i_rx_data(rx),
                    .i_data_from_pipe(i_data_from_pipe),
                    .is_rx_done(rx_done),
                    .is_tx_done(tx_done),
                    .is_stop_pipe(is_stop_pipe),
                    .o_step(os_step),
                    .o_address(o_address),
                    .o_instruction(o_instruction),
                    .o_tx_data(tx),
                    .os_tx_start(tx_start),
                    .os_MemWrite(os_MemWrite),
                    .o_led(o_led)
                    ); 
    Tx u_tx(
            .clk(clk),
            .rst(rst),
            .tx_start(tx_start),
            .s_tick(tick),
            .input_data(tx),
            .tx_done(tx_done),
            .tx(o_tx_bit)
            );
    Rx u_rx(
            .clk(clk),
            .rst(rst),
            .rx(i_rx_bit),
            .s_tick(tick),
            .rx_done(rx_done),
            .dout(rx)
            );

    BaudRate u_baudrate(
                        .clk(clk),
                        .rst(rst),
                        .tick(tick)
                        );
endmodule
