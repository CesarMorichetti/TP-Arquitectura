`timescale 1ns / 1ps

module tb_Stage_Execution();
    reg          rst;
    reg [4  : 0] i_rt_addr;
    reg [4  : 0] i_rd_addr;
    reg [31 : 0] i_sig_extended;
    reg [31 : 0] i_rs_reg;
    reg [31 : 0] i_rt_reg;
    reg [31 : 0] i_jump_address;
    reg [31 : 0] i_pc;
    reg [5  : 0] i_op;
    reg          is_RegDst;
    reg          is_MemRead;
    reg          is_MemWrite;
    reg          is_MemtoReg;
    reg [3  : 0] is_ALUop;
    reg          is_ALUsrc;
    reg          is_RegWrite;
    reg          is_shmat;

    wire [31 : 0] o_jump;
    wire [4  : 0] o_addr_jump;
    wire [31 : 0] o_ALU_res;
    wire [31 : 0] o_rt_reg;
    wire [4  : 0] o_addr_reg_dst;
    wire          os_zero;
    wire          os_write_jump;
    wire          os_taken;
    wire          os_RegWrite;
    wire          os_MemtoReg;
    wire          os_MemWrite;
    wire          os_MemRead;

    initial begin
        rst             = 0;
        i_rt_addr       = 0;
        i_rd_addr       = 0;
        i_sig_extended  = 0;
        i_rs_reg        = 0;
        i_rt_reg        = 0;
        i_jump_address  = 0;
        i_pc            = 0;
        i_op            = 0;
        is_RegDst       = 0;
        is_MemRead      = 0;
        is_MemWrite     = 0;
        is_MemtoReg     = 0;
        is_ALUop        = 0;
        is_ALUsrc       = 0;
        is_RegWrite     = 0;
        is_shmat        = 0;
        
        #100
        rst = 1;
        
        #10
        i_rt_addr       = 0;
        i_rd_addr       = 0;
        i_sig_extended  = 0;
        i_rs_reg        = 0;
        i_rt_reg        = 0;
        i_jump_address  = 0;
        i_pc            = 0;
        i_op            = 0;
        is_RegDst       = 0;
        is_ALUop        = 0;
        is_ALUsrc       = 0;
        is_shmat        = 0;

        //ADD 
        #10
        i_rt_addr       = 5;
        i_rd_addr       = 6;
        i_sig_extended  = 'h00000020;
        i_rs_reg        = 'h00000001;
        i_rt_reg        = 'h00000002;
        i_jump_address  = 'h00000000;
        i_pc            = 'h00000000;
        i_op            = 6'b000000;
        is_RegDst       = 0;
        is_ALUop        = 4'b0000;
        is_ALUsrc       = 0;
        is_shmat        = 0;

        //ANDI
        #10
        i_rt_addr       = 7;
        i_rd_addr       = 8;
        i_sig_extended  = 'h0000000f;
        i_rs_reg        = 'h00000003;
        i_rt_reg        = 0;
        i_jump_address  = 0;
        i_pc            = 0;
        i_op            = 0;
        is_RegDst       = 0;
        is_ALUop        = 4'b0011;
        is_ALUsrc       = 1;
        is_shmat        = 0;

        //SRA
        #10
        i_rt_addr       = 0;
        i_rd_addr       = 0;
        i_sig_extended  = 'h00000103;
        i_rs_reg        = 0;
        i_rt_reg        = 'h8000000a;
        i_jump_address  = 0;
        i_pc            = 0;
        i_op            = 0;
        is_RegDst       = 0;
        is_ALUop        = 4'b0000;
        is_ALUsrc       = 0;
        is_shmat        = 1;

        //JALR
        #10
        i_rt_addr       = 0;
        i_rd_addr       = 5'b00000;
        i_sig_extended  = 'h00000009;
        i_rs_reg        = 'h00000008;
        i_rt_reg        = 0;
        i_jump_address  = 1;
        i_pc            = 0;
        i_op            = 0;
        is_RegDst       = 0;
        is_ALUop        = 0;
        is_ALUsrc       = 0;
        is_shmat        = 0;


    end

    Stage_Execution u_Stage_Execution(
                .rst(rst),
                .i_rt_addr(i_rt_addr),
                .i_rd_addr(i_rd_addr),
                .i_sig_extended(i_sig_extended),
                .i_rs_reg(i_rs_reg),
                .i_rt_reg(i_rt_reg),
                .i_jump_address(i_jump_address),
                .i_pc(i_pc),
                .i_op(i_op),
                .is_RegDst(is_RegDst),
                .is_MemRead(is_MemRead),
                .is_MemWrite(is_MemWrite),
                .is_MemtoReg(is_MemtoReg),
                .is_ALUop(is_ALUop),
                .is_ALUsrc(is_ALUsrc),
                .is_RegWrite(is_RegWrite),
                .is_shmat(is_shmat),

                .o_jump(o_jump),
                .o_addr_jump(o_addr_jump),
                .o_ALU_res(o_ALU_res),
                .o_rt_reg(o_rt_reg ),
                .o_addr_reg_dst(o_addr_reg_dst),
                .os_zero(os_zero),
                .os_write_jump(os_write_jump),
                .os_taken(os_taken),
                .os_RegWrite(os_RegWrite),
                .os_MemtoReg(os_MemtoReg),
                .os_MemWrite(os_MemWrite),
                .os_MemRead(os_MemRead)
                                );
    endmodule





