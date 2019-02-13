`timescale 1ns / 1ps
module tb_branch_unit();

    reg rst;
    reg [5  : 0] i_op;
    reg [31 : 0] i_sign_ext;
    reg [31 : 0] i_jump_address;
    reg [31 : 0] i_pc;
    reg [31 : 0] i_rs_reg;
    reg [31 : 0] i_rt_reg;
    reg [4  : 0] i_rd_address;

    wire os_taken;
    wire os_write_jump;
    wire [31 : 0] o_jump_address;
    wire [4 : 0] o_reg_jump_address;
    
    initial begin
        rst             = 0;
        i_op            = 0;
        i_sign_ext      = 0;
        i_jump_address  = 0;
        i_pc            = 0;
        i_rs_reg        = 0;
        i_rt_reg        = 0;
        i_rd_address    = 0;

        #100
        rst = 1;
        #10
        //JR
        i_op            = 6'b000000;
        i_sign_ext      = 'h00000008;
        i_jump_address  = 'h00000001;
        i_pc            = 'h00000001;
        i_rs_reg        = 'h00000001;
        i_rt_reg        = 'h00000001;
        i_rd_address    = 5'b00001;
        #2
        //JALR
        i_op            = 6'b000000;
        i_sign_ext      = 'h00000009;
        i_jump_address  = 'h00000002;
        i_pc            = 'h00000002;
        i_rs_reg        = 'h00000002;
        i_rt_reg        = 'h00000002;
        i_rd_address    = 5'b00010;
        #2
        //6'b000000 default
        i_op            = 6'b000000;
        i_sign_ext      = 'h00000018;
        i_jump_address  = 'h00000003;
        i_pc            = 'h00000003;
        i_rs_reg        = 'h00000003;
        i_rt_reg        = 'h00000003;
        i_rd_address    = 5'b00011;
        #2
        //BEQ taken
        i_op            = 6'b000100;
        i_sign_ext      = 'h00000004;
        i_jump_address  = 'h00000004;
        i_pc            = 'h00000004;
        i_rs_reg        = 'h00000004;
        i_rt_reg        = 'h00000004;
        i_rd_address    = 5'b00100;
        #2
        //BEQ no taken
        i_op            = 6'b000100;
        i_sign_ext      = 'h00000004;
        i_jump_address  = 'h00000004;
        i_pc            = 'h00000004;
        i_rs_reg        = 'h00000004;
        i_rt_reg        = 'h00000005;
        i_rd_address    = 5'b00100;
        #2
        //BNE no taken
        i_op            = 6'b000101;
        i_sign_ext      = 'h00000005;
        i_jump_address  = 'h00000005;
        i_pc            = 'h00000005;
        i_rs_reg        = 'h00000005;
        i_rt_reg        = 'h00000005;
        i_rd_address    = 5'b00101;
        #2
        //BNE taken
        i_op            = 6'b000101;
        i_sign_ext      = 'h00000005;
        i_jump_address  = 'h00000005;
        i_pc            = 'h00000005;
        i_rs_reg        = 'h00000005;
        i_rt_reg        = 'h00000006;
        i_rd_address    = 5'b00100;
        #2
        //J
        i_op            = 6'b000010;
        i_sign_ext      = 'h00000006;
        i_jump_address  = 'h00000006;
        i_pc            = 'h00000006;
        i_rs_reg        = 'h00000006;
        i_rt_reg        = 'h00000006;
        i_rd_address    = 5'b00110;
        #2
        //JAL
        i_op            = 6'b000011;
        i_sign_ext      = 'h00000007;
        i_jump_address  = 'h00000007;
        i_pc            = 'h00000007;
        i_rs_reg        = 'h00000007;
        i_rt_reg        = 'h00000007;
        i_rd_address    = 5'b00111;
        #2
        //default
        i_op            = 6'b111100;
        i_sign_ext      = 'h00000008;
        i_jump_address  = 'h00000008;
        i_pc            = 'h00000008;
        i_rs_reg        = 'h00000008;
        i_rt_reg        = 'h00000008;
        i_rd_address    = 5'b01000;
        
    end
branch_unit u_branch_unit(
        .rst(rst),
        .i_op(i_op),
        .i_sign_ext(i_sign_ext),
        .i_jump_address(i_jump_address),
        .i_pc(i_pc),
        .i_rs_reg(i_rs_reg), 
        .i_rt_reg(i_rt_reg),
        .i_rd_address(i_rd_address), 
        .os_taken(os_taken),
        .os_write_jump(os_write_jump),
        .o_jump_address(o_jump_address),
        .o_reg_jump_address(o_reg_jump_address)
        );
endmodule
