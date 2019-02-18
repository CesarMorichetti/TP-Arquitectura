`timescale 1ns / 1ps
module branch_unit(
    input wire           rst,
    input wire  [5  : 0] i_op,
    input wire  [31 : 0] i_sign_ext,
    input wire  [31 : 0] i_jump_address,
    input wire  [31 : 0] i_pc,
    input wire  [31 : 0] i_rs_reg,
    input wire  [31 : 0] i_rt_reg,
    input wire           is_stall,
    //senal para el mux del pc
    output reg          os_taken,
    //senal para el segundo mux en etapa wb, indica que se
    //escribe en el registro la direccion del PC antes del salto
    output reg          os_write_pc,
    //senal para elegir entre el registro 31 o el rd
    //en la etapa wb.
    output reg          os_select_addr_reg,
    //direccion a saltar de la memoria de programa
    //es tanto para jump o para branch
    output reg  [31 : 0] o_jump_address,
    //el pc sale porque es el registro que se guarda en
    //banco de registros en el caso de intruccion JALR y JAL
    output reg  [31 : 0] o_pc_to_reg
    );

    always@(*)
    begin
        if(~rst)begin
            os_taken           = 0;
            os_write_pc        = 0;
            os_select_addr_reg = 0;
            o_jump_address     = 0;
            o_pc_to_reg        = 0;
        end
        else begin
            if(is_stall) begin
                case(i_op)
                    6'b000000: begin
                        case(i_sign_ext[5 -: 6])
                            //JR
                            6'b001000:begin
                                os_taken           = 1;
                                os_write_pc        = 0;
                                os_select_addr_reg = 0;
                                o_jump_address     = i_rs_reg;
                                o_pc_to_reg        = 0;
                            end                      
                            //JALR
                            6'b001001:begin
                                os_taken           = 1;
                                os_write_pc        = 1;
                                os_select_addr_reg = 0;//hace que pase la dir d
                                o_jump_address     = i_rs_reg;
                                o_pc_to_reg        = i_pc; 
                            end
                            default:begin
                                os_taken           = 0;
                                os_write_pc        = 0;
                                os_select_addr_reg = 0;
                                o_jump_address     = 0;
                                o_pc_to_reg        = 0; 
                            end
                        endcase
                    end
                    //BEQ
                    6'b000100:begin
                        if(i_rs_reg == i_rt_reg)begin
                            os_taken           = 1;
                            os_write_pc        = 0;
                            os_select_addr_reg = 0;
                            o_jump_address     = i_pc + i_sign_ext;
                            o_pc_to_reg        = 0; 
                        end 
                        else begin
                            os_taken           = 0;
                            os_write_pc        = 0;
                            os_select_addr_reg = 0;
                            o_jump_address     = 0;
                            o_pc_to_reg        = 0; 
                        end
                    end
                    //BNE
                    6'b000101:begin
                        if(i_rs_reg == i_rt_reg)begin
                            os_taken           = 0;
                            os_write_pc        = 0;
                            os_select_addr_reg = 0;
                            o_jump_address     = 0;
                            o_pc_to_reg        = 0; 
                        end 
                        else begin
                            os_taken           = 1;
                            os_write_pc        = 0;
                            os_select_addr_reg = 0;
                            o_jump_address     = i_pc + i_sign_ext;
                            o_pc_to_reg        = 0; 
                        end
                    end
                    //J
                    6'b000010:begin
                        os_taken           = 1;
                        os_write_pc        = 0;
                        os_select_addr_reg = 0;
                        o_jump_address     = i_jump_address;
                        o_pc_to_reg        = 0;
                    end
                    //JAL
                    6'b000011:begin
                        os_taken           = 1;
                        os_write_pc        = 1;
                        os_select_addr_reg = 1;//selecciona direccion 31
                        o_jump_address     = i_jump_address;
                        o_pc_to_reg        = i_pc;
                    end
                    default:begin
                        os_taken           = 0;
                        os_write_pc        = 0;
                        os_select_addr_reg = 0;
                        o_jump_address     = 0;
                        o_pc_to_reg        = 0; 
                    end
                endcase
            end
            else begin 
                os_taken           = 0;
                os_write_pc        = 0;
                os_select_addr_reg = 0;
                o_jump_address     = 0;
                o_pc_to_reg        = 0;
            end
        end
    end
endmodule
