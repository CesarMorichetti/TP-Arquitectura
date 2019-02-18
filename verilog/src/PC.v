`timescale 1ns / 1ps

module PC(
	input   wire clk,
	input   wire rst,
    input   wire i_PC_write,
	input   wire [31:0] i_PC,
	output  wire [31:0] o_PC
    );
    
    reg [31:0] PC_temp;
    
    always @(posedge clk) begin
        if (~rst)begin
            PC_temp <= 32'b00000000000000000000000000000000;  
        end
        else begin 
            if(i_PC_write) begin
                PC_temp <= i_PC;
            end
            else begin 
                PC_temp <= PC_temp;
            end
        end
    end 
    assign o_PC = PC_temp;
endmodule
