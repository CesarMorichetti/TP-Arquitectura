`timescale 1ns / 1ps
module tb_foward_unit();
    reg          EX_MEM_RegWrite; 
    reg  [4 : 0] EX_MEM_Rd;
    reg  [4 : 0] ID_EX_Rs;
    reg  [4 : 0] ID_EX_Rt;
    reg          MEM_WB_RegWrite;
    reg  [4 : 0] MEM_WB_Rd;
    wire [1 : 0] o_MUX_A_signal;
    wire [1 : 0] o_MUX_B_signal;

    initial begin
        #100
        EX_MEM_RegWrite = 0;
        EX_MEM_Rd = 0;
        ID_EX_Rs = 0;
        ID_EX_Rt = 0;
        MEM_WB_RegWrite = 0;
        MEM_WB_Rd = 0;
        #10
        EX_MEM_RegWrite = 1;
        EX_MEM_Rd = 5;
        ID_EX_Rs = 5;
        ID_EX_Rt = 0;
        MEM_WB_RegWrite = 0;
        MEM_WB_Rd = 0;
        #10
        EX_MEM_RegWrite = 0;
        EX_MEM_Rd = 5;
        ID_EX_Rs = 0;
        ID_EX_Rt = 5;
        MEM_WB_RegWrite = 0;
        MEM_WB_Rd = 0;
        #10
        EX_MEM_RegWrite = 0;
        EX_MEM_Rd = 0;
        ID_EX_Rs = 0;
        ID_EX_Rt = 4;
        MEM_WB_RegWrite = 1;
        MEM_WB_Rd = 4;
        #10
        EX_MEM_RegWrite = 0;
        EX_MEM_Rd = 0;
        ID_EX_Rs = 0;
        ID_EX_Rt = 4;
        MEM_WB_RegWrite = 0;
        MEM_WB_Rd = 4;
        #10
        EX_MEM_RegWrite = 0;
        EX_MEM_Rd = 5;
        ID_EX_Rs = 5;
        ID_EX_Rt = 0;
        MEM_WB_RegWrite = 1;
        MEM_WB_Rd = 5;



    end
    foward_unit u_foward_unit(
                            .EX_MEM_RegWrite(EX_MEM_RegWrite),
                            .EX_MEM_Rd(EX_MEM_Rd),
                            .ID_EX_Rs(ID_EX_Rs),
                            .ID_EX_Rt(ID_EX_Rt),
                            .MEM_WB_RegWrite(MEM_WB_RegWrite),
                            .MEM_WB_Rd(MEM_WB_Rd),
                            .o_MUX_A_signal(o_MUX_A_signal),
                            .o_MUX_B_signal(o_MUX_B_signal)
                             );
endmodule
