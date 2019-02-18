`timescale 1ns / 1ps
module tb_MUX3to1();

    reg [4 : 0] i_a;
    reg [4 : 0] i_b;
    reg [4 : 0] i_c;
    reg [1 : 0] i_selector;
    wire [4 : 0] salida;

    initial begin
        #100
        i_a = 1;
        i_b = 2;
        i_c = 3;
        i_selector = 2'b00;

        #10
        i_selector = 2'b01;
        #10
        i_selector = 2'b11;
        #10
        i_selector = 2'b10;

    end
    MUX3to1 #(.LEN(5))
        u_MUX3to1(
                 .i_selector(i_selector),
                 .i_entradaMUX_0(i_a),
                 .i_entradaMUX_1(i_b),
                 .i_entradaMUX_2(i_c),
                 .o_salidaMUX(salida)
                 );
endmodule
