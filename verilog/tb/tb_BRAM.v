`timescale 1ns / 1ps
module tb_BRAM();

reg           clk;
reg           w_enable;
reg  [7  : 0] address;
reg  [31 : 0] i_data;
wire [31 : 0] o_data;

initial begin
    clk = 0;
    w_enable = 0;
    address = 0;
    i_data = 0;
   
    #100
    w_enable = 1;
    address = 5;
    i_data = 'h000000ff;
    #2
    w_enable = 0;
    #2
    address = 2;
    #4
    address = 50;

end

always #1 clk = ~clk;

BRAM u_BRAM (
            .clk(clk),
            .i_w_enable(w_enable),
            .i_address(address),
            .i_data(i_data),
            .o_data(o_data)
            );
            
endmodule

