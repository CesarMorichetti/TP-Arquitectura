`timescale 1ns / 1ps
module FSM_Load(
               input wire           clk,
               input wire           rst,
               input wire  [7  : 0] i_rx_data,
               input wire           is_rx_done,
               input wire           is_start,
               output wire [7  : 0] o_address,
               output wire [31 : 0] o_instruction,
               output reg           os_WriteMem,
               output reg           os_done
               );
    
    //Estados 
    localparam [2 : 0] idle         = 3'b000;
    localparam [2 : 0] receive      = 3'b001;
    localparam [2 : 0] hold         = 3'b010;
    localparam [2 : 0] set_write    = 3'b011;
    localparam [2 : 0] down_write   = 3'b100;
    localparam [2 : 0] clear        = 3'b101;
    localparam [2 : 0] ready        = 3'b110;

    //Variables
    reg [2 : 0] state_reg;
    reg [2 : 0] state_next;
    //contador de bytes para generar una instruccion
    reg [1 : 0] byte_count_reg;
    reg [1 : 0] byte_count_next;

    //instruccion
    reg [31 : 0] instruction_reg;
    reg [31 : 0] instruction_next;

    //addres
    reg [7 : 0] address_reg;
    reg [7 : 0] address_next;
    
    always@(posedge clk)begin
        if(~rst)begin
            state_reg       <= idle;
            byte_count_reg  <= 0;
            instruction_reg <= 0;
            address_reg      <= 8'b11111111;
        end
        else begin
            state_reg       <= state_next; 
            byte_count_reg  <= byte_count_next; 
            instruction_reg <= instruction_next; 
            address_reg     <= address_next; 
        end
    end
    always@(*)begin
        case(state_reg)
            idle: begin
                if(is_start) begin
                    state_next       = receive;
                    byte_count_next  = byte_count_reg;
                    instruction_next = instruction_reg;
                    address_next     = address_reg;
                    os_WriteMem      = 1'b0;
                    os_done          = 1'b0;
                end
                else begin
                    state_next       = idle;
                    byte_count_next  = byte_count_reg;
                    instruction_next = instruction_reg;
                    address_next     = address_reg;
                    os_WriteMem      = 1'b0;
                    os_done          = 1'b0;
                end
            end
            receive: begin
                if(is_rx_done)begin
                    instruction_next = {i_rx_data, instruction_reg[31:8]};
                    if(byte_count_reg == 2'b11)begin
                        state_next       = hold;
                        address_next     = address_reg + 1;
                        byte_count_next  = 0;
                        os_WriteMem      = 1'b0;
                        os_done          = 1'b0;
                    end
                    else begin
                        state_next       = state_reg;
                        address_next     = address_reg;
                        byte_count_next  = byte_count_reg + 1;
                        os_WriteMem      = 1'b0;
                        os_done          = 1'b0;
                    end
                end
                else begin
                    state_next       = state_reg;
                    address_next     = address_reg;
                    instruction_next = instruction_reg; 
                    byte_count_next  = byte_count_reg;
                    os_WriteMem      = 1'b0;
                    os_done          = 1'b0;
                end
            end
            hold: begin
                state_next       = set_write;
                address_next     = address_reg;
                instruction_next = instruction_reg; 
                byte_count_next  = byte_count_reg;
                os_WriteMem      = 1'b0;
                os_done          = 1'b0;
            end
            set_write: begin
                state_next       = down_write;
                address_next     = address_reg;
                instruction_next = instruction_reg; 
                byte_count_next  = byte_count_reg;
                os_WriteMem      = 1'b1;
                os_done          = 1'b0;
            end
            down_write: begin
                state_next       = clear;
                address_next     = address_reg;
                instruction_next = instruction_reg; 
                byte_count_next  = byte_count_reg;
                os_WriteMem      = 1'b0;
                os_done          = 1'b0;
            end
            clear: begin
                if(instruction_reg == 'hffffffff)begin
                    state_next       = ready;
                    address_next     = 8'b00000000;
                    instruction_next = 0; 
                    byte_count_next  = byte_count_reg;
                    os_WriteMem      = 1'b0;
                    os_done          = 1'b0;
                end
                else begin
                    state_next       = receive;
                    address_next     = address_reg;
                    instruction_next = 0; 
                    byte_count_next  = byte_count_reg;
                    os_WriteMem      = 1'b0;
                    os_done          = 1'b0;
                end
            end
            ready: begin
                state_next       = idle;
                address_next     = address_reg;
                instruction_next = instruction_reg; 
                byte_count_next  = byte_count_reg;
                os_WriteMem      = 1'b0;
                os_done          = 1'b1;
            end
            default: begin
                state_next       = state_reg;
                address_next     = address_reg;
                instruction_next = instruction_reg; 
                byte_count_next  = byte_count_reg;
                os_WriteMem      = 1'b0;
                os_done          = 1'b0;
            end
        endcase
    end
    assign o_address     = address_reg;
    assign o_instruction = instruction_reg;
endmodule
