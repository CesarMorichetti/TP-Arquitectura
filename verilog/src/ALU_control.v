`timescale 1ns / 1ps
module ALU_control(
                input wire [3 : 0] is_ALUop,
                input wire [5 : 0] i_func,
                output reg [3 : 0] o_operation  
                 );
    //Operaciones para la ALU
    parameter [3 : 0] ADD  = 4'b0000;  
    parameter [3 : 0] SUB  = 4'b0001;  
    parameter [3 : 0] AND  = 4'b0010;  
    parameter [3 : 0] OR   = 4'b0011;  
    parameter [3 : 0] XOR  = 4'b0100;  
    parameter [3 : 0] NOR  = 4'b0101;  
    parameter [3 : 0] SLT  = 4'b0110;  
    parameter [3 : 0] SLL  = 4'b0111;  
    parameter [3 : 0] SRL  = 4'b1000;  
    parameter [3 : 0] SRA  = 4'b1001;  
    parameter [3 : 0] SLLV = 4'b1010;  
    parameter [3 : 0] SRLV = 4'b1011;  
    parameter [3 : 0] SRAV = 4'b1100;  
    parameter [3 : 0] LUI  = 4'b1101;

    always@(*)begin
        case(is_ALUop)
            //Es de tipo R-ver el campo funct           
            4'b0000:begin
                case(i_func)
                    6'b100000: o_operation = ADD; 
                    6'b100010: o_operation = SUB;
                    6'b100100: o_operation = AND;
                    6'b100101: o_operation = OR;
                    6'b100110: o_operation = XOR;
                    6'b100111: o_operation = NOR;
                    6'b101010: o_operation = SLT;
                    6'b000000: o_operation = SLL;
                    6'b000010: o_operation = SRL;
                    6'b000011: o_operation = SRA;
                    6'b000100: o_operation = SLLV;
                    6'b000110: o_operation = SRLV;
                    6'b000111: o_operation = SRAV;
                    6'b100001: o_operation = ADD;
                    6'b100011: o_operation = SUB;
                    default: o_operation = 4'b0000;
                endcase
            end
            //es load o store entonces suma
            4'b0001: o_operation = ADD;
            //ADDI
            4'b1000: o_operation = ADD;               
            //ANDI
            4'b1100: o_operation = AND;
            //ORI
            4'b1101: o_operation = OR;
            //XORI 
            4'b1110: o_operation = XOR;
            //SLTI
            4'b1010: o_operation = SLT;
            4'b1111: o_operation = LUI;
            default: o_operation = 4'b0000;
        endcase
    end
endmodule
