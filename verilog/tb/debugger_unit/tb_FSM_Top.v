`timescale 1ns / 1ps
module tb_FSM_Top();
    reg             rst;
    reg             clk;
    reg  [7    : 0] i_rx_data;       
    reg  [2559 : 0] i_data_from_pipe;
    reg             is_rx_done;      
    reg             is_tx_done;      
    reg             is_stop_pipe; 
    reg [31 : 0]    clk_counter;
    wire            o_step;          
    wire [7    : 0] o_address;       
    wire [31   : 0] o_instruction;   
    wire [7    : 0] o_tx_data;       
    wire            os_tx_start;     
    wire            os_MemWrite;     

    initial begin
        rst              = 0;
        clk              = 0;
        i_rx_data        = 0;       
        i_data_from_pipe = 0;
        is_rx_done       = 0;      
        is_tx_done       = 0;      
        is_stop_pipe     = 0;    
        #100
        rst              = 1;
        #20
        i_data_from_pipe[0]     = 1;
        i_data_from_pipe[1]     = 1;
        i_data_from_pipe[2]     = 1;
        i_data_from_pipe[3]     = 1;
        i_data_from_pipe[2591]  = 1;
        clk_counter             = 'hffffffff; 
        /*
        #100
        is_rx_done       = 1;
        i_rx_data        = 1;
        #20
        is_rx_done       = 0;
        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b00000000;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b00000000;
        #20
        is_rx_done  = 0;

        #1000
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;

        #200
        is_rx_done  = 1;
        i_rx_data   = 8'b11111111;
        #20
        is_rx_done  = 0;
        */
        #100
        is_rx_done       = 1;
        i_rx_data        = 2;
        #20
        is_rx_done       = 0;
        
        #300
        is_stop_pipe  = 1;
        #20
        is_stop_pipe = 0;
        
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

    FSM_Top u_FSM_Top(
                     .rst(rst),
                     .clk(clk),
                     .i_rx_data(i_rx_data),      
                     .i_data_from_pipe(i_data_from_pipe),
                     .is_rx_done(is_rx_done),     
                     .is_tx_done(is_tx_done),     
                     .is_stop_pipe(is_stop_pipe),   
                     .o_step(o_step),         
                     .o_address(o_address),      
                     .o_instruction(o_instruction),  
                     .o_tx_data(o_tx_data),       
                     .os_tx_start(os_tx_start),     
                     .os_MemWrite(os_MemWrite)
                     );

endmodule
