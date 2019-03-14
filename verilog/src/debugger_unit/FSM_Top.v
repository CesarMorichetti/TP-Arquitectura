`timescale 1ns / 1ps
module FSM_Top(
                input wire             rst,
                input wire             clk,
                input wire  [7    : 0] i_rx_data,       //data del receptor
                input wire  [2557 : 0] i_data_from_pipe,//data del pipe
                input wire             is_rx_done,      //recibio un dato
                input wire             is_tx_done,      //termino de transmitir un dato
                input wire             is_stop_pipe,    //señal de finalizacion del pipe
                output reg             o_step,          //enable pipe
                output wire [7    : 0] o_address,       //addres para program memory
                output wire [31   : 0] o_instruction,   //instruccion para program memory
                output wire [7    : 0] o_tx_data,       //data a transmitir
                output wire            os_tx_start,     //comenzar a transmitir
                output wire            os_MemWrite,      //escribir la program memory
                output reg             o_reset_pipe,            
                output reg             o_led            //Led estado idle
              );
     
    //Estados 
    localparam [2 : 0] idle      = 3'b000;
    localparam [2 : 0] load      = 3'b001;
    localparam [2 : 0] wait_load = 3'b010;
    localparam [2 : 0] fast      = 3'b011;
    localparam [2 : 0] wait_fast = 3'b100;
    localparam [2 : 0] step      = 3'b101;
    localparam [2 : 0] wait_step = 3'b110;

    //Variables
    reg [2 : 0] state_reg;
    reg [2 : 0] state_next;

    //signals 
    reg start_load;
    reg start_fast;
    reg start_step;
    reg start_send;
    
    //clk count
    reg [31 : 0]clk_count;

    wire load_done;
    wire fast_done;
    wire step_done;
    wire send_done;

    wire step_signal_from_fast;
    wire start_send_from_fast;
    wire step_signal_from_step;
    wire start_send_from_step;
    wire [31 : 0] bus_clk_count_from_fast;
    //wire [31 : 0] bus_clk_count_from_step;
    
    always@(posedge clk)begin
        if(~rst)begin
            state_reg <= idle;
        end
        else begin
            state_reg <= state_next;
        end
    end

    always@(*)begin
        case(state_reg)
            idle: begin
                o_led      = 1;
                o_reset_pipe = 0;
                if(is_rx_done)begin
                    case(i_rx_data)
                        8'b00000001: begin
                            state_next = load;
                            start_load = 1'b0;
                            start_fast = 1'b0;
                            start_step = 1'b0;
                            o_step     = 1'b0;
                            clk_count  = 0;
                            start_send = 0;
                        end
                        8'b00000010: begin
                            state_next = fast;
                            start_load = 1'b0;
                            start_fast = 1'b0;
                            start_step = 1'b0;
                            o_step     = 1'b0;
                            clk_count  = 0;
                            start_send = 0;
                        end
                        8'b00000011: begin
                            state_next = step;
                            start_load = 1'b0;
                            start_fast = 1'b0;
                            start_step = 1'b0;
                            o_step     = 1'b0;
                            clk_count  = 0;
                            start_send = 0;
                        end
                        default: begin
                            state_next = idle;
                            start_load = 1'b0;
                            start_fast = 1'b0;
                            start_step = 1'b0;
                            o_step     = 1'b0;
                            clk_count  = 0;
                            start_send = 0;
                        end
                    endcase
                end
                else begin
                    state_next = idle; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = 1'b0;
                    clk_count  = 0;
                    start_send = 0;
                end
            end
            load: begin
                o_led      = 0;
                o_reset_pipe = 1;
                state_next = wait_load; 
                start_load = 1'b1;
                start_fast = 1'b0;
                start_step = 1'b0;
                o_step     = 1'b0;
                clk_count  = 0;
                start_send = 0;
            end
            wait_load: begin
                o_led      = 0;
                o_reset_pipe = 1;
                if(load_done)begin
                    state_next = idle; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = 1'b0;
                    clk_count  = 0;
                    start_send = 0;
                end
                else begin
                    state_next = wait_load; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = 1'b0;
                    clk_count  = 0;
                    start_send = 0;
                end
            end
            fast: begin
                o_led      = 0;
                o_reset_pipe = 1;
                state_next = wait_fast; 
                start_load = 1'b0;
                start_fast = 1'b1;
                start_step = 1'b0;
                o_step     = 1'b0;
                clk_count  = 0;
                start_send = 0;
            end
            wait_fast: begin
                o_led      = 0;
                o_reset_pipe = 1;
                if(fast_done)begin
                    state_next = idle; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = step_signal_from_fast;//lo que venga de fsm de fast
                    clk_count  = bus_clk_count_from_fast;//wire del modulo
                    start_send = 0;
                end
                else begin
                    state_next = wait_fast; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = step_signal_from_fast;//lo que venga de fsm de fast
                    clk_count  = bus_clk_count_from_fast; //wire del modulo
                    start_send = start_send_from_fast;
                end
            end
            step: begin
                o_led      = 0;
                o_reset_pipe = 1;
                state_next = wait_step; 
                start_load = 1'b0;
                start_fast = 1'b0;
                start_step = 1'b1;
                o_step     = 1'b0;
                clk_count  = 0;
                start_send = 0;
            end
            wait_step: begin
                o_led      = 0;
                o_reset_pipe = 1;
                if(step_done)begin
                    state_next = idle; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = step_signal_from_step;
                    clk_count  = 0;
                    start_send = start_send_from_step;
                end
                else begin
                    state_next = wait_step; 
                    start_load = 1'b0;
                    start_fast = 1'b0;
                    start_step = 1'b0;
                    o_step     = step_signal_from_step;
                    clk_count  = 0;
                    start_send = start_send_from_step;
                end
            end
            default: begin
                o_led      = 0;
                o_reset_pipe = 1;
                state_next = idle; 
                start_load = 1'b0;
                start_fast = 1'b0;
                start_step = 1'b0;
                o_step     = 1'b0;
                clk_count  = 0;
                start_send = 0;
            end
        endcase
    end

    FSM_Load u_FSM_Load(
                       .clk(clk),
                       .rst(rst),
                       .i_rx_data(i_rx_data),
                       .is_rx_done(is_rx_done),
                       .is_start(start_load),
                       .o_address(o_address),
                       .o_instruction(o_instruction),
                       .os_WriteMem(os_MemWrite),
                       .os_done(load_done)
                       );
    FSM_Fast u_FSM_Fast(
                       .clk(clk),
                       .rst(rst),
                       .is_start(start_fast),
                       .is_done_send(send_done),
                       .is_stop_pipe(is_stop_pipe),
                       .os_step(step_signal_from_fast),     
                       .os_start_send(start_send_from_fast),
                       .os_done(fast_done),
                       .o_clk_count(bus_clk_count_from_fast)
                     );

    FSM_Send u_FSM_Send(
                       .clk(clk),
                       .rst(rst),
                       .i_data_from_pipe({{2{1'b0}},
                                         clk_count,
                                         i_data_from_pipe}),
                       .is_start(start_send),
                       .is_tx_done(is_tx_done),
                       .o_tx_data(o_tx_data),
                       .os_tx_start(os_tx_start),
                       .os_done(send_done)
                       );

    FSM_Step u_FSM_Step(
                      .clk(clk),
                      .rst(rst),
                      .is_start(start_step),
                      .is_done_send(send_done),
                      .is_stop_pipe(is_stop_pipe),
                      .i_rx_data(i_rx_data),
                      .is_rx_done(is_rx_done),
                      .os_step(step_signal_from_step),
                      .os_start_send(start_send_from_step),
                      .os_done(step_done)
                      //.o_clk_count(bus_clk_count_from_step)
                      );
    endmodule
