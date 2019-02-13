`timescale 1ns / 1ps
module BRAM(
            input                clk,
            input                i_w_enable,
            input  wire [7  : 0] i_address,
            input  wire [31 : 0] i_data,
            output reg  [31 : 0] o_data
            );

    reg [31 : 0] memoria[0 : 255];

    initial begin
        $readmemb("memoria.mem", memoria);
    end
    always@(posedge clk)
        begin
            if(i_w_enable) begin
                memoria[i_address] <= i_data;
            end
    end

    always@(negedge clk)
    begin
        o_data <= memoria[i_address];
    end
endmodule
