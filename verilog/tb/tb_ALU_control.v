`timescale 1ns / 1ps
module tb_ALU_control();

    reg  [3 : 0] ALUop;
    reg  [5 : 0] func;
    wire [3 : 0] operation;

    initial begin
        
        ALUop = 0;
        func  = 0;
        
        #100
        //R-Type
        #10//ADD
        ALUop = 4'b0000;
        func  = 6'b100000;
        #10//SUB
        ALUop = 4'b0000;
        func  = 6'b100010;
        #10//AND
        ALUop = 4'b0000;
        func  = 6'b100100;
        #10//OR
        ALUop = 4'b0000;
        func  = 6'b100101;
        #10//XOR
        ALUop = 4'b0000;
        func  = 6'b100110;
        #10//NOR
        ALUop = 4'b0000;
        func  = 6'b100111;
        #10//SLT
        ALUop = 4'b0000;
        func  = 6'b101010;
        #10//SLL
        ALUop = 4'b0000;
        func  = 6'b000000;
        #10//SRL
        ALUop = 4'b0000;
        func  = 6'b000010;
        #10//SRA
        ALUop = 4'b0000;
        func  = 6'b000011;
        #10//SLLV
        ALUop = 4'b0000;
        func  = 6'b000100;
        #10//SRLV
        ALUop = 4'b0000;
        func  = 6'b000110;
        #10//SRAV
        ALUop = 4'b0000;
        func  = 6'b000111;
        #10//ADDU
        ALUop = 4'b0000;
        func  = 6'b100001;
        #10//SUBU
        ALUop = 4'b0000;
        func  = 6'b100011;
        #10//DEF
        ALUop = 4'b0000;
        func  = 6'b111111;
        
        //INMEDIATE
        #10//LOAD o STORE
        ALUop = 4'b0001;
        func  = 6'b111111;
        
        #10//ADDI
        ALUop = 4'b1000;
        func  = 6'b111111;
        #10//ANDI
        ALUop = 4'b1100;
        func  = 6'b111111;
        #10//ORI
        ALUop = 4'b1101;
        func  = 6'b111111;
        #10//XORI
        ALUop = 4'b1110;
        func  = 6'b111111;
        #10//LUI
        ALUop = 4'b1111;
        func  = 6'b111111;
        #10//SLTI
        ALUop = 4'b1010;
        func  = 6'b111111;
        #10//DEF
        ALUop = 4'b1000;
        func  = 6'b111111;
    end

    ALU_control u_ALU_control(
                            .is_ALUop(ALUop),
                            .i_func(func),
                            .o_operation(operation)
                            );
endmodule
