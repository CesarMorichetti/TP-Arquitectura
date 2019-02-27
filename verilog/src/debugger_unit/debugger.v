`timescale 1ns / 1ps
module debugger(
                input wire           rst,
                input wire           clk,
                input wire           i_rx_done,
                input wire           i_tx_done,
                input wire  [7  : 0] i_data,
                input wire           is_stop_pipe,
                input wire  [2559 : 0] i_data_from_mips,
                output wire          o_step,
                output reg           o_MemWrite,
                output wire [31 : 0] o_instruction,
                output wire [7  : 0] o_address,
                output wire [7  : 0] o_data_send,
                output wire          o_tx_start
               );

	//declaraciones de los estados generales
	localparam [1 : 0] idle 	 = 2'b00;
    localparam [1 : 0] operation = 2'b01;
    localparam [1 : 0] load      = 2'b10;
    localparam [1 : 0] fast      = 2'b11;
    //declaracion estados de cada modo de operacion
    //LOAD
    localparam [1 : 0] Load_receive = 2'b00;//recibe los 4 bytes
    localparam [1 : 0] Load_send    = 2'b01;//manda a program memory la instr
    localparam [1 : 0] Load_ready   = 2'b10;//avisa que ya se cargo la PM
    //FAST
    localparam [1 : 0] Fast_start   = 2'b00;//step en 1 hasta recibir stop
    localparam [1 : 0] Fast_send    = 2'b01;//send data
    localparam [1 : 0] Fast_ready   = 2'b10;//avisa que ya termino de enviar
    
    //variables maquina de estados principal
    reg [1 : 0] state_reg;
    reg [1 : 0] state_next;
    
    reg [7 : 0] data_i_reg;
    reg [7 : 0] data_i_next;

    reg [7 : 0] data_send_reg;
    reg [7 : 0] data_send_next;
    reg         tx_start_reg;
    reg         tx_start_next;
    
    reg         step_reg;
    reg         step_next;

	//****variables locales para operacion load****
	reg [1 : 0] state_load_reg;
	reg [1 : 0] state_load_next;
    //----cuenta hasta 4 que son los 4 bytes de 
    //----una linea de memoria
    reg [1 : 0] count_byte_reg;
    reg [1 : 0] count_byte_next;
    //----se guarda cada byte que se recibe 
    //----cada 4 este registro va a tener una
    //----instruccion a enviar a la Program mem
    reg [31 : 0] instruction_reg;
    reg [31 : 0] instruction_next;
    reg [7  : 0] address_reg;
    reg [7  : 0] address_next;

	//****variables locales para operacion load****
	reg [1 : 0] state_fast_reg;
	reg [1 : 0] state_fast_next;
    //reg [2553 : 0] data_mips_reg;
    //reg [2553 : 0] data_mips_next;
    reg [11 : 0] byte_count_send_reg; //contador para enviar data (320)
    reg [11 : 0] byte_count_send_next;
    


	//FSMD
	always @(posedge clk) begin
		if(~rst) begin
			 state_reg 	           <= idle;
             state_load_reg        <= Load_receive;
             state_fast_reg        <= Fast_start;
             count_byte_reg        <= 2'b00;
             instruction_reg       <= 0;
             address_reg           <= 8'b11111111;
             data_i_reg            <= 0;
             data_send_reg         <= 0;
             step_reg              <= 0;
             tx_start_reg          <= 0;
             byte_count_send_reg   <= 7;
             //data_mips_reg         <= 0;
		end else begin
			 state_reg 	           <= state_next;
             state_load_reg        <= state_load_next;
             state_fast_reg        <= state_fast_next;
             count_byte_reg        <= count_byte_next;
             instruction_reg       <= instruction_next;
             address_reg           <= address_next;
             data_i_reg            <= data_i_next;
             data_send_reg         <= data_send_next;
             step_reg              <= step_next;
             tx_start_reg          <= tx_start_next;
             byte_count_send_reg   <= byte_count_send_next;
             //data_mips_reg         <= data_mips_next;
		end
	end

	always @(*) begin
		//Estados por si no entra a ningun case
		state_next = state_reg;
        state_load_next = state_load_reg;
        state_fast_next        = state_fast_reg;
		count_byte_next  = count_byte_reg;
		instruction_next        = instruction_reg;
        address_next           = address_reg;
        data_i_next             = data_i_reg;
        data_send_next          = data_send_reg;
		o_MemWrite = 1'b0;
        step_next   = step_reg;
        tx_start_next = 1'b0;
        byte_count_send_next = byte_count_send_reg;

        //data_mips_next         <= data_mips_reg;
		case (state_reg)
   			idle: begin
 				if(i_rx_done)begin
					state_next = operation;
					data_i_next = i_data;
				end
			end 
			operation: begin
                case(data_i_reg)
                    8'b0000001: state_next = load;
                    //8'b0000010: state_next = step;
                    8'b0000011: state_next = fast;
                    default:    state_next = idle;
                endcase
            end
			load: begin
                step_next = 0;
                case(state_load_reg)
                    Load_receive:begin
                        if(i_rx_done)begin
                            instruction_next = {i_data, instruction_reg[31:8]}; 
                            if(count_byte_reg == 2'b11)begin
                                state_load_next = Load_send;
                                address_next = address_reg + 1;
                            end
                            else begin
                                count_byte_next = count_byte_reg + 1;
                            end
                        end
                    end
                    Load_send: begin
                        o_MemWrite = 1'b1;
                        if(instruction_reg == 'hffffffff) begin
                            state_load_next = Load_ready;        
                            data_send_next = 8'b00000001;
                            instruction_next = 0;
                            count_byte_next = 2'b00;
                        end
                        else begin
                            instruction_next = 0;
                            count_byte_next = 2'b00;
                            state_load_next = Load_receive;        
                            tx_start_next = 1'b1;
                        end
                    end
                    Load_ready: begin
                        state_next = idle;
                        state_load_next = Load_receive;
                    end
                   endcase
			end
            /*
			step: begin
			end*/
			fast: begin
                case(state_fast_reg)
                    Fast_start: begin
                        step_next = 1'b1;
                        if(is_stop_pipe==1'b0)begin
                            step_next = 1'b0;
                            state_fast_next = Fast_send;
                        end
                    end
                    Fast_send: begin
                        if(i_tx_done)begin
                            if(byte_count_send_reg > 2559)begin
                                state_fast_next = Fast_ready;
                                data_send_next = 8'b00000010;
                                byte_count_send_next = 7;
                                tx_start_next = 1'b1;
                            end
                            else begin
                                data_send_next = i_data_from_mips[byte_count_send_reg -: 8];
                                tx_start_next  = 1'b1;
                                byte_count_send_next = byte_count_send_reg + 8; 
                            end
                        end
                    end
                    Fast_ready: begin
                        state_next = idle;
                        state_fast_next = Fast_start;
                    end
                endcase
			end
		endcase
	end
    assign o_instruction    = instruction_reg; 
    assign o_address        = address_reg;
    assign o_data_send      = data_send_reg;
    assign o_tx_start       = tx_start_reg; 
    assign o_step           = step_reg;
endmodule
