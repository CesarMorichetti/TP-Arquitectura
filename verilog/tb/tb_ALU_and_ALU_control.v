`timescale 1ns / 1ps
module tb_ALU_and_ALU_control();

    reg  [31 : 0] i_A;
    reg  [31 : 0] i_B;
    reg  [3  : 0] is_ALUop;
    reg  [5  : 0] i_func;  
    
    wire [31 : 0] o_res;

    wire [3 : 0]bus_operation;
    
    initial begin
        is_ALUop = 0;
        i_func  = 0;
        
        #100

        //ADD
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100000;
        i_A      = 'h00000001;
        i_B      = 'h00000005;

        //ADD
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100000;
        i_A      = 'h00000001;
        i_B      = 'h00000005;

        //SUB zero 
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100010;
        i_A      = 'h00000001;
        i_B      = 'h00000001;

        //SUB  
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100010;
        i_A      = 'h00000005;
        i_B      = 'h00000008;

        //SUB UNSIGNED
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100011;
        i_A      = 'h00000005;
        i_B      = 'h00000008;
        
        //AND
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100100;
        i_A      = 'h000000f0;
        i_B      = 'h0000000f;
        
        //OR 
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100101;
        i_A      = 'h000000f1;
        i_B      = 'h00000000;

        //XOR
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100110;
        i_A      = 'h00010010;
        i_B      = 'h01000010;

        //NOR
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100111;
        i_A      = 'h00000121;
        i_B      = 'h00000021;

        //SLT yes
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b101010;
        i_A      = 'h00000001;
        i_B      = 'h00000010;
        
        //SLT no
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b101010;
        i_A      = 'h00000101;
        i_B      = 'h00000010;
       
        //SLL
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b000000;
        i_A      = 'h00000100;//Es lo que esta en shmat desplazo 4
        i_B      = 'h0000001f;

        //SRL
        #10
        is_ALUop = 4'b0000;
        i_func  = 6'b000010;
        i_A      = 'h00000100;
        i_B      = 'h0000001f;
        
        //SRA 
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b000011;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //SLLV
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b000100;
        i_A      = 'h00000005;
        i_B      = 'h00000001;
        
        //SRLV
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b000110;
        i_A      = 'h00000003;
        i_B      = 'h00000001;
        
        //SRAV
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b000111;
        i_A      = 'h00000005;
        i_B      = 'h80000001;
        
        //DEFAULT
        #10
        is_ALUop = 4'b0000;
        i_func   = 6'b100001;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //load ostore (ADD) 
        #10
        is_ALUop = 4'b0001;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //ADDI (ADD) 
        #10
        is_ALUop = 4'b0010;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //ANDI (AND)
        #10
        is_ALUop = 4'b0011;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //ORI (OR) 
        #10
        is_ALUop = 4'b0100;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //XORI (XOR)
        #10
        is_ALUop = 4'b0101;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
        
        //SLIT yes
        #10
        is_ALUop = 4'b0110;
        i_func   = 6'b111111;
        i_A      = 'h00000001;
        i_B      = 'h0000000f;
        
        //SLIT no
        #10
        is_ALUop = 4'b0110;
        i_func   = 6'b111111;
        i_A      = 'h00000100;
        i_B      = 'h8000000f;
       
        //DEFAULT
        #10
        is_ALUop = 4'b1111;
        i_func   = 6'b111111;
        i_A      = 'h1111111;
        i_B      = 'h1111111;
    end
    
    ALU u_ALU(
             .i_A(i_A),
             .i_B(i_B),
             .i_operation(bus_operation),
             .o_res(o_res)
             );
    ALU_control u_ALU_control(
                             .is_ALUop(is_ALUop),
                             .i_func(i_func),
                             .o_operation(bus_operation)
                             );
endmodule
