`timescale 1ns / 1ps
module tb_FSM_Send();

    reg             clk;
    reg             rst;
    reg [2591 : 0]  i_data_from_pipe;
    reg             is_start;
    reg             is_tx_done;
    reg  [31 :  0]  clk_counter;
    wire [7   : 0]  o_tx_data;
    wire            os_tx_start;
    wire            os_done;

    initial begin
        clk                 = 0;
        rst                 = 0;
        i_data_from_pipe    = 0;
        is_start            = 0;
        is_tx_done          = 0;
        clk_counter         = 0;
        
        #100
        rst = 1;
        #20
        i_data_from_pipe[0]     = 1;
        i_data_from_pipe[1]     = 1;
        i_data_from_pipe[2]     = 1;
        i_data_from_pipe[3]     = 1;
        i_data_from_pipe[2591]  = 1;
        clk_counter             = 'hffffffff; 
        #200
        is_start = 1;
        #20
        is_start = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;
        #100
        is_tx_done = 1;
        #20
        is_tx_done = 0;

    end

    always #10 clk = ~clk;
    
    FSM_Send u_FSM_Send(
                       .clk(clk),
                       .rst(rst),
                       .i_data_from_pipe({{2{1'b0}},
                                         clk_counter,
                                         i_data_from_pipe}),
                       .is_start(is_start),
                       .is_tx_done(is_tx_done),
                       .o_tx_data(o_tx_data),
                       .os_tx_start(os_tx_start),
                       .os_done(os_done)
                       );


endmodule
