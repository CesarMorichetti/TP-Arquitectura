`timescale 1ns / 1ps
module MUX_control(
            input wire         is_selector,
            input wire         is_RegDst,
            input wire         is_MemRead,
            input wire         is_MemWrite,
            input wire         is_MemtoReg,
            input wire [3 : 0] is_ALUop,
            input wire         is_ALUsrc,
            input wire         is_RegWrite,
            input wire         is_shmat,
            input wire [2 : 0] is_load_store_type,
            output reg         os_RegDst,
            output reg         os_MemRead,
            output reg         os_MemWrite,
            output reg         os_MemtoReg,
            output reg [3 : 0] os_ALUop,
            output reg         os_ALUsrc,
            output reg         os_RegWrite,
            output reg         os_shmat,
            output reg [2 : 0] os_load_store_type
                  );
    always@(*)begin
        if(is_selector)begin
            os_RegDst           = is_RegDst;                   
            os_MemRead          = is_MemRead;
            os_MemWrite         = is_MemWrite;
            os_MemtoReg         = is_MemtoReg;
            os_ALUop            = is_ALUop;
            os_ALUsrc           = is_ALUsrc;
            os_RegWrite         = is_RegWrite;
            os_shmat            = is_shmat;
            os_load_store_type  = is_load_store_type;
        end
        else begin
            os_RegDst           = 0;                   
            os_MemRead          = 0;
            os_MemWrite         = 0;
            os_MemtoReg         = 0;
            os_ALUop            = 0;
            os_ALUsrc           = 0;
            os_RegWrite         = 0;
            os_shmat            = 0;
            os_load_store_type  = 0;
        end
    end
    
endmodule
