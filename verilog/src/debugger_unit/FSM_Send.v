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


    localparam [1 : 0] idle  = 2'b00;
    localparam [1 : 0] data  = 2'b01;
    localparam [1 : 0] send  = 2'b10;
    localparam [1 : 0] ready = 2'b11;

    //Variables
    reg [1  : 0] state_reg;
    reg [1  : 0] state_next;

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
                if(count_send_reg == 324)begin
                    state_next      = ready;      
                    count_send_next = 7;
                    data_send_next  = 0;
                    os_tx_start     = 0;
                    os_done         = 0;
                end
                else begin
                    if(is_tx_done)begin
                        state_next      = data;      
                        count_send_next = count_send_reg + 8;
                        data_send_next  = data_send_reg;
                        os_tx_start     = 1;
                        os_done         = 0;
                    end
                    else begin
                        state_next      = send;      
                        count_send_next = count_send_reg;
                        data_send_next  = data_send_reg;
                        os_tx_start     = 0;
                        os_done         = 0;
                    end
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
