`timescale 1ns / 1ps

module tb_ALU();

    reg           rst;
    reg  [31 : 0] i_A;
    reg  [31 : 0] i_B;
    reg  [3  : 0] i_operation;
   
    wire          o_zero;
    wire [31 : 0] o_res;

    initial begin
        rst         = 0;
        i_A         = 0;
        i_B         = 0;
        i_operation = 0;
    
        #100
        rst = 1;
       
        //ADD
        #10
        i_A         = 'h00000001;
        i_B         = 'h00000005;
        i_operation = 4'b0000;
        
        //SUB Zero
        #10
        i_A         = 'h00000001;
        i_B         = 'h00000001;
        i_operation = 4'b0001;
        
        //SUB 
        #10
        i_A         = 'h00000005;
        i_B         = 'h00000008;
        i_operation = 4'b0001;
        
        //AND 
        #10
        i_A         = 'h000000f0;
        i_B         = 'h0000000f;
        i_operation = 4'b0010;
        
        //OR 
        #10
        i_A         = 'h000000f1;
        i_B         = 'h00000000;
        i_operation = 4'b0011;
        
        //XOR 
        #10
        i_A         = 'h00010010;
        i_B         = 'h01000010;
        i_operation = 4'b0100;
        
        //NOR 
        #10
        i_A         = 'h00000121;
        i_B         = 'h00000021;
        i_operation = 4'b0101;
        
        //SLT yes 
        #10
        i_A         = 'h00000001;
        i_B         = 'h00000010;
        i_operation = 4'b0110;
        
        //SLT no 
        #10
        i_A         = 'h00000101;
        i_B         = 'h00000010;
        i_operation = 4'b0110;
        
        //SLL 
        #10
        i_A         = 'h00000100;//Es lo que esta en shmat desplazo 4
        i_B         = 'h0000001f;
        i_operation = 4'b0111;
        
        //SRL 
        #10
        i_A         = 'h00000100;
        i_B         = 'h0000001f;
        i_operation = 4'b1000;
        
        //SRA 
        #10
        i_A         = 'h00000100;
        i_B         = 'h8000000f;
        i_operation = 4'b1001;
        
        //SLLV 
        #10
        i_A         = 'h00000005;
        i_B         = 'h00000001;
        i_operation = 4'b1010;
        
        //SRLV 
        #10
        i_A         = 'h00000003;
        i_B         = 'h00000001;
        i_operation = 4'b1011;
        
        //SRAV
        #10
        i_A         = 'h00000005;
        i_B         = 'h80000001;
        i_operation = 4'b1100;
        
        //LUI 
        #10
        i_A         = 'h00000000;
        i_B         = 'h00001001;
        i_operation = 4'b1101;

        //DEFAULT 
        #10
        i_A         = 'h00000000;
        i_B         = 'h00001001;
        i_operation = 4'b1111;
    end

    ALU u_ALU(
             .rst(rst),
             .i_A(i_A),
             .i_B(i_B),
             .i_operation(i_operation),
             .o_zero(o_zero),
             .o_res(o_res)
             );
endmodule
