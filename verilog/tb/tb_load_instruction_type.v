`timescale 1ns / 1ps
module tb_load_instruction_type();
    reg  [2  : 0] is_load_store_type;
    reg  [31 : 0] i_mem_data;
    wire [31 : 0] o_load;

    initial begin
        #100
        //LB
        is_load_store_type = 3'b000;
        i_mem_data         = 'h00000f81;
        //LH
        #10
        is_load_store_type = 3'b001;
        i_mem_data         = 'h000f8001;
        //LW
        #10
        is_load_store_type = 3'b011;
        i_mem_data         = 'h04000001;
        //LWU
        #10
        is_load_store_type = 3'b111;
        i_mem_data         = 'h80000100;
        //LBU
        #10
        is_load_store_type = 3'b100;
        i_mem_data         = 'h00400081;
        //LHU
        #10
        is_load_store_type = 3'b101;
        i_mem_data         = 'h00208001;
        //DEF
        #10
        is_load_store_type = 3'b110;
        i_mem_data         = 'h00300230;


    end
    load_instruction_type u_load_instruction_type(
                            .is_load_store_type(is_load_store_type),
                            .i_mem_data(i_mem_data),
                            .o_load(o_load)
                            );
endmodule
