`timescale 1ns / 1ps
module tb_MIPS();
    reg          clk;
    reg          rst;
    reg          step;

    wire [31 : 0] o_resultado;
    wire [4  : 0] o_direccion;

    initial begin
        clk = 0;
        rst = 0;
        
        #100
        rst  = 1;
        #100
        step = 1;
        #40
        step = 0;
        #100
        step = 1;

    end

    always #10 clk = ~clk;   
    
    MIPS u_mips(            
    .clk(clk),
    .rst(rst),
    .i_step(step),
    .o_resultado(o_resultado),
    .o_direccion(o_direccion)
    );

endmodule
