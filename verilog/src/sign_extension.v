`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 06:00:58 PM
// Design Name: 
// Module Name: sign_extension
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


module sign_extension(
    input wire [15:0] i_entrada,
    output wire [31:0] o_salida
    );
    //assign o_salida = {{16{i_entrada[15]}},i_entrada};
    assign o_salida = $signed(i_entrada);
endmodule
