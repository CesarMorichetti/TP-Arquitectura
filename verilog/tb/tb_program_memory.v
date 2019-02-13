`timescale 1ns / 1ps

module tb_intruction_memory();
    reg clk;
    reg rst;
    reg [5:0]addr;
    wire [31:0] instruction;
    
    initial begin
        rst = 0;
        clk = 1;
        addr = 6'b000000;
        #100
        rst = 1;
        #10
        addr = 6'b000001;
        #10
        addr = 6'b000010;
        #10
        addr = 6'b000011;        
        #10
        addr = 6'b000100;        
    end
    always #1  clk = ~clk;

    instruction_memory instruction_memory(
                    .clk(clk),
                    .rst(rst),
                    .i_address(addr),
                    .o_instruction(instruction));
endmodule
