`timescale 1ns / 1ps
module FSM_Fast(
               input wire           clk,
               input wire           rst,
               input wire           is_start,
               input wire           is_done_send,
               input wire           is_stop_pipe,
               output reg           os_step,     
               output reg           os_start_send,
               output reg           os_done,
               output wire [31 : 0] o_clk_count 
               );
    
    //Estados 
    localparam [2 : 0] idle           = 3'b000;
    localparam [2 : 0] start_fast     = 3'b001;
    localparam [2 : 0] wait_pipe_done = 3'b010;
    localparam [2 : 0] start_send     = 3'b011;
    localparam [2 : 0] wait_send_done = 3'b100;
    localparam [2 : 0] ready          = 3'b101;

    //Variables
    reg [2 : 0] state_reg;
    reg [2 : 0] state_next;
    
    reg flag_count;
    reg flag_clear_count;
    reg [31 : 0] count;
    always@(posedge clk)begin
        if(~rst)begin
            state_reg   <= idle;  
            count       <= 0;
        end
        else begin
            state_reg   <= state_next;
            if(flag_count == 1'b1)begin
                count <= count + 1;
            end
            else begin
                if(flag_clear_count == 1'b1)begin
                    count <= 0;
                end
                else begin
                    count <= count;
                end
            end
        end
    end
    always@(*)begin
        case(state_reg)
            idle: begin
                if(is_start)begin
                    state_next       = start_fast;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b0;
                    os_done          = 1'b0;
                    flag_count       = 1'b0;
                    flag_clear_count = 1'b0;
                end
                else begin
                    state_next       = idle;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b0;
                    os_done          = 1'b0;
                    flag_count       = 1'b0;
                    flag_clear_count = 1'b0;
                end
            end
            start_fast: begin
                state_next       = wait_pipe_done;
                os_start_send    = 1'b0;  
                os_step          = 1'b1;
                os_done          = 1'b0;
                flag_count       = 1'b1;
                flag_clear_count = 1'b0;
            end
            wait_pipe_done: begin
                if(is_stop_pipe)begin
                    state_next       = start_send;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b0;
                    os_done          = 1'b0;
                    flag_count       = 1'b0;
                    flag_clear_count = 1'b0;
                end
                else begin
                    state_next       = wait_pipe_done;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b1;
                    os_done          = 1'b0;
                    flag_count       = 1'b1;
                    flag_clear_count = 1'b0;
                end
            end
            start_send: begin
                state_next       = wait_send_done;
                os_start_send    = 1'b1;  
                os_step          = 1'b0;
                os_done          = 1'b0;
                flag_count       = 1'b0;
                flag_clear_count = 1'b0;
            end
            wait_send_done: begin
                if(is_done_send)begin
                    state_next       = ready;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b0;
                    os_done          = 1'b0;
                    flag_count       = 1'b0;
                    flag_clear_count = 1'b0;
                end
                else begin
                    state_next       = wait_send_done;
                    os_start_send    = 1'b0;  
                    os_step          = 1'b0;
                    os_done          = 1'b0;
                    flag_count       = 1'b0;
                    flag_clear_count = 1'b0;
                end
            end
            ready: begin
                state_next       = idle;
                os_start_send    = 1'b0;  
                os_step          = 1'b0;
                os_done          = 1'b1;
                flag_count       = 1'b0;
                flag_clear_count = 1'b1;
            end
            default: begin
                state_next       = idle;
                os_start_send    = 1'b0;  
                os_step          = 1'b0;
                os_done          = 1'b0;
                flag_count       = 1'b0;
                flag_clear_count = 1'b0;
            end
        endcase
    end
    assign o_clk_count = count; 
endmodule
