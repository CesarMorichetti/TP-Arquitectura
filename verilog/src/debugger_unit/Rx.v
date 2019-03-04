`timescale 1ns / 1ps
module Rx 
	#(parameter LEN_DATA 		= 8,
				STOP_BIT_COUNT	= 16
	)
	(
	input 	wire 					clk,
	input	wire 					rst,
	input 	wire 					rx,		//dato de entrada
	input 	wire					s_tick,	//sampler
	output 	reg 					rx_done,//termino de recibir
	output 	wire [7 : 0] 			dout 	//byte recibido
);
	//declaracion de los estados
	localparam [1 : 0] idle 	= 2'b00;
	localparam [1 : 0] start	= 2'b01;
	localparam [1 : 0] data 	= 2'b10;
	localparam [1 : 0] stop 	= 2'b11;

	//variables locales
	//estado de la FSMD
	reg [1 : 0] state_reg, state_next;
	//Contador para la sincronizacion
	reg [3 : 0] s_reg, s_next;
	//Contador de bits recibidos
	reg [2 : 0] n_reg, n_next;
	//Buffer donde se almacenan los bits recibidos
	reg [7 : 0] b_reg, b_next;

	//FSMD state and data register
	always @(posedge clk or negedge rst) begin
		if(~rst) begin
			 state_reg 	<= idle;
			 s_reg 		<= 0;
			 n_reg		<= 0;
			 b_reg 		<= 0; 
		end else begin
			 state_reg 	<= state_next;
			 s_reg 		<= s_next;
			 n_reg 		<= n_next;
			 b_reg 		<= b_next;
		end
	end

	always @(*) begin
		//Esto son lo default
		rx_done 	= 1'b0;
		state_next 	= state_reg;
		s_next 		= s_reg;
		n_next 		= n_reg;
		b_next 		= b_reg;
		case (state_reg)
			idle: begin
				if(~rx) begin
					state_next = start;
					s_next = 0;
				end
			end // idle:
			start: begin
				if(s_tick) begin
					if(s_reg == 7) begin
						state_next = data;
						s_next = 0;
						n_next = 0;
					end
					else begin
						s_next = s_reg + 1;
					end
				end
			end // start:
			data: begin
				if (s_tick)begin
					if(s_reg == 15) begin
						s_next = 0;
						b_next = {rx, b_reg[7:1]};
						if(n_reg == LEN_DATA - 1) begin
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
			end // data:
			stop: begin
				if(s_tick) begin
					if(s_reg == STOP_BIT_COUNT - 1) begin
						state_next = idle;
						rx_done = 1'b1;
					end
					else begin
						s_next = s_reg + 1;
					end
				end
			end // stop:
		endcase
	end
	assign dout = b_reg;
endmodule
