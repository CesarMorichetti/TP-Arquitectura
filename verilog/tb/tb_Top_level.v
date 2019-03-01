`timescale 1ns / 1ps
module tb_Toplevel();

    reg rst;
    reg clk;
    reg is_rx_done;
    reg is_tx_done;
    reg [7 : 0] i_rx_data;
    wire [7    : 0] o_tx_data;
    wire            os_tx_start;
    integer ch,numero;

    initial begin
        clk = 0;
        rst = 0;
        is_rx_done = 0;
        is_tx_done = 0;
        i_rx_data = 0;

        #100
        rst = 1;
        /*
        //Elijo estado load 
        is_rx_done = 1;
        i_rx_data  = 8'b00000001;
        #20
        is_rx_done = 0;

        #100
        is_rx_done = 1;
        i_rx_data = 8'b00000001;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b00000010;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b00000011;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b00000100;
        #20
        is_rx_done = 0;

        #100
        is_rx_done = 1;
        i_rx_data = 8'b10000000;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b01000000;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b11000000;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b00100000;
        #20
        is_rx_done = 0;

        #100
        is_rx_done = 1;
        i_rx_data = 8'b11111111;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b11111111;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b11111111;
        #20
        is_rx_done = 0;
        #100
        is_rx_done = 1;
        i_rx_data = 8'b11111111;
        #20
        is_rx_done = 0;
    */
    //Elijo estado fast 
            
            is_rx_done = 1;
            i_rx_data = 8'b00000010;
            #20
            is_rx_done = 0;
            
            

            //$fdisplay(ch, " %h ", o_data_send);
            //$fclose(ch);
            //$finish;
    end
    
    always #10 clk = ~clk;
    /*
    always@(posedge clk)begin
        if (o_tx_start == 1'b1)begin
            $displayh("cacaaaaaaaaaaaaaaaaaaa %b " , o_data_send);
        end
    end
    */
    Top_level u_Top_level(
             .clk(clk),
             .rst(rst),
             .i_rx_data(i_rx_data),
             .is_rx_done(is_rx_done),
             .is_tx_done(is_tx_done),
             .o_tx_data(o_tx_data),
             .os_tx_start(os_tx_start)
             );
             
endmodule
