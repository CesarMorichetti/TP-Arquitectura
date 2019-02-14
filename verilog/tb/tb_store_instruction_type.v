`timescale 1ns / 1ps
module tb_store_instruction_type();
    reg  [2  : 0] is_load_store_type;
    reg  [31 : 0] i_data_to_mem;
    wire [31 : 0] o_store;

    initial begin
        #100
        //LB
        is_load_store_type = 3'b000;
        i_data_to_mem         = 'h00000f81;
        //LH
        #10
        is_load_store_type = 3'b001;
        i_data_to_mem         = 'h000f8001;
        //LW
        #10
        is_load_store_type = 3'b011;
        i_data_to_mem         = 'h04000001;
        //DEF
        #10
        is_load_store_type = 3'b110;
        i_data_to_mem         = 'h00300230;


    end
    store_instruction_type u_store_instruction_type(
                            .is_load_store_type(is_load_store_type),
                            .i_data_to_mem(i_data_to_mem),
                            .o_store(o_store)
                            );
endmodule
