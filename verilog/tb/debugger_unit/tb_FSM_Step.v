`timescale 1ns / 1ps
module tb_FSM_Step();

    reg       clk;
    reg       rst;
    reg       is_start;
    reg       is_done_send;
    reg       is_stop_pipe;
    reg [7:0] i_rx_data;
    reg       is_rx_done;
    wire      os_step;     
    wire      os_start_send;
    wire      os_done;

    initial begin
        clk             = 0;
        rst             = 0;
        is_start        = 0;
        is_done_send    = 0;
        is_stop_pipe    = 0;
        i_rx_data       = 8'b00001111;
        is_rx_done      = 0;
        #100
        rst             = 1;

        #20 
        is_start        = 1;
        #20
        is_start        = 0;
        #500
        is_rx_done      = 1;
        #20
        is_rx_done      = 0;
        #500
        is_done_send    = 1;
        #20
        is_done_send    = 0;
        #500
        is_rx_done      = 1;
        #20
        is_rx_done      = 0;

        #500
        is_done_send    = 1;
        #20
        is_done_send    = 0;
        #500
        is_rx_done      = 1;
        #20
        is_rx_done      = 0;
                
        #500
        is_done_send    = 1;
        #20
        is_done_send    = 0;
        #500
        is_rx_done      = 1;
        #20
        is_rx_done      = 0;
        
        #500
        is_done_send    = 1;
        #20
        is_done_send    = 0;
        #500
        is_rx_done      = 1;
        #20
        is_rx_done      = 0;
        
        #500
        is_stop_pipe    = 1;
        #20
        is_stop_pipe    = 0;
    end

    always #10 clk = ~clk;

    FSM_Step u_FSM_Step(
                      .clk(clk),
                      .rst(rst),
                      .is_start(is_start),
                      .is_done_send(is_done_send),
                      .is_stop_pipe(is_stop_pipe),
                      .i_rx_data(i_rx_data),
                      .is_rx_done(is_rx_done),
                      .os_step(os_step),
                      .os_start_send(os_start_send),
                      .os_done(os_done)
                      );
endmodule