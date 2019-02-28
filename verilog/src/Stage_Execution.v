`timescale 1ns / 1ps


module Stage_Execution(
                input  wire          rst,
                input  wire [4  : 0] i_rt_addr,
                input  wire [4  : 0] i_rd_addr,
                input  wire [31 : 0] i_sig_extended,//Parte menos significativa de la instruccion ext
                input  wire [31 : 0] i_rs_reg,//registro, no confundir con la direccion
                input  wire [31 : 0] i_rt_reg,//registro, no confundir con la direccion
                input  wire [31 : 0] i_jump_address,
                input  wire [31 : 0] i_pc,
                input  wire [5 : 0]  i_op,
                input  wire          is_RegDst,
                input  wire          is_MemRead,
                input  wire          is_MemWrite,
                input  wire          is_MemtoReg,
                input  wire [3 : 0]  is_ALUop,
                input  wire          is_ALUsrc,
                input  wire          is_RegWrite,
                input  wire          is_shmat,
                input  wire [2  : 0] is_load_store_type,
                input  wire          is_stall,
                input  wire          is_stop_pipe,
                //para forward unit
                input  wire [4  : 0] i_rs_addr,
                input  wire          i_EX_MEM_RegWrite,
                input  wire [4  : 0] i_EX_MEM_Rd,
                //input  wire [4  : 0] i_ID_EX_Rs,
                //input  wire [4  : 0] i_ID_EX_Rt,
                input  wire          i_MEM_WB_RegWrite,
                input  wire [4  : 0] i_MEM_WB_Rd,
                input  wire [31 : 0] i_MEM_WB_reg,//registro corto circuito
                input  wire [31 : 0] i_EX_MEM_reg,//registro corto circuito

                output wire [31 : 0] o_jump,//direccion a saltar
                output wire [31 : 0] o_pc_to_reg,//para el caso de salto que
                                                 //escribe banco de registros
                output wire [31 : 0] o_ALU_res,
                output wire [31 : 0] o_rt_reg,
                output wire [4  : 0] o_addr_reg_dst,//direccion del banco de
                                                      //registros a escribir
                output wire          os_write_pc,
                output wire          os_taken,
                //output wire          os_select_addr_reg,
                output wire          os_RegWrite,
                output wire          os_MemtoReg,
                output wire          os_MemWrite,
                output wire          os_MemRead,
                output wire          os_stop_pipe,
                output wire [2  : 0] os_load_store_type
                );
    wire [31 : 0] bus_input_A_ALU;
    wire [31 : 0] bus_input_B_ALU;
    wire [3  : 0] bus_ALU_operation;
    //Para forward unit
    wire [1  : 0] bus_MUX3to1_A;
    wire [1  : 0] bus_MUX3to1_B;
    wire [31 : 0] bus_MUX_MUX_A;
    wire [31 : 0] bus_MUX_MUX_B;

    //wire [31 : 0] bus_MUX_branch_unit_rs;
    //wire [31 : 0] bus_MUX_branch_unit_rs;
    
    wire [4  : 0] bus_addr_reg_dst;
    wire          bus_select_addr_reg;
    
    foward_unit u_foward_unit(
                            .EX_MEM_RegWrite(i_EX_MEM_RegWrite),
                            .EX_MEM_Rd(i_EX_MEM_Rd),
                            .ID_EX_Rs(i_rs_addr),
                            .ID_EX_Rt(i_rt_addr),
                            .MEM_WB_RegWrite(i_MEM_WB_RegWrite),
                            .MEM_WB_Rd(i_MEM_WB_Rd),
                            .o_MUX_A_signal(bus_MUX3to1_A),
                            .o_MUX_B_signal(bus_MUX3to1_B)
                             );

/*  
    MUX3to1#(.LEN(5)) 
            u_mux3to1_rs_branch_unit(
                       .i_selector(bus_MUX3to1_A),
                       .i_entradaMUX_0(i_rs_reg),
                       .i_entradaMUX_1(i_MEM_WB_reg),
                       .i_entradaMUX_2(i_EX_MEM_reg),
                       .o_salidaMUX(bus_MUX_branch_unit_rs)
                       );                        

    MUX3to1#(.LEN(5)) 
            u_mux3to1_rt_branch_unit(
                       .i_selector(bus_MUX3to1_B),
                       .i_entradaMUX_0(i_rt_reg),
                       .i_entradaMUX_1(i_MEM_WB_reg),
                       .i_entradaMUX_2(i_EX_MEM_reg),
                       .o_salidaMUX(bus_MUX_branch_unit_rs)
                       );       
*/
    branch_unit u_branch_unit(
                            .rst(rst),
                            .i_op(i_op),
                            .i_sign_ext(i_sig_extended),
                            .i_jump_address(i_jump_address),
                            .i_pc(i_pc),
                            .i_rs_reg(bus_MUX_MUX_A),
                            .i_rt_reg(bus_MUX_MUX_B),
                            .is_stall(is_stall),
                            .os_taken(os_taken),
                            .os_write_pc(os_write_pc),
                            .os_select_addr_reg(bus_select_addr_reg),
                            .o_jump_address(o_jump),
                            .o_pc_to_reg(o_pc_to_reg)
                            );

    MUX3to1#(.LEN(32)) 
            u_mux3to1_A(
                       .i_selector(bus_MUX3to1_A),
                       .i_entradaMUX_0(i_rs_reg),
                       .i_entradaMUX_1(i_MEM_WB_reg),
                       .i_entradaMUX_2(i_EX_MEM_reg),
                       .o_salidaMUX(bus_MUX_MUX_A)
                       );                        
    MUX3to1#(.LEN(32)) 
            u_mux3to1_B(
                       .i_selector(bus_MUX3to1_B),
                       .i_entradaMUX_0(i_rt_reg),
                       .i_entradaMUX_1(i_MEM_WB_reg),
                       .i_entradaMUX_2(i_EX_MEM_reg),
                       .o_salidaMUX(bus_MUX_MUX_B)
                       );                        

    MUX2to1#(.LEN(32))
            u_mux_input_A_ALU(
                             .i_selector(is_shmat),
                             .i_entradaMUX_0(bus_MUX_MUX_A),
                             .i_entradaMUX_1(i_sig_extended),
                             .o_salidaMUX(bus_input_A_ALU)
                             );
    MUX2to1#(.LEN(32))
            u_mux_input_B_ALU(
                             .i_selector(is_ALUsrc),
                             .i_entradaMUX_0(bus_MUX_MUX_B),
                             .i_entradaMUX_1(i_sig_extended),
                             .o_salidaMUX(bus_input_B_ALU)
                             );
    ALU u_ALU(
             .i_A(bus_input_A_ALU),
             .i_B(bus_input_B_ALU),
             .i_operation(bus_ALU_operation),
             .o_res(o_ALU_res)
             );                       
    
    ALU_control u_ALU_control(
                             .is_ALUop(is_ALUop),
                             .i_func(i_sig_extended[5 -: 6]),
                             .o_operation(bus_ALU_operation)
                             );

    MUX2to1#(.LEN(5))
            u_mux_RegDst(
                        .i_selector(is_RegDst),
                        .i_entradaMUX_0(i_rt_addr),
                        .i_entradaMUX_1(i_rd_addr),
                        .o_salidaMUX(bus_addr_reg_dst)
                        );
    MUX2to1#(.LEN(5))
           u_mux_inst_jal(
                   .i_selector(bus_select_addr_reg),//señal que viene de la jump unit
                   .i_entradaMUX_0(bus_addr_reg_dst),
                   .i_entradaMUX_1(5'b11111),//es el reg 31 para la instruccion jal
                   .o_salidaMUX(o_addr_reg_dst)
                   );
    assign o_rt_reg             = bus_MUX_MUX_B;
    assign os_RegWrite          = is_RegWrite;
    assign os_MemtoReg          = is_MemtoReg;
    assign os_MemWrite          = is_MemWrite;
    assign os_MemRead           = is_MemRead; 
    assign os_load_store_type   = is_load_store_type;
    assign os_stop_pipe         = is_stop_pipe;
endmodule
