`timescale 1ns / 1ps


module registers(
        input wire clk,
        input wire i_wenable,
        input wire [4:0] i_addres_rs,
        input wire [4:0] i_addres_rt,
        input wire [4:0] i_addres_data,
        input wire [31:0] i_data,
        output reg [31:0] o_data_rs,
        output reg [31:0] o_data_rt
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
endmodule
