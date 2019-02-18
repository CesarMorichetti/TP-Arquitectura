`timescale 1ns / 1ps
module foward_unit (
                   input wire         EX_MEM_RegWrite,
                   input wire [4 : 0] EX_MEM_Rd,
                   input wire [4 : 0] ID_EX_Rs,
                   input wire [4 : 0] ID_EX_Rt,
                   input wire         MEM_WB_RegWrite,
                   input wire [4 : 0] MEM_WB_Rd,
                   output wire [1 : 0] o_MUX_A_signal,
                   output wire [1 : 0] o_MUX_B_signal
                   ); 

    assign o_MUX_A_signal = (EX_MEM_RegWrite && EX_MEM_Rd != 5'b00000 && EX_MEM_Rd == ID_EX_Rs) ? 2'b10 :
                            (MEM_WB_RegWrite && MEM_WB_Rd != 5'b00000 && MEM_WB_Rd == ID_EX_Rs) ? 2'b01 :
                                                                                                  2'b00;
    assign o_MUX_B_signal = (EX_MEM_RegWrite && EX_MEM_Rd != 5'b00000 && EX_MEM_Rd == ID_EX_Rt) ? 2'b10 :
                            (MEM_WB_RegWrite && MEM_WB_Rd != 5'b00000 && MEM_WB_Rd == ID_EX_Rt) ? 2'b01 :
                                                                                                  2'b00;




/*
    always@(*) begin
        if(EX_MEM_RegWrite          && 
           EX_MEM_Rd != 5'b00000    && 
           EX_MEM_Rd == ID_EX_Rs) begin
            o_MUX_A_signal = 2'b10;
        end
        else if(MEM_WB_RegWrite         && 
                MEM_WB_Rd  != 5'b00000  && 
                EX_MEM_Rd  != ID_EX_Rs  &&
                MEM_WB_Rd  == ID_EX_Rs  ) begin
                    o_MUX_A_signal = 2'b01;
            end
        else begin
            o_MUX_A_signal = 2'b00;
        end
    end
    always@(*) begin
        if(EX_MEM_RegWrite          && 
           EX_MEM_Rd != 5'b00000    && 
           EX_MEM_Rd == ID_EX_Rt) begin
            o_MUX_B_signal = 2'b10;
        end
        else if(MEM_WB_RegWrite         && 
                MEM_WB_Rd  != 5'b00000  && 
                EX_MEM_Rd  != ID_EX_Rt  &&
                MEM_WB_Rd  == ID_EX_Rt  ) begin
            o_MUX_B_signal = 2'b01;
        end
        else begin
            o_MUX_B_signal = 2'b00;
        end
    end
*/
endmodule
