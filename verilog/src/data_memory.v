`timescale 1ns / 1ps

module data_memory(
    // INPUTS
    input wire clk,
    input wire rst,
    input wire [31:0] i_address,    //Entrada proveniente del latch 3 EX/MEM
    input wire [31:0] i_write_data, //Entrada proveniente del latch 3 EX/MEM
    // Control MEM
    input wire i_MemRead,
    input wire i_MemWrite,
    
    // OUTPUTS
    output reg [31:0] o_read_data, //Entrada proveniente del latch 3 EX/
    );
    
	parameter DATA_BITS = 32;
	parameter ADDR_BITS = 32;
	
	//-- Memoria
    reg [DATA_BITS-1:0] ram [0:31];	// Memoria de 2K. 
	integer i;
	
	//Escritura
	always@(posedge clk)
	   if(~rst) begin
	       for(i = 0; i<32; i=i+1)
               ram[i] <= i; 
	       end    
	   else 
           if(in_MemWrite) begin
               ram[i_address] <= i_write_data; 	     // Escribe el dato entrante en la RAM.
           end
        
    //Lectura
    always @(negedge clk)    
       if(i_MemRead) begin
           o_read_data <= ram[i_address];         // Lee la RAM y envia el dato a la salida.       
       end
endmodule
