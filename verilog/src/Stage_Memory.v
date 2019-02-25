`timescale 1ns / 1ps
module Stage_Memory(
                input  wire          clk,
                input  wire [31 : 0] i_ALU_res,
                input  wire [31 : 0] i_rt_reg,
                input  wire [4  : 0] i_addr_reg_dst,
                input  wire [31 : 0] i_pc_to_reg,
                input  wire          is_write_pc,
                //input  wire          is_select_addr_reg,
                input  wire          is_RegWrite,
                input  wire          is_MemtoReg,
                input  wire          is_MemWrite,
                input  wire          is_MemRead,
                input  wire [2  : 0] is_load_store_type,
                output wire [31 : 0] o_output_mem,
                output wire [31 : 0] o_ALU_res,
                output wire [4  : 0] o_addr_reg_dst,
                output wire [31 : 0] o_pc_to_reg,
                //output wire          os_select_addr_reg,
                output wire          os_write_pc,
                output wire          os_RegWrite,
                output wire          os_MemtoReg,
                output wire [1023 : 0] o_data_to_debug
                );
    
    wire [31 : 0] bus_store_memory;
    wire [31 : 0] bus_memory_load;
//Ver  que onda con el flag zero y el MemRead
    /*
    BRAM u_memory(
                 .clk(clk),
                 .i_w_enable(is_MemWrite),
                 .i_address(i_ALU_res[7:0]),
                 .i_data(bus_store_memory),
                 .o_data(bus_memory_load)
                 );
*/
    data_memory u_data_memory(
                             .clk(clk),
                             .i_Read(is_MemRead),
                             .i_wenable(is_MemWrite),
                             .i_address(i_ALU_res[4:0]),
                             .i_data(bus_store_memory),
                             .o_data(bus_memory_load),
                             .o_data_to_debug(o_data_to_debug)
                             );
    store_instruction_type
            u_store_instruction_type(
                                    .is_load_store_type(is_load_store_type),
                                    .i_data_to_mem(i_rt_reg),
                                    .o_store(bus_store_memory)
                                    );
    load_instruction_type
            u_load_instruction_type(
                                    .is_load_store_type(is_load_store_type),
                                    .i_mem_data(bus_memory_load),
                                    .o_load(o_output_mem)
                                    );

    assign o_ALU_res          = i_ALU_res;
    assign o_addr_reg_dst     = i_addr_reg_dst;
    assign o_pc_to_reg        = i_pc_to_reg;
    assign os_RegWrite        = is_RegWrite;
    assign os_MemtoReg        = is_MemtoReg;
    //assign os_select_addr_reg = is_select_addr_reg;
    assign os_write_pc        = is_write_pc;
endmodule
