`timescale 1ns / 1ps


module registers(
        input wire clk,
        input wire i_wenable,
        input wire [4:0] i_addres_rs,
        input wire [4:0] i_addres_rt,
        input wire [4:0] i_addres_data,
        input wire [31:0] i_data,
        output reg [31:0] o_data_rs,
        output reg [31:0] o_data_rt,
        output wire [1023 : 0] o_registers
    );
    reg [31:0]register_file[0:31];
    initial begin
        $readmemb("clear_register.mem", register_file);
    end

    always@(posedge clk) begin
        if(i_wenable) begin
            register_file[i_addres_data] <= i_data;
        end
    end
    always@(negedge clk) begin
        if(i_addres_rs == i_addres_data)begin
            o_data_rs <= i_data;
            o_data_rt <= register_file[i_addres_rt];
        end 
        else begin
            if(i_addres_rt == i_addres_data)begin
                o_data_rs <= register_file[i_addres_rs];
                o_data_rt <= i_data; 
            end 
            else begin
                o_data_rs <= register_file[i_addres_rs];
                o_data_rt <= register_file[i_addres_rt];
            end
        end
    end
        assign o_registers = {register_file[0],
                          register_file[1],
                          register_file[2],
                          register_file[3],
                          register_file[4],
                          register_file[5],
                          register_file[6],
                          register_file[7],
                          register_file[8],
                          register_file[9],
                          register_file[10],
                          register_file[11],
                          register_file[12],
                          register_file[13],
                          register_file[14],
                          register_file[15],
                          register_file[16],
                          register_file[17],
                          register_file[18],
                          register_file[19],
                          register_file[20],
                          register_file[21],
                          register_file[22],
                          register_file[23],
                          register_file[24],
                          register_file[25],
                          register_file[26],
                          register_file[27],
                          register_file[28],
                          register_file[29],
                          register_file[30],
                          register_file[31]
                        };
endmodule
