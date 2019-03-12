`timescale 1ns / 1ps

module Latch_EX_MEM(
                input wire          rst,
                input wire          clk,
                input wire          i_step,
                input wire          is_jump_taken,//limpia en caso de salto
                input wire [31 : 0] i_jump,//direccion a saltar
                input wire [31 : 0] i_pc_to_reg,
                input wire [31 : 0] i_ALU_res,
                input wire [31 : 0] i_rt_reg,
                input wire [4  : 0] i_addr_reg_dst,//direccion del banco de
                                                   //registros a escribir
                input wire          is_write_pc,
                input wire          is_taken,
                //input wire          is_select_addr_reg,
                input wire          is_RegWrite,
                input wire          is_MemtoReg,
                input wire          is_MemWrite,
                input wire          is_MemRead,    
                input wire          is_stop_pipe,
                input wire [2  : 0] is_load_store_type,
                output reg [31 : 0] o_jump,//direccion a saltar
                output reg [31 : 0] o_pc_to_reg,
                output reg [31 : 0] o_ALU_res,
                output reg [31 : 0] o_rt_reg,
                output reg [4  : 0] o_addr_reg_dst,//direccion del banco de
                                                  //registros a escribir
                output reg          os_write_pc,
                output reg          os_taken,
                //output reg          os_select_addr_reg,
                output reg          os_RegWrite,
                output reg          os_MemtoReg,
                output reg          os_MemWrite,
                output reg          os_MemRead,    
                output reg          os_stop_pipe,
                output reg [2  : 0] os_load_store_type
                    );



    always@(posedge clk)begin
        if(~rst)begin
            o_jump              <= 0;
            o_pc_to_reg         <= 0;
            o_ALU_res           <= 0;
            o_rt_reg            <= 0;
            o_addr_reg_dst      <= 0;
            os_write_pc         <= 0;
            os_taken            <= 0;
            //os_select_addr_reg  <= 0;
            os_RegWrite         <= 0;
            os_MemtoReg         <= 0;
            os_MemWrite         <= 0;              
            os_MemRead          <= 0; 
            os_load_store_type  <= 0;
            os_stop_pipe        <= 0;
        end
        else begin
            if(i_step) begin
                if(is_jump_taken)begin
                    o_jump              <= 0;
                    o_pc_to_reg         <= 0;
                    o_ALU_res           <= 0;
                    o_rt_reg            <= 0;
                    o_addr_reg_dst      <= 0;
                    os_write_pc         <= 0;
                    os_taken            <= 0;
                    //os_select_addr_reg  <= 0;
                    os_RegWrite         <= 0;
                    os_MemtoReg         <= 0;
                    os_MemWrite         <= 0;              
                    os_MemRead          <= 0; 
                    os_load_store_type  <= 0;
                    os_stop_pipe        <= 0;
                end
                else begin
                    o_jump              <= i_jump;
                    o_pc_to_reg         <= i_pc_to_reg;
                    o_ALU_res           <= i_ALU_res;
                    o_rt_reg            <= i_rt_reg;
                    o_addr_reg_dst      <= i_addr_reg_dst;
                    os_write_pc         <= is_write_pc;
                    os_taken            <= is_taken;
                    //os_select_addr_reg  <= is_select_addr_reg;
                    os_RegWrite         <= is_RegWrite;
                    os_MemtoReg         <= is_MemtoReg;
                    os_MemWrite         <= is_MemWrite;              
                    os_MemRead          <= is_MemRead; 
                    os_load_store_type  <= is_load_store_type;
                    os_stop_pipe        <= is_stop_pipe;
                end
            end
        end
    end
endmodule
