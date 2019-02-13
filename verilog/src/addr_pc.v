`timescale 1ns / 1ps
module adder_pc(
	input wire  [31:0] i_adder,
	output wire [31:0] o_adder
    );

	assign o_adder = i_adder + 1'b1;

endmodule
