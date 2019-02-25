`timescale 1ns / 1ps
module Stage_WriteBack(
                      input  wire [31 : 0] i_output_mem,
                      input  wire [31 : 0] i_ALU_res,
                      input  wire [4  : 0] i_addr_reg_dst,
                      input  wire [31 : 0] i_pc_to_reg,
                      input  wire          is_RegWrite,
                      input  wire          is_MemtoReg,
                      //input  wire          is_select_addr_reg,
                      input  wire          is_write_pc,
                      input  wire          is_stop_pipe,
                      output wire [31 : 0] o_reg_dst,
                      output wire [4  : 0] o_addr_reg_dst,
                      output wire          os_RegWrite,
                      output  wire          os_stop_pipe
                      );

    wire [31 : 0] bus_data_wb;
    MUX2to1#(.LEN(32))
           u_MUX_ALU_MEM(
                   .i_selector(is_MemtoReg),
                   .i_entradaMUX_0(i_ALU_res),
                   .i_entradaMUX_1(i_output_mem),
                   .o_salidaMUX(bus_data_wb)
                   );
    /*
    MUX2to1#(.LEN(5))
           u_MUX_WB(
                   .i_selector(is_select_addr_reg),
                   .i_entradaMUX_0(i_addr_reg_dst),
                   .i_entradaMUX_1(5'b11111),//es el reg 31 para la instruccion jal
                   .o_salidaMUX(o_addr_reg_dst)
                   );
    */
    MUX2to1#(.LEN(32))
           u_MUX_ADDR(
                   .i_selector(is_write_pc),
                   .i_entradaMUX_0(bus_data_wb),
                   .i_entradaMUX_1(i_pc_to_reg),
                   .o_salidaMUX(o_reg_dst)
                   );

    assign os_RegWrite    = is_RegWrite;
    assign o_addr_reg_dst = i_addr_reg_dst;
    assign os_stop_pipe = is_stop_pipe;
endmodule
