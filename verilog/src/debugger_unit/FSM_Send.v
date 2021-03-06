`timescale 1ns / 1ps
module FSM_Send(
                input wire clk,
                input wire rst,
                input wire [2591 : 0] i_data_from_pipe,
                input wire            is_start,
                input wire            is_tx_done,
                output wire [7   : 0] o_tx_data,
                output reg            os_tx_start,
                output reg            os_done
                );


    localparam [2 : 0] idle         = 3'b000;
    localparam [2 : 0] data         = 3'b001;
    localparam [2 : 0] send         = 3'b010;
    localparam [2 : 0] wait_send    = 3'b011;
    localparam [2 : 0] ready        = 3'b100;

    //Variables
    reg [2  : 0] state_reg;
    reg [2  : 0] state_next;

    reg [11 : 0] count_send_reg; 
    reg [11 : 0] count_send_next; 
    
    reg [7  : 0] data_send_reg;
    reg [7  : 0] data_send_next;


    always@(posedge clk)begin
        if(~rst)begin
            state_reg       <= idle;
            count_send_reg  <= 7;
            data_send_reg   <= 0;
        end
        else begin
            state_reg       <= state_next;
            count_send_reg  <= count_send_next;
            data_send_reg   <= data_send_next;
        end
    end

    always@(*)begin
        case(state_reg)
            idle: begin
                if(is_start)begin
                    state_next      = data;      
                    count_send_next = 7;
                    data_send_next  = 0;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
                else begin
                    state_next      = idle;      
                    count_send_next = 7;
                    data_send_next  = 0;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
            end
            data: begin
                state_next      = send;      
                count_send_next = count_send_reg;
                data_send_next  = i_data_from_pipe[count_send_reg -: 8];
                os_tx_start     = 0;
                os_done         = 0;
            end
            send: begin
                if(count_send_reg > 2591)begin
                    state_next      = ready;      
                    count_send_next = 7;
                    data_send_next  = 0;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
                else begin
                    state_next      = wait_send;      
                    count_send_next = count_send_reg + 8;
                    data_send_next  = data_send_reg;
                    os_tx_start     = 1;
                    os_done         = 0;
                end
            end
            wait_send: begin
                if(is_tx_done==1'b1)begin
                    state_next      = data;      
                    count_send_next = count_send_reg;
                    data_send_next  = data_send_reg;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
                else begin
                    state_next      = wait_send;      
                    count_send_next = count_send_reg;
                    data_send_next  = data_send_reg;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
            end
            ready: begin
                state_next      = idle;      
                count_send_next = 7;
                data_send_next  = 0;
                os_tx_start     = 0;
                os_done         = 1;
            end
            default: begin
                state_next      = idle;      
                count_send_next = 7;
                data_send_next  = 0;
                os_tx_start     = 0;
                os_done         = 0;
            end
        endcase
    end

    assign o_tx_data = data_send_reg; 
endmodule
