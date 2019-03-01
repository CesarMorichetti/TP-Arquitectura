`timescale 1ns / 1ps
module tb_FSM_Load();

    reg           clk;
    reg           rst;
    reg           is_rx_done;
    reg  [7  : 0] i_rx_data;
    reg           is_start;
    wire [7  : 0] o_address;
    wire [31 : 0] o_instruction;
    wire          os_WriteMem;
    wire          os_done;

    initial begin
        clk         = 0;
        rst         = 0;          
        is_rx_done  = 0;
        i_rx_data   = 0;
        is_start    = 0;     

        #100
        rst         = 1;

        #200
        is_start    = 1;
        #20
        is_start    = 0;

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

    end
    always #10 clk = ~clk;

    FSM_Load u_FSM_Load(
                       .clk(clk),
                       .rst(rst),
                       .i_rx_data(i_rx_data),
                       .is_rx_done(is_rx_done),
                       .is_start(is_start),
                       .o_address(o_address),
                       .o_instruction(o_instruction),
                       .os_WriteMem(os_WriteMem),
                       .os_done(os_done)
                       );
endmodule
