`timescale 1ns / 100ps
module Tx #(
	parameter LEN_DATA 			= 8,
	parameter STOP_BIT_COUNT 	= 16
	) 
	(
	input 	wire 							clk,		
	input 	wire 							rst,
	input 	wire 							tx_start,	//Iniciar la transmision
	input 	wire 							s_tick,		//Sampleo
	input		wire [LEN_DATA - 1 : 0] input_data,		//byte a transmitir
	output 	reg 							tx_done,	//Fin de la transmision
	output 	wire 							tx 			//bit transmitido
	
);

	//declaraciones de los estados
	localparam [1 : 0] idle 	= 2'b00;
	localparam [1 : 0] start 	= 2'b01;
	localparam [1 : 0] data 	= 2'b10;
	localparam [1 : 0] stop 	= 2'b11;

	//variables locales
	reg [1 : 0] state_reg;
	reg [1 : 0] state_next;
	//Contador para arrancar sincronizar
	reg [3 : 0] s_reg;
	reg [3 : 0] s_next;
	//Contador de bits transmitidos
	reg [2 : 0] n_reg;
	reg [2 : 0] n_next;
	//Registro donde se guarda el input_data
	reg [7 : 0] b_reg;
	reg [7 : 0] b_next;
	//Para avisar que va a transmitir, esta siempre en 1 cuando arranca pasa a 0(se conecta con tx)
	reg 		tx_reg;
	reg 		tx_next;

	//FSMD
	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			 state_reg 	<= idle;
			 s_reg 		<= 0;
			 n_reg 		<= 0;
			 b_reg 		<= 0;
			 tx_reg 	<= 1'b1;
		end else begin
			 state_reg 	<= state_next;
			 s_reg 		<= s_next;
			 n_reg 		<= n_next;
			 b_reg 		<= b_next;
			 tx_reg 	<= tx_next;
		end
	end

	always @(*) begin
		//Estados por si no entra a ningun case
		state_next = state_reg;
		tx_done = 1'b0;
		s_next = s_reg;
		n_next = n_reg;
		b_next = b_reg;
		tx_next = tx_reg;

		case (state_reg)
			idle: begin
				tx_next = 1'b1;
				if(tx_start)begin
					state_next = start;
					s_next = 0;
					b_next = input_data;
				end
			end 
			start: begin
				tx_next = 1'b0;
				if(s_tick) begin
					if(s_reg == 15) begin
						state_next = data;
						s_next = 0;
						n_next = 0;
					end
					else begin
						s_next = s_reg + 1;
					end
				end
			end
			data: begin
				tx_next = b_reg[0];//el bit a transmitir
				if(s_tick) begin
					if(s_reg == 15) begin
						s_next = 0;
						b_next = b_reg >> 1; 
						if(n_reg == (LEN_DATA - 1)) begin
							state_next = stop;
						end
						else begin
							n_next = n_reg + 1;
						end
					end
					else begin
						s_next = s_reg + 1;
					end
				end
			end
			stop: begin
				tx_next = 1'b1;
				if(s_tick) begin
					if(s_reg == (STOP_BIT_COUNT - 1))begin
						state_next = idle;
						tx_done = 1'b1;
					end
					else begin
						s_next = s_reg + 1;
					end
				end
			end
		endcase
	end
	assign tx = tx_reg;
endmodule