`timescale 1ns / 1ps
module hazard_unit(
                  input  wire         is_ID_EX_MemRead,
                  input  wire [4 : 0] i_ID_EX_Rt,
                  input  wire [4 : 0] i_IF_ID_Rs,
                  input  wire [4 : 0] i_IF_ID_Rt,
                  output reg          os_PC_write,
                  output reg          os_write_IF_ID,
                  output reg          os_mux_control
                  );

    always@(*)begin
        if(is_ID_EX_MemRead == 1'b1 && ((i_ID_EX_Rt == i_IF_ID_Rs) || 
        (i_ID_EX_Rt == i_IF_ID_Rt)))begin
            os_PC_write    = 0;//no escribo el pc
            os_write_IF_ID = 0;//no escribo el latch
            os_mux_control = 0;//pongo todos 0 en control
        end
        else begin
            os_PC_write    = 1;
            os_write_IF_ID = 1;
            os_mux_control = 1;
            
        end
    end

endmodule
