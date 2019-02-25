`timescale 1ns / 1ps
module tb_Toplevel();


    reg rst;
    reg clk;
    reg i_rx_done;
    reg [7 : 0] i_data;

    wire [2553 : 0] o_output_mips;
    wire [7    : 0] o_data_send;
    wire            o_tx_start;

    initial begin
        
        clk = 0;
        rst = 0;
        i_rx_done = 0;
        i_data = 0;

        #100
        rst = 1;
        //Elijo estado load 
        i_rx_done = 1;
        i_data = 8'b00000001;
        #20
        i_rx_done = 0;

        #100
        i_rx_done = 1;
        i_data = 8'b00000001;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b00000010;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b00000011;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b00000100;
        #20
        i_rx_done = 0;

        #100
        i_rx_done = 1;
        i_data = 8'b10000000;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b01000000;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b11000000;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b00100000;
        #20
        i_rx_done = 0;

        #100
        i_rx_done = 1;
        i_data = 8'b11111111;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b11111111;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b11111111;
        #20
        i_rx_done = 0;
        #100
        i_rx_done = 1;
        i_data = 8'b11111111;
        #20
        i_rx_done = 0;


    end

    always #10 clk = ~clk;

    Top_level u_Top_level(
             .clk(clk),
             .rst(rst),
             .i_rx_done(i_rx_done),
             .i_data(i_data),
             .o_output_mips(o_output_mips),
             .o_data_send(o_data_send),
             .o_tx_start(o_tx_start)
             );
endmodule
