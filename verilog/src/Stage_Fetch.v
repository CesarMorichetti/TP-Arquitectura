`timescale 1ns / 1ps
module Stage_Fetch(
    input   wire            clk,
	input   wire            rst,
    input   wire            i_step,
    //para escribir program memory
    input   wire            i_program_memory_write,
    input   wire [31 : 0]   i_instruction_write,
    input   wire [7  : 0]   i_address_write,

	//Entradas a la etapa desde etapa MEM
	//input   wire            i_MUX_branch_selector,
    //input   wire            i_MUX_jump_selector,
    //input   wire [31 : 0]   i_branch_address,
    //input   wire [31 : 0]   i_jump_address,
	input   wire            i_taken,
    input   wire [31 : 0]   i_branch_address,
	// Entradas desde la Hazard Detection Unit
	input   wire            i_PC_write,
	//salida de la etapa IF
	output  wire [31 : 0]   o_pc,
    output  wire [31 : 0]   o_instruction,
    output  wire            os_stop_pipe
    );
    
    
    wire [31:0] bus1; //entrada a MUX y salida de ADD
    wire [31:0] bus2; //salida MUX y entrada a PC
    wire [31:0] bus3; //salida PC y entrada a ADD y InstMemory
    wire [31:0] bus4; //salida InstMemory
    wire [7 :0] bus_mux_memory; //bus entre mux
/*
    MUX2to1 u_MUX_branch(
            .i_selector(i_MUX_branch_selector),
            .i_entradaMUX_0(bus1),
            .i_entradaMUX_1(i_branch_address),
            .o_salidaMUX(bus5)
            );
*/
//Multiplexor de PC
    MUX2to1 #(.LEN(32))
            u_MUX_PC(
            .i_selector(i_taken),
            .i_entradaMUX_0(bus1),
            .i_entradaMUX_1(i_branch_address),
            .o_salidaMUX(bus2)
            );

    //PC
    PC     u_PC(
            .clk(clk),
            .rst(rst),
            .i_step(i_step),
            .i_PC_write(i_PC_write),
            .i_PC(bus2),
            .o_PC(bus3)
            );
     
    //ADD
    adder_pc   u_addr_pc(
            .i_adder(bus3), //32 bits
            .o_adder(bus1) //32  bits
            );

    //MUX para determinar si el address es del debug o del pc
    MUX2to1 #(.LEN(8))
            u_MUX_memory_address(
            .i_selector(i_program_memory_write),
            .i_entradaMUX_0(bus3[7:0]),
            .i_entradaMUX_1(i_address_write),
            .o_salidaMUX(bus_mux_memory)
            );

    //instruction_memory
    BRAM u_instruction_memory(
                        .clk(clk),
                        .i_w_enable(i_program_memory_write),
                        .i_address(bus_mux_memory),
                        .i_data(i_instruction_write),
                        .o_data(bus4)
                        );

    stop_pipe u_stop_pipe(
             .i_instruction(bus4),
             .os_stop_pipe(os_stop_pipe)
             );
    assign o_pc             = bus1;
    assign o_instruction    = bus4;
endmodule
