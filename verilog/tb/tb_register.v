`timescale 1ns / 1ps
module tb_registers();

    reg clk;
    reg w_enable;
    reg [4:0] addres_rs;
    reg [4:0] addres_rt;
    reg [4:0] addres_rd;
    reg [31:0] data_rd;
    wire [31:0] data_rs;
    wire [31:0] data_rt;

    initial begin
    
        clk = 0;
        data_rd=0;
        w_enable = 0;
        addres_rs = 0;
        addres_rt = 0;
        addres_rd = 0;
        data_rd = 0;
        
        #100
        w_enable = 1;
        addres_rd = 5'b00011;
        data_rd = 'hff010000;
        #2 
        w_enable = 1;
        addres_rd = 5'b00001;
        data_rd = 'hff010011;
        addres_rs = 5'b00001;
        addres_rt = 5'b00011;
        #2
        w_enable = 0;
        addres_rs = 5'b00001;
        addres_rt = 5'b00000;
        #2
        addres_rs = 5'b00000;
        addres_rt = 5'b00011;
                
    end

    always #1 clk = ~clk;

    registers u_registers(
        .clk(clk),
        .i_wenable(w_enable),
        .i_addres_rs(addres_rs),
        .i_addres_rt(addres_rt),
        .i_addres_data(addres_rd),
        .i_data(data_rd),
        .o_data_rs(data_rs),
        .o_data_rt(data_rt)
    );

endmodule
