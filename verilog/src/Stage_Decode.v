`timescale 1ns / 1ps

module Stage_Decode(
                    input wire           clk,
                    //desde WB
                    input wire  [4  : 0] i_addr_data,//direccion registro a escribir
                    input wire  [31 : 0] i_data, //contenido a escribir
                    input wire           i_RegWrite,
                    //desde Fetch
                    input wire  [31 : 0] i_pc,
                    input wire  [31 : 0] i_instruction,
                    //para la hazard unit
                    input wire  [4  : 0] i_ID_EX_rt,
                    input wire           is_ID_EX_MemRead,
                    //Salidas
                    output wire [4  : 0] o_rt_addr,
                    output wire [4  : 0] o_rd_addr,
                    output wire [31 : 0] o_sig_extended,//Parte menos significativa de la instruccion ext
                    output wire [31 : 0] o_rs_reg,//registro, no confundir con la direccion
                    output wire [31 : 0] o_rt_reg,//registro, no confundir con la direccion
                    output wire [31 : 0] o_pc,
                    output wire [31 : 0] o_jump_address,
                    output wire          os_RegDst,
                    output wire          os_MemRead,
                    output wire          os_MemWrite,
                    output wire          os_MemtoReg,
                    output wire [3 : 0]  os_ALUop,
                    output wire          os_ALUsrc,
                    output wire          os_RegWrite,
                    output wire          os_shmat,
                    output wire [2 : 0]  os_load_store_type,
                    //para branch unit
                    output wire [5 : 0]  o_op,
                    //para hazard unit
                    output wire          os_pc_write,//esta no entra al latch
                    output wire          os_write_IF_ID,//esta no entra al latch
                    output wire          os_stall//esta si es la señal para meter
                                                //burbuja en las señales de salto
);

    wire [5  : 0]  op;
    wire [4  : 0]  rs;
    wire [4  : 0]  rt;
    wire [4  : 0]  rd;
    wire [15 : 0]  address;

    wire [31:0] rs_reg;
    wire [31:0] rt_reg;
    wire [31:0] signExt; 
    wire [31:0] jump_address;
    
    //buses entre control y mux control
    wire         bus_RegDst;
    wire         bus_MemRead;
    wire         bus_MemWrite;
    wire         bus_MemtoReg;
    wire [3 : 0] bus_ALUop;
    wire         bus_ALUsrc;
    wire         bus_RegWrite;
    wire         bus_shmat;
    wire [2 : 0] bus_load_store_type;

    //buses que salen de hazard unit
    wire         bus_mux_control;

    assign op     = i_instruction[31 -: 6];
    assign rs     = i_instruction[25 -: 5];
    assign rt     = i_instruction[20 -: 5];
    assign rd     = i_instruction[15 -: 5];
    assign address = i_instruction[15 -: 16];
    assign jump_address = {{24{1'b0}}, i_instruction[7 -: 8]};
   
    hazard_unit u_hazard_unit(
                             .is_ID_EX_MemRead(is_ID_EX_MemRead),
                             .i_ID_EX_Rt(i_ID_EX_rt),
                             .i_IF_ID_Rs(rs),
                             .i_IF_ID_Rt(rt),
                             .os_PC_write(os_pc_write),
                             .os_write_IF_ID(os_write_IF_ID),
                             .os_mux_control(bus_mux_control)
                             );
    registers u_register (
                    .clk(clk),
                    .i_wenable(i_RegWrite),
                    .i_addres_rs(rs),
                    .i_addres_rt(rt),
                    .i_addres_data(i_addr_data),
                    .i_data(i_data),
                    .o_data_rs(rs_reg),
                    .o_data_rt(rt_reg)
                    );
    
    // Extension de signo los 16 LSB de intruccion R e I
    sign_extension u_signext_ri_type(
                            .i_entrada(address),
                            .o_salida(signExt)
                            );

    control u_control(
                    .i_op(op),
                    .i_func(address[5:0]),
                    .RegDst(bus_RegDst),
                    .MemRead(bus_MemRead),
                    .MemWrite(bus_MemWrite),
                    .MemtoReg(bus_MemtoReg),
                    .ALUop(bus_ALUop),
                    .ALUsrc(bus_ALUsrc),
                    .RegWrite(bus_RegWrite),
                    .shmat(bus_shmat),
                    .load_store_type(bus_load_store_type)
                    );
    
    MUX_control u_MUX_control(
                    .is_selector(bus_mux_control),
                    .is_RegDst(bus_RegDst),
                    .is_MemRead(bus_MemRead),
                    .is_MemWrite(bus_MemWrite),
                    .is_MemtoReg(bus_MemtoReg),
                    .is_ALUop(bus_ALUop),
                    .is_ALUsrc(bus_ALUsrc),
                    .is_RegWrite(bus_RegWrite),
                    .is_shmat(bus_shmat),
                    .is_load_store_type(bus_load_store_type),
                    .os_RegDst(os_RegDst),
                    .os_MemRead(os_MemRead),
                    .os_MemWrite(os_MemWrite),
                    .os_MemtoReg(os_MemtoReg),
                    .os_ALUop(os_ALUop),
                    .os_ALUsrc(os_ALUsrc),
                    .os_RegWrite(os_RegWrite),
                    .os_shmat(os_shmat),
                    .os_load_store_type (os_load_store_type)
                    );
    assign o_rt_addr = rt;
    assign o_rd_addr = rd;
    assign o_sig_extended = signExt;
    assign o_rs_reg = rs_reg;
    assign o_rt_reg = rt_reg;
    assign o_pc = i_pc;
    assign o_jump_address = jump_address;
    assign o_op = op;
    assign os_stall = bus_mux_control;
endmodule
