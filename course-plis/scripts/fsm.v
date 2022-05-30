`timescale 1ns / 1ps
//
module fsm(input 		   rst,
			  input		   clk,
			  input		   ce,
			  input		   load,
			  input		   up,
			  input  [3:0] data,
			  
			  output [3:0] seq);
			  
reg [3:0] state;

behaviour beh (.X(state),
					.Y(seq));

always @(posedge clk, posedge rst)
	begin
		if (rst)
			state <= 4'h0;
		else
			begin
				if (load)
					state <= data;
				if (ce && up)
					state <= state + 4'h1;
				if (ce && !up)
					state <= state - 4'h1;
				if (!ce && !load)
					state <= state;
			end
	end
endmodule
