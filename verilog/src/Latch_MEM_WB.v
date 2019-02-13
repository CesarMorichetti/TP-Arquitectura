`timescale 1ns / 1ps
module Latch_MEM_WB(
                input  wire          clk,
                input  wire          rst,
                input  wire [31 : 0] i_output_mem,
                input  wire [31 : 0] i_ALU_res,
                input  wire [4  : 0] i_addr_reg_dst,
                input  wire [31 : 0] i_pc_to_reg,
                input  wire          is_RegWrite,
                input  wire          is_MemtoReg,
                input  wire          is_select_addr_reg,
                input  wire          is_write_pc,
                output reg [31 : 0]  o_output_mem,
                output reg [31 : 0]  o_ALU_res,
                output reg [4  : 0]  o_addr_reg_dst,
                output reg [31 : 0]  o_pc_to_reg,
                output reg           os_select_addr_reg,
                output reg           os_write_pc,
                output reg           os_RegWrite,
                output reg           os_MemtoReg
                   );
                   
    always@(posedge clk)begin
        if(~rst)begin
            o_output_mem        <= 0;
            o_ALU_res           <= 0;
            o_addr_reg_dst      <= 0;
            o_pc_to_reg         <= 0;
            os_RegWrite         <= 0;
            os_MemtoReg         <= 0;
            os_write_pc         <= 0;
            os_select_addr_reg  <= 0;
        end
        else begin
            o_output_mem        <= i_output_mem;
            o_ALU_res           <= i_ALU_res;
            o_addr_reg_dst      <= i_addr_reg_dst;
            o_pc_to_reg         <= i_pc_to_reg;
            os_RegWrite         <= is_RegWrite;
            os_MemtoReg         <= is_MemtoReg;
            os_write_pc         <= is_write_pc;
            os_select_addr_reg  <= is_select_addr_reg;

        end
    end
endmodule
