`timescale 1ns / 1ps
module tb_MIPS();
    reg          clk;
    reg          rst;

    wire [31 : 0] o_resultado;
    wire [4  : 0] o_direccion;

    initial begin
        clk = 0;
        rst = 0;

        #101
        rst        = 1;
    end

    always #10 clk = ~clk;   
    
    MIPS u_mips(            
    .clk(clk),
    .rst(rst),
    .o_resultado(o_resultado),
    .o_direccion(o_direccion)
    );

endmodule
