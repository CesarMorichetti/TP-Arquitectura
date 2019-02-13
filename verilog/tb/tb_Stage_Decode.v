`timescale 1ns / 1ps

module tb_Stage_Decode();


    reg           clk;
    reg           rst;
    reg           RegWrite;
    reg  [4  : 0] addr_data;
    reg  [31 : 0] data; 
    reg  [31 : 0] i_pc;
    reg  [31 : 0] instruction;
    reg           write_jump;
    reg  [4  : 0] addr_jump;
    reg  [31 : 0] jump;
    

    wire [4  : 0] rt_addr;
    wire [4  : 0] rd_addr;
    wire [31 : 0] sig_extended;
    wire [31 : 0] rs_reg;
    wire [31 : 0] rt_reg;
    wire [31 : 0] o_pc;
    wire [31 : 0] jump_address;
    wire          os_RegDst;
    //wire          os_jump;
    //wire          os_Branch;
    wire          os_MemRead;
    wire          os_MemWrite;
    wire          os_MemtoReg;
    wire [3 : 0]  os_ALUop;
    wire          os_ALUsrc;
    wire          os_RegWrite;
    wire          os_shmat;
    wire [5 : 0]  o_op;
    initial begin
        clk         = 0;
        rst         = 0;
        RegWrite    = 0;
        addr_data   = 0;
        data        = 0; 
        i_pc        = 0;
        instruction = 0;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;
        #100
        rst = 1;
        
        #10
        RegWrite = 1;
        addr_data = 0;
        data = 'h00000001;
        i_pc = 'h00000000;
        instruction = 'h00000000;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;

        #2
        RegWrite = 1;
        addr_data = 1;
        data = 'h00000002;
        i_pc = 'h00000000;
        instruction = 'h00000000;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;

        #2
        RegWrite = 1;
        addr_data = 2;
        data = 'h00000003;
        i_pc = 'h00000000;
        instruction = 'h00000000;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;
        
        #2
        RegWrite = 1;
        addr_data = 3;
        data = 'h00000004;
        i_pc = 'h00000000;
        instruction = 'h00000000;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;
        
        #10
        RegWrite = 0;          
        addr_data = 5;
        data = 'h00000008; 
        i_pc = 'h0000000a;
        instruction = 'h00221820;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;
        
        #2
        RegWrite = 0;
        addr_data = 6;
        data = 'h0000000f;
        i_pc = 'h00000005;
        instruction = 'h80220000;
        addr_jump   = 0;
        jump        = 0;
        write_jump  = 0;
        
        #2
        RegWrite = 0;
        addr_data = 6;
        data = 'h0000000f;
        i_pc = 'h00000005;
        instruction = 'h80220000;
        addr_jump   = 9;
        jump        = 'hffffffff;
        write_jump  = 1;
    end

    always #1 clk = ~ clk;
    
    Stage_Decode u_Stage_Decode(
                            .clk(clk),
                            .rst(rst),
                            .i_addr_data(addr_data),
                            .i_data(data), 
                            .i_RegWrite(RegWrite),
                            .i_pc(i_pc),
                            .i_instruction(instruction),
                            .i_addr_jump(addr_jump),
                            .i_jump(jump),
                            .i_write_jump(write_jump),
                            .o_rt_addr(rt_addr),
                            .o_rd_addr(rd_addr),
                            .o_sig_extended(sig_extended),
                            .o_rs_reg(rs_reg),
                            .o_rt_reg(rt_reg),
                            .o_pc(o_pc),
                            .o_jump_address(jump_address),
                            .os_RegDst(os_RegDst),
                            //.os_jump(os_jump),
                            //.os_Branch(os_Branch),
                            .os_MemRead(os_MemRead),
                            .os_MemWrite(os_MemWrite),
                            .os_MemtoReg(os_MemtoReg),
                            .os_ALUop(os_ALUop),
                            .os_ALUsrc(os_ALUsrc),
                            .os_RegWrite(os_RegWrite),
                            .os_shmat(os_shmat),
                            .o_op(o_op)
                            );
endmodule
