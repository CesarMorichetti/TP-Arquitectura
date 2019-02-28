`timescale 1ns / 1ps
module tb_MIPS();
    reg          clk;
    reg          rst;
    reg          step;
    reg          program_memory_write;
    reg [31 : 0] instruction_write;
    reg [7  : 0] address_write;

    wire [2553 : 0] o_to_debug;
    wire            o_stop_signal;

    initial begin
        clk = 0;
        rst = 0;
        program_memory_write = 0;
        instruction_write = 0;
        address_write = 0;

        
        #100
        rst  = 1;
        
        #100
        step = 1;
        /*
        #40
        step = 0;
        #100
        step = 1;
*/
        #500
        step = 0;
    end

    always #10 clk = ~clk;   
    
    MIPS u_mips(            
    .clk(clk),
    .rst(rst),
    .i_step(step),
    .i_program_memory_write(program_memory_write),
    .i_instruction_write(instruction_write),
    .i_address_write(address_write),
    .o_to_debug(o_to_debug),
    .o_stop_signal(o_stop_signal)
    );

endmodule
