`timescale 1ns / 1ps

module tb_Stage_Decode();


    reg           clk;

    reg           i_RegWrite;
    reg  [4  : 0] i_addr_data;
    reg  [31 : 0] i_data; 
    reg  [31 : 0] i_pc;
    reg  [31 : 0] i_instruction;
    reg  [4  : 0] i_ID_EX_rt;
    reg           is_ID_EX_MemRead;
    

    wire [4  : 0] o_rt_addr;
    wire [4  : 0] o_rd_addr;
    wire [31 : 0] o_sig_extended;
    wire [31 : 0] o_rs_reg;
    wire [31 : 0] o_rt_reg;
    wire [31 : 0] o_pc;
    wire [31 : 0] o_jump_address;
    wire          os_RegDst;
    wire          os_MemRead;
    wire          os_MemWrite;
    wire          os_MemtoReg;
    wire [3 : 0]  os_ALUop;
    wire          os_ALUsrc;
    wire          os_RegWrite;
    wire          os_shmat;
    wire [2 : 0]  os_load_store_type;
    wire [5 : 0]  o_op;
    wire          os_pc_write;
    wire          os_write_IF_ID;
    initial begin
        clk                 = 0;
        i_RegWrite          = 0;
        i_addr_data         = 0;
        i_data              = 0; 
        i_pc                = 0;
        i_instruction       = 0;
        i_ID_EX_rt          = 0;
        is_ID_EX_MemRead    = 0;

        #100
        i_RegWrite          = 1;
        i_addr_data         = 5'b00001;
        i_data              = 7; 
        //ADD
        i_instruction       = 31'b00000000001000100010000000100000;
        //La instruccion siguiente no es un load
        i_ID_EX_rt          = 0;
        is_ID_EX_MemRead    = 0;
        
        #2
        i_RegWrite          = 0;
        i_addr_data         = 0;
        i_data              = 0; 
        //Instruccion de adelante es un load y coincide uno de los reg(rs)
        i_instruction       = 31'b00000000001000100000000000100000;
        i_ID_EX_rt          = 5'b00001;
        is_ID_EX_MemRead    = 1;
        #2
        i_RegWrite          = 0;
        i_addr_data         = 0;
        i_data              = 0; 
        //Instruccion de adelante es un load pero no coinsiden los reg 
        i_instruction       = 31'b00000000001000100000000000100000;
        i_ID_EX_rt          = 5'b00011;
        is_ID_EX_MemRead    = 1;
        #2
        i_RegWrite          = 0;
        i_addr_data         = 0;
        i_data              = 0; 
        //Instruccion de adelante es un load y coincide uno de los reg(rt)
        i_instruction       = 31'b00000000001000100000000000100000;
        i_ID_EX_rt          = 5'b00010;
        is_ID_EX_MemRead    = 1;
    end

    always #1 clk = ~ clk;
    
    Stage_Decode u_Stage_Decode(
                            .clk(clk),
                            .i_addr_data(i_addr_data),
                            .i_data(i_data), 
                            .i_RegWrite(i_RegWrite),
                            .i_pc(i_pc),
                            .i_instruction(i_instruction),
                            .i_ID_EX_rt(i_ID_EX_rt),
                            .is_ID_EX_MemRead(is_ID_EX_MemRead),
                            .o_rt_addr(o_rt_addr),
                            .o_rd_addr(o_rd_addr),
                            .o_sig_extended(o_sig_extended),
                            .o_rs_reg(o_rs_reg),
                            .o_rt_reg(o_rt_reg),
                            .o_pc(o_pc),
                            .o_jump_address(o_jump_address),
                            .os_RegDst(os_RegDst),
                            .os_MemRead(os_MemRead),
                            .os_MemWrite(os_MemWrite),
                            .os_MemtoReg(os_MemtoReg),
                            .os_ALUop(os_ALUop),
                            .os_ALUsrc(os_ALUsrc),
                            .os_RegWrite(os_RegWrite),
                            .os_shmat(os_shmat),
                            .os_load_store_type(os_load_store_type),
                            .o_op(o_op),
                            .os_pc_write(os_pc_write),
                            .os_write_IF_ID(os_write_IF_ID)
                            );
endmodule
