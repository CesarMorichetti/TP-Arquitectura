`timescale 1ns / 1ps
module MIPS(
            input  wire          clk,
            input  wire          rst,
            input  wire          i_step,
            input  wire          i_program_memory_write,
            input  wire [31 : 0] i_instruction_write,
            input  wire [7  : 0] i_address_write,
            output wire [2557 : 0] o_to_debug,
            output wire            o_stop_signal
            );
    //internos
    //---Estos son las salidas de la etapa Ex a la etapa decode y la etapa
    //---Fetch. Son para saltos
    wire          bus_taken;
    wire [31 : 0] bus_jump;

    //---Estos son las salidas de la etapa wb a la etapa decode, para guardar
    //---el resultado en el banco de registros
    wire [31 : 0] bus_reg_dst;
    wire [4  : 0] bus_addr_reg_dst;
    wire          bus_RegWrite;

    //---hazard unit
    wire          bus_PC_write;//no escribe el pc
    wire          bus_write_IF_ID;//no escribe el Latch_IF_ID
    //Wires Stage Fetch
    wire [31 : 0] pc_if_latch;
    wire [31 : 0] instruction_if_latch;
    wire          stop_pipe_if_latch;
    wire [31 : 0] pc_latch_id;
    wire [31 : 0] instruction_latch_id;
    wire          stop_pipe_latch_id;

    //Wires Stage Decode
    wire [4  : 0] rt_addr_id_latch;
    wire [4  : 0] rd_addr_id_latch;
    wire [4  : 0] rs_addr_id_latch;
    wire [31 : 0] sig_extended_id_latch;
    wire [31 : 0] rs_reg_id_latch;
    wire [31 : 0] rt_reg_id_latch;
    wire [31 : 0] pc_id_latch;
    wire [31 : 0] jump_address_id_latch;
    wire          RegDst_id_latch;
    wire [2 : 0] load_store_id_latch;
    wire          MemRead_id_latch;
    wire          MemWrite_id_latch;
    wire          MemtoReg_id_latch;
    wire [3 : 0]  ALUop_id_latch;
    wire          ALUsrc_id_latch;
    wire          RegWrite_id_latch;
    wire          shmat_id_latch;
    wire [5 : 0]  op_id_latch;         
    wire          stall_id_latch;
    wire          stop_pipe_id_latch;

    wire [4  : 0] rt_addr_latch_ex;
    wire [4  : 0] rd_addr_latch_ex;
    wire [4  : 0] rs_addr_latch_ex;
    wire [31 : 0] sig_extended_latch_ex;
    wire [31 : 0] rs_reg_latch_ex;
    wire [31 : 0] rt_reg_latch_ex;
    wire [31 : 0] pc_latch_ex;
    wire [31 : 0] jump_address_latch_ex;
    wire          RegDst_latch_ex;
    wire          MemRead_latch_ex;
    wire          MemWrite_latch_ex;
    wire          MemtoReg_latch_ex;
    wire [3 : 0]  ALUop_latch_ex;
    wire          ALUsrc_latch_ex;
    wire          RegWrite_latch_ex;
    wire          shmat_latch_ex; 
    wire [5 : 0]  op_latch_ex;
    wire [2 : 0]  load_store_latch_id;
    wire          stall_latch_ex;
    wire          stop_pipe_latch_ex;

    //Wires Stage Execution
    wire [31 : 0] jump_ex_latch;
    wire [4  : 0] addr_jump_ex_latch;
    wire [31 : 0] ALU_res_ex_latch;
    wire [31 : 0] rt_reg_ex_latch;
    wire [4  : 0] addr_reg_dst_ex_latch;
    wire          zero_ex_latch;
    wire          write_jump_ex_latch;
    wire          taken_ex_latch;
    wire          RegWrite_ex_latch;
    wire          MemtoReg_ex_latch;
    wire          MemWrite_ex_latch;
    wire          MemRead_ex_latch;
    wire [31 : 0] pc_to_reg_ex_latch;
    wire          write_pc_ex_latch;
    wire          select_addr_reg_ex_latch;
    wire [2  : 0] load_store_type_ex_latch;
    wire          stop_pipe_ex_latch;
    
    wire [31 : 0] ALU_res_latch_mem;
    wire [31 : 0] rt_reg_latch_mem;
    wire [4  : 0] addr_reg_dst_latch_mem;
    wire          zero_latch_mem;
    wire          RegWrite_latch_mem;
    wire          MemtoReg_latch_mem;
    wire          MemWrite_latch_mem;
    wire          MemRead_latch_mem; 
    
    wire [31 : 0] pc_to_reg_latch_me;
    wire          write_pc_latch_mem;
    wire          select_addr_reg_latch_mem;
    wire [2  : 0] load_store_type_latch_mem;
    wire          stop_pipe_latch_mem;
   
    //Stage Memory

    wire [31 : 0] output_mem_mem_latch;//hay dos mem para respetar nomenclatura 
    wire [31 : 0] ALU_res_mem_latch;   
    wire [4  : 0] addr_reg_dst_mem_latch; 
    wire          RegWrite_mem_latch; 
    wire          MemtoReg_mem_latch; 
    wire [31 : 0] pc_to_reg_mem_latch;
    wire          select_addr_reg_mem_latch;
    wire          write_pc_mem_latch;
    wire          stop_pipe_mem_latch;

    wire [31 : 0] output_mem_latch_wb;//hay dos mem para respetar nomenclatura 
    wire [31 : 0] ALU_res_latch_wb;   
    wire [4  : 0] addr_reg_dst_latch_wb; 
    wire          RegWrite_latch_wb; 
    wire          MemtoReg_latch_wb; 

    wire [31 : 0] pc_to_reg_latch_wb;
    wire          select_addr_reg_latch_wb;
    wire          write_pc_latch_wb;
    wire          stop_pipe_latch_wb;

    //bus stop_pipe signal
    wire          bus_stop_pipe;
    wire          bus_MUX_stop_pipe;
    //buses to debug unit
    wire [1023 : 0] bus_register_to_debug;
    wire [1023 : 0] bus_data_to_debug;

    //si la instruccion es hlt (todos 1) desde wb viene una señal que 
    //me pone la señal de pc write a 0 para cortar el pipe 
    MUX2to1#(.LEN(1))
            u_MUX_stop_pipe(
                           .i_selector(bus_stop_pipe),
                           .i_entradaMUX_0(bus_PC_write),
                           .i_entradaMUX_1(1'b0),
                           .o_salidaMUX(bus_MUX_stop_pipe)
                           );
    //Stage Fetch
    Stage_Fetch u_Stege_Fetch(
                            .clk(clk),
                            .rst(rst),
                            .i_step(i_step),
                            .i_program_memory_write(i_program_memory_write),
                            .i_instruction_write(i_instruction_write),
                            .i_address_write(i_address_write),
                            .i_taken(bus_taken),
                            .i_branch_address(bus_jump),
                            .i_PC_write(bus_MUX_stop_pipe),
                            .o_pc(pc_if_latch),
                            .o_instruction(instruction_if_latch),
                            .os_stop_pipe(stop_pipe_if_latch)
                            );


    Latch_IF_ID u_latch_if_id(
                            .clk(clk),
                            .rst(rst),
                            .i_step(i_step),
                            .is_jump_taken(bus_taken),
                            .i_pc(pc_if_latch),
                            .i_instruction(instruction_if_latch),
                            .is_write_IF_ID(bus_write_IF_ID),
                            .is_stop_pipe(stop_pipe_if_latch),
                            .o_pc(pc_latch_id),
                            .o_instruction(instruction_latch_id),
                            .os_stop_pipe(stop_pipe_latch_id)
                            );
    //Stage Decode
    Stage_Decode u_Stage_Decode(
                            .clk(clk),
                            .i_addr_data(bus_addr_reg_dst),
                            .i_data(bus_reg_dst), 
                            .i_RegWrite(bus_RegWrite),
                            .i_pc(pc_latch_id),
                            .i_instruction(instruction_latch_id),
                            .i_ID_EX_rt(rt_addr_latch_ex),
                            .is_ID_EX_MemRead(MemRead_latch_ex),
                            .is_stop_pipe(stop_pipe_latch_id),
                            .o_rt_addr(rt_addr_id_latch),
                            .o_rd_addr(rd_addr_id_latch),
                            .o_rs_addr(rs_addr_id_latch),
                            .o_sig_extended(sig_extended_id_latch),
                            .o_rs_reg(rs_reg_id_latch),
                            .o_rt_reg(rt_reg_id_latch),
                            .o_pc(pc_id_latch),
                            .o_jump_address(jump_address_id_latch),
                            .os_RegDst(RegDst_id_latch),
                            .os_MemRead(MemRead_id_latch),
                            .os_MemWrite(MemWrite_id_latch),
                            .os_MemtoReg(MemtoReg_id_latch),
                            .os_ALUop(ALUop_id_latch),
                            .os_ALUsrc(ALUsrc_id_latch),
                            .os_RegWrite(RegWrite_id_latch),
                            .os_shmat(shmat_id_latch),
                            .os_load_store_type(load_store_id_latch),
                            .o_op(op_id_latch),
                            .os_pc_write(bus_PC_write),
                            .os_write_IF_ID(bus_write_IF_ID),
                            .os_stall(stall_id_latch),
                            .os_stop_pipe(stop_pipe_id_latch),
                            .o_register_to_debug(bus_register_to_debug)
                            );
    Latch_ID_EX u_latch_id_ex(
                            .clk(clk),
                            .rst(rst),
                            .i_step(i_step),
                            .is_jump_taken(bus_taken),
                            .i_rt_addr(rt_addr_id_latch),
                            .i_rd_addr(rd_addr_id_latch),
                            .i_rs_addr(rs_addr_id_latch),
                            .i_sig_extended(sig_extended_id_latch),
                            .i_rs_reg(rs_reg_id_latch),
                            .i_rt_reg(rt_reg_id_latch),
                            .i_pc(pc_id_latch),
                            .i_jump_address(jump_address_id_latch),
                            .is_RegDst(RegDst_id_latch),
                            .is_MemRead(MemRead_id_latch),
                            .is_MemWrite(MemWrite_id_latch),
                            .is_MemtoReg(MemtoReg_id_latch),
                            .is_ALUop(ALUop_id_latch),
                            .is_ALUsrc(ALUsrc_id_latch),
                            .is_RegWrite(RegWrite_id_latch),
                            .is_shmat(shmat_id_latch),
                            .is_load_store_type(load_store_id_latch),
                            .i_op(op_id_latch),
                            .is_stall(stall_id_latch),
                            .is_stop_pipe(stop_pipe_id_latch),
                            .o_rt_addr(rt_addr_latch_ex),
                            .o_rd_addr(rd_addr_latch_ex),
                            .o_rs_addr(rs_addr_latch_ex),
                            .o_sig_extended(sig_extended_latch_ex),
                            .o_rs_reg(rs_reg_latch_ex),
                            .o_rt_reg(rt_reg_latch_ex),
                            .o_pc(pc_latch_ex),
                            .o_jump_address(jump_address_latch_ex),
                            .o_op(op_latch_ex),
                            .os_RegDst(RegDst_latch_ex),
                            .os_MemRead(MemRead_latch_ex),
                            .os_MemWrite(MemWrite_latch_ex),
                            .os_MemtoReg(MemtoReg_latch_ex),
                            .os_ALUop(ALUop_latch_ex),
                            .os_ALUsrc(ALUsrc_latch_ex),
                            .os_RegWrite(RegWrite_latch_ex),
                            .os_shmat(shmat_latch_ex),
                            .os_load_store_type(load_store_latch_id),
                            .os_stop_pipe(stop_pipe_latch_ex),
                            .os_stall(stall_latch_ex)
                            );
    //Stage Execution
    Stage_Execution u_Stage_Execution(
                            .rst(rst),
                            .i_rt_addr(rt_addr_latch_ex),
                            .i_rd_addr(rd_addr_latch_ex),
                            .i_sig_extended(sig_extended_latch_ex),
                            .i_rs_reg(rs_reg_latch_ex),
                            .i_rt_reg(rt_reg_latch_ex),
                            .i_jump_address(jump_address_latch_ex),
                            .i_pc(pc_latch_ex),
                            .i_op(op_latch_ex),
                            .is_RegDst(RegDst_latch_ex),
                            .is_MemRead(MemRead_latch_ex),
                            .is_MemWrite(MemWrite_latch_ex),
                            .is_MemtoReg(MemtoReg_latch_ex),
                            .is_ALUop(ALUop_latch_ex),
                            .is_ALUsrc(ALUsrc_latch_ex),
                            .is_RegWrite(RegWrite_latch_ex),
                            .is_shmat(shmat_latch_ex),
                            .is_load_store_type(load_store_latch_id),
                            .is_stall(stall_latch_ex),
                            .i_rs_addr(rs_addr_latch_ex),
                            .i_EX_MEM_RegWrite(RegWrite_latch_mem),
                            .i_EX_MEM_Rd(addr_reg_dst_latch_mem),
                            .i_MEM_WB_RegWrite(RegWrite_latch_wb),
                            .i_MEM_WB_Rd(addr_reg_dst_latch_wb),
                            .i_MEM_WB_reg(bus_reg_dst),
                            .i_EX_MEM_reg(ALU_res_latch_mem),
                            .is_stop_pipe(stop_pipe_latch_ex),
                            .o_jump(jump_ex_latch),
                            .o_pc_to_reg(pc_to_reg_ex_latch),
                            .o_ALU_res(ALU_res_ex_latch),
                            .o_rt_reg(rt_reg_ex_latch),
                            .o_addr_reg_dst(addr_reg_dst_ex_latch),
                            .os_write_pc(write_pc_ex_latch),
                            .os_taken(taken_ex_latch),
                            //.os_select_addr_reg(select_addr_reg_ex_latch),
                            .os_RegWrite(RegWrite_ex_latch),
                            .os_MemtoReg(MemtoReg_ex_latch),
                            .os_MemWrite(MemWrite_ex_latch),
                            .os_MemRead(MemRead_ex_latch),
                            .os_stop_pipe(stop_pipe_ex_latch),
                            .os_load_store_type(load_store_type_ex_latch)
                            );
    Latch_EX_MEM u_latch_ex_mem(
                           .clk(clk),
                           .rst(rst),
                           .i_step(i_step),
                           .is_jump_taken(bus_taken),
                           .i_jump(jump_ex_latch),
                           .i_pc_to_reg(pc_to_reg_ex_latch),
                           .i_ALU_res(ALU_res_ex_latch),
                           .i_rt_reg(rt_reg_ex_latch),
                           .i_addr_reg_dst(addr_reg_dst_ex_latch),
                           .is_write_pc(write_pc_ex_latch),
                           .is_taken(taken_ex_latch),
                           //.is_select_addr_reg(select_addr_reg_ex_latch),
                           .is_RegWrite(RegWrite_ex_latch),
                           .is_MemtoReg(MemtoReg_ex_latch),
                           .is_MemWrite(MemWrite_ex_latch),
                           .is_MemRead(MemRead_ex_latch),    
                           .is_load_store_type(load_store_type_ex_latch),
                           .is_stop_pipe(stop_pipe_ex_latch),
                           .o_jump(bus_jump),
                           .o_pc_to_reg(pc_to_reg_latch_me),
                           .o_ALU_res(ALU_res_latch_mem),
                           .o_rt_reg(rt_reg_latch_mem),
                           .o_addr_reg_dst(addr_reg_dst_latch_mem),
                           .os_write_pc(write_pc_latch_mem),
                           .os_taken(bus_taken),
                           //.os_select_addr_reg(select_addr_reg_latch_mem),
                           .os_RegWrite(RegWrite_latch_mem),
                           .os_MemtoReg(MemtoReg_latch_mem),
                           .os_MemWrite(MemWrite_latch_mem),
                           .os_MemRead(MemRead_latch_mem),
                           .os_load_store_type(load_store_type_latch_mem),
                           .os_stop_pipe(stop_pipe_latch_mem)
                           );

    Stage_Memory u_Stage_Memory(
                           .clk(clk),
                           .i_ALU_res(ALU_res_latch_mem), 
                           .i_rt_reg(rt_reg_latch_mem),
                           .i_addr_reg_dst(addr_reg_dst_latch_mem),
                           .i_pc_to_reg(pc_to_reg_latch_me),
                           .is_write_pc(write_pc_latch_mem),
                           //.is_select_addr_reg(select_addr_reg_latch_mem),
                           .is_RegWrite(RegWrite_latch_mem), 
                           .is_MemtoReg(MemtoReg_latch_mem),
                           .is_MemWrite(MemWrite_latch_mem), 
                           .is_MemRead(MemRead_latch_mem),
                           .is_load_store_type(load_store_type_latch_mem),  
                           .is_stop_pipe(stop_pipe_latch_mem),
                           .o_output_mem(output_mem_mem_latch), 
                           .o_ALU_res(ALU_res_mem_latch),   
                           .o_addr_reg_dst(addr_reg_dst_mem_latch), 
                           .o_pc_to_reg(pc_to_reg_mem_latch),
                           //.os_select_addr_reg(select_addr_reg_mem_latch),
                           .os_write_pc(write_pc_mem_latch),
                           .os_RegWrite(RegWrite_mem_latch), 
                           .os_MemtoReg(MemtoReg_mem_latch),  
                           .o_data_to_debug(bus_data_to_debug),
                           .os_stop_pipe(stop_pipe_mem_latch)
                          );

    Latch_MEM_WB u_latch_mem_wb(
                           .clk(clk),
                           .rst(rst),
                           .i_step(i_step),
                           .i_output_mem(output_mem_mem_latch),
                           .i_ALU_res(ALU_res_mem_latch),
                           .i_addr_reg_dst(addr_reg_dst_mem_latch),
                           .i_pc_to_reg(pc_to_reg_mem_latch),
                           .is_RegWrite(RegWrite_mem_latch),
                           .is_MemtoReg(MemtoReg_mem_latch),
                           //.is_select_addr_reg(select_addr_reg_mem_latch),
                           .is_write_pc(write_pc_mem_latch),
                           .is_stop_pipe(stop_pipe_mem_latch),
                           .o_output_mem(output_mem_latch_wb),
                           .o_ALU_res(ALU_res_latch_wb),
                           .o_addr_reg_dst(addr_reg_dst_latch_wb),
                           .o_pc_to_reg(pc_to_reg_latch_wb),
                           //.os_select_addr_reg(select_addr_reg_latch_wb),
                           .os_write_pc(write_pc_latch_wb),
                           .os_RegWrite(RegWrite_latch_wb),
                           .os_MemtoReg(MemtoReg_latch_wb),
                           .os_stop_pipe(stop_pipe_latch_wb)
                           );

    Stage_WriteBack u_Stage_WriteBack(
                           .i_output_mem(output_mem_latch_wb),
                           .i_ALU_res(ALU_res_latch_wb),
                           .i_addr_reg_dst(addr_reg_dst_latch_wb),
                           .i_pc_to_reg(pc_to_reg_latch_wb),
                           .is_RegWrite(RegWrite_latch_wb),
                           .is_MemtoReg(MemtoReg_latch_wb),
                           //.is_select_addr_reg(select_addr_reg_latch_wb),
                           .is_write_pc(write_pc_latch_wb),
                           .is_stop_pipe(stop_pipe_latch_wb),
                           .o_reg_dst(bus_reg_dst),
                           .o_addr_reg_dst(bus_addr_reg_dst),
                           .os_RegWrite(bus_RegWrite),
                           .os_stop_pipe(bus_stop_pipe)
                           );

    assign o_to_debug = {pc_latch_id, instruction_if_latch, stop_pipe_latch_id,

                         bus_register_to_debug,

                         rt_addr_latch_ex, rd_addr_latch_ex, rs_addr_latch_ex, sig_extended_latch_ex,
                         rs_reg_latch_ex, rt_reg_latch_ex, pc_latch_ex, jump_address_latch_ex,
                         op_latch_ex, RegDst_latch_ex, MemRead_latch_ex, MemWrite_latch_ex,
                         MemtoReg_latch_ex, ALUop_latch_ex, ALUsrc_latch_ex, RegWrite_latch_ex,
                         shmat_latch_ex, load_store_latch_id, stall_latch_ex, stop_pipe_latch_ex,

                         bus_jump, pc_to_reg_latch_me, ALU_res_latch_mem, rt_reg_latch_mem, 
                         addr_reg_dst_latch_mem, write_pc_latch_mem, bus_taken, RegWrite_latch_mem,
                         MemtoReg_latch_mem, MemWrite_latch_mem, MemRead_latch_mem,
                         load_store_type_latch_mem, stop_pipe_latch_mem,

                         bus_data_to_debug,

                         output_mem_latch_wb, ALU_res_latch_wb, addr_reg_dst_latch_wb,
                         pc_to_reg_latch_wb, write_pc_latch_wb, RegWrite_latch_wb,
                         MemtoReg_latch_wb, stop_pipe_latch_wb
                         };
    assign o_stop_signal = bus_MUX_stop_pipe; 
endmodule   
