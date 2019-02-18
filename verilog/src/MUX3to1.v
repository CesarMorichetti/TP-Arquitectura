`timescale 1ns / 1ps
`define LEN 32
module MUX3to1
    #(parameter LEN = `LEN)
    (
	input   wire [1       : 0] i_selector,
	input   wire [LEN - 1 : 0] i_entradaMUX_0,
	input   wire [LEN - 1 : 0] i_entradaMUX_1,
    input   wire [LEN - 1 : 0] i_entradaMUX_2,
	output  wire [LEN - 1 : 0] o_salidaMUX
    );

    assign o_salidaMUX = i_selector == 2'b10 ? i_entradaMUX_2:
                         i_selector == 2'b01 ? i_entradaMUX_1:
                                               i_entradaMUX_0;
endmodule
