`timescale 1ns / 1ps
module FSM_Step(
               input wire           clk,
               input wire           rst,
               input wire           is_start,
               input wire           is_done_send,
               input wire           is_stop_pipe,
               input wire [7:0]     i_rx_data,
               input wire           is_rx_done,
               output reg           os_step,     
               output reg           os_start_send,
               output reg           os_done,
               output wire [31 : 0] o_clk_count
               );

    //Estados 
    localparam [3 : 0] idle             = 4'b0000;
    localparam [3 : 0] wait_step_signal = 4'b0001;
    localparam [3 : 0] start_step       = 4'b0010;
    localparam [3 : 0] stop_step        = 4'b0011;
    localparam [3 : 0] wait_clk         = 4'b0100;
    localparam [3 : 0] start_send       = 4'b0101;
    localparam [3 : 0] wait_send_done   = 4'b0110;
    localparam [3 : 0] check_stop_pipe  = 4'b0111;
    localparam [3 : 0] ready            = 4'b1000;

    //Variables
    reg [3 : 0] state_reg;
    reg [3 : 0] state_next;
    
    reg [31 : 0] count_reg;
    reg [31 : 0] count_next;
    //reg [31 : 0] count;
    
    always@(posedge clk)begin
        if(~rst)begin
            state_reg <= idle;
            count_reg     <= 0;
        end
        else begin
            state_reg <= state_next;
            count_reg <= count_next;
        end
    end
    
    always@(*)begin
        case(state_reg)
            idle: begin
                    count_next = count_reg;
                if(is_start)begin
                    state_next = wait_step_signal;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
                else begin
                    state_next = idle;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
            end
            wait_step_signal: begin
                    count_next = count_reg;
                if(is_rx_done)begin
                    if(i_rx_data == 8'b00001111)begin
                        state_next = start_step;
                        os_start_send = 1'b0;
                        os_step       = 1'b0;
                        os_done       = 1'b0;
                        //flag_count    = 1'b0;
                        //flag_clear_count = 1'b0;
                    end
                    else begin
                        state_next = wait_step_signal;
                        os_start_send = 1'b0;
                        os_step       = 1'b0;
                        os_done       = 1'b0;
                        //flag_count    = 1'b0;
                        //flag_clear_count = 1'b0;
                    end
                end
                else begin
                    state_next = wait_step_signal;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
            end
            start_step: begin
                state_next = stop_step;
                os_start_send = 1'b0;
                os_step       = 1'b1;
                os_done       = 1'b0;
                count_next    = count_reg + 1;
                //flag_count    = 1'b1;
                //flag_clear_count = 1'b0;
            end
            stop_step: begin
                    count_next = count_reg;
                state_next = wait_clk;
                os_start_send = 1'b0;
                os_step       = 1'b0;
                os_done       = 1'b0;
                //flag_count    = 1'b0;
                //flag_clear_count = 1'b0;
            end
            wait_clk: begin
                    count_next = count_reg;
                state_next = start_send;
                os_start_send = 1'b0;
                os_step       = 1'b0;
                os_done       = 1'b0;
                //flag_count    = 1'b0;
                //flag_clear_count = 1'b0;
            end
            start_send: begin
                    count_next = count_reg;
                state_next = wait_send_done;
                os_start_send = 1'b1;
                os_step       = 1'b0;
                os_done       = 1'b0;
                //flag_count    = 1'b0;
                //flag_clear_count = 1'b0;
            end
            wait_send_done: begin
                    count_next = count_reg;
                if(is_done_send)begin
                    state_next = check_stop_pipe;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
                else begin
                    state_next = wait_send_done;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
            end
            check_stop_pipe: begin
                    count_next = count_reg;
                if(is_stop_pipe == 1'b0)begin
                    state_next = ready;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
                else begin
                    state_next = wait_step_signal;
                    os_start_send = 1'b0;
                    os_step       = 1'b0;
                    os_done       = 1'b0;
                    //flag_count    = 1'b0;
                    //flag_clear_count = 1'b0;
                end
            end
            ready: begin
                    count_next = count_reg;
                state_next = idle;
                os_start_send = 1'b0;
                os_step       = 1'b0;
                os_done       = 1'b1;
                //flag_count    = 1'b0;
                //flag_clear_count = 1'b1;
            end
            default: begin
                    count_next = count_reg;
                state_next = idle;
                os_start_send = 1'b0;
                os_step       = 1'b0;
                os_done       = 1'b0;
                //flag_count    = 1'b0;
                //flag_clear_count = 1'b0;
            end
        endcase
    end
    assign o_clk_count = count_reg;
endmodule
