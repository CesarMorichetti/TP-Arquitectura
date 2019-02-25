`timescale 1ns / 1ps
module debugger(
                input wire           rst,
                input wire           clk,
                input wire           i_rx_done,
                input wire  [7  : 0] i_data,
                output wire          o_step,
                output reg           o_MemWrite,
                output wire [31 : 0] o_instruction,
                output wire [7  : 0] o_address,
                output wire [7  : 0] o_data_send,
                output reg           o_tx_start
               );

	//declaraciones de los estados generales
	localparam [1 : 0] idle 	 = 2'b00;
    localparam [1 : 0] operation = 2'b01;
    localparam [1 : 0] load      = 2'b10;
    //declaracion estados de cada modo de operacion
    //LOAD
    localparam [1 : 0] Load_receive = 2'b00;//recibe los 4 bytes
    localparam [1 : 0] Load_send    = 2'b01;//manda a program memory la instr
    localparam [1 : 0] Load_ready   = 2'b10;//avisa que ya se cargo la PM
    
    //variables maquina de estados principal
    reg [1 : 0] state_reg;
    reg [1 : 0] state_next;
    
    reg [7 : 0] data_i_reg;
    reg [7 : 0] data_i_next;

    reg [7 : 0] data_send_reg;
    reg [7 : 0] data_send_next;
    
    reg         step_reg;
    reg         step_next;

	//variables locales para operacion load
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


	//FSMD
	always @(posedge clk) begin
		if(~rst) begin
			 state_reg 	           <= idle;
             state_load_reg        <= Load_receive;
             count_byte_reg        <= 2'b00;
             instruction_reg       <= 0;
             address_reg           <= 8'b11111111;
             data_i_reg            <= 0;
             data_send_reg         <= 0;
             step_reg              <= 0;
		end else begin
			 state_reg 	           <= state_next;
             state_load_reg        <= state_load_next;
             count_byte_reg        <= count_byte_next;
             instruction_reg       <= instruction_next;
             address_reg           <= address_next;
             data_i_reg            <= data_i_next;
             data_send_reg         <= data_send_next;
             step_reg              <= step_next;
		end
	end

	always @(*) begin
		//Estados por si no entra a ningun case
		state_next = state_reg;
        state_load_next = state_load_reg;
		o_tx_start = 1'b0;
		count_byte_next  = count_byte_reg;
		instruction_next        = instruction_reg;
        address_next           = address_reg;
        data_i_next             = data_i_reg;
        data_send_next          = data_send_reg;
		o_MemWrite = 1'b0;
        o_tx_start = 1'b0;
        step_next   = step_reg;
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
                    //8'b0000011: state_next = fast;
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
                        end
                    end
                    Load_ready: begin
                        o_tx_start = 1'b1;
                        state_next = idle;
                        state_load_next = Load_receive;
                    end
                   endcase
			end
            /*
			step: begin
			end
			fast: begin
			end*/
		endcase
	end
    assign o_instruction    = instruction_reg; 
    assign o_address        = address_reg;
    assign o_data_send      = data_send_reg;
    assign o_step           = step_reg;
endmodule
