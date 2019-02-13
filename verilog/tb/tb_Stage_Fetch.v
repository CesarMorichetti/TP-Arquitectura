`timescale 1ns / 1ps


module tb_Stage_Fetch();
    
    reg            clk;
    reg            rst;
    //reg          MUX_branch_selector;
    //reg          MUX_jump_selector;
    //reg [31 : 0] branch_address;
    //reg [31 : 0] jump_address;
    reg   [31 : 0] branch_address;
    reg            taken;
    reg            PC_write;

    wire [31 : 0] pc;
    wire [31 : 0] instruction;

    initial begin
        clk                 = 0;
        rst                 = 0;
        //MUX_branch_selector = 0;
        //MUX_jump_selector   = 0;
        //branch_address      = 0;
        //jump_address        = 0;
        branch_address      = 0;
        taken               = 0;
        PC_write            = 0;

        #100
        rst = 1;
        
        #100
        PC_write = 1;
        //MUX_branch_selector  = 0;
        //MUX_jump_selector    = 0;
        //branch_address       = 0;
        //jump_address         = 0;
        branch_address         = 0;
        taken                = 0;
        #40
        //MUX_branch_selector  = 1;
        //MUX_jump_selector    = 0;
        //branch_address       = 5;
        //jump_address         = 0;
        branch_address         = 6;
        taken                = 1;
        
        #2
        taken                = 0;
        //MUX_branch_selector  = 0;
        //MUX_jump_selector    = 0;
        #10
        //MUX_branch_selector  = 1;
        //MUX_jump_selector    = 1;
        //branch_address       = 0;
        //jump_address         = 30;
        branch_address         = 0;
        taken                = 1;
        #2
        //MUX_branch_selector  = 0;
        //MUX_jump_selector    = 0;
        taken                = 0;
        #50
        //MUX_branch_selector  = 0;
        //MUX_jump_selector    = 1;
        //branch_address       = 0;
        //jump_address         = 0;
        branch_address         = 32;
        taken                = 1;
        #2
        //MUX_branch_selector  = 0;
        //MUX_jump_selector    = 0;
        taken                = 0;
        /*
        #20
        MUX_branch_selector  = 1;
        MUX_jump_selector    = 0;
        branch_address       = 100;
        jump_address         = 00;
        #2
        MUX_branch_selector  = 0;
        MUX_jump_selector    = 0;
        */
        
    end
    
    Stage_Fetch u_Stege_Fetch(
            .clk(clk),
            .rst(rst),
            //.i_MUX_branch_selector(MUX_branch_selector),
            //.i_MUX_jump_selector(MUX_jump_selector),            
            //.i_branch_address(branch_address),
            //.i_jump_address(jump_address),
            .i_taken(taken),
            .i_branch_address(branch_address),
            .i_PC_write(PC_write),
            .o_pc(pc),
            .o_instruction(instruction)
            );

    always #1 clk = ~clk;
endmodule
