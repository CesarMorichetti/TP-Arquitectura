`timescale 1ns / 1ps


module data_memory(
        input wire clk,
        input wire i_Read,
        input wire i_wenable,
        input wire [4:0] i_address,
        input wire [31:0] i_data,
        output reg [31:0] o_data,
        output wire [1023 : 0] o_data_to_debug
    );
    reg [31:0]memory[0:31];
    initial begin
        $readmemb("clear_register.mem", memory);
    end

    always@(posedge clk) begin
        if(i_wenable) begin
            memory[i_address] <= i_data;
        end
    end
    always@(negedge clk) begin
        o_data <= memory[i_address];
    end

    assign o_data_to_debug = { memory[0],
                               memory[1],
                               memory[2],
                               memory[3],
                               memory[4],
                               memory[5],
                               memory[6],
                               memory[7],
                               memory[8],
                               memory[9],
                               memory[10],
                               memory[11],
                               memory[12],
                               memory[13],
                               memory[14],
                               memory[15],
                               memory[16],
                               memory[17],
                               memory[18],
                               memory[19],
                               memory[20],
                               memory[21],
                               memory[22],
                               memory[23],
                               memory[24],
                               memory[25],
                               memory[26],
                               memory[27],
                               memory[28],
                               memory[29],
                               memory[30],
                               memory[31]};
endmodule
