`timescale 1ns / 1ps

module ALU(
    input wire  [31 : 0] i_A,
    input wire  [31 : 0] i_B,
    input wire  [3  : 0] i_operation,
    //output wire          o_zero,
    output reg  [31 : 0] o_res

    );
    
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
    parameter [3 : 0] ADDU = 4'b1101;  
    parameter [3 : 0] SUBU = 4'b1110;  
    parameter [3 : 0] LUI  = 4'b1111;//default  
   
    
    always @(*) begin
        case(i_operation)
            ADD:  o_res <= $signed(i_A) + $signed(i_B);
            SUB:  o_res <= $signed(i_A) - $signed(i_B);
            AND:  o_res <= i_A & i_B;
            OR :  o_res <= i_A | i_B;
            XOR:  o_res <= i_A ^ i_B;
            NOR:  o_res <= ~(i_A | i_B);
            SLT:  o_res <= {32{$signed(i_A)<$signed(i_B)}};
            SLL:  o_res <= i_B << i_A[10 -: 5];
            SRL:  o_res <= i_B >> i_A[10 -: 5];
            SRA:  o_res <= $signed(i_B) >>> i_A[10 -: 5];
            SLLV: o_res <= i_B << i_A;
            SRLV: o_res <= i_B >> i_A;
            SRAV: o_res <= $signed(i_B) >>> i_A;
            ADDU: o_res <= i_A + i_B;
            SUBU: o_res <= i_A - i_B;
            LUI:  o_res <= {i_B[15 : 0], 16'b0000000000000000};
        endcase
    end
    //assign o_zero = result == 0 ? 1: 0;
    
endmodule

