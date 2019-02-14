`timescale 1ns / 1ps

module tb_Stage_Memory();
    
    reg           clk;
    reg  [31 : 0] i_ALU_res;
    reg  [31 : 0] i_rt_reg;
    reg  [4  : 0] i_addr_reg_dst;
    reg  [31 : 0] i_pc_to_reg;
    reg           is_write_pc;
    reg           is_select_addr_reg;
    reg           is_RegWrite;
    reg           is_MemtoReg;
    reg           is_MemWrite;
    reg           is_MemRead;
    reg  [2  : 0] is_load_store_type;
    wire [31 : 0] o_output_mem;
    wire [31 : 0] o_ALU_res;
    wire [4  : 0] o_addr_reg_dst;
    wire [31 : 0] o_pc_to_reg;
    wire          os_select_addr_reg;
    wire          os_write_pc;
    wire          os_RegWrite;
    wire          os_MemtoReg;

    initial begin
        clk             = 0;
        i_ALU_res       = 'h00000000;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00000;
        i_pc_to_reg     = 0;
        is_write_pc     = 0;
        is_select_addr_reg= 0;
        is_RegWrite     = 0;
        is_MemtoReg     = 0;
        is_MemWrite     = 0;
        is_MemRead      = 0;
        is_load_store_type = 0;

        #100
        //Escribo en memoria entonces ALU_res es una direccion
        //instruccion SB con signo
        i_ALU_res       = 'h00000001;
        i_rt_reg        = 'h00000082;
        i_addr_reg_dst  = 5'b10001;
        is_MemWrite     = 1;
        is_load_store_type = 3'b000;
        
        #10
        //Escribo en memoria entonces ALU_res es una direccion
        //instruccion SB sin signo
        i_ALU_res       = 'h00000002;
        i_rt_reg        = 'h00000012;
        i_addr_reg_dst  = 5'b10001;
        is_MemWrite     = 1;
        is_load_store_type = 3'b000;

        #10
        //Escribo en memoria entonces ALU_res es una direccion
        //instruccion SH con signo
        i_ALU_res       = 'h00000003;
        i_rt_reg        = 'h00008003;
        i_addr_reg_dst  = 5'b10101;
        is_MemWrite     = 1;
        is_load_store_type = 3'b001;

        #10
        //Escribo en memoria entonces ALU_res es una direccion
        //instruccion SH sin signo
        i_ALU_res       = 'h00000004;
        i_rt_reg        = 'h00000003;
        i_addr_reg_dst  = 5'b10101;
        is_MemWrite     = 1;
        is_load_store_type = 3'b001;

        #10
        //Escribo en memoria entonces ALU_res es una direccion
        //instruccio SW
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00008084;
        i_addr_reg_dst  = 5'b00011;
        is_MemWrite     = 1;
        is_load_store_type = 3'b011;

        #10
        //Leo de memoria
        //instruccion LB
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b000;

           
        #10
        //Leo de memoria
        //instruccion LBU
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b100;

        #10
        //Leo de memoria
        //instruccion LH
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b001;

        #10
        //Leo de memoria
        //instruccion LHU
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b101;

        #10
        //Leo de memoria
        //instruccion LW
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b011;

        #10
        //Leo de memoria
        //instruction LWU
        i_ALU_res       = 'h00000005;
        i_rt_reg        = 'h00000000;
        i_addr_reg_dst  = 5'b00010;
        is_MemWrite     = 0;
        is_load_store_type = 3'b111;


    end    
    always #1 clk = ~clk;
    
    Stage_Memory u_Stage_Memory(
                               .clk(clk),
                               .i_ALU_res(i_ALU_res), 
                               .i_rt_reg(i_rt_reg),
                               .i_addr_reg_dst(i_addr_reg_dst),
                               .i_pc_to_reg(i_pc_to_reg),
                               .is_write_pc(is_write_pc),
                               .is_select_addr_reg(is_select_addr_reg),
                               .is_RegWrite(is_RegWrite), 
                               .is_MemtoReg(is_MemtoReg), 
                               .is_MemWrite(is_MemWrite), 
                               .is_MemRead(is_MemRead),
                               .is_load_store_type(is_load_store_type),  
                               .o_output_mem(o_output_mem), 
                               .o_ALU_res(o_ALU_res),   
                               .o_addr_reg_dst(o_addr_reg_dst),
                               .o_pc_to_reg(o_pc_to_reg),
                               .os_select_addr_reg(os_select_addr_reg),
                               .os_write_pc(os_write_pc), 
                               .os_RegWrite(os_RegWrite), 
                               .os_MemtoReg(os_MemtoReg)  
                              );
endmodule
    

