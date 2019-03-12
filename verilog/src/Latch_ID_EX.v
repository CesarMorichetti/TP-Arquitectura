`timescale 1ns / 1ps

module Latch_ID_EX(
    input wire clk,
    input wire rst,
    input wire i_step,
    input wire          is_jump_taken,//limpia en caso de salto
    input wire [4  : 0] i_rt_addr,
    input wire [4  : 0] i_rd_addr,
    input wire [4  : 0] i_rs_addr, 
    input wire [31 : 0] i_sig_extended,//Parte menos significativa de la instruccion ext
    input wire [31 : 0] i_rs_reg,//registro, no confundir con la direccion
    input wire [31 : 0] i_rt_reg,//registro, no confundir con la direccion
    input wire [31 : 0] i_pc,
    input wire [31 : 0] i_jump_address,
    input wire [5  : 0] i_op,
    input wire          is_RegDst,
    input wire          is_MemRead,
    input wire          is_MemWrite,
    input wire          is_MemtoReg,
    input wire [3  : 0] is_ALUop,
    input wire          is_ALUsrc,
    input wire          is_RegWrite,
    input wire          is_shmat,
    input wire [2  : 0] is_load_store_type,
    input wire          is_stall, 
    input wire          is_stop_pipe,
    output reg [4  : 0] o_rt_addr,
    output reg [4  : 0] o_rd_addr,
    output reg [4  : 0] o_rs_addr,
    output reg [31 : 0] o_sig_extended,
    output reg [31 : 0] o_rs_reg,
    output reg [31 : 0] o_rt_reg,
    output reg [31 : 0] o_pc,
    output reg [31 : 0] o_jump_address,
    output reg [5 : 0]  o_op,
    output reg          os_RegDst,
    output reg          os_MemRead,
    output reg          os_MemWrite,
    output reg          os_MemtoReg,
    output reg [3 : 0]  os_ALUop,
    output reg          os_ALUsrc,
    output reg          os_RegWrite,
    output reg          os_shmat,
    output reg [2 : 0]  os_load_store_type,
    output reg          os_stall,
    output reg          os_stop_pipe
    );
    
    always@(posedge clk)
    begin
        if(~rst)begin
            o_rt_addr           <= 0;
            o_rd_addr           <= 0;
            o_rs_addr           <= 0;
            o_sig_extended      <= 0;
            o_rs_reg            <= 0;
            o_rt_reg            <= 0;
            o_pc                <= 0;
            o_jump_address      <= 0;
            os_RegDst           <= 0;
            os_MemRead          <= 0;
            os_MemWrite         <= 0;
            os_MemtoReg         <= 0;
            os_ALUop            <= 0;
            os_ALUsrc           <= 0;
            os_RegWrite         <= 0;
            os_shmat            <= 0;
            os_load_store_type  <= 0;
            o_op                <= 0; 
            os_stall            <= 0;
            os_stop_pipe        <= 0;
        end
        else begin
            if(i_step)begin
                if(is_jump_taken)begin
                    o_rt_addr           <= 0;
                    o_rd_addr           <= 0;
                    o_rs_addr           <= 0;
                    o_sig_extended      <= 0;
                    o_rs_reg            <= 0;
                    o_rt_reg            <= 0;
                    o_pc                <= 0;
                    o_jump_address      <= 0;
                    os_RegDst           <= 0;
                    os_MemRead          <= 0;
                    os_MemWrite         <= 0;
                    os_MemtoReg         <= 0;
                    os_ALUop            <= 0;
                    os_ALUsrc           <= 0;
                    os_RegWrite         <= 0;
                    os_shmat            <= 0;
                    os_load_store_type  <= 0;
                    o_op                <= 0; 
                    os_stall            <= 0;
                    os_stop_pipe        <= 0;
                end
                else begin
                    o_rt_addr           <= i_rt_addr;
                    o_rd_addr           <= i_rd_addr;
                    o_rs_addr           <= i_rs_addr;
                    o_sig_extended      <= i_sig_extended;
                    o_rs_reg            <= i_rs_reg;
                    o_rt_reg            <= i_rt_reg;
                    o_pc                <= i_pc;
                    o_jump_address      <= i_jump_address;
                    os_RegDst           <= is_RegDst;
                    os_MemRead          <= is_MemRead;
                    os_MemWrite         <= is_MemWrite;
                    os_MemtoReg         <= is_MemtoReg;
                    os_ALUop            <= is_ALUop;
                    os_ALUsrc           <= is_ALUsrc;
                    os_RegWrite         <= is_RegWrite;
                    os_shmat            <= is_shmat;
                    os_load_store_type  <= is_load_store_type;
                    o_op                <= i_op;
                    os_stall            <= is_stall;
                    os_stop_pipe        <= is_stop_pipe;
                end
            end
        end
    end

endmodule
