`timescale 1ns / 1ps

module tb_Stage_Memory();
    
    reg           clk;
    reg  [31 : 0] i_ALU_res;
    reg  [31 : 0] i_rt_reg;
    reg  [4  : 0] i_addr_reg_dst;
    reg           is_zero;
    reg           is_RegWrite;
    reg           is_MemtoReg;
    reg           is_MemWrite;
    reg           is_MemRead;
    wire [31 : 0] o_output_mem;
    wire [31 : 0] o_ALU_res;
    wire [4  : 0] o_addr_reg_dst;
    wire          os_RegWrite;
    wire          os_MemtoReg;

    initial begin
        clk             = 0;
        i_ALU_res       = 'h00000000;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00000;
        is_zero         = 0;
        is_RegWrite     = 0;
        is_MemtoReg     = 0;
        is_MemWrite     = 0;
        is_MemRead      = 0;

        #100
        //Escribo en memoria entonces ALU_res es una direccion
        i_ALU_res       = 'h00000001;
        i_rt_reg        = 'h00000002;
        i_addr_reg_dst  = 5'b10001;
        is_MemWrite     = 1;

        #10
        //Escribo en memoria entonces ALU_res es una direccion
        i_ALU_res       = 'h00000002;
        i_rt_reg        = 'h00000003;
        i_addr_reg_dst  = 5'b10101;
        is_MemWrite     = 1;

        #10
        //Escribo en memoria entonces ALU_res es una direccion
        i_ALU_res       = 'h00000003;
        i_rt_reg        = 'h00000044;
        i_addr_reg_dst  = 5'b00011;
        is_MemWrite     = 1;

        #10
        //Leo de memoria
        i_ALU_res       = 'h00000002;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;

        #10
        //Leo de memoria
        i_ALU_res       = 'h00000003;
        i_rt_reg        = 'h00000001;
        i_addr_reg_dst  = 5'b00100;
        is_MemWrite     = 0;
           
    end    
    always #1 clk = ~clk;
    
    Stage_Memory u_Stage_Memory(
                               .clk(clk),
                               .i_ALU_res(i_ALU_res), 
                               .i_rt_reg(i_rt_reg),
                               .i_addr_reg_dst(i_addr_reg_dst),
                               .is_zero(is_zero),     
                               .is_RegWrite(is_RegWrite), 
                               .is_MemtoReg(is_MemtoReg), 
                               .is_MemWrite(is_MemWrite), 
                               .is_MemRead(is_MemRead),  
                               .o_output_mem(o_output_mem), 
                               .o_ALU_res(o_ALU_res),   
                               .o_addr_reg_dst(o_addr_reg_dst), 
                               .os_RegWrite(os_RegWrite), 
                               .os_MemtoReg(os_MemtoReg)  
                              );
endmodule
    

