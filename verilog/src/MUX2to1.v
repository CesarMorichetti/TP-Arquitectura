`timescale 1ns / 1ps
`define LEN 32
module MUX2to1
    #(parameter LEN = `LEN)
    (
	input   wire i_selector,
	input   wire [LEN - 1 : 0] i_entradaMUX_0,
	input   wire [LEN - 1 : 0] i_entradaMUX_1,
	output  wire [LEN - 1 : 0] o_salidaMUX
    );

    assign o_salidaMUX = i_selector ? i_entradaMUX_1:
                                         i_entradaMUX_0;
endmodule
