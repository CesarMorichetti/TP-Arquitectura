`timescale 1ns / 1ps
module Stage_Decode(
                    input wire           clk,
                    //desde WB
                    input wire  [4  : 0] i_addr_data,//direccion registro a escribir
                    input wire  [31 : 0] i_data, //contenido a escribir
                    input wire           i_RegWrite,
                    //desde Fetch
                    input wire  [31 : 0] i_pc,
                    input  wire [31 : 0] i_instruction,
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
                    output wire [5 : 0]  o_op
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



    assign op     = i_instruction[31 -: 6];
    assign rs     = i_instruction[25 -: 5];
    assign rt     = i_instruction[20 -: 5];
    assign rd     = i_instruction[15 -: 5];
    assign address = i_instruction[15 -: 16];
    assign jump_address = {{24{1'b0}}, i_instruction[7 -: 8]};
   
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
                    .RegDst(os_RegDst),
                    .MemRead(os_MemRead),
                    .MemWrite(os_MemWrite),
                    .MemtoReg(os_MemtoReg),
                    .ALUop(os_ALUop),
                    .ALUsrc(os_ALUsrc),
                    .RegWrite(os_RegWrite),
                    .shmat(os_shmat),
                    .load_store_type(os_load_store_type)
                    );
    
    assign o_rt_addr = rt;
    assign o_rd_addr = rd;
    assign o_sig_extended = signExt;
    assign o_rs_reg = rs_reg;
    assign o_rt_reg = rt_reg;
    assign o_pc = i_pc;
    assign o_jump_address = jump_address;
    assign o_op = op;
endmodule
