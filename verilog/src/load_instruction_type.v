`timescale 1ns / 1ps
module load_instruction_type(
                            input  wire [2  : 0] is_load_store_type,
                            input  wire [31 : 0] i_mem_data,
                            output reg [31 : 0] o_load
                            );

    always@(*)begin
        case(is_load_store_type)
            //load bytesigned
            3'b000: o_load = {{24{i_mem_data[7]}},i_mem_data[7:0]}; 
            //load half
            3'b001: o_load = {{16{i_mem_data[15]}},i_mem_data[15:0]};
            //load completa
            3'b011: o_load = i_mem_data;
            //load byte unsigned
            3'b100: o_load = {{24'b0},i_mem_data[7:0]};
            //load half unsigned
            3'b101: o_load = {{16'b0},i_mem_data[15:0]};
            //load word unsigned
            3'b111: o_load = i_mem_data;
            default: o_load = 0;
        endcase
    end

endmodule
