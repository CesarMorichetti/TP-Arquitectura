`timescale 1ns / 1ps
module tb_Toplevel();

    reg rst;
    reg clk;
    reg i_rx_data;
    wire o_tx_data;
    wire o_led;
    wire o_stop;

    initial begin
        clk = 0;
        rst = 0;
        i_rx_data = 0;

        #100
        rst = 1;

        //Elijo estado load
        //arranca rx
        #10
        i_rx_data = 0;
        //byte = 00000001
        #143970
        i_rx_data = 0;   
        #104640
        i_rx_data = 1;
        #91560
        i_rx_data = 0;
        #91560
        i_rx_data = 0;
        #91560
        i_rx_data = 0;
        #91560
        i_rx_data = 0;
        #91560
        i_rx_data = 0;
        #91560
        i_rx_data = 0;
        //finaliza rx
        #91560
        i_rx_data = 1;

/*
        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 0;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion HLT 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;

        //arranca rx
        #49200
        i_rx_data = 0;
        //cargo instruccion 
        #72250
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        #49200
        i_rx_data = 1;
        //finaliza rx
        #49200
        i_rx_data = 1;
        */
    end
    
    always #10 clk = ~clk;
    Top_level u_Top_level(
             .clk(clk),
             .rst(~rst),
             .i_rx_data(i_rx_data),
             .o_tx_data(o_tx_data),
             .o_led(o_led),
             .o_stop_signal(o_stop)
             );
             
endmodule
