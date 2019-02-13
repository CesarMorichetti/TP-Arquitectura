`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2018 06:32:07 PM
// Design Name: 
// Module Name: ADD_PC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder(
	input wire  [31:0] i_adder_a,
	input wire  [31:0] i_adder_b,
	output wire [31:0] o_adder
    );

	assign o_adder = i_adder_a + i_adder_b;

endmodule
