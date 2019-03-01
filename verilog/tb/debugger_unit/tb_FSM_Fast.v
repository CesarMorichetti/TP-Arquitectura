`timescale 1ns / 1ps
module tb_FSM_Fast();

    reg clk;
    reg rst;
    reg is_start;
    reg is_done_send;
    reg is_stop_pipe;
    wire os_step;     
    wire os_start_send;
    wire os_done;
    wire [31 : 0] o_clk_count;     
    initial begin
        clk             = 0;
        rst             = 0;
        is_start        = 0;
        is_done_send    = 0;
        is_stop_pipe    = 0;

        #100
        rst             = 1;

        #100
        is_start        = 1;
        #20
        is_start        = 0;
        
        #200
        is_stop_pipe    = 1;
        #20
        is_stop_pipe    = 0;

        #200
        is_done_send    = 1;
        #20
        is_done_send    = 0;


    end

    always #10 clk = ~clk;

    FSM_Fast u_FSM_Fast(
                       .clk(clk),
                       .rst(rst),
                       .is_start(is_start),
                       .is_done_send(is_done_send),
                       .is_stop_pipe(is_stop_pipe),
                       .os_step(os_step),     
                       .os_start_send(os_start_send),
                       .os_done(os_done),
                       .o_clk_count(o_clk_count)
                     );
endmodule
