`timescale 1ns / 1ps
module store_instruction_type(
                            input  wire [2  : 0] is_load_store_type,
                            input  wire [31 : 0] i_data_to_mem,
                            output reg  [31 : 0] o_store
                            );

    always@(*)begin
        case(is_load_store_type)
            //store bytesigned
            3'b000: o_store = {{24{i_data_to_mem[7]}},i_data_to_mem[7:0]}; 
            //store half
            3'b001: o_store = {{16{i_data_to_mem[15]}},i_data_to_mem[15:0]};
            //store completa
            3'b011: o_store = i_data_to_mem;
            default: o_store = 0;
        endcase
    end

endmodule
