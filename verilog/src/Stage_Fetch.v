`timescale 1ns / 1ps
module Stage_Fetch(
    input   wire            clk,
	input   wire            rst,
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
    output  wire [31 : 0]   o_instruction
    );
    
    
    wire [31:0] bus1; //entrada a MUX y salida de ADD
    wire [31:0] bus2; //salida MUX y entrada a PC
    wire [31:0] bus3; //salida PC y entrada a ADD y InstMemory
    wire [31:0] bus4; //salida InstMemory
    //wire [31:0] bus5; //bus entre mux
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
            .i_PC_write(i_PC_write),
            .i_PC(bus2),
            .o_PC(bus3)
            );
     
    //ADD
    adder_pc   u_addr_pc(
            .i_adder(bus3), //32 bits
            .o_adder(bus1) //32  bits
            );

    //instruction_memory
    BRAM u_instruction_memory(
                        .clk(clk),
                        .i_w_enable(0),
                        .i_address(bus3[7:0]),
                        .i_data('h00000000),
                        .o_data(bus4)
                        );

    assign o_pc             = bus1;
    assign o_instruction    = bus4;
endmodule
