`timescale 1ns / 1ps
module tb_hazard_unit();

    reg         is_ID_EX_MemRead;
    reg [4 : 0] i_ID_EX_Rt;
    reg [4 : 0] i_IF_ID_Rs;
    reg [4 : 0] i_IF_ID_Rt;

    wire          o_PC_write;
    wire          os_write_IF_ID;
    wire          os_mux_control;

    initial begin
        #100
        is_ID_EX_MemRead = 0;
        i_ID_EX_Rt = 0;
        i_IF_ID_Rs = 0;
        i_IF_ID_Rt = 0;

        #10//RT = RS
        is_ID_EX_MemRead = 1;
        i_ID_EX_Rt = 5'b00001;
        i_IF_ID_Rs = 5'b00001;
        i_IF_ID_Rt = 0;
        #10//RT = RT
        is_ID_EX_MemRead = 1;
        i_ID_EX_Rt = 5'b00001;
        i_IF_ID_Rs = 5'b00010;
        i_IF_ID_Rt = 5'b00001;
        #10//RT distinto pero load
        is_ID_EX_MemRead = 1;
        i_ID_EX_Rt = 5'b00001;
        i_IF_ID_Rs = 5'b00011;
        i_IF_ID_Rt = 5'b00010;
        #10//No es load pero reg iguales
        is_ID_EX_MemRead = 0;
        i_ID_EX_Rt = 5'b00001;
        i_IF_ID_Rs = 5'b00001;
        i_IF_ID_Rt = 0;
        #10//No es load pero reg dist 
        is_ID_EX_MemRead = 0;
        i_ID_EX_Rt = 5'b00001;
        i_IF_ID_Rs = 5'b00011;
        i_IF_ID_Rt = 0;

    end
    
    hazard_unit u_hazard_unit(
                             .is_ID_EX_MemRead(is_ID_EX_MemRead),
                             .i_ID_EX_Rt(i_ID_EX_Rt),
                             .i_IF_ID_Rs(i_IF_ID_Rs),
                             .i_IF_ID_Rt(i_IF_ID_Rt),
                             .o_PC_write(o_PC_write),
                             .os_write_IF_ID(os_write_IF_ID),
                             .os_mux_control(os_mux_control)
                             );
endmodule
