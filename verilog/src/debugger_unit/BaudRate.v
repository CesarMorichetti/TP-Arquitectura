`timescale 1ns / 1ps
module BaudRate (
	input 	wire clk,
	input	wire rst,
	output 	wire tick
);

//sentencias declarativas
reg 	flag;
integer count;

assign tick = flag;

always @(posedge clk or negedge rst) begin 
	if(~rst) begin
		flag 	<= 1'b0;
		count 	<= 0;
	end 
	else begin
	//326
		if(count == 163)begin
			flag 	<= 1'b1;
			count	<= 0;
		end
		else begin
			flag 	<= 1'b0;
			count <= count + 1;
		end
	end
end
endmodule
