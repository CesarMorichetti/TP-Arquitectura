`timescale 1ns / 1ps
module tb_MIPS();
    reg          clk;
    reg          rst;
    reg          step;

    wire [2553 : 0] o_to_debug;

    initial begin
        clk = 0;
        rst = 0;
        
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
    end

    always #10 clk = ~clk;   
    
    MIPS u_mips(            
    .clk(clk),
    .rst(rst),
    .i_step(step),
    .o_to_debug(o_to_debug)
    );

endmodule
