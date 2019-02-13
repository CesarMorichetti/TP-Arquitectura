`timescale 1ns / 1ps
module tb_MIPS();
    reg          clk;
    reg          rst;
    reg          i_PC_write;

    wire [31 : 0] o_resultado;
    wire [4  : 0] o_direccion;

    initial begin
        clk = 0;
        rst = 0;
        i_PC_write = 0;

        #100
        rst        = 1;
        i_PC_write = 1; 
    end

    always #1 clk = ~clk;   
    
    MIPS u_mips(            
    .clk(clk),
    .rst(rst),
    .i_PC_write(i_PC_write),
    .o_resultado(o_resultado),
    .o_direccion(o_direccion)
    );

endmodule
